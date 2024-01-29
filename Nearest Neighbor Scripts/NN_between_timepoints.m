
% Nearest neighbor calculations to compare two cell populations:

% specify folder that contains all the .csv files to be analyzed
mypath = uigetdir();
% Choose file for first timepoint: dayneg
%[mysheet,mypath] = uigetfile('.csv');
mysheet = dir(fullfile(mypath, '*baseline*.csv'));
filepath = fullfile(mypath,mysheet.name); % Combine path and filename
mytable = readtable(filepath); % Get data: M

csvfiles = dir(fullfile(mypath, '*week*.csv')); % week .csv files
directory = uigetdir(); % where to write files to

for mysheet = csvfiles'
    filepath = fullfile(mypath,mysheet.name); % Combine path and filename
    mytable2 = readtable(filepath); % Get first sheet data: M

    % Get coordinates and calculate nearest Neighbor distances
    
    FirstMG_X = mytable.XM; % Get microglia X coordinates from first timepoint
    FirstMG_Y = mytable.YM; % Get microglia Y coordinates from first timepoint
    
    FirstMG_coords = cat(2,FirstMG_X,FirstMG_Y); % Concatenate to get n-by-2 matrix for (x,y) coordinates
    
    SecondMG_x = mytable2.XM; % Get microglia X coordinates from second timepoint 
    SecondMG_y = mytable2.YM; % Get microglia Y coordinates from second timepoint
    
    SecondMG_coords = cat(2,SecondMG_x,SecondMG_y); % Concatenate to get n-by-2 matrix for (x,y) coordinates
    
    % Use knnsearch function to get the nearest neighbor index and distance.
    % knn search works by looking at each row (cell) in the second matrix, and asks
    % "what row (cell) in the first column is closes to this cell?". It then outputs
    % the index of that particular cell and the distance between the two cells 
    [Idx,D] = knnsearch(FirstMG_coords,SecondMG_coords,'K',1);
    % If you're looking at just microglial coordinates, and want to know how
    % far away is the closest microglia (to calculate spacing index), you would
    % compare the same set of coordinates to each other, and look at the second
    % closes one. So you use K=2 and look at the 2nd column.
    %create table of data
    Mean = mean(D);
    Max = max(D);
    Min = min(D);
    StatsNN = table(Mean,Max,Min);
    Distances = D;
    DistancesNN = table(Distances);
    dotLocations = find(mysheet.name == '.')
    nameBeforeFirstDot = mysheet.name(1:dotLocations(1)-1)
    filename = nameBeforeFirstDot + ".xlsx";
    writetable(StatsNN,fullfile(directory,filename),'Sheet', 1);
    writetable(DistancesNN,fullfile(directory,filename),'Sheet', 2);
    
end





