close all
clear all

t=6;
initial=[0 0 0 0 0 2];
p=[120 1.5 0.0045 0.05 600 9];

[T,Y] = broomheadxpp( t,initial, p );

plot(T,Y(:,1))