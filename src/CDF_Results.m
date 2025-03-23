clc; clear; close all;

filename = 'data/results_LBM.txt'; % Lire depuis /data
fid = fopen(filename, 'r');
if fid == -1
    error('Impossible d''ouvrir le fichier de résultats.');
end

% Initialisation du stockage des perméabilités calculées
permeability_values = [];

% Lire le fichier ligne par ligne
while ~feof(fid)
    line = fgetl(fid);
    
    % Vérifier si la ligne contient la perméabilité calculée
    if contains(line, 'Perméabilité calculée:')
        % Extraire la valeur numérique après ":"
        value = sscanf(line, 'Perméabilité calculée: %f µm²');
        permeability_values = [permeability_values; value];
    end
end

% Fermer le fichier après lecture
fclose(fid);

% Vérifier qu'on a bien récupéré des données
if isempty(permeability_values)
    error('Aucune donnée de perméabilité trouvée dans le fichier.');
end

% Transformation log des valeurs (car elles suivent une loi log-normale)
log_permeability = log(permeability_values);

% Estimation des paramètres de la loi log-normale
mu = mean(log_permeability);    % Moyenne du log
sigma = std(log_permeability);  % Écart-type du log

% Définition des valeurs pour la PDF et la CDF
x = linspace(min(permeability_values), max(permeability_values), 100);
pdf_values = lognpdf(x, mu, sigma);
cdf_values = logncdf(x, mu, sigma);

% 🎨 **Tracer la CDF**
figure;
plot(x, cdf_values, 'b-', 'LineWidth', 2);
grid on;
xlabel('Perméabilité calculée (\mum^2)');
ylabel('Probabilité cumulative (CDF)');
title('Fonction de Répartition Empirique (CDF) de la Perméabilité');
saveas(gcf, '../results/CDF_plot.png');

% 🎨 **Tracer la PDF**
figure;
plot(x, pdf_values, 'r-', 'LineWidth', 2); % Courbe de densité log-normale
grid on;
xlabel('Perméabilité calculée (\mum^2)');
ylabel('Densité de probabilité (PDF)');
title('Densité de Probabilité (PDF) de la Perméabilité');
saveas(gcf, '../results/PDF_plot.png');

%%
% Vérifier que des données sont disponibles
if isempty(permeability_values)
    error('Aucune donnée de perméabilité trouvée.');
end

% Transformation log des valeurs (car elles suivent une loi log-normale)
log_permeability = log(permeability_values);

% Calcul de la médiane et du FVG
mu = mean(log_permeability);    % Moyenne dans l'espace log
sigma = std(log_permeability);  % Écart-type dans l'espace log

mediane = exp(mu);              % Médiane de la loi log-normale
FVG = exp(sigma);               % Facteur de Variation Géométrique (FVG)

% Calcul de l'intervalle d'incertitude
borne_inf = mediane / FVG;
borne_sup = mediane * FVG;

% Affichage des résultats
fprintf('Médiane de la perméabilité : %.3f µm²\n', mediane);
fprintf('Facteur de Variation Géométrique (FVG) : %.3f\n', FVG);
fprintf('Intervalle d''incertitude (1 écart-type) : [%.3f , %.3f] µm²\n', borne_inf, borne_sup);

% Calcul des incertitudes asymétriques
u_moins = mediane - (mediane / FVG);
u_plus = (mediane * FVG) - mediane;

% Affichage des incertitudes asymétriques
fprintf('Incertitude inférieure u^- : %.3f µm²\n', u_moins);
fprintf('Incertitude supérieure u^+ : %.3f µm²\n', u_plus);
