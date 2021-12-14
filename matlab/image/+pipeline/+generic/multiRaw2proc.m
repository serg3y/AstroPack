function [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd] = multiRaw2proc(FilesList, Args)
    % 
    % Example: L=io.files.filelist('LAST*science.fits');
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(289:308),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(249:268),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(329:348),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(349:368),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(369:388),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(389:408),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(409:428),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(429:448),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(449:468),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(469:488),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(209:228),'CalibImages',CI);
    
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(489:508),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(509:528),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(129:148),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(129:148),'CalibImages',CI);
    
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(189:208),'CalibImages',CI);
    
    
    % fails
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(169:188),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(58:77),'CalibImages',CI);
    
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(529:548),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(549:568),'CalibImages',CI);
    
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(619:623),'CalibImages',CI);
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(624:627),'CalibImages',CI);
    
    
    
    % with bad images:
    % [AllSI, MergedCat, MatchedS, Coadd, ResultSubIm, ResultAsteroids, ResultCoadd]=pipeline.generic.multiRaw2proc(L(309:328),'CalibImages',CI);
    
    
    arguments
        FilesList                                               % Cell array, regexp, or AstroIamge
        Args.CalibImages CalibImages          = [];
        Args.Dark                             = []; % [] - do nothing
        Args.Flat                             = []; % [] - do nothing
        Args.Fringe                           = []; % [] - do nothing
        Args.SubImageSizeXY                   = [1600 1600];  % empty - full image
        Args.OverlapXY                        = [64 64];
        
        Args.IdentifyBadImagesCCDSEC          = [3001 4000 3001 4000];
        
        Args.AstroImageReadArgs cell          = {};
        Args.ImageSizeXY                      = []; % if empty, get size from first image header
        
        Args.SameField logical                = true;
        Args.CatName                          = 'GAIAEDR3';
        
        Args.singleRaw2procArgs cell          = {};
        Args.DeletePropAfterSrcFinding        = {'Back','Var'};
        Args.UpdateCounter logical            = true;
        
        Args.coaddArgs cell                   = {};
        
        % Background and source finding
        Args.backgroundArgs cell              = {};
        Args.BackSubSizeXY                    = [128 128];
        Args.ZP                               = 25;
        Args.findMeasureSourcesArgs cell      = {};
        Args.photometricZPArgs cell           = {};
        
        % Astrometry
        Args.Scale                            = 1.25;
        Args.Tran                             = Tran2D('poly3');
        Args.astrometryRefineArgs             = {};
        
        % Match against external catalog: 'MergedCat
        Args.CoaddMatchMergedCat logical      = true;
        Args.MergedMatchMergedCat logical     = true;
        
        Args.mergeCatalogsArgs cell           = {};
        
        Args.ReturnRegisteredAllSI logical    = false;
        
    end
    
    
    
    
    if isa(FilesList, 'AstroImage')
        % FileList is an AstroImage
        AI = FilesList;
%         [SizeY, SizeX] = AI(1).sizeImage;
    else
        % FileList is a cell array of images
%         OutN = FITS.get_keys(FilesList{1}, {'NAXIS1','NAXIS2'});
%         SizeX = real(str2doubleq(OutN{1}));
%         SizeY = real(str2doubleq(OutN{2}));
%     
%         [CCDSEC,UnCCDSEC,Center,Nxy,NewNoOverlap] = imUtil.image.subimage_grid([SizeX, SizeY], 'SubSizeXY',[1600 1600],...
%                                                                                                'OverlapXY',[64 64]);
%                                                                                          
%         
%         
%         [CCDSEC,UnCCDSEC,Center,Nxy,NewNoOverlap] = imUtil.image.subimage_grid([SizeX, SizeY], 'SubSizeXY',Args.SubImageSizeXY,...
%                                                                                                'OverlapXY',Args.OverlapXY);
%                                                                                          
%         
    
        %[SubImage,CCDSEC,Center,NooverlapCCDSEC,NewNoOverlap,Nxy] = partition_subimage(
        
        AI = AstroImage(FilesList, Args.AstroImageReadArgs{:});
    end
        
    
    
    % search for bad images
    [Result,ACF] = imProc.stat.identifyBadImages(AI, 'CCDSEC',Args.IdentifyBadImagesCCDSEC);
    AI = AI(~[Result.BadImageFlag]);

    Nim = numel(AI);
    
    %Nsub = 24;
    %AllSI = AstroImage([Nim, Nsub]);
    AstrometricCat = [];
    for Iim=1:1:Nim
        %Iim
        
        if Iim==1 || ~Args.SameField || isempty(AstrometricCat)
            % need to generate AstrometricCat for field
            %tic;
            % ResultSingle(Iim) is not needed
            % AllSI(Iim,:),
            [SI, BadImageFlag, AstrometricCat] = pipeline.generic.singleRaw2proc(AI(Iim),'CalibImages',Args.CalibImages,...
                                                                                      'CatName',Args.CatName,...
                                                                                      'DeletePropAfterSrcFinding',Args.DeletePropAfterSrcFinding,...
                                                                                      'RefineSearchRadius',10,...
                                                                                      'RemoveBadImages',false,...
                                                                                      Args.singleRaw2procArgs{:});
            %toc
            
        else
            %tic;
            [SI, BadImageFlag, ~] = pipeline.generic.singleRaw2proc(AI(Iim),'CalibImages',Args.CalibImages,...
                                                                         'CatName',AstrometricCat,...
                                                                         'WCS',AllSI(Iim-1,:),...
                                                                         'DeletePropAfterSrcFinding',Args.DeletePropAfterSrcFinding,...
                                                                         'RefineSearchRadius',10,...
                                                                         'RemoveBadImages',false,...
                                                                         Args.singleRaw2procArgs{:});
            %toc
            
        end
       
        if Iim==1
            % alocate AstroImage for all sub images
            Nsub  = numel(SI);
            AllSI = AstroImage([Nim, Nsub]);
        end
                
        if ~BadImageFlag
            AllSI(Iim,:) = SI;

            % clean data that will not be used later on
            % AllSI(Iim,:) = AllSI(Iim,:).deleteProp(Args.DeletePropAfterSrcFinding);

            % add keywords to Header
            if Args.UpdateCounter
                for Isub=1:1:Nsub
                    AllSI(Iim,Isub).HeaderData.replaceVal({'COUNTER'}, Iim);
                end
            end
        end
        
    end
    clear SI;
    
    
    % get JD
    JD = julday(AllSI(:,1));
    
    % merge catalogs
    [MergedCat, MatchedS, ResultSubIm.ResZP, ResultSubIm.ResVar, ResultSubIm.FitMotion] = imProc.match.mergeCatalogs(AllSI,...
                                                                                                            Args.mergeCatalogsArgs{:},...
                                                                                                            'MergedMatchMergedCat',Args.MergedMatchMergedCat);
    
    % search for asteroids - proper motion channel
    [MergedCat, ResultAsteroids.AstCrop] = imProc.asteroids.searchAsteroids_pmCat(MergedCat, 'BitDict',AllSI(1).MaskData.Dict, 'JD',JD, 'PM_Radius',3, 'Images',AllSI);
    
    % search for asteroids - orphan channel
    % imProc.asteroids.searchAsteroids_orphans
    
    % cross match with external catalogs
    
    % flag orphans
    
    
    % coadd images
    Nfields = numel(MatchedS);
    ResultCoadd = struct('ShiftX',cell(Nfields,1), 'ShiftY',cell(Nfields,1), 'CoaddN',cell(Nfields,1), 'AstrometricFit',cell(Nfields,1), 'ZP',cell(Nfields,1), 'PhotCat',cell(Nfields,1)); % ini ResultCoadd struct
    Coadd       = AstroImage([Nfields, 1]);  % ini Coadd AstroImage
    for Ifields=1:1:Nfields
        ResultCoadd(Ifields).ShiftX = median(diff(MatchedS(Ifields).Data.X,1,1), 2, 'omitnan');
        ResultCoadd(Ifields).ShiftY = median(diff(MatchedS(Ifields).Data.Y,1,1), 2, 'omitnan');
    
        ShiftXY = cumsum([0 0; -[ResultCoadd(Ifields).ShiftX, ResultCoadd(Ifields).ShiftY]]);
        % no need to transform WCS - as this will be dealt later on
        RegisteredImages = imProc.transIm.imwarp(AllSI(:,Ifields),...
                                                 'ShiftXY',ShiftXY,...
                                                 'TransWCS',false,...
                                                 'FillValues',0,...
                                                 'ReplaceNaN',true,...
                                                 'CreateNewObj',~Args.ReturnRegisteredAllSI);
        
        % use sigma clipping...
        % 1. NOTE that the mean image is returned so that the effective gain
        % is now Gain/Nimages
        % 2. RegisteredImages has no header so no JD...
        [Coadd(Ifields), ResultCoadd(Ifields).CoaddN] = imProc.stack.coadd(RegisteredImages, Args.coaddArgs{:},'StackMethod','sigmaclip');
        
        % Background
        Coadd(Ifields) = imProc.background.background(Coadd(Ifields), Args.backgroundArgs{:}, 'SubSizeXY',Args.BackSubSizeXY);
    
        % Source finding
        Coadd(Ifields) = imProc.sources.findMeasureSources(Coadd(Ifields), Args.findMeasureSourcesArgs{:},...
                                                   'RemoveBadSources',true,...
                                                   'ZP',Args.ZP,...
                                                   'CreateNewObj',false);
                                           
                                           
        % astrometry    
        MeanJD = mean(JD);
        [ResultCoadd(Ifields).AstrometricFit, Coadd(Ifields), AstrometricCat] = imProc.astrometry.astrometryRefine(Coadd(Ifields), Args.astrometryRefineArgs{:},...
                                                                                                'WCS',AllSI(1,Ifields).WCS,...
                                                                                                'EpochOut',MeanJD,...
                                                                                                'Scale',Args.Scale,...
                                                                                                'CatName',Args.CatName,...
                                                                                                'Tran',Args.Tran,...
                                                                                                'CreateNewObj',false);

        
        % photometric calibration
        [Coadd(Ifields), ResultCoadd(Ifields).ZP, ResultCoadd(Ifields).PhotCat] = imProc.calib.photometricZP(Coadd(Ifields),...
                                                                                                    'CreateNewObj',false,...
                                                                                                    'MagZP',Args.ZP,...
                                                                                                    'CatName',AstrometricCat,...
                                                                                                    Args.photometricZPArgs{:});
        
        
        
    end
    
    if Args.CoaddMatchMergedCat
        % match against external catalogs
        Coadd = imProc.match.match_catsHTMmerged(Coadd, 'SameField',false, 'CreateNewObj',false);
    end
    
    
    % save products
    Args.SaveProcIm     = true;
    Args.SaveProcMask   = true;
    Args.SaveProcCat    = true;
    Args.SaveMatchCat   = true;
    Args.SaveMatchSrc   = true;
    Args.SaveCoaddIm    = true;
    Args.SaveCoaddMask  = true;
    Args.SaveCoaddCat   = true;
    
    SubDir = '4';
    
    IP   = ImagePath;
    if Args.SaveProcIm   
        Nim = numel(AllSI);
        for Iim=1:1:Nim
            IP.readFromHeader(AllSI(Iim));  
            IP.Product = 'Image';
            IP.SubDir  = SubDir;
            % FFU: whos is responsible for creating the dir? ImagePath?
            % FFU: the date is today - BUG!!
            AllSI(Iim).write1(IP.genFull, 'Image', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
           
        end        
    end
    
    if Args.SaveProcMask
        Nim = numel(AllSI);
        for Iim=1:1:Nim
            IP.readFromHeader(AllSI(Iim));  
            IP.Product = 'Mask';
            IP.SubDir  = SubDir;
            % FFU: whos is responsible for creating the dir? ImagePath?
            % FFU: the date is today - BUG!!
            AllSI(Iim).write1(IP.genFull, 'Mask', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
        end
    end
    
    if Args.SaveProcCat
        Nim = numel(AllSI);
        for Iim=1:1:Nim
            IP.readFromHeader(AllSI(Iim));  
            IP.Product = 'Cat';
            IP.SubDir  = SubDir;
            AllSI(Iim).write1(IP.genFull, 'Cat', 'FileType','fits',...
                                                   'WriteHeader',false,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
        end
    end
    
    
    if Args.SaveMatchCat
        % save MergedCat
        Nim = numel(MergedCat);
        for Iim=1:1:Nim
            % use the Coadd header 
            IP.readFromHeader(Coadd(Iim));       %MergedCat(Iim));  
            IP.Product = 'Cat';
            IP.Level   = 'merged';
            IP.Counter = 0;
            IP.SubDir  = SubDir;
            Coadd(Iim).write1(IP.genFull('PathLevel','proc'), 'Cat', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
        end
        
    end
    
    if Args.SaveMatchSrc
        Nim = numel(MatchedS);
        for Iim=1:1:Nim
            IP.Product  = 'MergedMat';
            IP.Level    = 'merged';
            IP.Counter  = 0;
            IP.FileType = 'hdf5';
            IP.SubDir   = SubDir;
            IP.CropID   = Iim;
            MatchedS(Iim).write(IP.genFull('PathLevel','proc'));
        end
    end
    
    if Args.SaveCoaddIm
        Nim = numel(Coadd);
        for Iim=1:1:Nim
            IP.readFromHeader(Coadd(Iim));  
            IP.Product = 'Image';
            IP.Counter = 0;
            IP.SubDir  = SubDir;
            % Path need to be like for an individual image
            Coadd(Iim).write1(IP.genFull('PathLevel','proc'), 'Image', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
        end
       
    end
    
    if Args.SaveCoaddMask
        Nim = numel(Coadd);
        for Iim=1:1:Nim
            IP.readFromHeader(Coadd(Iim));  
            IP.Product = 'Mask';
            IP.Counter = 0;
            IP.SubDir  = SubDir;
            % Path need to be like for an individual image
            Coadd(Iim).write1(IP.genFull('PathLevel','proc'), 'Mask', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
        end
    end
    
    if Args.SaveCoaddCat
        Nim = numel(Coadd);
        for Iim=1:1:Nim
            IP.readFromHeader(Coadd(Iim));  
            IP.Product = 'Cat';
            IP.Counter = 0;
            IP.SubDir  = SubDir;
            Coadd(Iim).write1(IP.genFull('PathLevel','proc'), 'Cat', 'FileType','fits',...
                                                   'WriteHeader',true,...
                                                   'Append',false,...
                                                   'OverWrite',true,...
                                                   'WriteTime',false);
                                               
        end
    end
    
    
    
    
    % for testing:
%     clear Coadd
%     clear ResultCoadd
%     clear RegisteredImages
%     clear MergedCat
%     clear MatchedS
%     clear ResultSubIm
%     clear AllSI
    
end

