% Script estimates house prices by creating a linear regression model
% Function input: [ area, construction year, room number, floor amount, x-coord., y-coord. ]
% Model is created from similar Excel data.
% It is beforehandedly known that the downtown location is:
% x = 1.43 km
% y = 0.63 km

function price_house = estimate_price(input)
	display_figures = true; % Set true to show figures
    global stats;   % [R2, F-statistics, p-value, estimate of error variance]
    
    % Create model from the Excel data. 
    % Leave some rows for the model validation.
    data = xlsread('input_data.xlsx');
    y  = data(1:170,1); % price (€)
    x1 = data(1:170,2); % living space (m2)
    x2 = data(1:170,3); % construction year
    x3 = data(1:170,4); % floor number
    x4 = data(1:170,5); % number of rooms
    x5 = data(1:170,6); % x-location of the house
    x6 = data(1:170,7); % y-location of the house
    x7 = sqrt((x5-1.43).^2 + (x6-0.63).^2); % distance to downtown
    
    X = [ones(length(x1),1) x1 x2 x3 x4 x7];
    [b,~,SSR,~,stats] = regress(y,X);  % calculates: inv(X'*X)*X'*y;

    distance_to_downtown = sqrt((input(5)-1.43).^2 + (input(6)-0.63).^2);
    house_params = [input(1:4), distance_to_downtown];
    house_params = [1, house_params] % y = b0 + b1*x1 + b2*x2 ... 
                                     % first term is not multiplied with x, thus 1). 
    price_house = house_params*b     % y_est -> estimate price
    
    % validation step:
    MaxErr = max(abs(price_house - y))
    
    % Calcualating SSE and SST
    SSE = 0; SST = 0;
    y2_mean = mean(house_params);
    for n = 1:length(house_params)
       SSE = SSE + (house_params(n) - (b(n)')^2);
       SST = SST + (house_params(n) - y2_mean)^2;
    end
    
    % =====================================================================
    % PLOTS.
    if display_figures

        % Individual figures for all data columns
        xlabels = {'Price','Living space','Construction year','Floor number', ...
                   'number of rooms', 'x-location', 'y-location'}
        y  = data(:,1);
        for i = 2:7 % figures n:m
            figure;
            b1 = data(:,i)\y;
            yCalc1 = b1*data(:,i);
            scatter(data(:,i),y);
            hold on
            plot(data(:,i),yCalc1);

            X = [ones(length(data(:,i)),1) data(:,i)];
            b = X\y;
            yCalc2 = X*b;
            Rsq1 = 1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2)
            Rsq2 = 1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2)
            plot(data(:,i),yCalc2)

            xlabel(xlabels(i));
            ylabel('Price (€)')
            title(['Linear regression relation between Price &',xlabels(i)])
            legend('Data',['Slope, R2 = ' num2str(Rsq1)],['Slope & intercept, R2 = ' num2str(Rsq2)],'Location','SouthEast');
            grid on; hold off;
        end
    end
end