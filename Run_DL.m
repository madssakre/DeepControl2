% Script used to train networks to predict multi-dimensional RF pulses for MRI
%
% as descibed in
%
%    DeepControl: 2DRF pulses facilitating B1+ inhomogeneity and B0 off‐resonance compensation in vivo at 7 T
%
%    Mads S. Vinding 1, Christoph S. Aigner 2, Sebastian Schmitter 2,3, Torben E. Lund 1
%
%    1: Center of Functionally Integrative Neuroscience, Aarhus University, Denmark
%    2: Physikalisch-Technische Bundesanstalt, Braunschweig and Berlin, Germany
%    3: Center for Magnetic Resonance Research, University of Minnesota, Minneapolis, Minnesota, USA
%
%  Correspondence:
%  Mads S. Vinding,
%  Center of Functionally Integrative Neuroscience,
%  Aarhus University,
%  Denmark
%  Email: msv<Snabel-A>cfin.au.dk
%
%
% 
%  Magn Reson Med. 2021;85:3308–3317. 
%  DOI: 10.1002/mrm.28667
%
%
%  PLEASE NOTE: The workflow behind this work largely follows that of our first
%  publication: 
%
%     Ultra-fast (milliseconds), multi-dimensional RF pulse design with deep learning
%
%     Mads Sloth Vinding 1, Birk Skyum 2, Ryan Sangill 1, Torben Ellegaard Lund 1
%
%  in the repository: 
%
%      https://github.com/madssakre/DeepControl
%
%  The difference is the type of input. Now being 64x64x3 for each case. And
%  the output now sized 1x1400 for each case. The first input layer is the
%  the target pattern. The second input layer is the B0 map, scaled to the range
%  -1 to 1, where 1 corresponds to a value of 600 Hz. The third layer is the
%  B1 sensitivity map ranging from 0 to 1.
%
%
%  PLEASE NOTE: The training and validation inputs and targets loaded below
%  are designed for this demonstration... to enable the user to see
%  the script running. It is not expected, due to the limited size, that
%  the network will converge to a state-of-the-art network. The user will have to
%  increase the library by own hand, and the data provided is only to show
%  one possible construction. The data also includes the spiral gradient
%  waveform that was used and the scale factor we used to transfer the
%  predicted pulses to physical units.
%
%  The authors take no responsibilities for the use of this software
%
%     Copyright (C) 2021  Mads Sloth Vinding
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.


load('Example_data.mat'); 



% design the neural network skeleton
 Layers = [ ...
    imageInputLayer([64,64, 3],'Normalization','none','Name','input')
    convolution2dLayer(5,40,'Stride',2,'Name','conv1')
    reluLayer('Name','relu1')
    convolution2dLayer(3,600,'Stride',2,'Name','conv2')
    reluLayer('Name','relu2')
    convolution2dLayer(2,60','Stride',2,'Name','conv3')
    reluLayer('Name','relu3')
    fullyConnectedLayer(6000,'Name','fc2')
    fullyConnectedLayer(1400,'Name','fc3')
    regressionLayer('Name','output')];



% define options
options = trainingOptions(...
    'sgdm', ...
    'MaxEpochs',1000,...
    'Shuffle','every-epoch',...
    'Plots','training-progress',...
    'ValidationData',{validateInput,validateTarget},...
    'ValidationPatience',Inf,...,
    'ExecutionEnvironment','gpu',...
    'ValidationFrequency', 1000,...
    'InitialLearnRate',0.006,...
    'MiniBatchSize',1024);


% start training with validation
[net,netinfo] = trainNetwork(trainInput,trainTarget,Layers,options);


% save the net
save('net.mat','net')





