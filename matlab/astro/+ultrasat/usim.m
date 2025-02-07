function [usimImage, AP, ImageSrcNoiseADU] =  usim ( Args ) 
    % Make a simulated ULTRASAT image from a source catalog
    % Package: ultrasat
    % Description: Make a simulated ULTRASAT image from a source catalog
    % Input: -    
    %       * ...,key,val,... 
    %       'Cat'       - a catalog of simulated sources or the number of sources to generate randomly
    %       'SkyCat'    - the flag determines whether the input coordinates are RA, Dec
    %       'PlaneRotation - [deg] rotation of the plane w.r.t. the north celestial pole
    %       'Mag'       - a vector of source magnitudes or 1 magnitude for all the sources
    %       'Ebv'       - E(B-V) of the observed field 
    %       'FiltFam'   - the filter family for which the source magnitudes are defined
    %       'Filt'      - the filter[s] for which the source magnitudes are defined
    %       'SpecType'  - model of the input spectra ('BB','PL') or 'tab'
    %       'Spec'      - parameters of the input spectra (temperature, spectral index) or a table of spectral intensities
    %       'Exposure'  - image exposure
    %       'Tile'      - name of the ULTRASAT tile ('A','B','C','D')
    %       'ImRes'     - image resolution in 1/pix units (allowed values: 1, 2, 5, 10, 47.5)
    %       'RotAng'    - tile rotation angle[s] relative to the axis of the raw PSF database
    %       'RA0'       - the RA,  deg of the camera aimpoint 
    %       'Dec0'      - the Dec, deg of the camera aimpoint 
    %       'WCSFile'   - if not empty, the image WCS is read from this file
    %       'ArraySizeLimit' - the maximal array size, machine-dependent, determines the method in specWeight
    %       'MaxNumSrc'      - the maximal size of a source chunk to be worked over at a time
    %       'MaxPSFNum'      - the maximal number of recorded PSFs
    %       'NoiseDark'      - dark current noise (1/0)
    %       'NoiseSky'       - sky background (1/0)
    %       'NoisePoisson'   - Poisson noise (1/0)
    %       'NoiseReadout'   - Read-out noise (1/0)
    %       'Inj'            - source injection method (technical)
    %       'OutType'        - type of output image: FITS, AstroImage object, RAW object
    %       'Dir'            - the output directory
    %       'OutName'        - root name of the output files
    %       'SaveMatFile'    - whether to make an output .mat file with all the modelled structures
    %       'SaveRegionsBySourceMag' - whether to write additional region files according to the input source magnitudes
    %       'PostModelingFindSources' - do post modeling source search
    % Output : - an AstroImage object with filled Catalog property 
    %            (also a FITS image file output + ds9 region files, RAW file output)           
    %          - an array of per-object AstroPSFs
    %          - an ADU image (simple array)
    % Tested : Matlab R2020b
    % Author : A. Krassilchtchikov (Mar-Aug 2023)
    % Example: Sim = ultrasat.usim('Cat',1000) 
    % (simulate 1000 sources at random positions with the default spectrum and magnitude)  
    %          
  
    arguments          
        Args.Cat             =  10;          % if a number (N), generate N random fake sources
                                             % if a 2D table, use X, Y from this table
                                             % if an AstroCatalog object, use source coordinates from this object
        Args.SkyCat logical  = false;        % the flag determines whether the input coordinates are RA, Dec or in X, Y
        Args.PlaneRotation   =   0;          % [deg] rotation of the detector plane w.r.t. the north celestial pole
                                             
        Args.Mag             =  20;          % apparent magnitudes of the input sources: 
                                             % one magnitude for all the objects or a vector of magnitudes                                              
        Args.Ebv             =   0;          % E(B-V) of the observed field (currently 1 value for all the objects)
                                             % if E(B-V) > 0 the input magnitudes are treated as dereddened
        Args.FiltFam         = {'ULTRASAT'}; % one filter family for all the source magnitudes or an array of families
                                             
        Args.Filt            = {''};         % one filter for all the source magnitudes or an array of filters
        
        Args.SpecType        = {'BB'};       % parameters of the source spectra: 
                                             % either an array of AstSpec or AstroSpec objects
                                             % or an array of model spectra parameters: 
                                             % {'BB'} 3500 [Temperature (K)] -- blackbody
                                             % {'PL'} 2.   [Alpha -- power-law F ~ lambda^alpha]
                                             % {'Tab'} table: NumSrc spectra, each spectral flux in a column
                                             % NB: the input spectral flux should be
                                             % in [erg cm(-2) s(-1) A(-1)] as seen near Earth (absorbed)!
        Args.Spec            = 5800;
                                             
        Args.Exposure        = [3 300];      % number and duration of exosures [s]; 1 x 300 s is the standard ULTRASAT exposure
        
        Args.Tile            = 'B';          % the tile name: 'A' and 'B' are the upper tiles, 'D' and 'C' are the lower tiles
        
        Args.ImRes           = 5;            % the internal image resolution: 5 is 1/5 of the ULTRASAT pixel
                                             % possible values: 1, 2, 5, 10, 47.5

        Args.RotAng          = 0;            % the PSF rotation angle relative to the axis of the raw PSF database (deg)
                                             % may be a vector with individual angle for each of the sources
                                            
        Args.RA0             = 214.99;       % the default position of the [0 0] pixel (~ telescope FOV center)
        Args.Dec0            = 52.78;        % is a certain point in the GALEX GROTH_00 field
        Args.WCSFile         = {''};         % if not empty, the image WCS is read from this file
                                             
        Args.ArraySizeLimit  = 8;            % [Gb] the limit determines the method employed in inUtil.psf.specWeight
        Args.MaxNumSrc       = 10000;        % the maximal size of a source chunk to be worked over at a time
        
        Args.MaxPSFNum       = 10000;        % if the number of input sources is above this value, 
                                             % do not record individual PSF and do not attach them to the output AstroImage 
        % currently not employed:
%         Args.NoiseDark    logical = true;    % Dark count noise  
%         Args.NoiseSky     logical = true;    % Sky background 
%         Args.NoisePoisson logical = true;    % Poisson noise
%         Args.NoiseReadout logical = true;    % Read-out noise
%                                              % (see details in imUtil.art.noise)
                                             
        Args.Inj             = 'direct';     % source injection method can be either 'FFTshift' or 'direct'
        
        Args.OutType         = 'all';        % output type: 'AstroImage', 'FITS', 'all' (default)
        
        Args.OutDir          = '.';          % the output directory
        Args.OutName         = 'SimImage';   % root name of output files

        Args.SaveMatFile  logical = false;            % whether to make an output .mat file with all the modelled structures
        Args.SaveRegionsBySourceMag logical = false;  % whether to write additional region files according to the input source magnitudes
        
        Args.PostModelingFindSources logical = false; % attempt for a post-modeling source search (in general, should be out of the modeling routing)         
    end
    
    % input format correction
    if ~iscell(Args.FiltFam)
                Args.FiltFam  = {Args.FiltFam};
    end
    if ~iscell(Args.Filt)
                Args.Filt     = {Args.Filt};
    end
    if ~iscell(Args.SpecType)
                Args.SpecType = {Args.SpecType};
    end
    if ~iscell(Args.WCSFile)
                Args.WCSFile  = {Args.WCSFile};
    end 
    
                        % simulation start 
                        Exposure = Args.Exposure(1) * Args.Exposure(2); 
                            
                        cprintf('hyper','ULTRASAT simulation started\n');
                        fprintf('%s%d%s%s\n','The total requested exposure is ',Exposure,...
                                ' seconds for tile ',Args.Tile);
                        fprintf('%s%d%s\n','The requested PSF resolution is 1/',Args.ImRes,' of the pixel size');
                            
                        % performance speed test
                        tic; tstart = datetime("now"); 
    
    %%%%%%%%%%%%%%%%%%%%% Simulation parameters and some physical constants
    
%     Eps = 1e-12;            % precision (currently not employed)
    Tiny = 1e-30;
    
    C   = constant.c;       % the speed of light in vacuum, [cm/s]
    H   = constant.h;       % the Planck constant, [erg s]   
    
    RAD = 180./pi;          % the radian
    
    %%%%%%%%%%%%%%%%%%%% ULTRASAT PSF database parameters
               
    Nrad    = 25; 
    Rad     = linspace(0,10,Nrad);          % lab PSF grid points in radius    
            
    MinWave = 2000;  % [A] the band boundaries
    MaxWave = 11000; % [A]
    
    WavePSF = linspace(MinWave,MaxWave,91); % lab PSF grid points in wavelength
    
%     PixRat  = 47.5; % the ratio of the ULTRASAT pixel size to that of the lab PSF image (currently not employed)
        
    %%%%%%%%%%%%%%%%%%%% the spectral grid used for countrate calculations

    Nwave   = 9001;                                % number of spectral bins used for countrate calculations
    Wave    = linspace(MinWave,MaxWave,Nwave);     % the wavelength grid 
    
    DeltaLambda = (MaxWave-MinWave)/(Nwave-1);     % the wavelength bin size in Angstroms 
    
    %%%%%%%%%%%%%%%%%%%% basic ULTRASAT imaging parameters

    ImageSizeX  = 4738; % tile size (pix)
    ImageSizeY  = 4738; % tile size (pix)
    
    FocalLength = 360;    % [mm] 
    PixelSizeMm = 9.5e-3; % [mm] pixel size 
    PixSizeDeg  = ( PixelSizeMm / FocalLength ) * RAD;  % [deg] pixel size  
    
    GapMm       = 2.4;  % gap width in mm
    Ngap        = ceil( GapMm / PixelSizeMm); % number of pixels in the gap
    
    DAper       = 33.;                   % [cm]    aperture diameter
    SAper       = pi * DAper ^ 2 / 4;    % [cm(2)] aperture area
    
    % coordinates of the inner core of the tile and the rotation angle of the PSF: 
    % NB: the additional rotation by -90 deg for tile "B" is required to have the PSF coma in the right position!
    % the CRPIX values are chosen so that the CRVAL coordinates are at the aimpoint of the telescope
    switch Args.Tile
        case 'A'
            X0 = ImageSizeX + 0.5; Y0 = 0.5;
            RotAngle = Args.RotAng - 90 + 90;  
            CRPIX1   = ImageSizeX+Ngap/2;
            CRPIX2   = -Ngap/2;
        case 'B'
            X0 = 0.5;              Y0 = 0.5;
            RotAngle = Args.RotAng - 90 + 0;  
            CRPIX1   = -Ngap/2;
            CRPIX2   = -Ngap/2;
        case 'C'
            X0 = 0.5;              Y0 = ImageSizeY + 0.5;
            RotAngle = Args.RotAng - 90 - 90;  
            CRPIX1   = -Ngap/2;
            CRPIX2   = ImageSizeY+Ngap/2;
        case 'D'
            X0 = ImageSizeX + 0.5; Y0 = ImageSizeY + 0.5;
            RotAngle = Args.RotAng - 90 + 180;  
            CRPIX1   = ImageSizeX+Ngap/2;
            CRPIX2   = ImageSizeY+Ngap/2;
        otherwise            
            error('Invalid tile name, exiting..');   
    end
    
    % pixel saturation and per pixel background (from YS),
    %  e-/ADU conversion coefficients
    FullWell    = 1.6e5;  % [e-] the pixel saturation limit for 1 exposure
    GainThresh  = 1.6e4;  % [e-/pix] the gain threshold
    E2ADUhigh   = 1.185;  % below GainThresh e-/pix 
    E2ADUlow    = 0.074;  % above GainThresh e-/pix
    
    % [e-/pix] background estimates for a 300 s exposure made by YS
    Back.Zody    = 27; Back.Cher  = 15; Back.Stray = 12; Back.Dark = 12;
    Back.Readout =  6; Back.Cross =  2; Back.Gain  =  1;
    
%     Back.Tot = ( Back.Zody  + Back.Cher + Back.Stray + Back.Dark + ...
%                  Back.Cross + Back.Gain ) * sqrt(Exposure/300.) + Back.Readout * Args.Exposure(1); % NOT CORRECT
             
    Back.Tot = ( Back.Zody  + Back.Cher + Back.Stray + Back.Dark + ...
                 Back.Cross + Back.Gain + Back.Readout ) * Args.Exposure(1); 
    
    %%%%%%%%%%%%%%%%%%%% load the matlab object with the ULTRASAT properties:
    
    UP_db = sprintf('%s%s',tools.os.getAstroPackPath,'/../data/ULTRASAT/P90_UP_test_60_ZP_Var_Cern_21.mat');   
    io.files.load1(UP_db,'UP');
    
    %%%%%%%%%%%%%%%%%%%%%  read the chosen PSF database from a .mat file

                                fprintf('Reading PSF database.. '); 

    PSF_db = sprintf('%s%s%g%s',tools.os.getAstroPackPath,'/../data/ULTRASAT/PSF/ULTRASATlabPSF',Args.ImRes,'.mat');
    ReadDB = struct2cell ( io.files.load1(PSF_db) ); % PSF data at the chosen spatial resolution
    PSFdata = ReadDB{2}; 

%     if ( size(PSFdata,3) ~= Nwave ) || ( size(PSFdata,4) ~= Nrad )
     if size(PSFdata,4) ~= Nrad 
         error('PSF array size mismatch, exiting..');
     end

                                fprintf('done\n'); 
                                elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update'); tic
        
    %%%%%%%%%%%%%%%%%%%% read source coordinates from an input catalog or make a fake catalog
    
    if isempty(Args.WCSFile{1}) % make a local WCS
        
        SimWCS = AstroWCS();
        SimWCS.ProjType  = 'TAN';
        SimWCS.ProjClass = 'ZENITHAL';
        SimWCS.CooName   = {'RA'  'DEC'};
        SimWCS.CTYPE     = {'RA---TAN','DEC---TAN'};
        SimWCS.CUNIT     = {'deg', 'deg'};
        SimWCS.CD(1,1)   = PixSizeDeg;
        SimWCS.CD(2,2)   = PixSizeDeg;  
        SimWCS.CRVAL(1)  = Args.RA0;
        SimWCS.CRVAL(2)  = Args.Dec0;
        SimWCS.CRPIX(1)  = CRPIX1; 
        SimWCS.CRPIX(2)  = CRPIX2; 
        SimWCS.populate_projMeta;
        
        % rotate the image:
        Alpha_rad = Args.PlaneRotation/RAD;
        RotMatrix = [cos(Alpha_rad), -sin(Alpha_rad);
                     sin(Alpha_rad),  cos(Alpha_rad)];
        SimWCS.CD = RotMatrix * SimWCS.CD;
        
    else % or read in an appropriate ULTRASAT header and extract WCS
        SimHeader = AstroHeader(Args.WCSFile{1},1); 
        SimWCS    = AstroWCS.header2wcs(SimHeader);   
        SimWCS.populate_projMeta;
    end
        
    if isa(Args.Cat,'AstroCatalog') % read sources from an AstroCatalog object 
 
        NumSrc        = size(Args.Cat.Catalog,1); 
        RA            = Args.Cat.Catalog(:,find(strcmp(Args.Cat.ColNames, 'RA'))); 
        DEC           = Args.Cat.Catalog(:,find(strcmp(Args.Cat.ColNames, 'Dec'))); 
        
        if isempty(find(strcmp(Args.Cat.ColNames, 'X'), 1)) % no pixel coordinates in the catalog
            [CatX, CatY]  = SimWCS.sky2xy(RA,DEC);          % get them from the SimWCS
        else                                                % read pixel coordinates
            CatX      = Args.Cat.Catalog(:,find(strcmp(Args.Cat.ColNames, 'X'))); 
            CatY      = Args.Cat.Catalog(:,find(strcmp(Args.Cat.ColNames, 'Y'))); 
        end               
                            fprintf('%d%s\n',NumSrc,' sources read from the input AstroCatalog object');
        
    elseif size(Args.Cat,2) > 1 && size(Args.Cat,3) == 1 % read source coordinates from a text table
        
        NumSrc = size(Args.Cat,1);
        
        if Args.SkyCat   % the input coordinates are sky coordinates
            RA  = Args.Cat(:,1);
            DEC = Args.Cat(:,2);
            [CatX, CatY] = SimWCS.sky2xy(RA,DEC); 
        else             % the input coordinates are pixel coordinates
            CatX   = Args.Cat(:,1);
            CatY   = Args.Cat(:,2);
            [RA, DEC] = SimWCS.xy2sky(CatX,CatY);
%             RA     = zeros(NumSrc,1); % can be calculated later if needed
%             DEC    = zeros(NumSrc,1); % -//-
        end
                            fprintf('%d%s\n',NumSrc,' sources read from the input table');
        
    elseif size(Args.Cat,2) == 1 % make a fake catalog with Args.Cat sources randomly distributed over the FOV
        
        NumSrc = Args.Cat;  % the number of fake sources

        CatX    = max(0.51, ImageSizeX * rand(NumSrc,1) ); 
        CatY    = max(0.51, ImageSizeY * rand(NumSrc,1) ); 
        
        [RA, DEC] = SimWCS.xy2sky(CatX,CatY);
        
%         RA      = zeros(NumSrc,1);  % can be calculated later if needed
%         DEC     = zeros(NumSrc,1);  % -//-
%  
                            fprintf('%d%s\n',NumSrc,' random sources generated');
                            
    else
        
                            error('Incorrect catalog input, exiting..'); 
                                    
    end
    
    % check which of the sources fall out of the FOV
    
    InFOV = (CatX > 0.1) .* (CatY > 0.1) .* (CatX < ImageSizeX) .* (CatY < ImageSizeY);
    
                            if ( sum(InFOV) < NumSrc ) 
                                cprintf('red','%d%s\n',NumSrc-sum(InFOV),' objects out of the FOV');
                            end
    
    CatFlux  = zeros(NumSrc,1);   % will be determined below from spectra * transmission 
    
    %%%%%%%%%%%%%%%%%%%% reading source magnitudes and filters, 
    %%%%%%%%%%%%%%%%%%%% calculating the extinction curve
    
    if numel(Args.Mag) > 1
        InMag = Args.Mag;
    else
        InMag = Args.Mag(1)*ones(NumSrc,1);
    end
    if numel(Args.FiltFam) > 1
        FiltFam = {Args.FiltFam};
    else
        FiltFam = repmat(Args.FiltFam,1,NumSrc);
    end
    if numel(Args.Filt) > 1
        Filter = {Args.Filt};
    else
        Filter = repmat(Args.Filt,1,NumSrc);
    end
    
    %%% TBD: if sum(InFOV) < NumSrc cut the input data so that 
    %%% it contain only the sources falling into the FOV
    % InMag = InMag(logical(InFOV))
    % FiltFam = FiltFam(logical(InFOV))
    % Filter  = Filter(logical(InFOV))
    % Spec    = ...
    
    ExtMag     = astro.spec.extinction(Args.Ebv,(Wave./1e4)');
    Extinction = 10.^(-0.4.*ExtMag);
%     plot(Wave,Extinction);
    
    %%%%%%%%%%%%%%%%%%%%% split the list of objects into chunks and work
    %%%%%%%%%%%%%%%%%%%%% chunk-by-chunk 
    
    NCh  = ceil ( NumSrc / Args.MaxNumSrc );
    ChL  = zeros(NCh,1); 
    ChR  = zeros(NCh,1);
    
    for ICh = 1:NCh-1
        
        ChL(ICh) = (ICh - 1) * Args.MaxNumSrc + 1;
        ChR(ICh) = ICh * Args.MaxNumSrc;
        
    end
    
    ChL(NCh) = (NCh-1) * Args.MaxNumSrc + 1;
    ChR(NCh) = NumSrc; 
    
    ImageSrc = zeros(ImageSizeX, ImageSizeY); % make an empty source image
    
    %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%
    
    for ICh = 1:NCh   % main loop over source chunks: radial distances, spectra, convolution, injection 

        cprintf('hyper','%s%d%s%d\n','Chunk ',ICh, ' out of ',NCh);

        NumSrcCh = ChR(ICh) - ChL(ICh) + 1;  % number of sources in the current chunk (Args.MaxNumSrc or less)
        Range    = ChL(ICh):ChR(ICh); 

        %%%%%%%%%%%%%%%%%%%%% obtain radial distances of the sources from the INNER CORNER of the tile 
        %%%%%%%%%%%%%%%%%%%%% and regrid the throughput array at given source positions 

        RadSrc = sqrt( ( CatX(Range) - X0 ).^2 + ( CatY(Range) - Y0 ).^2 ) .*  PixSizeDeg;   % the source radii [deg]        
        TotT   = interpn(UP.wavelength, Rad', UP.TotT, Wave', RadSrc', 'linear', Tiny)';     % regrid the throughput 
        [~, IndR] = min( abs(RadSrc - Rad), [], 2);                                          % IndR is the RXX filter 
                                                                                             % zone number for each of the sources
        %%%%%%%%%%%%%%%%%%%%% read or generate source spectra
        %%%%%%%%%%%%%%%%%%%%%

                                fprintf('Reading source spectra.. ');

        SpecIn  = zeros(NumSrcCh, Nwave);  % the incoming spectra 

        % read the input spectra or generate synthetic spectra 
    
    %                 if false  %%% TEST: use the Stellar Spectra from UP.Specs
    %                     fprintf('TEST RUN: using stellar spectra from UP.Specs ..');
    %                     for Isrc = 1:1:NumSrc
    %                         % stellar spectra from Pickles. NB: these are normalized to 1 at 5556 Ang !
    %                         %Pick(Isrc) = UP.Specs( rem(Isrc,43)+1 ); 
    %                         %Pick(Isrc) = UP.Specs(17); % a G0.0V star 
    %                         %Pick(Isrc) = UP.Specs(27); % an M0.0V star 
    %                         if rem(Isrc,2) == 0 % for Cat2 catalog
    %                             Pick(Isrc) = UP.Specs(17); % UP.Specs(17); 
    %                         else
    %                             Pick(Isrc) = UP.Specs(27); % UP.Specs(27); 
    %                         end
    %                     end
    %                     Args.Spec = Pick(1:NumSrc);
    %                 end  %%% END TEST 
                 
        switch isa(Args.Spec,'AstroSpec') || isa(Args.Spec,'AstSpec')

            case 0  % make a synthetic spectrum for a given model

                switch lower( Args.SpecType{1} ) 

                    case 'bb'                   

                        if numel( Args.Spec ) ~= NumSrc && numel( Args.Spec ) ~= 1
                            error('The size of the source temperature array is incorrect, exiting..');
                        elseif numel( Args.Spec ) == 1
                            fprintf('%s%5.0f%s','generating BB spectra for T = ',Args.Spec,' K .. ');
                            Temp = Args.Spec .* ones(NumSrcCh,1);
                        else
                            fprintf('%s','generating BB spectra for individual source temperatures .. ');
                            Temp = Args.Spec( Range );
                        end

                        SpecIn = cell2mat({ AstroSpec.blackBody(Wave',Temp).Flux })'; % erg s(-1) cm(-2) A(-1)

                    case 'pl'

                        if numel( Args.Spec ) ~= NumSrc && numel( Args.Spec ) ~= 1
                            error('The size of the source spectral index array is incorrect, exiting..');
                        elseif numel( Args.Spec ) == 1
                            fprintf('%s%5.0f','generating PL spectra for Alpha = ',Args.Spec);
                            Alpha = Args.Spec .* ones(NumSrcCh,1);
                        else
                            fprintf('%s','generating PL spectra for individual spectral indexes .. ');
                            Alpha = Args.Spec( Range );
                        end
                        
                        SpecIn = Wave .^ Alpha;                                     % erg s(-1) cm(-2) A(-1)   

                    case 'tab'

                        fprintf('%s','Reading source spectra from a table..');

                        if size( Args.Spec, 2) == NumSrc && size( Args.Spec, 1) == Nwave
                            % NumSrc spectra at the standard grid 2000:1:11000
                            for Isrc = 1:1:NumSrcCh

                                Isrc_gl = Isrc + ChL(ICh) - 1;   % global source number 

                                SpecIn(Isrc,:) = Args.Spec(:,Isrc_gl); % read the spectra from table columns

                            end
                        elseif size( Args.Spec, 2) == NumSrc + 1
                            % NumSrc spectra at a nonstandard grid, the wavelength
                            % grid is in the column number NumSrc + 1 
                            for Isrc = 1:1:NumSrcCh 

                                Isrc_gl = Isrc + ChL(ICh) - 1;   % global source number 

                                SpecIn(Isrc,:) = interp1(Args.Spec(:,NumSrc+1), Args.Spec(:,Isrc_gl), Wave, 'linear', 0);

                            end
                        else
                            error('Number of columns or rows in the spectral input table is incorrect, exiting..');
                        end

                    otherwise

                        error('Spectral parameters not properly defined in uSim, exiting..');
                end

            case 1  % read the table from an AstroSpec/AstSpec object and regrid it to Wave set of wavelengths
                
                if isa(Args.Spec,'AstSpec')
                    Flx = cell2mat({Args.Spec( Range ).Int});
                elseif isa(Args.Spec,'AstroSpec')
                    Flx = cell2mat({Args.Spec( Range ).Flux});
                end
                Wav = cell2mat({Args.Spec( Range ).Wave});

                for Isrc = 1:1:NumSrcCh  % can not make it a 1-liner? 
                    SpecIn(Isrc,:) = interp1( Wav(:,Isrc), Flx(:,Isrc), Wave, 'linear', 0 );
                end
                
%                 for Isrc = 1:1:NumSrcCh
%                     Isrc_gl = Isrc + ChL(ICh) - 1;   % global source number 
% 
%                     if isa(Args.Spec,'AstSpec') 
%                         SpecIn(Isrc,:) = interp1( Args.Spec(Isrc_gl).Wave, Args.Spec(Isrc_gl).Int, Wave, 'linear', 0);
%                     elseif isa(Args.Spec,'AstroSpec')
%                         SpecIn(Isrc,:) = interp1( Args.Spec(Isrc_gl).Wave, Args.Spec(Isrc_gl).Flux, Wave, 'linear', 0);
%                     end 
%                 end

        end
                                fprintf('done\n'); 
                                elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update');

                                tic
                    
    %                     if false % TEST input: a flat spectrum the 240-280 band, null otherwise0
    %                         fprintf('TEST input: flat spectrum in the 240-280 band\n');                        
    %                         for Iwave = 1:1:Nwave
    %                             for Isrc = 1:1:NumSrc
    %                                 if (Wave(Iwave) < 2400) || (Wave(Iwave) > 2800) 
    %                                     SpecIn(Isrc,Iwave) = 0.;
    %                                 else
    %                                     SpecIn(Isrc,Iwave) = 1.;
    %                                 end
    %                             end
    %                         end
    %                     end % END TEST
        %%%%%%%%%%%%%%%%%%%%%  rescale the spectra to the input magnitudes 

                                fprintf('%s%s%s%s%s','Rescaling spectra to fit the input ',...
                                         FiltFam{1},'/',Filter{1},' magnitudes...');

%         for Isrc = 1:1:NumSrcCh
% 
%               Isrc_gl = Isrc + ChL(ICh) - 1;   % global source number 
%               
%               AS = AstroSpec([Wave' SpecIn(Isrc,:)']); % can not take this out of the loop, as AstroSpec can not 
%                                                          % produce multiple objects at a time ? 
%               if strcmp(FiltFam,'ULTRASAT')
%                 SpecScaled  = scaleSynphot(AS, InMag(Isrc_gl), UP.U_AstFilt(IndR(Isrc)),'R1'); % NB: here 'R1' does not mean anything
%               else
%                 SpecScaled  = scaleSynphot(AS, InMag(Isrc_gl), FiltFam{Isrc_gl}, Filter{Isrc_gl}); % scaleSynphot does not work with arrays of filters?
%               end
%               SpecIn(Isrc,:) = SpecScaled.Flux .* Extinction; % the scaled flux is multiplied by the extinction factor 
% 
%         end  
        
%         if strcmp(FiltFam,'ULTRASAT') % DOES NOT WORK:
%         astro.spec.synthetic_phot does not know how to deal with _multiple filters_
%             MagSc = astro.spec.synthetic_phot([Wave' SpecIn'],UP.U_AstFilt(IndR(Range)),'R1','AB');
%         else
%             MagSc = astro.spec.synthetic_phot([Wave' SpecIn'],FiltFam(Range),Filter(Range),'AB');
%         end

        MagSc = zeros(1,NumSrcCh);
        if strcmp(FiltFam,'ULTRASAT')
            for Isrc = 1:1:NumSrcCh              
                MagSc(Isrc) = astro.spec.synthetic_phot([Wave' SpecIn(Isrc,:)'],UP.U_AstFilt(IndR(Isrc)),'R1','AB');
            end
        else
            for Isrc = 1:1:NumSrcCh
                Isrc_gl = Isrc + ChL(ICh) - 1;   % global source number
                MagSc(Isrc) = astro.spec.synthetic_phot([Wave' SpecIn(Isrc,:)'],FiltFam{Isrc_gl},Filter{Isrc_gl},'AB');
            end
        end
        Factor   = 10.^(-0.4.*(MagSc' - InMag(Range))); % rescaling factor
        SpecIn   = SpecIn ./ Factor;                     
        SpecObs  = SpecIn .* Extinction';               % observed (extincted) spectrum

                                fprintf('done\n'); 
                                elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update');

                                tic
        %%%%%%%%%%%%%%%%%%%%%  convolve the spectrum with the ULTRASAT throughut and
        %%%%%%%%%%%%%%%%%%%%%  fill the CatFlux column with the spectrum-intergated countrate fluxes

        % [ counts /s /bin ] = [ erg s(-1) cm(-2) A(-1) ] * [ counts / ph ] * [ A / bin ] * [ cm(2) ]/ [ erg / ph ]:
        SpecCts = SpecObs .* TotT .* DeltaLambda .* SAper ./ ( H*C ./(1e-8 .* Wave) );
        % the wavelength integrated source fluxes [ counts / s ]:
        CatFlux(Range) = sum(SpecCts,2);
        
                                fprintf('Source spectra convolved with the throughput\n'); 

        %%%%%%%%%%%%%%%%%%%%%  integrate the throughput-convolved source spectra 
        %%%%%%%%%%%%%%%%%%%%%  S_i(λ)*Th(λ,r_i) with their PSF_i(λ,r_i) over the frequency range 
        %%%%%%%%%%%%%%%%%%%%%  and obtain spectrum-weighted PSF_i for each source

                                fprintf('Weighting source PSFs with their spectra.. ');

        WPSF = imUtil.psf.specWeight(SpecCts, RadSrc, PSFdata, 'Rad', Rad, 'SizeLimit',Args.ArraySizeLimit, ...
                                     'Lambda',WavePSF,'SpecLam',Wave); 

                                fprintf('done\n'); 
                                elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update'); tic
        %%%%%%%%%%%%%%%%%%%%% rotate the weighted source PSFs, blur them due to the S/C jitter 
        %%%%%%%%%%%%%%%%%%%%% and inject them into an empty tile image

                                fprintf('Rotating the PSFs and injecting them into an empty image.. ');
                                
        CatX_ch    = CatX(Range);   % cut the appropriate parts of the Cat catalog
        CatY_ch    = CatY(Range);
        CatFlux_ch = CatFlux(Range);
        
        if numel(RotAngle) > 1 
            RotAngle_ch = RotAngle(Range);
        else
            RotAngle_ch = RotAngle;
        end
        
        [Image_ch, PSF_ch] = imUtil.art.injectArtSrc (CatX_ch, CatY_ch, CatFlux_ch, ImageSizeX, ImageSizeY,...
                                 WPSF, 'PSFScaling', Args.ImRes, 'RotatePSF', RotAngle_ch,...
                                 'Jitter', 1, 'Method', Args.Inj, 'MeasurePSF', 0); 

                                fprintf(' done\n');
                                elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update'); tic                      
        %%%%%%%%%%%%%%%%%%%% add the chunk image to the summed source image
        %%%%%%%%%%%%%%%%%%%% and populate the PSF of the sources 
        
        ImageSrc = ImageSrc + Image_ch;  % add the image containing the newly added sources to the current summed image
        
        if NumSrc < Args.MaxPSFNum
            PSF(:,:,Range) = PSF_ch;  % fill in the resulting PSF array if the number of sources is not too large
        end
                                fprintf('Partial source image added to the stacked source image \n');
                                
    end % end the loop over source chunks
    
    %%%%%%%%%%%%%%%%%%%%% add and apply various types of noise to the tile image 
    %%%%%%%%%%%%%%%%%%%%% NB: while ImageSrc is in [counts/s], ImageSrcNoise is already in [counts] !!
    
                                cprintf('hyper','Adding noise .. ');
                    
%     ImageSrcNoise = imUtil.art.noise(ImageSrc,'Exposure',Args.Exposure,...
%                                     'Dark',Args.NoiseDark,'Sky',Args.NoiseSky,...
%                                     'Poisson',Args.NoisePoisson,'ReadOut',Args.NoiseReadout);                              
        
    NoiseLevel    = Back.Tot * ones(ImageSizeX,ImageSizeY);   % already in [counts], see above
    SrcAndNoise   = ImageSrc .* Exposure + NoiseLevel; 
    
%     ImageSrcNoise = poissrnd( SrcAndNoise, ImageSizeX, ImageSizeY);                             
%     ImageBkg      = poissrnd( NoiseLevel, ImageSizeX, ImageSizeY);
%     
%     As the noise level is already quite high for typical exposures,
%     we can use a faster normal distribution instead of the true Poisson distribution
    ImageSrcNoise =  normrnd( SrcAndNoise, sqrt(SrcAndNoise), ImageSizeX, ImageSizeY);              
    ImageBkg      =  normrnd( NoiseLevel,  sqrt(NoiseLevel),  ImageSizeX, ImageSizeY);
                                 
                            fprintf(' done\n');                   
                            elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update'); 
    %%%%%%%%%%%%%%%%%%%%%%  cut the saturated pixels (to be refined later) 
    
    Thresh        = FullWell * Args.Exposure(1);
    AboveThresh   = sum(ImageSrcNoise(:) > Thresh);
    ImageSrcNoise = min(ImageSrcNoise, Thresh);
    
                            fprintf('%d saturated pixels cutted\n',AboveThresh);
    %%%%%%%%%%%%%%%%%%%%%%  make an ADU and mask ADU images (for a single
    %%%%%%%%%%%%%%%%%%%%%%  exposure observation only)
    
    if Args.Exposure(1) == 1
        ImageSrcNoiseGainMask = ImageSrcNoise > GainThresh;  % if the signal is above the threshold, use low gain
        ImageSrcNoiseGain = ImageSrcNoise .* ( ImageSrcNoiseGainMask .* E2ADUlow + ...
                                              (ones(ImageSizeX,ImageSizeY)-ImageSrcNoiseGainMask) .* E2ADUhigh );
        ImageSrcNoiseADU = ultrasat.e2ADU(ImageSrcNoiseGain, ImageSrcNoiseGainMask); % the ADU is a 14-bit integer 
    else
        fprintf('NOTE: the ADU image is not produced once multiple exposures are modelled..\n'); 
    end

    %%%%%%%%%%%%%%%%%%%%%%  output: a) an AstroImage object with filled image, header, and PSF properties  
    %%%%%%%%%%%%%%%%%%%%%%          b) a FITS image c) a native (RAW) format image 
    
                            fprintf('Compiling output structures and writing files..\n'); drawnow('update'); tic
    
    % compile a catalog table
    Cat = [CatX CatY CatFlux InMag RA DEC];
    
    % if we generated a fake catalog above, make a catalog table here 
    if ~isa(Args.Cat,'AstroCatalog')    
        Args.Cat = AstroCatalog({Cat},'ColNames',{'X','Y','Counts/s','MAG','RA','Dec'},'HDU',1);
    end
        
    % make an AstroImage (note, the images are to be transposed!)
    usimImage = AstroImage( {ImageSrcNoise'} ,'Back', {NoiseLevel'}, 'Var', {ImageBkg'},'Cat', {Args.Cat.Catalog}); 

    % save the final source PSFs into an AstroPSF array and attach it to
    % the resulting AstroImage object, if the source number is not too large
    if NumSrc < Args.MaxPSFNum
        AP(1:NumSrc) = AstroPSF;
        for Isrc = 1:1:NumSrc
            AP(Isrc).DataPSF = PSF(:,:,Isrc);
        end
        usimImage.PSF = AP; 
    else
        fprintf('NOTE: the number of input sources is too large to record each of their PSFs..\n'); 
    end
    
    % add the WCS data to the AstroImage object:
    usimImage.WCS = SimWCS; 
    
    AH = usimImage.WCS.wcs2header;       % make a header from the WCS
    usimImage.HeaderData.Data = AH.Data; % add the header data to the AstroImage
    
    % add some more keywords and values to the image header:
    usimImage.setKeyVal('EXPTIME',Exposure);
    usimImage.setKeyVal('DATEOBS','2026-07-01T00:00:00');
%         AH = usimImage.Header;               % save the header back from the AstroImage

    % save the AstroImage object in a .mat file for a future usage (if requested):
    if Args.SaveMatFile 
        OutObjName = sprintf('%s%s%s%s',Args.OutName,'_tile',Args.Tile,'.mat');   
        save(OutObjName,'usimImage','-v7.3');
    end
           
    % write the image to a FITS file    
    if strcmp( Args.OutType,'FITS') || strcmp( Args.OutType,'all')
                
        OutFITSName = sprintf('%s%s%s%s%s%s%s','!',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'.fits');
        FITS.write(usimImage.Image, OutFITSName, 'Header',usimImage.HeaderData.Data,...
                    'DataType','single', 'Append',false,'OverWrite',true,'WriteTime',true);

        if Args.Exposure(1) == 1 % the ADU image is put out only when we model 1 exposure
            OutFITSName = sprintf('%s%s%s%s%s%s%s','!',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'_ADU.fits'); 
            FITS.write(ImageSrcNoiseADU, OutFITSName, 'DataType','int16',...
                        'Append',false,'OverWrite',true,'WriteTime',true);
        end
               
        % make a text file with the input catalog:
        OutTxtName = sprintf('%s%s%s%s%s%s',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'_InCat.txt'); 
        fileID = fopen(OutTxtName,'w'); 
%         fprintf(fileID,'%7.1f %7.1f %5.2f %.2d\n',Cat(:,(1:4))');
        fprintf(fileID,'%7.1f %7.1f %5.2f %.2d %.4d %.4d\n',Cat');
        fclose(fileID);
        
        % an accompanying region file: 
        OutRegName  = sprintf('%s%s%s%s%s%s',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'.reg');
        DS9_new.regionWrite([CatX CatY],'FileName',OutRegName,'Color','blue','Marker','b','Size',1,'Width',4,...
                            'Precision','%.2f','PrintIndividualProp',0); 
        
        % optional region files for various parts of the source distribution (these can be also extracted later from *InCat.txt):
        if Args.SaveRegionsBySourceMag
            idx = Cat(:,4) > 24.5 & Cat(:,4) < 25.5;      % faintest sources
            CatFaint = Cat(idx,:);  
            OutRegName  = sprintf('%s%s%s%s%s%s',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'faint.reg');
            DS9_new.regionWrite([CatFaint(:,1) CatFaint(:,2)],'FileName',OutRegName,'Color','blue','Marker','o','Size',1,'Width',4,...
                                 'Precision','%.2f','PrintIndividualProp',0);     
          
            idx = Cat(:,4) > 23.5 & Cat(:,4) < 24.5;      % medium brightness sources 
            CatMed = Cat(idx,:);  
            OutRegName  = sprintf('%s%s%s%s%s%s',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'medium.reg');
            DS9_new.regionWrite([CatMed(:,1) CatMed(:,2)],'FileName',OutRegName,'Color','green','Marker','o','Size',1,'Width',4,...
                                 'Precision','%.2f','PrintIndividualProp',0);
            
            idx = Cat(:,4) > 22.5 & Cat(:,4) < 23.5;      % bright sources 
            CatBright = Cat(idx,:);  
            OutRegName  = sprintf('%s%s%s%s%s%s',Args.OutDir,'/',Args.OutName,'_tile',Args.Tile,'bright.reg');
            DS9_new.regionWrite([CatBright(:,1) CatBright(:,2)],'FileName',OutRegName,'Color','cyan','Marker','b','Size',1,'Width',4,...
                                'Precision','%.2f','PrintIndividualProp',0);     
        end
        
    end
    %%%%%%%%%%%%%%%%%%%%    
                    elapsed = toc; fprintf('%4.1f%s\n',elapsed,' sec'); drawnow('update'); 
                    tstop = datetime("now"); 
                    cprintf('hyper','%s%s%s\n','Simulation completed in ',tstop-tstart,...
                                         ' , see the generated images')
    %%%%%%%%%%%%%%%%%%%% post modeling checks (optional; in fact, should be done with another method)
    if Args.PostModelingFindSources
    %     
    %     MeasuredCat = imProc.sources.findMeasureSources(usimImage,'ForcedList',[CatX CatY],...
    %                          'OnlyForced',1,'CreateNewObj',1,'ReCalcBack',0,'ZP',UP.ZP(1,1)).CatData;

        MeasuredCat = imProc.sources.findMeasureSources(usimImage,'RemoveBadSources',1,'CreateNewObj',1,...
                                                        'ReCalcBack',0,'ZP',UP.ZP(1,1)).CatData;

        Coords = MeasuredCat.Catalog(:,1:2);
        SNRs = MeasuredCat.Catalog(:,8:12);
        Mag_Aper = MeasuredCat.Catalog(:,23:25);
    %     Mag_Aper_err = MeasuredCat.Catalog(:,26:28);
        Summary = [Coords SNRs(:,4:5) Mag_Aper(:,2:3)]; 

        idx5 = Summary(:,3) > 5; % take only sources over 5 sigma
        Summ5 = Summary(idx5,:); 
    %     idx3 = Summary(:,3) > 3; % take only sources over 3 sigma
    %     Summ3 = Summary(idx3,:); 
        OutRegName  = sprintf('%s%s%s%s',Args.OutDir,'/SimImage_tile',Args.Tile,'detected.reg');
        DS9_new.regionWrite([Summ5(:,1) Summ5(:,2)],'FileName',OutRegName,'Color','red','Marker','o','Size',1,'Width',4);     
    end
end

