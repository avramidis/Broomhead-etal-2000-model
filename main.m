close all
clear all

t=[0 6];                        // Integration time span. 0 to 6 seconds.
initial=[0 0 0 0 0 2];          // Broomhead et al. model's initial values. Set for 2 degrees eye movement.
p=[120 1.5 0.0045 0.05 600 9];  // Broomhead et al. model's parameter values. Jerk waveform.

[T,Y]  = broomhead( t, initial, p );  // Call the MATLAB solver

plot(T,Y(:,1)) // Plot the simulated gaze angle


