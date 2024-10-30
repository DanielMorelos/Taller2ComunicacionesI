% Generación de señal, ruido y análisis de SNR
[signal,t,intmodsig] = gensignal(amp,type,f,fs,tmax, fmoduladora,k,ampm);% Funcion que generauna señal según el tipo seleccionado (sinusoidal, AM, FM, etc.)

[SNR_linear,noise,signal_power,noise_power,noisegen,noisy_signal]=NOISE(signal,SNR_db); %Funcion para generar ruido blanco aditivo (AWGN) y añade el ruido a la señal original.

received_SNR=results(signal,noisy_signal);%Funcion para hallar el SNR recibido
proporcion=error(SNR_db,received_SNR);%Funcion que calcula la relacion entre el SNR esperado y el calculado
%% Gráficas de las señales en el dominio del tiempo
figure; 
subplot(3, 1, 1);  
plot(t, noisy_signal); %Grafica la señal con ruido con respecto al tiempo
title('Señal Recibida con Ruido AWGN');
xlabel('Tiempo (s)');
ylabel('Amplitud');
subplot(3, 1, 2);   
plot(t, signal); %Grafica la señal sin ruido con respecto al tiempo
title('Señal generada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
subplot(3, 1, 3);  
plot(t, noisegen); %Grafica el ruido con respecto al tiempo
title('Ruido generado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
%% Gráficas de las señales en el dominio de la frecuencia (Espectro)
figure;
subplot(3, 1, 1); % Espectro de la señal con ruido
freq = linspace(-fs/2, fs/2, length(t)); %Rango de frecuencias para la fft
plot(freq, abs(fftshift(fft(noisy_signal)))); %Calcula la fft de la señal con ruido
title('Espectro de la Señal con Ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
subplot(3, 1, 2); % Espectro de la señal sin ruido
freq = linspace(-fs/2, fs/2, length(t)); %Rango de frecuencias para la fft
plot(freq, abs(fftshift(fft(signal)))); %Calcula la fft de la señal generada
title('Espectro de la Señal sin Ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
subplot(3, 1, 3); % Espectro del ruido
freq = linspace(-fs/2, fs/2, length(t)); %Rango de frecuencias para la fft
plot(freq, abs(fftshift(fft(noisegen)))); %Calcula la fft del ruido generado para cumplir con la SNR esperada
title('Espectro del Ruido');
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
%% Funciones
function [signal,t,intmodsig] = gensignal(amp,type,f,fs,tmax,fmoduladora,k,ampm ) % Función para generar la señal a la que se le añadira el ruido
intmodsig=0;
t = 0:1/fs:tmax; % Inico=0, pasos de 1/fs, final= 0.1
    switch lower(type)
        case 'sinusoidal'
            signal = amp*sin(2 * pi * f * t); % Señal sinusoidal
        case 'cuadrada'
            signal = amp*square(2 * pi * f * t); % Señal cuadrada
        case 'triangular'
            signal = amp*sawtooth(2 * pi * f * t, 0.5); % Señal triangular
        case 'cosinoidal'
            signal = amp*cos(2 * pi * f * t); % Señal cosinoidal
        case 'am'  % Modulación en amplitud
            mod_signal = ampm*sin(2 * pi * fmoduladora * t); % Señal moduladora
            signal = amp * (1 + mod_signal) .* cos(2 * pi * f * t);
        case 'fm'  % Modulación en frecuencia
            mod_signal = ampm*sin(2 * pi * fmoduladora * t); % Señal moduladora
            intmodsig = cumtrapz(t, mod_signal);
            signal = amp * cos(2 * pi * f * t +k*2*pi* intmodsig);
        case 'pm'  % Modulación en fase
            mod_signal = ampm*sin(2 * pi * fmoduladora * t); % Señal moduladora
            signal = amp * cos(2 * pi * f * t + k * mod_signal);
        otherwise
            error('Tipo de señal no válido. Use: ''sinusoidal'', ''cuadrada'', ''triangular'', ''cosinoidal'', ''am'', ''fm'', o ''pm''.');
    end
end

function [SNR_linear,noise,signal_power,noise_power,noisegen,noisy_signal]=NOISE(signal,SNR_db)  %Funcion que haya el ruido necesario para cumplir con una SNR predefinida y lo suma a la señal
noise = randn(size(signal)); %Vector de ruido gaussiano blanco del tamaño de la señal de entrada
SNR_linear = 10^(SNR_db/10); %Convierte la SNR en dB a escala linear
fprintf('SNR en escala lineal: %f \n', SNR_linear);%Muestra la SNR en escala lineal
signal_power = rms(signal)^2; %Formula para hallar la potencia de la señal
fprintf('Potencia de la señal: %f \n', signal_power); %Muestra la potencia de la señal
noise_power = signal_power / SNR_linear; %Calcula la potencia que deberia tener el ruido para cumplir con la SNR
fprintf('Potencia del ruido: %f \n', noise_power);
noisegen=sqrt(noise_power) * noise; %Escala el ruido generado para que tenga la potencia esperada
noisy_signal = signal + sqrt(noise_power) * noise; %Le suma el ruido a la señal
end

function received_SNR=results(signal,noisy_signal)%Funicon que calcula la SNR de la señal con ruido generada
received_SNR = 10 * log10(rms(signal)^2 / rms(noisy_signal - signal)^2); %Calcula la SNR recibida en dB
fprintf('SNR calculada: %f dB\n', received_SNR);%Muestra la SNR recibida
end

function proporcion=error(SNR_db,received_SNR)%Funcion para hallar la relacion entre el SNR esperado y el calculado
proporciondb=abs(((SNR_db-received_SNR)/SNR_db))*100;%Diferencia porcentual entre la SNR calculada y la esperada
fprintf('Diferencia porcentual entre la SNR calculada y la esperada: %f %% \n', proporciondb);
proporcion=abs(((10^(SNR_db/10)-10^(received_SNR/10))/10^(SNR_db/10)))*100;%Diferencia porrcentual entre la potencia esperada y la calculada
fprintf('Diferencia porcentual entre la potencia esperada y la calculada: %f %% \n', proporcion);
end
