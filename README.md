# Simple Pendulum Simulation
Matlab Simple Pendulum simulation. To be used for Path Generation in the future.

## Resulting Figures:
<div>
<img src="https://github.com/davinbirdi/simple_pendulum/blob/main/pendulum1.png?raw=true" width="40%">
<img src="https://github.com/davinbirdi/simple_pendulum/blob/main/pendulum2.png?raw=true" width="40%">
</div>

## Program:

Initializing Variables for computation:
```
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
```

As you can see I created a empty matrices here which would contain my data. Matlab tells me that I should predefine the size of these to improve performance, but I was OK with this for the first few iterations of this.

As this is a non-linear differential equation, it's not easy to solve analytically but not so bad to solve numerically via this discrete method that we continously apply the kinematic equations to.
```
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
```
We can see I appended each iteration onto the current array of the previous data, making it longer each cycle. To apply more resolution, we can decrease the timestep.


To plot the position, angle, and velocity of the pendulum, I used a simple tiledlayout to create multiple plots within one figure. Most of the code below relates to the formatting of the plots.
```
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
```

### Animation:

This was the coolest part of this simulation which I based off of my friend Yuni's previous code from a Robotics class we took together.
I first created the y-data as it was not necessary in the above loop. In the loop I begin cycling through each of the data arrays.

The coord variable is a 2x2 array which stores the data of the pendulum origin in the first column and the current position in the second.
The first plot command plots the mass, drawing a line from the origin to the ball's position. We use the command `hold off` to draw only the current frame, which we do the opposite of in the second plot command which draws the history of where the end mass has been using the x and y position data.

We need to lock the axis which we set as square with the appropriate window size in order to keep it constant while the animiation plays. This prevents it from "zooming out" as it automatically sets the window size based on the data it is currently displaying.

```
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
```

This whole scripts provides the figures shown above and can be altered to adjust the Initial Conditions and various constants.
