function  call_generic_random_forests()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name - call_generic_random_forests
% Creation Date - 7th July 2015
% Author - Soumya Banerjee
% Website - https://sites.google.com/site/neelsoumya/
%
% Description - Function to load data and call generic random forests function
%
% Parameters - 
%	Input	
%
%	Output
%               BaggedEnsemble - ensemble of random forests
%               Plots of out of bag error
%		Example prediction	
%
% Example -
%		call_generic_random_forests()
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

load fisheriris

% 'X' represents the numeric matrix of training data, with features for each 
% observation in the form : 
% [(petal length) (petal width) (sepal length) (sepal width)]
X = meas;

% 'Y' are predicted responses (labels) as a function of observations in X
Y = species;

% 'treesCount' is the number of decision trees for predicting response Y 
% as a function X
treesCount = 60;

BaggedEnsemble = generic_random_forests(X,Y,treesCount,'classification');

% function 'predict(Mdl,X)' returns a vector of predicted class labels for 
% the predictor data in the table or matrix 'X', based on the trained 
% discriminant analysis classification model 'Mdl'
predict(BaggedEnsemble,[5 3 5 1.8])
