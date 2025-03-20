clc; clear; close all;

% Charger les échantillons générés par LHS
data = readtable('LHS_samples.csv');

% Nombre d'échantillons
N_samples = height(data);

% Paramètres constants
seed = 3;
deltaP = 0.1;  % Chute de pression en Pa
NX = 100;
mean_fiber_d= 12.5 ; % in microns
std_d= 2.85 ; % in microns
dx = 0.000002; % Taille de la grille en m
filename = 'fiber_mat.tiff';

% Ouvrir un fichier pour enregistrer les résultats
output_file = 'results_LBM.txt';
fid = fopen(output_file, 'w');

% Vérifier si le fichier s'est bien ouvert
if fid == -1
    error('Impossible d''ouvrir le fichier de sortie.');
end

% Boucle sur chaque ensemble de paramètres LHS
for i = 1:N_samples
    % Récupérer les paramètres de l'échantillon i
    poro = data.porosite(i);                % Porosité (-)
    permeability_lhs = data.permeabilite(i); % Perméabilité (µm²)

    % Génération de la structure de fibres
    d_equivalent = Generate_sample(seed, filename, mean_fiber_d, std_d, poro, NX, dx);
    
    % Calcul du champ d'écoulement et de la perméabilité avec LBM
    [poro_eff, Re, k_in_micron2] = LBM(filename, NX, deltaP, dx, d_equivalent);
    
    % Sauvegarde des résultats dans le fichier
    fprintf(fid, 'Sample %d:\n', i);
    fprintf(fid, 'Diamètre moyen des fibres: %.3f µm\n', mean_fiber_d);
    fprintf(fid, 'Porosité: %.6f\n', poro);
    fprintf(fid, 'Perméabilité LHS: %.3f µm²\n', permeability_lhs);
    fprintf(fid, 'Perméabilité calculée: %.3f µm²\n', k_in_micron2);
    fprintf(fid, 'Porosité effective: %.6f\n', poro_eff);
    fprintf(fid, 'Nombre de Reynolds: %.6f\n', Re);
    fprintf(fid, '---------------------------------------\n');
    
    % Afficher la progression
    fprintf('Simulation %d/%d terminée\n', i, N_samples);
end

% Fermer le fichier de sortie
fclose(fid);

fprintf('Toutes les simulations sont terminées. Résultats sauvegardés dans %s\n', output_file);
