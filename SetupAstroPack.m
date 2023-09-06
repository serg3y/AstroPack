% Inputs
rootfolder = 'D:\MatLab'; %where to install AstroPack.git

% Clone AstroPack
cd(rootfolder)
if ~isfolder('AstroPack.git')
    !git clone https://github.com/EranOfek/AstroPack AstroPack.git
    cd AstroPack.git
    !git checkout dev1
end

% Set environment variable
if isempty(getenv('ASTROPACK_PATH'))
    setenv('ASTROPACK_PATH',fullfile(rootfolder,'AstroPack.git'))
end
%TODO: this is for the sessnion only, make it permonent

% Configure MatLab startup.m
startupfile = which('startup');
if isempty(startupfile)
    startupfile = fullfile(userpath,'startup.m');
    system(['echo run ' rootfolder '\AstroPack.git\matlab\startup\startup.m > ' startupfile]); %create new file
elseif ~contains(fileread(startupfile),'AstroPack.git\matlab\startup\startup.m')
    system(['echo run ' rootfolder '\AstroPack.git\matlab\startup\startup.m >> ' startupfile]); %append to file
end
% run(startupfile)

% Test mex
cd(rootfolder)
try 
    copyfile(fullfile(matlabroot,'extern','examples','mex','yprime.c'),'.')
    mex yprime.c
catch
    error('Manual mex required: MatLab "Home" tab > Add ons > Search for "MinGW" > select "MATLAB Support for MinGW-w64 C/C++Compiler" > Install > Install ')
end
