%% Ajout du calcul de u_input selon V&V 20

% Lire le fichier results_LBM.txt
filename_results = '../data/results_LBM.txt';
fid = fopen(filename_results, 'r');
if fid == -1
    error('Impossible d''ouvrir le fichier des résultats.');
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

% Calcul de la moyenne et de l'écart-type empirique
mean_S = mean(permeability_values);
u_input = sqrt(sum((permeability_values - mean_S).^2) / (length(permeability_values) - 1));

% Affichage du résultat
fprintf('u_input (incertitude sur la perméabilité) = %.3f µm²\n', u_input);

% Optionnel : Ajouter u_input dans results_LBM.txt
fid = fopen(filename_results, 'a');
if fid ~= -1
    fprintf(fid, '\nIncertitude totale u_input: %.3f µm²\n', u_input);
    fclose(fid);
end
