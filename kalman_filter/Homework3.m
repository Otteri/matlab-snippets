% ELEC-E8104 - Stochastic models and estimation
% Homework 3
%
% P-2
clear;
% Load given data:
load("hw3_data.mat");
% Alternatively load dataset manually

% Model:
F = [1.2, 1; -0.5, 0];
G = [0.6; 0.2];
H = [1, 0];

% Noises:
Q = [1, 0; 0, 1];
R = 0.2;

% Set initial conditions:
P_prior(:,:,1) = [10, 0; 0, 10];
xHat(:,1) = [0; 0];

% The Kalman filter
% Logic follows KF diagram in: ELEC_E8104_equation_2018.pdf.
% Notice that the loop begins from "Innovation covariance",
% since we already have the "state prediction covariance".
for k=1:100
    S(:,:,k) = R+H*P_prior(:,:,k)*H';                          % Innovation covariance
    W(:,:,k) = P_prior(:,:,k)*H'*S(:,:,k)^-1;                  % Filter gain
    Pcov(:,:,k) = P_prior(:,:,k)-W(:,:,k)*S(:,:,k)*W(:,:,k)';  % Updated state covariance
    zHat(:,k) = H*xHat(:,k);                                   % Measurement prediction
    v(:,k) = y(:,k)-zHat(:,k);                                 % Measurement residual
    xpos(:,k) = xHat(:,k)+W(:,:,k)*v(:,k);                     % Updated state estimate
    xHat(:,k+1) = F*xpos(:,k)+G*u(:,k);                        % State prediction
    P_prior(:,:,k+1) = F*Pcov(:,:,k)*F'+Q;                     % State prediction covariance
end

% Plot:
hold on
plot(x(1,1:100));
plot(xpos(1,1:100));
legend('Real state', 'Estimate', 'Location','NorthWest');
title("Kalman-estimate (P-2)");

%%
% P-3

clear;
u    = [10, -10, 0];
y_1  = [0, 3.2, -0.8];
y_2  = [NaN, 0, 3];
y_12 = [y_1; y_2];
F    = [0.8, 0; 1, 0];
G    = [0.3; 0];
H    = [1, 0; 0, 1];
Q    = [0.01, 0; 0, 0];
R    = [0.1, 0; 0, 0.01];

xHat(:,1) = [0;0];
P_prior(:,:,1) = [1,0;0,1];

% first iteration must be done outside loop, because we don't have y2 yet.
k = 1;
zHat(:,k) = H*xHat(:,k);                                       % Measurement prediction
v(:,k) = y_1(:,k)- zHat(:,k);                                  % Measurement residual    
S(:,:,k) = R + H*P_prior(:,:,k)*H';                            % Innovation covariance
W(:,:,k) = P_prior(:,:,k)*H'*S(:,:,k)^-1;                      % Filter gain 
P_u(:,:,k) = P_prior(:,:,k) - W(:,:,k)*S(:,:,k)*W(:,:,k)';     % Updated state covariance
x_u(:,k) = xHat(:,k) + W(:,:,k) * v(:,k);                      % Updated state estimate    
xHat(:,k+1) = F*x_u(:,k)+G*u(:,k);                             % State prediction
P_prior(:,:,k+1) = F*P_u(:,:,k)*F'+Q;                          % State prediction covariance

% Now we can iterate normally.
% Instead of using one y-datavector, we should utilize both.
for k = 2:3
    zHat(:,k) = H*xHat(:,k);                                   % Measurement prediction
    v(:,k) = y_12(:,k)- zHat(:,k);                             % Measurement residual    
    S(:,:,k) = R + H*P_prior(:,:,k)*H';                        % Innovation covariance
    W(:,:,k) = P_prior(:,:,k)*H'*S(:,:,k)^-1;                  % Filter gain
    P_u(:,:,k) = P_prior(:,:,k) - W(:,:,k)*S(:,:,k)*W(:,:,k)'; % Updated state covariance
    x_u(:,k) = xHat(:,k) + W(:,:,k) * v(:,k);                  % Updated state estimate
    xHat(:,k+1) = F*x_u(:,k)+G*u(:,k);                         % State prediction
    P_prior(:,:,k+1) = F*P_u(:,:,k)*F'+Q;                      % State prediction covariance
end

% Plot:
hold on;
plot(y_12(1,1:3));
plot(xHat(1,1:3));
legend("State", "Estimate");
title("Kalman-estimate (P-3)");

