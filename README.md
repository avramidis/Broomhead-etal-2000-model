## Broomhead-etal-2000-model ##

This repositosy includes Matlab and Python code that can be used to integrate the Broomhead et al. (2000) saccadic model. 

The MATLAB script uses the ode15 solver.

The [XPPAUT](http://www.math.pitt.edu/~bard/xpp/xpp.html) script uses the [trapezoidal rule](http://en.wikipedia.org/wiki/Trapezoidal_rule_%28differential_equations%29).

The Broomhead.py Python script uses the vode method.

The broomhead.m file includes the broomhead function which integrates the model using MATLAB for a time interval and a model parameter set. The broomheadxpp integrates the model using XPPAUT.

The Broomhead et al. (2000) model is a saccadic model that can generate both normal and abnormal eye movements (e.g. nystagmus).

Descriptions of the model can be found at:
http://eprints.ma.man.ac.uk/217/01/covered/MIMS_ep2006_62.pdf
http://link.springer.com/article/10.1007/s00285-005-0336-4

This codebase was developed in collaboration with [Dr. Ozgur E. Akman](http://emps.exeter.ac.uk/mathematics/staff/oea201) at the [University of Exeter, UK](http://www.exeter.ac.uk/). 

##How to run the code##

Using Matlab run the main.m or mainxpp.m file.

For Python run the broomhead.py script.

