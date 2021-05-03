% The default matlab startup script for AstroPack
% edit(fullfile(userpath,'startup.m'))

% display numbers format
format short g

% random numbers
% randomizing the seed of the matlab random number generator
%rand('state',sum(100*clock));
rng('shuffle');


% define graphics defaults
% set the plot AxesFontSize and AxesFontName default
set(0,'DefaultAxesFontSize',14);
set(0,'DefaultAxesFontName','times');


% define in session constants
% Assign variables to the matlab workspace
assignin('base','RAD',180./pi);    % Radian


% BaseDir
MatlabDir    = 'matlab';          %%% <--- EDIT IF NEEDED
AstroPackDir = 'AstroPack';       %%% <--- EDIT IF NEEDED
CatsHTMDir   = '/euler/catsHTM';  %%% <--- EDIT IF NEEDED - use '', if no catsHTM

if (ismac || isunix)
    % mac / unix
    HomeDir = getenv('HOME');
else
    % windows
    HomeDir = getenv('HOMEPATH');
end
if (isempty(HomeDir))
    error('Can not find home directory environment variable - edit the startup.m file accordingly');
end
AstroPackPath = sprintf('%s%s%s%s%s',HomeDir,filesep,MatlabDir,filesep,AstroPackDir);

% addpath for AstroPack
% This is a cell array of cell arrays
% Each cell contains one path to add.
% The inside cell gives the directory path - e.g., {'matlab','astro'} means .../matlab/astro/
DirList.AstroPack = {{AstroPackPath,'data','test_images','fits_samples'},...
                     {AstroPackPath,'matlab','astro'},...
                     {AstroPackPath,'matlab','base'},...
                     {AstroPackPath,'matlab','external'},...
                     {AstroPackPath,'matlab','image'},...
                     {AstroPackPath,'matlab','pipeline'},...
                     {AstroPackPath,'matlab','util'},...
                     {AstroPackPath,'matlab','obsolete'}};

if ~isempty(CatsHTMDir)
    DirList.CatsHTM = {{CatsHTMDir,'2MASS'},...
                       {CatsHTMDir,'2MASSxsc'},...
                       {CatsHTMDir,'AAVSO_VSX'},...
                       {CatsHTMDir,'AKARI'},...
                       {CatsHTMDir,'APASS'},...
                       {CatsHTMDir,'Cosmos'},...
                       {CatsHTMDir,'CRTS_per_var'},...
                       {CatsHTMDir,'DECaLS','DR5'},...
                       {CatsHTMDir,'FIRST'},...
                       {CatsHTMDir,'GAIA','DR1'},...
                       {CatsHTMDir,'GAIA','DR2'},...
                       {CatsHTMDir,'GAIA','DR2_19'},...
                       {CatsHTMDir,'GAIA','DRE3'},...
                       {CatsHTMDir,'GALEX','DR6Plus7'},...
                       {CatsHTMDir,'GLADE'},...
                       {CatsHTMDir,'GLIMPSE'},...
                       {CatsHTMDir,'HST','HSCv2'},...
                       {CatsHTMDir,'IPHAS','DR2'},...
                       {CatsHTMDir,'LAMOST','DR4'},...
                       {CatsHTMDir,'NED','20180502'},...
                       {CatsHTMDir,'NOAO'},...
                       {CatsHTMDir,'NVSS'},...
                       {CatsHTMDir,'PGC'},...
                       {CatsHTMDir,'PS1'},...
                       {CatsHTMDir,'PTFpc'},...
                       {CatsHTMDir,'ROSATfsc'},...
                       {CatsHTMDir,'SDSS','DR10'},...
                       {CatsHTMDir,'SDSS','DR14offset'},...
                       {CatsHTMDir,'Simbad_PM200'},...
                       {CatsHTMDir,'SkyMapper'},...
                       {CatsHTMDir,'SpecSDSS','DR14'},...
                       {CatsHTMDir,'Spitzer','IRACgc'},...
                       {CatsHTMDir,'Spitzer','SAGE'},...
                       {CatsHTMDir,'SWIREz'},...
                       {CatsHTMDir,'UCAC4'},...
                       {CatsHTMDir,'UCACGAIADR2accel'},...
                       {CatsHTMDir,'UKIDSS','DR10'},...
                       {CatsHTMDir,'unWISE'},...
                       {CatsHTMDir,'URAT1'},...
                       {CatsHTMDir,'VISTA'},...
                       {CatsHTMDir,'VISTA','Viking','DR2'},...
                       {CatsHTMDir,'VST','ATLAS','DR3'},...
                       {CatsHTMDir,'VST','KiDS','DR3'},...
                       {CatsHTMDir,'WISE'},...
                       {CatsHTMDir,'XMM'},...
                       {CatsHTMDir,'ZTF','LCDR1'},...
                       {CatsHTMDir,'ZTF','SrcLCDR1'},...
                       {CatsHTMDir,'ZTF','ztfDR1var'}};                     
end       
                 
% add all DirList to path                 
FN  = fieldnames(DirList);
Nfn = numel(FN);
for Ifn=1:1:Nfn
    Tmp = DirList.(FN{Ifn});
    Ndir = numel(Tmp);
    for Idir=1:1:Ndir
        FullPath = sprintf('%s%s%s%s%s%s%s',fullfile(Tmp{Idir}{:}));
        addpath(FullPath)
    end
end
