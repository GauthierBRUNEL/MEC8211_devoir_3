clc; clear; close all;

% Nombre d'échantillons à générer
N = 200;  % À modifier selon besoin

% Paramètres des distributions (moyenne et écart-type)
mu = [12.5, 0.900, 80.6];  % Moyenne pour [Diamètre, Porosité, Perméabilité]
sigma = [2.85, 7.50e-3, 14.7];  % Écart-type pour [Diamètre, Porosité, Perméabilité]

% Génération des échantillons avec LHS
X = lhsnorm(mu, diag(sigma.^2), N);

% Extraction des variables
diametre_fibres = X(:,1);
porosite = X(:,2);
permeabilite = X(:,3);

% Affichage des résultats
figure;
subplot(3,1,1);
histogram(diametre_fibres, 30, 'Normalization', 'pdf');
xlabel('Diamètre des fibres (µm)'); ylabel('Densité'); title('Distribution - Diamètre des fibres');

subplot(3,1,2);
histogram(porosite, 30, 'Normalization', 'pdf');
xlabel('Porosité (-)'); ylabel('Densité'); title('Distribution - Porosité');

subplot(3,1,3);
histogram(permeabilite, 30, 'Normalization', 'pdf');
xlabel('Perméabilité (µm²)'); ylabel('Densité'); title('Distribution - Perméabilité');
saveas(gcf, '../results/LHS_distributions.png');

% Stocker les données si besoin
%data = table(diametre_fibres, porosite, permeabilite);
data = table(porosite, permeabilite);
writetable(data, '../data/LHS_samples.csv');
