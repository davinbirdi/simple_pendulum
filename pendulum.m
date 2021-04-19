close all;
clear
clc

% Initial Conditions:
theta_initial = 2*pi/4;
v_initial = 100;

theta = theta_initial;
v = v_initial;

% Constants:
g = -9.8;
m = 1;
l = 1;
b = -0.05;

% Initializations:
timestep = 0.005;
endtime = 1.5;

time_data = [];
theta_data = [];
pos_data = [];
vel_data = [];


for index = 0:timestep:endtime
    
    % Numerical Iterative solution
    
    theta = theta + v*timestep;
    % Bounding Theta (-pi, pi]
    if (theta>pi); theta = theta - 2*pi; end
    
    s = sin(theta) * l;
    v = v + g*sin(theta) + b*v;
    
    % Data Collection
    theta_data = [theta_data ; theta];
    pos_data = [pos_data ; s];
    vel_data = [vel_data; v];
    
    time_data = [time_data; index];
    
end


% Plotting:
figure(1);
movegui("west")
tiledlayout(3,1)

nexttile
plot(time_data, theta_data)
ylabel("Theta")
yticks([-pi -pi/2 0 pi/2 pi])
yticklabels({ '-\pi','-\pi/2', '0', '\pi/2','\pi'})
title("Theta measured from Equilibrium v. Time")
my_string = "Length = " + l + ', Mass = ' + m + ", Damping Coeff. = " + b + ...
    ", Initial Angle: " + num2str(theta_initial, '%0.2f') + ", Initial Velocity: " + v_initial;
subtitle(my_string)

nexttile
plot(time_data, pos_data)
title("X-Position measured from Equilibrium v. Time")
ylabel("X-Position")

nexttile
plot(time_data, vel_data)
title("Tangential Velocity v. Time")
ylabel("Tangential-Velocity")


% Animation: Dynamic Plot
% Credits to Yuni Fuchioka for who's code I based this on.
figure(2)
movegui('center')

y_data = 1-l*cos(theta_data);

for i = (1:max(size(time_data)))
    coord = [0 pos_data(i); 1 y_data(i)];
    
    figure(2);
    
    hold off
    plot(coord(1,:), coord(2,:), '-o', 'MarkerSize', 10, 'LineWidth', 2)
    hold on;
    plot(pos_data(1:i),y_data(1:i))
    
    title(("Time = " + num2str(time_data(i),'%0.2f')));
    axis([-2*l 2*l -l/2 7/2*l])
    axis square
    
    pause(0.001)
end

% Cleanup
clear coord i my_string theta_initial v_initial ...
    timestep theta s  v endtime index