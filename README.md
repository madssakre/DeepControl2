					DeepControl

						v 2.0

				      9-12-2020
				      
				      
				     Mads Vinding

INTRODUCTION

By designing a high number of pulse inputs, e.g., desired magnetization profiles, and then computing the pulses that best achieve the desired magnetization, we have shown that these informations can be used to train a neural network by deep learning, such that the network mimics the pulse computation tool, and when presented to a similar input, outputs a pulse very close to what the computation tool would output.

We call this DeepControl and it adheres to the convention of using optimal control theory or similar optimization strategies to compute and optimize a large number of controls, in this case, RF pulse controls, for MRI.

In this study we included B0 and B1+ fieldmaps in the training library and found that the network was able to compensate B0 and B1+ inhomogeneity effects in simulation and experiments at 7 tesla.

The study is described in:

    DeepControl: 2DRF pulses facilitating B1+ inhomogeneity and B0 off‐resonance compensation in vivo at 7 T

    Mads S. Vinding, Christoph S. Aigner, Sebastian Schmitter, Torben E. Lund

	Magn Reson Med. 2021;85:3308–3317. 
	DOI: 10.1002/mrm.28667


The optimal control that was used to create the training library is described in https://arxiv.org/abs/2107.00933

REMARKS

The nature of this method is vast training libraries of thousands and thousands RF pulses and their associated inputs used to calculate the pulses. These libraries are extensive in size, and today not something one would typically generate on commodity hardware (although it is not impossible). The networks, as we have developed in MATLAB, also occupy a decent amount of space.

Hence, this repository currently only support the training script and a small example data set. The users will have to, by own hand, setup the large scale optimizations on their own computer framework, and will also have to design the input by own hand. 

On reasonable request we may be able to give further support.