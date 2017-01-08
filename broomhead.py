# Author: Eleftherios Avramidis $
# Email: el.avramidis@gmail.com $
# Date: 2017/01/07 $
# Version: 1.0 $
# Copyright: MIT License

import time
import math
from scipy.integrate import ode
import numpy as np
import matplotlib.pyplot as plt

start_time = time.time()

def sburstf( x, aval,  bval,  atval,  btval ):
    if (x > 0.00):
        y=(atval * (1.00 - math.exp(-x / btval)))
    else:
        y=(-(aval / bval) * x * math.exp(x / (bval)))

    return y

def f(t, y, p):
    T1=0.15;
    T2=0.012;
    Tn=25.00;

    yout = np.zeros(6)

    yout[0] = y[1];
    yout[1] = -(((1.00 / T1) + (1.00 / T2)) * y[1]) - (1.00 / (T1 * T2) * y[0]) + (1.00 / (T1 * T2) * y[2]) + ((1.00 / T1) + (1.00 / T2)) * (y[3] - y[4]);
    yout[2] = -(y[2] / Tn) + (y[3] - y[4]);
    yout[3] = (1.00 / p[2])*(-y[3] - (p[3] * y[3] * ((y[4]**2))) + sburstf(y[5], p[0], p[1], p[4], p[5]));
    yout[4] = (1.00 / p[2])*(-y[4] - (p[3] * y[4] * ((y[3]**2))) + sburstf(-y[5], p[0], p[1], p[4], p[5]));
    yout[5] = -(y[3] - y[4]);

    return yout.tolist()


def dsburstf( x, aval,  bval,  atval,  btval ):
    if (x > 0.00):
        y=(atval*math.exp(-x / btval)) / btval;
    else:
        y=-((aval*math.exp(x / bval)) / bval + (aval*x*math.exp(x / bval)) / bval**2);

    return y

def jac(t, y, p):
    T1=0.15;
    T2=0.012;
    Tn=25.00;

    jac = np.zeros((6,6))

    jac[0,0] = 0;
    jac[0,1] = 1;
    jac[0,2] = 0;
    jac[0,3] = 0;
    jac[0,4] = 0;
    jac[0,5] = 0;

    jac[1,0] = -1 / (T1*T2);
    jac[1,1] = -(1 / T1) - (1 / T2);
    jac[1,2] = 1 / (T1*T2);
    jac[1,3] = (1 / T1) + (1 / T2);
    jac[1,4] = -(1 / T1) - (1 / T2);
    jac[1,5] = 0;

    jac[2,0] = 0;
    jac[2,1] = 0;
    jac[2,2] = -1 / Tn;
    jac[2,3] = 1;
    jac[2,4] = -1;
    jac[2,5] = 0;

    jac[3,0] = 0;
    jac[3,1] = 0;
    jac[3,2] = 0;
    jac[3,3] = -(p[3] * (y[4]**2) + 1) / p[2];
    jac[3,4] = -(2 * p[3] * y[4] * y[3]) / p[2];
    jac[3,5] = dsburstf(y[5], p[0], p[1], p[4], p[5]) / p[2];

    jac[4,0] = 0;
    jac[4,1] = 0;
    jac[4,2] = 0;
    jac[4,3] = -(2 * p[3] * y[4] * y[3]) / p[2];
    jac[4,4] = -(p[3] * (y[3]**2) + 1) / p[2];
    jac[4,5] = dsburstf(-y[5], p[0], p[1], p[4], p[5]) / p[2];

    jac[5,0] = 0;
    jac[5,1] = 0;
    jac[5,2] = 0;
    jac[5,3] = -1;
    jac[5,4] = 1;
    jac[5,5] = 0;

    return jac.tolist()

y0, t0 = [0.0, 0.0, 0.0, 0.0, 0.0, 2.0], 0
p=[120, 1.5, 0.0045, 0.05, 600, 9]

r = ode(f, jac)
r.set_integrator('vode')
r.set_initial_value(y0, t0)
r.set_f_params(p)
r.set_jac_params(p)

t1 = 6
dt = 5e-6

yout = np.zeros((math.ceil(t1/dt)+1,6))
i=0
while r.successful() and r.t < t1:
    yout[i]=r.integrate(r.t+dt)
    i=i+1

print("--- %s seconds ---" % (time.time() - start_time))

t = np.arange(0.0, t1+dt, dt)
plt.plot(t,yout[:,0])
plt.ylabel('Gaze angle (degs)')
plt.xlabel('Time (s)')
plt.show()

