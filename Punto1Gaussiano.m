clc 
clear
close all

N = 1000;            % Número de muestras
t = 1:N;             % Vector de tiempo
mu1 = 0;             % Media de X
sigma1 = 1;          % Desviación estándar de X
mu2 = 3;             % Media de Y
sigma2 = 2;          % Desviación estándar de Y
  

% Generación de procesos gaussianos independientes
X = generarProcesoGaussiano(N, mu1, sigma1);   % Señal
Y = generarProcesoGaussiano(N, mu2, sigma2);   % Señal


% Cálculo de la covarianza y correlación
[covXY, corrXY] = calcularEstadisticas(X, Y);

%Si la covarianza es positiva, significa que cuando X aumenta, Y tiende a aumentar también. 
%Hay una relación directa entre las variables.
%Si la covarianza es negativa, indica que cuando X aumenta,  Y tiende a disminuir.
%Hay una relación inversa entre las variables.
%Una covarianza cercana a cero sugiere que no hay una relación lineal clara entre X y Y.

%Correlacion:
%Valores cercanos a ±1: Indican una relación lineal fuerte.
%Valores cercanos a 0: Indican una relación lineal débil o inexistente.

disp('Covarianza entre X y Y:');
disp(covXY);
disp('Correlación entre X y Y:');
disp(corrXY);


% Calcular la autocorrelación del proceso de ruido blanco
Rxx = xcorr(X, 'unbiased');   % Autocorrelación de X

% Calcular la PSD usando la transformada de Fourier de la autocorrelación
PSD_value = fft(Rxx);        
PSD_value = PSD_value(1);     % Valor constante para ruido blanco

disp('Densidad Espectral de Potencia (PSD) del ruido blanco (calculada desde la autocorrelación):');
disp(abs(PSD_value / N));


% Gráficos
figure('Name','Análisis de Procesos Gaussianos','NumberTitle','off');

subplot(2,2,1);
plot(t, X);
title('Proceso X');
xlabel('Tiempo (t)');
ylabel('Amplitud');

subplot(2,2,2);
histogram(X, 30);
title('Histograma de X');
xlabel('Amplitud');
ylabel('Frecuencia');

subplot(2,2,3);
plot(t, Y);
title('Proceso Y');
xlabel('Tiempo (t)');
ylabel('Amplitud');

subplot(2,2,4);
histogram(Y, 30);
title('Histograma de Y');
xlabel('Amplitud');
ylabel('Frecuencia');
%%
%AWGN
         
fs = 1000;              
t = 0:1/fs:1-1/fs;     
f0 = 10;               
A = 4;                 

% Generación de la señal transmitida
s = A * sin(2*pi*f0*t);

X = generarProcesoGaussiano(N, mu1, sigma1);

R = s + X;

figure;
subplot(3,1,1);
plot(t, s);
title('Señal Transmitida');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,2);
plot(t, X);
title('Ruido AWGN');
xlabel('Tiempo (s)');
ylabel('Amplitud');

subplot(3,1,3);
plot(t, R);
title('Señal Recibida');
xlabel('Tiempo (s)');
ylabel('Amplitud');

%%

function X = generarProcesoGaussiano(N, mu, sigma)
    X = sigma * randn(1, N) + mu;
end

function [covXY, corrXY] = calcularEstadisticas(X, Y)
    covXY = cov(X, Y);
    corrXY = corrcoef(X, Y);
end


