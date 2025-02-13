function [initialPopulations, modelParameters, simulationParameters, discretizationParamaters, epsilon, eta] = initializeSimulation

epsilon = 0;%1e-23; % threshol for smallest value of population density (to avoid singularity due to 1/N term) 

%---simulation parameters----------------------------------------------
T = 5000; %final time
storageTimes = 0 : 20 : T; % solution storage times. Solutins are sored at closest time samples depending on Dt
x_0 = 0;    x_I = 70; % x1 range
simulationParameters = struct('T', T, 'times', storageTimes, 'x_0', x_0, 'x_I', x_I);

%---discretization parameters------------------------------------------
Dt = 0.005;  % time steps
Dx = (x_I - x_0)/ 700; %x1 mesh   
discretizationParamaters = struct('Dt', Dt, 'Dx', Dx);

x = x_0 : Dx : x_I;
I = length(x);

%---model parameters---------------------------------------------------
global D1 D2 V_s V_u1 V_u2 U kappa K1 K2 Q_opt R1 R2
D1 = 1;  % diffusion matrix for populationn 1
D2 = 1;  % diffusion matrix for populationn 2
V_s = 1/0.2;    % 1/measure of the strength of stabilizing selection (V_s = 1/S, where S defined in Table 1)
V_u1 = 4;    % variance of the within phenotipic-resource utility curve for population 1 (V_u1 = V_1 where V is defined in Table 1)
V_u2 = 4;    % variance of the within phenotipic-resource utility curve for population 2 (V_u2 = V_2 where V is defined in Table 1)
U = 0.02;  % rate of increase in trait variance due to mutation
kappa = 0;  % population impact factor
K1 = 1 * ones(I, 1);  % carrying capacity for population 1
K2 = 1 * ones(I, 1);  % carrying capacity for population 2
R1 = 1.1 * ones(I, 1);  % intrinsic rate of increase for optimally adapted individuals of population 1
R2 = 1 * ones(I, 1);  % intrinsic rate of increase for optimally adapted individuals of population 2

dQ_opt = -0.5; % optimum trait gradient dQ
Q_0 = 10; % optimum trait at x_J

Q_opt = Q_0 + dQ_opt  * (x - x(end))';    % optimum trait value 

%-----------------

modelParameters = struct('D1', D1, 'D2', D2,  'V_s', V_s, 'V_u1', V_u1, 'V_u2', V_u2, 'U', U, 'kappa', kappa, 'K1', K1, 'K2', K2, 'Q_opt', Q_opt, 'R1', R1, 'R2', R2);

%---solver parameters----------------------------------------------------
eta = 1/2;

%---initial values-------------------------------------------------------
initialPopulations = struct('density', [], 'trait_mean', [], 'trait_variance', []);

%---For competitive exclusion -------------------------------------------- 
center = 30; % population center
radius = sqrt(1); % population radius in each direction 
initialPopulations(1).density = 0.5 * sech( abs( x - center ) / radius )' + epsilon;
center_index_x = dsearchn(x', center); 
initialPopulations(1).trait_mean = 0.1 * ( Q_opt - Q_opt(center_index_x) ) + Q_opt(center_index_x);
initialPopulations(1).trait_variance = 1 * ones(I, 1);

center = 55; % population center 
radius = sqrt(1); % population radius in each direction
initialPopulations(2).density = 0.5 * sech( abs( x - center ) / radius )' + epsilon;
center_index_x = dsearchn(x', center); 
initialPopulations(2).trait_mean = 0.1 * ( Q_opt - Q_opt(center_index_x) ) + Q_opt(center_index_x);
initialPopulations(2).trait_variance = 1 * ones(I, 1);



end

