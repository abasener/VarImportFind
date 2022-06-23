%%------------------------------------------------------------
% Abgail Basener 4/8/2022
%
% This code will import data from a Excel file. It will use the first column
% of the file as the output and the other columns as predictors. It will
% build and display a decision tree based on those, then display a
% bar chart of the importance of the predictors.
% HR: https://www.mathworks.com/?s_tid=gn_logo, Bill Basener(father)
%%------------------------------------------------------------

%% Import and Setup Data from a File
T = readtable('cbb2.csv');   % Put the name of your data file and type here
leaf = [2 5 10 20 50 100];  % Change the depth of the tree for as manny iterations as wanted
output_var = 'POSTSEASON';  % Name in file of var you want as the classes
f = removevars(T,{output_var});
o = T.(output_var);
[z,w] = size(f);
j = 1;
%summary(T);
col = 'rbcmyg';
min_err = 10;

%% Make Forest with depths of leaf(i)
figure
hold on
for i=1:length(leaf)
    fprintf('Min Leaf Size: %d \n',leaf(i));
    b = TreeBagger(150,f,o,...
        'Method','classification', ...
        'OOBPredictorImportance', 'on', ...
        'MinLeafSize',leaf(i));
        %'PredictorSelection','curvature',...
        %'OOBPrediction','On', ...
    err = min(oobError(b));
    plot(oobError(b),col(i));
    if err<min_err
        min_err = err;
        b_best = b;
        j = i;
        %fprintf('New Best Min Leaf Size: %d \n',leaf(i))
    end
end
% Add Catagory Lables
title('Error Over Time for n Size Leaf Mix Stops');
xlabel('Number of Grown Trees')
ylabel('Error') 
legend({'2' '5' '10' '20' '50' '100'},'Location','NorthEast')
hold off

%% Output best tree from above
fprintf('-----------------------------')
view(b_best.Trees{1},'Mode','graph')
fprintf('Final Best Min Leaf Size: %d \n',leaf(j))
fprintf('Erro is: %d \n',min_err)

%% Get Importance
imp = b_best.OOBPermutedPredictorDeltaError;
% Show the Predictor Importance Estimates in a Bar Chart
figure;
bar(imp);
title('Predictor Importance Estimates');
ylabel('Estimates');
xlabel('Predictors');
grid on;
% Add Catagory Lables
t = linspace(1,w,w);
xticks(t);
h = gca;
h.XTickLabel = b.PredictorNames;
h.XTickLabelRotation = 45;