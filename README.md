## Broomhead-etal-2000-model ##

The Broomhead et al. (2000) model is a saccadic model that can generate both normal and abnormal eye movements (e.g. nystagmus).

The broomhead.m file includes the broomhead function which integrates the model using MATLAB for a time interval and a model parameter set.

Paper of the model can be found at:
http://www.ncbi.nlm.nih.gov/pubmed/10836585
http://eprints.ma.man.ac.uk/217/01/covered/MIMS_ep2006_62.pdf

##Example##

The following code shows how to use the broomhead function.

```matlab
t=[0 6];
initial=[0 0 0 0 0 2];
p=[120 1.5 0.0045 0.05 600 9];

[T,Y]  = broomhead( t, initial, p );

plot(T,Y(:,1))
```

