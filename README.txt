% First author and code base owner: Allie Del Giorno
% This code implements the discriminative framework for the A. Del Giorno, J.A. Bagnell, M. Hebert ECCV 2016 paper "A Discriminative Framework for Anomaly Detection in Large Videos"
% If you have issues running the code or plan to use it for research purposes, please contact me: adelgior@cs.cmu.edu .

% ===== Installation =====
% ffmpeg must be installed on your system (to unpack the videos).

% ===== Usage =====
% == Demo
% Run the script 'demo.m':
>> matlab -r demo
This script should run and terminate with a print statement "Demo success!" and a time.
On my (laptop) machine, it takes about 15 minutes.  The greatest proportion of time is spent 'unpacking' the videos.

% == Modifications
% You'll want to modify the script code/scripts/runscript.m as a starting point.
% Parameter modifications can be made in Configure.m (make your own configuration)
% The set of all parameters and their defaults are listed in code/src/configure/DefaultPars.m .  You can change most of these parameters in Configure.m .

% ===== Functionality =====
% This code takes a video file (.mp4, .avi) and returns a .train file (libsvm format) with features from the video.
% It will NOT generate anomaly scores for videos.  To generate your own features (or put them into the correct format for this code to use), please download the latest version of: ___________________ .
% One set of features is provided for comparison in: data/input/features/Avenue/03.

% ===== System Requirements =====
% Linux with MATLAB
% This code has been tested on Ubuntu 12.04.  The 'core' of the implementation is in C++, though some functionality/wrapping is provided in MATLAB.

% ===== Other notes =====
% This code was originally combined with the anomaly detection code before I decided to split it for usability, so if you see remnants of that code, my apologies!
