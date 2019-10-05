clc; clearvars; close all;

% Validation rows from the Excel
params = [69, 2010, 4, 10, 1.38727463782683, 0.522109940800501]; %line 199, ans = 302000
%params = [67, 2016, 3, 10, 1.56781992662921, 0.714859643999188]; %line 200, ans = 312000
%params = [68, 2019, 4, 8, 1.53419959237661, 0.63522700142074];   %line 201, ans = 308000

global stats; % R^2 etc. Just for checking...
price_estimate = estimate_price(params);
prettyPrice = vpa(price_estimate,5)