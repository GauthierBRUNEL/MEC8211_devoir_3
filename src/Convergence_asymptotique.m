% Chargement des données
% Remplace 'data.csv' par le nom de ton fichier si nécessaire
data = readtable('../data/data.csv');

% Extraction des variables
delta_x = data.delta_x;
poro_eff = data.poro_eff_1; % Colonne "poro_eff" normalisée
Re = data.Re_1;             % Colonne "Re" normalisée
k_micron2 = data.k_micron2_1; % Colonne "k_micron2" normalisée

% Normalisation des variables
poro_eff_norm = (poro_eff - min(poro_eff)) / (max(poro_eff) - min(poro_eff));
Re_norm = (Re - min(Re)) / (max(Re) - min(Re));
k_micron2_norm = (k_micron2 - min(k_micron2)) / (max(k_micron2) - min(k_micron2));

% Tracé des courbes
figure;
plot(delta_x, poro_eff_norm, '-o', 'DisplayName', 'Porosité Normalisée');
hold on;
plot(delta_x, Re_norm, '-s', 'DisplayName', 'Re Normalisé');
plot(delta_x, k_micron2_norm, '-^', 'DisplayName', 'k_micron2 Normalisé');
saveas(gcf, '../results/Convergence_plot.png');

% Mise en forme du graphique
grid on;
legend show;
xlabel('delta x');
ylabel('Valeurs Normalisées');
title('Tracé des variables normalisées en fonction de delta x');
