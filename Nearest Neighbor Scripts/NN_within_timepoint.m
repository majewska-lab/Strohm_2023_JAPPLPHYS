% Nearest neighbor calculations to compare microglia:

% Choose file
%[mysheet,mypath] = uigetfile('.csv');

% specify folder that contains all the .csv files to be analyzed
mypath = uigetdir();
csvfiles = dir( fullfile(mypath, '*.csv'));
directory = uigetdir();

for mysheet = csvfiles'
    filepath = fullfile(mypath,mysheet.name); % Combine path and filename
    mytable = readtable(filepath); % Get first sheet data: M
    
    % Get coordinates and calculate nearest Neighbor distances
    MG_X = mytable.XM; % Get microglia X coordinates
    MG_Y = mytable.YM; % Get microglia Y coordinates
    
    MG_coords = cat(2,MG_X,MG_Y); % Concatenate to get n-by-2 matrix for (x,y) coordinates
    
    % Use knnsearch function to get the nearest neighbor index and distance.
    % knn search works by looking at each row (cell) in the second matrix, and asks
    % "what row (cell) in the first column is closes to this cell?". It then outputs
    % the index of that particular cell and the distance between the two cells 
    [Idx,D] = knnsearch(MG_coords,MG_coords,'K',2);
    % If you're looking at just microglial coordinates, and want to know how
    % far away is the closest microglia (to calculate spacing index), you would
    % compare the same set of coordinates to each other, and look at the second
    % closes one. So you use K=2 and look at the 2nd column.
    %create table of data
    Mean = mean(D); %gets mean NN distance
    Max = max(D);%gets maximum NN distance
    Min = min(D);%gets minimum NN distance
    StatsNN = table(Mean,Max,Min);
    Distances = D;
    DistancesNN = table(Distances);
    dotLocations = find(mysheet.name == '.')
    nameBeforeFirstDot = mysheet.name(1:dotLocations(1)-1)
    filename = nameBeforeFirstDot + ".xlsx";
    writetable(StatsNN,fullfile(directory,filename),'Sheet', 1);
    writetable(DistancesNN,fullfile(directory,filename),'Sheet', 2);
end




