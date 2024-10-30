clc 
clear
close all

P_X0 = 0.3;                   % Probabilidad de transmitir un 0
P_X1 = 0.7;                   % Probabilidad de transmitir un 1
P_Y1_given_X0 = 0.01;         % Probabilidad de recibir un 1 dado que se transmitió un 0
P_Y0_given_X1 = 0.1;          % Probabilidad de recibir un 0 dado que se transmitió un 1

[P_Y1, P_X1_given_Y1] = calcularProbabilidades(P_X0, P_X1, P_Y1_given_X0, P_Y0_given_X1);
graficarProbabilidades(P_Y1, P_X1_given_Y1);

ruido_adicional = 0.3;
[P_Y1, P_X1_given_Y1] = calcularProbabilidades(P_X0, P_X1, P_Y1_given_X0, P_Y0_given_X1, ruido_adicional);
graficarProbabilidades(P_Y1, P_X1_given_Y1);

%%
function graficarProbabilidades(P_Y1, P_X1_given_Y1)
    figure;
    subplot(1, 2, 1);
    bar(1, P_Y1, 'FaceColor', [0.2, 0.6, 0.8]);
    title('Probabilidad de que la salida sea 1');
    xlabel('Evento Y=1');
    ylabel('Probabilidad');
    set(gca, 'XTick', 1, 'XTickLabel', {'Y=1'});
    ylim([0, 1]);  

    subplot(1, 2, 2);
    bar(1, P_X1_given_Y1, 'FaceColor', [0.8, 0.2, 0.6]);
    title('Probabilidad de transmitir 1 dado Y=1');
    xlabel('Evento X=1 | Y=1');
    ylabel('Probabilidad');
    set(gca, 'XTick', 1, 'XTickLabel', {'X=1 | Y=1'});
    ylim([0, 1]);  
end

%%

function [P_Y1, P_X1_given_Y1, BER] = calcularProbabilidades(P_X0, P_X1, P_Y1_given_X0, P_Y0_given_X1, ruido_adicional)
    % Si el ruido adicional no está especificado, se asume cero
    if nargin < 5
        ruido_adicional = 0;
    end

    % Ajuste de las probabilidades condicionales según el ruido adicional
    P_Y1_given_X0 = min(P_Y1_given_X0 + ruido_adicional, 1);
    P_Y0_given_X1 = min(P_Y0_given_X1 + ruido_adicional, 1);

    % Cálculo de las probabilidades
    P_Y1 = P_X0 * P_Y1_given_X0 + P_X1 * (1 - P_Y0_given_X1); % P(Y=1)
    P_X1_given_Y1 = (P_X1 * (1 - P_Y0_given_X1)) / P_Y1;       % P(X=1 | Y=1)

    % Cálculo de la tasa de error de bit (BER)
    % BER = Probabilidad de error al transmitir 0 * Probabilidad de transmitir 0 +
    %       Probabilidad de error al transmitir 1 * Probabilidad de transmitir 1
    BER = P_X0 * P_Y1_given_X0 + P_X1 * P_Y0_given_X1;
    
    fprintf('Probabilidad de que la salida sea 1: %f\n', P_Y1);
    fprintf('Probabilidad de que se haya transmitido un 1 dado que la salida es 1: %f\n', P_X1_given_Y1);
    fprintf('Tasa de Error de Bit (BER): %f\n', BER);
end 

