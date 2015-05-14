# Broomhead-etal-2000-model
Code for Broomhead et al. (2000) saccadic model

Integration of the Broomhead et al. (2000) saccadic model using MATLAB. 

Paper of the model can be found at 
http://www.ncbi.nlm.nih.gov/pubmed/10836585 and 
http://eprints.ma.man.ac.uk/217/01/covered/MIMS_ep2006_62.pdf

Sample MATLAB code to run the model:

t=[0 6];
initial=[0 0 0 0 0 2];
p=[120 1.5 0.0045 0.05 600 9];

[T,Y]  = broomhead( t, initial, p );

plot(T,Y(:,1))
