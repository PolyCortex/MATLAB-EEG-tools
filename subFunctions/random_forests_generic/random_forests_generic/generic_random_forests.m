function [BaggedEnsemble, nodeLevels, nodeAngles, nodeProp, nodeParents] = generic_random_forests(X,Y,iNumBags,str_method)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name - generic_random_forests
% Creation Date - 6th July 2015
% Author - Soumya Banerjee
% Website - https://sites.google.com/site/neelsoumya/
%
% Description - Function to use random forests
%
% Parameters - 
%	Input	
%		X - matrix
%		Y - matrix of response
%		iNumBags - number of bags to use for boostrapping
%		str_method - 'classification' or 'regression'
%
%	Output
%               BaggedEnsemble - ensemble of random forests
%               Plots of out of bag error
%
% Example -
%
%	 load fisheriris
% 	 X = meas;
%	 Y = species;
%	 BaggedEnsemble = generic_random_forests(X,Y,60,'classification')
%	 predict(BaggedEnsemble,[5 3 5 1.8])
%
%
% Acknowledgements -
%           Dedicated to my mother Kalyani Banerjee, my father Tarakeswar Banerjee
%				and my wife Joyeeta Ghose.
%
% License - BSD
%
% Change History - 
%                   7th July 2015 - Creation by Soumya Banerjee
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% When 'OOBPredict' is 'On', info on what observations are out of bag for 
% each tree is stored. 
BaggedEnsemble = TreeBagger(iNumBags,X,Y,'OOBPred','On','Method',str_method,'PredictorSelection','curvature','OOBPredictorImportance','on','PredictorNames',{'slowWave','delta','theta','alpha','beta'});

% % UNCOMMENT FOR : plot out of bag prediction error
% oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
% figID = figure;
% plot(oobErrorBaggedEnsemble)
% xlabel 'Number of grown trees';
% ylabel 'Out-of-bag classification error';
% print(figID, '-dpdf', sprintf('randomforest_errorplot_%s.pdf', date));

% Info from turning 'OOBPredict' 'On' as part of the 'TreeBagger' fonction 
% is used by 'oobPrediction' to compute the predicted class probabilities 
% for each tree in the ensemble.
oobPredict(BaggedEnsemble)

% to obtain tree levels array
a = BaggedEnsemble.Trees{1};
nodeLevels = zeros(size(a.Parent));
currParent0 = 0;
currLevel = 1;
nodeLevels(1) = currLevel-1;
for i = 2:a.NumNodes
    % assign node parent to a variable
    currParent = a.Parent(i);
    % determine if current parent is different from previous parent
    if currParent ~= currParent0
        % if current parent is different from last parent, assign current
        % parent, 'currParent' as initial parent, 'currParent0'
        currParent0 = currParent;
        % initialize maximim spots count
        remSpots = 2;
    end
    remSpots = remSpots - 1;
    nodeLevels(i) = currLevel;
    if remSpots == 0 && i ~= a.NumNodes
        if nodeLevels(a.Parent(i)) ~= nodeLevels(a.Parent(i+1))
            currLevel = currLevel+1;
        end
    end          
end
% to obtain nodes angles array
nodeAngles = zeros(size(a.Parent));
nodeProp = zeros(size(a.Parent)); 
for ii = 2:2:(a.NumNodes-1)
   % first angle, alpha
   nodeProp(ii) = 1-a.NodeProbability(ii)/a.NodeProbability(a.Parent(ii));
   nodeAngles(ii) = nodeProp(ii)*pi/2;
   % second angle, beta
   nodeProp(ii+1) = 1-nodeProp(ii);
   nodeAngles(ii+1) = nodeAngles(ii)-pi/2;
end
nodeParents = a.Parent;
nodeProp = 1-nodeProp;

% % UNCOMMENT FOR : note that there are 'n' number of trees corresponding to iNumBags, where
% % 'n' is the input to the function 'view(BaggedEnsemble.Trees{n})'
% % to view the fist tree (n = 1) 
% view(BaggedEnsemble.Trees{1}) % text description
view(BaggedEnsemble.Trees{1},'mode','graph') % graphic description
