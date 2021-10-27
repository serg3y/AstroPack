function [SI, AstrometricCat, Result]=singleRaw2proc(File, Args)
    % Basic processing of a single raw image into a processed image
    %   Including:
    %       Reading the image
    %       Generate a mask image and mask saturated pixels
    %       Subtract bias/dark image
    %       Divide by flat image
    %       Remove Fringe image
    %       Break image to sub images
    %       Estimate background
    %       Basic source findinging
    %       Astrometry
    %       Update astrometry in catalog
    %       Photometric ZP
    %       Update photometric ZP in catalog
    %       Save products
    % Input  : -
    % Output : -
    % Author : Eran Ofek (Aug 2021)
    % Example: pipeline.generic.singleRaw2proc
    %          % generate CalibImages using example in CalibImages/unitTest
    %          File = 'LAST.2.1.2_20200821.020230.952_clear_0_science.fits';
    %          File = 'LAST.2.1.2_20200820.184642.957_clear_0_science.fits';
    %          [SI, AstrometricCat,Result]=pipeline.generic.singleRaw2proc(File,'CalibImages',CI);
    %          [SI, ~,Result]=pipeline.generic.singleRaw2proc(File,'CalibImages',CI, 'CatName',AstrometricCat);
    
    arguments
        File                   % FileName+path / AstroImage
        Args.Dir                              = '';
        Args.CalibImages CalibImages          = [];
        Args.Dark                             = []; % [] - do nothing
        Args.Flat                             = []; % [] - do nothing
        Args.Fringe                           = []; % [] - do nothing
        Args.BlockSize                        = [1600 1600];  % empty - full image
        Args.Scale                            = 1.25;
        
        Args.MultiplyByGain logical           = true; % after fringe correction
        Args.MaskSaturated(1,1) logical       = true;
        Args.InterpOverSaturated(1,1) logical = true;
        Args.DoAstrometry(1,1) logical        = true;
        Args.DoPhotometry(1,1) logical        = true;
        Args.MatchExternal(1,1) logical       = false;
        Args.SaveProducts(1,1) logical        = true;
        
        Args.maskSaturatedArgs cell           = {};
        Args.debiasArgs cell                  = {};
        Args.SubtractOverscan logical         = false;
        Args.MethodOverScan                   = 'globalmedian';
        Args.deflatArgs cell                  = {};
        Args.CorrectFringing logical          = false;
        Args.image2subimagesArgs cell         = {};
        Args.OverlapXY                        = [64 64];
        Args.backgroundArgs cell              = {};
        Args.BackSubSizeXY                    = [128 128];
        Args.interpOverNanArgs cell           = {};
        Args.findMeasureSourcesArgs cell      = {};
        Args.ZP                               = 25;
        Args.photometricZPArgs cell           = {};
        Args.astrometrySubImagesArgs cell     = {};
        Args.CatName                          = 'GAIAEDR3';  % or AstroCatalog
        Args.addCoordinates2catalogArgs cell  = {'OutUnits','deg'};
        
        Args.OrbEl                            = []; %celestial.OrbitalEl.loadSolarSystem;  % prepare ahead to save time % empty/don't match
        Args.match2solarSystemArgs            = {};
        Args.GeoPos                           = [];
        
        Args.SaveFileName                     = [];  % full path or ImagePath object
        Args.CreateNewObj logical             = false;
    end
    
    % Get Image
    if ischar(File)
        if ~isempty(Args.Dir)
            File = sprintf('%s%s%s',Args.Dir, filesep, File);
        end
        
        AI = AstroImage(File);
    elseif isa(File, 'AstroImage')
        AI = File;
    else
        error('Unsupported File type option');
    end
    
    % createNewObj
    if Args.CreateNewObj
        AI = AI.copy;
    end
    
    % set CalibImages
    if isempty(Args.CalibImages)
        CI = CalibImages;
        CI.Dark   = Args.Dark;
        CI.Flat   = Args.Flat;
        CI.Fringe = Args.Fringe;
    else
        CI = Args.CalibImages;
    end
        
    
    AI.setKeyVal('FILTER','clear');
    AI.setKeyVal('SATURVAL',55000);
    AI.setKeyVal('OBSLON',35.0);
    AI.setKeyVal('OBSLAT',31.0);
    AI.setKeyVal('OBSALT',400);
    
    % fix date
    % JD is can't be written with exponent
    Date = AI.HeaderData.getVal('DATE-OBS');
    Date = sprintf('%s:%s:%s', Date(1:13), Date(14:15), Date(16:end));
    JD   = celestial.time.julday(Date);
    StrJD = sprintf('%16.8f',JD);
    AI.setKeyVal('JD',StrJD);
    
    AI = CI.processImages(AI, 'SubtractOverscan',false, 'InterpolateOverSaturated',true,...
                              'MaskSaturated',Args.MaskSaturated,...
                              'maskSaturatedArgs',Args.maskSaturatedArgs,...
                              'debiasArgs',Args.debiasArgs,...
                              'SubtractOverscan',Args.SubtractOverscan,...
                              'MethodOverScan',Args.MethodOverScan,...
                              'deflatArgs',Args.deflatArgs,...
                              'CorrectFringing',Args.CorrectFringing,...
                              'MultiplyByGain',Args.MultiplyByGain);
                              
    % crop overscan
    AI.crop([1 6354 1 9600]);
   
    % get JD from header
    JD = julday(AI.HeaderData);
    
    % Sub Images - divide the image to multiple sub images
    % Set UpdatCat to false, since in this stage there is no catalog
    [SI, InfoCCDSEC] = imProc.image.image2subimages(AI, Args.BlockSize, 'UpdateCat',false, Args.image2subimagesArgs{:}, 'OverlapXY',Args.OverlapXY);
    clear AI;
    
    % Background 
    SI = imProc.background.background(SI, Args.backgroundArgs{:}, 'SubSizeXY',Args.BackSubSizeXY);
    
    % Source finding
    SI = imProc.sources.findMeasureSources(SI, Args.findMeasureSourcesArgs{:},...
                                               'RemoveBadSources',true,...
                                               'ZP',Args.ZP,...
                                               'CreateNewObj',false);
    
    
    % Astrometry, including update coordinates in catalog
    if Args.DoAstrometry
        Tran = Tran2D('poly3');
        [Result.AstrometricFit, SI, AstrometricCat] = imProc.astrometry.astrometrySubImages(SI, Args.astrometrySubImagesArgs{:},...
                                                                                        'EpochOut',JD,...
                                                                                        'Scale',Args.Scale,...
                                                                                        'CatName',Args.CatName,...
                                                                                        'CCDSEC', InfoCCDSEC.EdgesCCDSEC,...
                                                                                        'Tran',Tran,...
                                                                                        'CreateNewObj',false);
                                                                                    
    
        % Update Cat astrometry
        %SI = imProc.astrometry.addCoordinates2catalog(SI, Args.addCoordinates2catalogArgs{:},'UpdateCoo',true);
    end
    
    % Photometric ZP
    if Args.DoPhotometry
        [SI, ZP, PhotCat] = imProc.calib.photometricZP(SI, 'CreateNewObj',false, 'MagZP',Args.ZP, Args.photometricZPArgs{:});
    
        % Update Cat photometry
    end
    
    % match known solar system objects
    if ~isempty(Args.OrbEl)
        % NOTE TIME SHOULD be in TT scale
        %tic;
        TTmUTC = 70./86400;
        [SourcesWhichAreMP, SI] = imProc.match.match2solarSystem(SI, 'JD',JD+TTmUTC, 'OrbEl',Args.OrbEl, 'GeoPos', Args.GeoPos, Args.match2solarSystemArgs{:});
        %toc
    end
    
    % match against external catalogs
    if Args.MatchExternal
        % 0. search for non-MP transients
        
        % 1. Add columns for matched sources
        
        % 2. generate a new catalog of only matched sources
        
    end
    
    % Save products
%     if ~isempty(Args.SaveFileName)
%        
%     end
    
    
end
