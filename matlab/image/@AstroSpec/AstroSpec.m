

classdef AstroSpec < Component
    properties (Dependent)
        Wave
        Flux
        FluxErr
        Back
        Mask
        WaveUnits
        FluxUnits
    end
    
    properties
        Data table
        MaskData MaskImage   = MaskImage;
        Z                    = [];   % spectrum redshift-frame [0 - restframe]
        Vel                  = [];   % override Z
        DistZ                = [];   % redshift for ditsnace
        LumDist              = [];   % [pc]
        Ebv                  = [];   % Vector - [mag]
        Zext                 = 0;    % Vector - redshift of extinction
        R                    = 3.08; % Vector - 
    end
        
    
    properties (Hidden, SetAccess=private)
        %CooUnitsKnown(1,1) logical                                      = false;
    end
    
    properties (Hidden, Constant)
        DefColNameWave                   = 'Wave';
        DefColNameFlux                   = 'Flux';
        DefColNameFluxErr                = 'FluxErr';
        DefColNameBack                   = 'Back';
        DefColNameMask                   = 'Mask';
    end
  
    
    
    methods % constructor
        function Obj = AstroSpec(Matrix, Columns, Units)
            % constructor for AstroSpec
            % Input  : - An AstroSpec, Matrix, table, or cell array of
            %            matrix/tables.
            %          - A cell array of column names.
            %          - A cell array of unit names.
            % Output : - An AstroSpec object
            % Exanple: AS = AstroSpec(rand(100,2))
            
            arguments
                Matrix
                Columns cell         = {};
                Units cell           = {};
            end
            DefColNames = {'Wave', 'Flux', 'FluxErr', 'Back', 'Mask'};
            DefColUnits = {'Ang' , 'cgs/A', 'cgs/A','cgs/A',''};
            
           
            if isa(Matrix, 'AstroSpec')
                Obj = Matrix;
            else
                if ischar(Matrix)
                    % read from file
                    error('Read from file not yet available');
                    
                elseif istable(Matrix)
                    Obj.Data = Matrix;
                    if ~isempty(Columns)
                        Obj.Data.Properties.VariableNames = Columns;
                    end
                    if ~isempty(Units)
                        Obj.Data.Properties.VariableUnits = Units;
                    end
                elseif isnumeric(Matrix)
                    if numel(Matrix)==1
                        for I=1:1:Matrix
                            Obj(I) = AstroSpec(zeros(0,2), Columns, Units);
                        end
                    else
                        Ncol = size(Matrix,2);
                        if isempty(Columns)
                            % use default column names
                            Columns = DefColNames(1:Ncol);
                        end
                        if isempty(Units)
                            % use default column names
                            Units = DefColUnits(1:Ncol);
                        end

                        Obj.Data = array2table(Matrix, 'VariableNames', Columns);
                        Obj.Data.Properties.VariableUnits = Units;
                    end
                elseif  iscell(Matrix)
                    Ncell = numel(Matrix);
                    for Icell=1:1:Ncell
                        Obj(Icell) = AstroSpec(Matrix{Icell}, Columns, Units);
                    end
                else
                    error('Unknown input (Matrix) option');
                end
            end    
        end
        
    end
   
    methods % setters and getters
        function Result = get.Wave(Obj)
            % getter for Wave
            
            if any(strcmp(Obj.Data.Properties.VariableNames, Obj.DefColNameWave))
                Result = Obj.Data.(Obj.DefColNameWave);
            else
                % field not available
                Result = [];
            end
        end
        
        function set.Wave(Obj, Input)
            % setter for Wave
            
            Obj.Data.(Obj.DefColNameWave) = Input;
        end
        
        function Result = get.WaveUnits(Obj)
            % getter for WaveUnits
            
            Flag = ismember(Obj.Data.Properties.VariableNames, Obj.DefColNameWave); % index of wave columns
            if ~any(Flag)
                error('Wavelength column is not populated');
            end
            
            Result = Obj.Data.Properties.VariableUnits{Flag};
        end
        
        function set.WaveUnits(Obj, OutUnits)
            % setter for WaveUnits
            
            Flag = ismember(Obj.Data.Properties.VariableNames, Obj.DefColNameWave); % index of wave columns
            if ~any(Flag)
                error('Wavelength column is not populated');
            end
            CurUnits  = Obj.Data.Properties.VariableUnits{Flag};
            WaveData  = Obj.Data.(Obj.DefColNameWave);
            
            Obj.Data.(Obj.DefColNameWave) = convert.length(CurUnits, OutUnits, WaveData);
            Obj.Data.Properties.VariableUnits{Flag} = OutUnits;
            
        end
        
        function Result = get.Flux(Obj)
            % getter for Flux
            
            if any(strcmp(Obj.Data.Properties.VariableNames, Obj.DefColNameFlux))
                Result = Obj.Data.(Obj.DefColNameFlux);
            else
                % field not available
                Result = [];
            end
        end
        
        function set.Flux(Obj, Input)
            % setter for Flux
            
            Obj.Data.(Obj.DefColNameFlux) = Input;
        end
        
        function Result = get.FluxErr(Obj)
            % getter for FluxErr
            
            if any(strcmp(Obj.Data.Properties.VariableNames, Obj.DefColNameFluxErr))
                Result = Obj.Data.(Obj.DefColNameFluxErr);
            else
                % field not available
                Result = [];
            end
        end
        
        function set.FluxErr(Obj, Input)
            % setter for FluxErr
            
            Obj.Data.(Obj.DefColNameFluxErr) = Input;
        end
        
        function Result = get.Back(Obj)
            % getter for Back
            
            if any(strcmp(Obj.Data.Properties.VariableNames, Obj.DefColNameBack))
                Result = Obj.Data.(Obj.DefColNameBack);
            else
                % field not available
                Result = [];
            end
        end
        
        function set.Back(Obj, Input)
            % setter for Back
            
            Obj.Data.(Obj.DefColNameBack) = Input;
        end
        
        function Result = get.FluxUnits(Obj)
            % getter for FluxUnits
            
            Flag = ismember(Obj.Data.Properties.VariableNames, Obj.DefColNameFlux); % index of flux columns
            if ~any(Flag)
                error('Flux column is not populated');
            end
            
            Result = Obj.Data.Properties.VariableUnits{Flag};
        end
        
        function set.FluxUnits(Obj, OutUnits)
            % setter for FluxUnits
            
            Flag = ismember(Obj.Data.Properties.VariableNames, Obj.DefColNameFlux); % index of wave columns
            if ~any(Flag)
                error('Wavelength column is not populated');
            end
            CurUnits     = Obj.Data.Properties.VariableUnits{Flag};
            WaveData     = Obj.Data.(Obj.DefColNameWave);
            FluxData     = Obj.Data.(Obj.DefColNameFlux);
            FluxErrData  = Obj.Data.(Obj.DefColNameFlux);
            BackData     = Obj.Data.(Obj.DefColNameFlux);
            
            Obj.Data.(Obj.DefColNameFlux)    = convert.flux(FluxData,    CurUnits, OutUnits, WaveData, Obj.WaveUnits);
            Obj.Data.(Obj.DefColNameFluxErr) = convert.flux(FluxErrData, CurUnits, OutUnits, WaveData, Obj.WaveUnits);
            Obj.Data.(Obj.DefColNameBack)    = convert.flux(BackData,    CurUnits, OutUnits, WaveData, Obj.WaveUnits);
            
            Obj.Data.Properties.VariableUnits{Flag} = OutUnits;
            
        end
        
        function Result = get.Mask(Obj)
            % getter for Mask data
            
            Result = Obj.MaskData.Data;
        end
        
        function set.Mask(Obj, Input)
            % setter for Mask data
            
            Obj.MaskData.Data = Input;
        end
        
    end
    
    methods (Static)  % aux functions
        function [Factor] = applyExtinctionZ(ObsWave, Zext, EbvZ, RZ)
            % Calculate extinction to observed wavelngth vector in various redshifts.
            % Input  : - A vector of wavelength [Ang] in the observed
            %            frame.
            %          - A vector redshifts in which to apply extinction.
            %          - A vector of E_{B-V} to apply in each redshift.
            %            Use negative E_{B-V} to apply the inverse
            %            operator.
            %          - A vector of R_V to use in each redshift.
            %            Default is 3.08.
            % Output : - A vector of extinction factors, corresponding to
            %            the observed wavelength.
            % Author : Eran Ofek (Aug 2021)
            % Example: Factor = AstroSpec.applyExtinctionZ([5000 5010]', [0.5, 0], [0.2, 0.05], [2, 3.08])
            
            arguments
                ObsWave
                Zext
                EbvZ
                RZ                          = 3.08;
            end
            
            Zext = Zext(:);
            EbvZ = EbvZ(:);
            RZ   = RZ(:);
            Nz   = numel(Zext);
            EbvZ = EbvZ.*ones(Nz,1);
            RZ   = RZ.*ones(Nz,1);
            
            ObsWaveMicrons = ObsWave./1e4;  % Ang -> micrometer
            A_LambdaMag = zeros(numel(ObsWaveMicrons), Nz);
            for Iz=1:1:Nz
                ObsWaveMicronsZ = ObsWaveMicrons ./ (1 + Zext(Iz));
                A_LambdaMag(:,Iz)  = astro.spec.extinction(EbvZ(Iz), ObsWaveMicronsZ, [], RZ(Iz));
            end
            Factor = 10.^(-0.4.*sum(A_LambdaMag, 2));
        end
        
        function [FilterCell, Name] = read2FilterMatrix(Family, Name)
            % Convet a filter name/AstFilter to cell of transmissions
            % Input  : - A cell of family names, a family name, a matrix or
            %            an AstFilter object.
            %          - A filter name or a cell of names.
            % Output : - A cell array of filter transmissions.
            %          - A cell array of filter names.
            % Author : Eran Ofek (Aug 2021)
            % Example: [FilterCell, Name] = AstroSpec.read2FilterMatrix(Family, Name)
            
            if ischar(Name)
                Name = {Name};
            end
            
            if ischar(Family)
                Family = {Family};
            end
                
            if iscellstr(Family)
                Family = AstFilter.get(Family, Name);
            end
            
            if isa(Family, 'AstFilter')
                Nf = numel(Family);
                FilterCell = cell(1, Nf);
                for If=1:1:Nf
                    FilterCell{If} = Family(If).nT;
                end
            elseif isnumeric(Family)
                FilterCell{1} = Family;
            else
                error('Unknown Family option');
            end
                
        end
    end
    
    methods (Static) % special spectra
        function Result = blackBody(WaveData, Temp, Args)
            % Create an AstroSpec object with black body spectra
            %       Return specific (per Ang) luminosity or emittence.
            % Input  : - A vector of wavelengths, or an AstroSPec object
            %            from which the wavelength vector will be taken.
            %          - A vector of temperature.
            %          * ...,key,val,...
            %            'Radius' - Scalar or vector of BB radii for conversion
            %                   to luminosity. If empty,
            %                   then return the spectra in units of
            %                   emittemce from a cm^2/s/A on the BB.
            %            'RadiusUnits' - Radius units. Default is 'cm'.
            %            'Dist' - Scalar of vector of distances. If empty,
            %                   then return the spectra in units of
            %                   emittemce from a cm^2/s/A on the BB.
            %            'DistUnits' - Distance units. Default is 'pc'.
            %            'SpecType' - Spectrum type:
            %                    'P'  - planck formula, default.
            %                    'RJ' - Rayleigh-Jeans approximation
            %                    'W'  - Wein spectrum.
            % Output : - An AstroSPec array, with element per temperature.
            % Author : Eran Ofek (Aug 2021)
            % Example: Result = AstroSpec.blackBody((4000:10:9000)', [5000; 6000])
            
            arguments
                WaveData
                Temp                    = 5700;  % K
                Args.Radius             = [];
                Args.RadiusUnits        = 'cm';
                Args.Dist               = [];
                Args.DistUnits          = 'pc';
                Args.SpecType char      = 'P';   % 'P' | 'RJ' | 'W'
            end
            
            Nt     = numel(Temp);
            Nrad   = numel(Args.Radius);
            Ndist  = numel(Args.Dist);
            Result = AstroSpec(Nt);
            for It=1:1:Nt
                if isa(WaveData, 'AstroSpec')
                    Ias       = min(numel(WaveData), It);
                    Wave      = WaveData(Ias).Wave;
                    WaveUnits = Wavedata(Ias).WaveUnits;
                    WaveAng   = convert.length(WaveUnits, 'Ang', Wave);
                else
                    WaveAng   = WaveData;
                    WaveUnits = 'Ang';
                end
                [~,~,Flux] = astro.spec.black_body(Temp(It), WaveAng);
                if ~isempty(Args.Radius) && ~isempty(Args.Dist)
                    Ir     = min(Nt, Nrad);
                    Id     = min(Nt, Ndist);
                    Radius = convert.length(Args.RadiusUnits, 'cm', Args.Radius(Ir));
                    Dist   = convert.length(Args.DistUnits,   'cm', Args.Dist(Id));
                    
                    Flux   = Flux .* (Radius./Dist).^2;
                end
                
                Result(It) = AstroSpec({[WaveAng, Flux]}, {'Wave','Flux'}, {WaveUnits, 'cgs/A'});
            end
            
        end
            
    end
    
    methods (Static)  % read spectra from spectral libraries
        function Spec = synspecGAIA(Args)
            % Load GAIA synthetic spectra and if necessey interpolate over
            % Temperature (other parameters are not interpolated).
            % Input  : * ...,key,val,...
            %            'Temp' - Vector of fffective temperature of spectra [K], in
            %                   range of 3,500 to 400,000 K.
            %                   Default is 5750.
            %            'GraV' - Vector of surface gravity (log10(cgs)]
            %                   Default is 4.5
            %            'Metal' - Vector of metalicity.
            %                   Must be in (-2.5:0.5:0.5).
            %                   Default is 0.
            %            'Rot' - Rotation [km/s]. Default is 0.
            %            'OutType' - ['astrospec'] | 'astspec' | 'mat'.
            % Outout : - An AstroSpec object with specta.
            % Author : Eran Ofek (Aug 2021)
            % Example: Spec = AstroSpec.synspecGAIA
            %          Spec = AstroSpec.synspecGAIA('Temp',[5750 5500 5550],'Grav',[4.5]);
            %          Spec = AstroSpec.synspecGAIA('Temp',[3500:1000:1e4],'Grav',[4.5]);
            
            arguments
                Args.Temp           = 5750;
                Args.Grav           = 4.5   
                Args.Metal          = 0;
                Args.Rot            = 0;
                Args.OutType        = 'astrospec';   % 'astrospec' | 'astspec' | 'mat'
                Args.VecTemp        = [(3500:250:10000), (10500:500:12000), (13000:1000:35000), 40000, 45000, (1e5:1e5:4e5)];
                Args.VecMetal       = (-2.5:0.5:0.5);
            end
            
            
            Nt   = numel(Args.Temp);
            Ng   = numel(Args.Grav);
            Nm   = numel(Args.Metal);
            Nr   = numel(Args.Rot);
            Nmax = max([Nt,Ng,Nm,Nr]);
            Temp = Args.Temp(:).*ones(Nmax,1);
            Grav = Args.Grav(:).*ones(Nmax,1);
            Metal= Args.Metal(:).*ones(Nmax,1);
            Rot  = Args.Rot(:).*ones(Nmax,1);
            
            WaveFileName = 'GAIA_Wave1A.mat';
            
            PWD = pwd;
            % FFU: This dir is in config/Install.Data.Dirs.yml
            cd('~/matlab/data/spec/GAIA_SpecTemplate');
            
            FileSuffix = 'K2SNWNVD01F.mat';
            W          = io.files.load2(sprintf('%s',WaveFileName));
            
            
            for Is=1:1:Nmax
                if (Metal(Is)<0)
                    MetalSign = 'M';
                else
                    MetalSign = 'P';
                end

                if any(Temp(Is)==Args.VecTemp)
                    % read a single file
                    SpecName = sprintf('T%05dG%02d%s%02dV%03d%s',...
                        round(Temp(Is)),round(Grav(Is).*10),MetalSign,round(abs(Metal(Is)).*10),round(Rot(Is)),FileSuffix);

                    SpecMat  = [W, io.files.load2(SpecName)];
                else
                    % requires interpolation in T and M
                    DeltaT = Temp(Is) - Args.VecTemp;
                    DeltaTpos = DeltaT(DeltaT>0);
                    DeltaTneg = DeltaT(DeltaT<0);
                    
                    T1 = Temp(Is) - min(DeltaTpos);
                    T2 = Temp(Is) - max(DeltaTneg);
                    
                    SpecName1 = sprintf('T%05dG%02d%s%02dV%03d%s',...
                        T1,round(Grav(Is).*10),MetalSign,round(abs(Metal(Is)).*10),round(Rot(Is)),FileSuffix);
                    SpecName2 = sprintf('T%05dG%02d%s%02dV%03d%s',...
                        T2,round(Grav(Is).*10),MetalSign,round(abs(Metal(Is)).*10),round(Rot(Is)),FileSuffix);

                    SpecMat1  = [io.files.load2(SpecName1)];
                    SpecMat2  = [io.files.load2(SpecName2)];
                    
                    % weights
                    T2w = abs(T1 - Temp(Is))./abs(T2-T1);
                    T1w = abs(T2 - Temp(Is))./abs(T2-T1);
                    
                    SpecMat   = [W, T1w.*SpecMat1 + T2w.*SpecMat2];
                    
                end

                switch lower(Args.OutType)
                    case 'astrospec'
                        Spec(Is) = AstroSpec(SpecMat);
                        Spec(Is).Z   = 0;
                        Spec(Is).Vel = 0;
                    case 'astspec'
                        Spec(Is)=AstSpec.mat2spec(SpecMat,{'Wave','Int'},{'Ang','erg*cm^-2 *s^-1*Ang^-1'});
                        Spec(Is).z = 0;
                        Spec(Is).source = 'GAIA local DB';
                        Spec(Is).ObjName = sprintf('GAIA synspec T=%f, g=%f, M=%f, R=%f',Temp(Is),Grav(Is),Metal(Is),Rot(Is));
                    case 'mat'
                        % do nothing
                        Spec = SpecMat;
                    otherwise
                        error('Unknown OutType option');
                end
            end
            cd(PWD);
            
        end

        function Result = specGalQSO(Name, OutType)
            % Get galaxy/qso template spectrum from ../spec/SpecGalQSO/ data directory.
            % Description: Get Galaxy or QSO spectral template from local
            %              database.
            % Input  : - If empty, will return all available file names.
            %            If a single file name, then load it.
            %            If 'all', then return all spectra.
            %          - Output type: 'astrospec'|'mat'. Default is
            %            'AstroSpec'.
            % Output : - An AstroSoec object or a matrix with the requested
            %            spectrum. If the first argument is empty then this
            %            is a cell array of available file names.
            % Author : Eran Ofek (Sep 2021)
            % Example: AstroSpec.specGalQSO
            %          A=AstroSpec.specGalQSO('QSO_NIR');
            %          A=AstroSpec.specGalQSO('all');
            % Reliable: 2
            
            arguments
                Name      = [];
                OutType   = 'AstroSpec';
            end
            DataName = 'SpecGalQSO';
            Suffix   = '.txt';
            I = Installer;
            
            
            if isempty(Name)
                % return all available file names
                Files = I.getFilesInDataDir(DataName);
                Result = {Files.name};
            else
                switch lower(Name)
                    case 'all'
                        % load all spectra
                        Files = I.getFilesInDataDir(DataName);
                        Name = {Files.name};
                end
                if ischar(Name)
                    Name = {Name};
                end

                Nd = numel(Name);
                
                Dir = I.getDataDir(DataName);
                Iast = 0;
                for Id=1:1:Nd
                    if strcmp(Name{Id}, 'ReadMe')
                        % ignore
                    else
                        Iast = Iast + 1;
                        FullName = sprintf('%s%s%s', Dir, filesep, Name{Id});
                        if strcmp(FullName(end-3:end),Suffix)
                            % file name already contains suffix
                        else
                            % add suffix
                            FullName = sprintf('%s%s',FullName,Suffix);
                        end
                        Spec = io.files.load2(FullName);

                        switch lower(OutType)
                            case 'mat'
                                Result = Spec;
                            case 'astrospec'
                                Result(Iast) = AstroSpec({Spec});
                            otherwise
                                error('Unknown OutType option');
                        end
                    end
                end
            end

        end
        
        

    end
    
    methods  % resampling, sort, interpolation
        function Result = sort(Obj, Args)
            % Sort elements of AstroSpec object by wavelength
            % Input  : - An AstroSpec object.
            %          * ...,key,val,...
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with the elements sorted by
            %            wavelength.
            % Author : Eran Ofek (Aug 2021)
            % Example: S = AstroSpec({rand(100,3)});
            %          S.sort;
            
            arguments
                Obj
                Args.CreateNewObj           = [];
            end
                
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                [Result(Iobj).Data, Isort] = sortrows(Obj(Iobj).Data, 'Wave');
                
                if ~isempty(Obj(Iobj).MaskData.Data)
                    Result(Iobj).MaskData.Data = Obj(Iobj).MaskData.Data(Isort);
                end
            end
        end
                
        function Obj = selectWave(Obj, Flag)
            % Select lines from AstroSpec (don't generate a new copy)
            % Input  : - An AstroSpec object
            %          - A vector of logical flags or indices of lines to
            %            select.
            % Output : - The original AstroSpec with the removed lines.
            % Author : Eran Ofek (Aug 2021)
            % Example: AS = AstroSpec({rand(100,3)});
            %          AS = selectWave(AS, [1 2 3]);
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                Obj(Iobj).Data = Obj(Iobj).Data(Flag,:);
            end
            
        end
        
        function Result = interp1(Obj, NewWave, Args)
            % Interpolate the elements of AstroSpec into a new wavelength grid.
            %       The Mask will be interpolated using nearest
            %       interpolation. This function works only if the Data is
            %       convertable to a numeric matrix.
            % Input  : - An AstroSpec object.
            %          - A vector of new wavelngth grid on which to
            %            interpolate the AstroSpec object.
            %            Alternatively, a AstroSpec object with wavelength.
            %          * ...,key,val,...
            %            'Method' - Interpolation method. See interp1 for
            %                   options. Default is 'linear'.
            %            'ExtraArgs' - A cell array of additional arguments
            %                   to pass to interp1. Default is {}.
            %            'RemoveNan' - A logical indicating of to remove
            %                   NaNs. Default is false.
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with the interpolated spectra.
            % Author : Eran Ofek (Aug 2021)
            % Example: S = AstroSpec({rand(100,3)});
            %          S.sort;
            %          S.interp1([0:0.1:1]);
            
            arguments
                Obj
                NewWave
                Args.Method                 = 'linear';
                Args.ExtraArgs cell         = {};
                Args.RemoveNan(1,1) logical = false;
                Args.CreateNewObj           = [];
            end
          
            if isa(NewWave, 'AstroSpec')
                NewWave = NewWave.Wave;
            end
            NewWave = NewWave(:);
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
            
            Nobj = numel(Obj);
            
            for Iobj=1:1:Nobj
                % special treatment for Mask
                if ~isempty(Obj(Iobj).MaskData.Data)
                    Result(Iobj).MaskData.Data = interp1(Obj(Iobj).Wave, Obj(Iobj).MaskData.Data, NewWave, 'nearest');
                end
                VarNames = Obj(Iobj).Data.Properties.VariableNames;
                VarUnits = Obj(Iobj).Data.Properties.VariableUnits;
                Result(Iobj).Data = array2table(interp1(Obj(Iobj).Wave, table2array(Obj(Iobj).Data), NewWave, Args.Method, Args.ExtraArgs{:}));
                Result(Iobj).Data.Properties.VariableNames = VarNames;
                Result(Iobj).Data.Properties.VariableUnits = VarUnits;
                
                if Args.RemoveNan
                    Flag = isnan(Result(Iobj).Wave) | isnan(Result(Iobj).Flux);
                    Result(Iobj) = selectWave(Result(Iobj), ~Flag);
                end
            end
        end
        
        function [New1, New2] = interpAndKeepOverlap(Obj1, Obj2, Args)
            % Given two AstroSpec objects, interpolate the first into the
            % wavelength grid defined by the second and keep only the
            % overlaping points.
            % Input  : - The first AstroSpec object (multi elements
            %            supported).
            %          - The second AstroSpec object (multi elements
            %            supported).
            %            'Method' - Interpolation method. See interp1 for
            %                   options. Default is 'linear'.
            %            'ExtraArgs' - A cell array of additional arguments
            %                   to pass to interp1. Default is {}.
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with the interpolated spectra.
            % Author : Eran Ofek (Aug 2021)
            % Example: S1 = AstroSpec({rand(100,3)});
            %          S1.sort
            %          S2 = AstroSpec({rand(100,3).*0.5});
            %          S2.sort
            %          [New1, New2] = interpAndKeepOverlap(S1, S2);
           
            arguments
                Obj1
                Obj2
                Args.Method           = 'linear';
                Args.ExtraArgs cell   = {};
                Args.CreateNewObj     = [];
            end
            
            [New1] = createNewObj(Obj1, Args.CreateNewObj, nargout, 0);
            [New2] = createNewObj(Obj2, Args.CreateNewObj, nargout, 1);

            N1 = numel(New1);
            N2 = numel(New2);
            N  = max(N1, N2);
            for I=1:1:N
                I1 = min(I, N1);
                I2 = min(I, N2);
                
                New1(I1) = interp1(New1(I1), New2(I2).Wave, 'Method',Args.Method, 'ExtraArgs',Args.ExtraArgs, 'CreateNewObj',false);
                % remove NaNs
                FlagNN   = ~isnan(New1(I1).Flux) | isnan(New2(I2).Flux);
                New1(I1) = selectWave(New1(I1), FlagNN);
                New2(I2) = selectWave(New2(I2), FlagNN);
            end
            
        end
            
        function Result = interpOverRanges(Obj, Ranges, Args)
            % Interpolate AstroSpec object over some ranges
            %       Useful for interpolation over ranges containing
            %       spectral lines.
            % Input  : - An AstroSpec object.
            %          - A two column matrix of [Min Max] ranges.
            %            Each line is a wavelength range, and data points
            %            within (<>) this range will be interpolated.
            %          * ...,key,val,...
            %            'Method' - Interpolation method. See interp1 for
            %                   options. Default is 'linear'.
            %            'ExtraArgs' - A cell array of additional arguments
            %                   to pass to interp1. Default is {}.
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with the interpolated spectra.
            % Author : Eran Ofek (Aug 2021)
            % Example: S = AstroSpec({rand(100,3)});
            %          S.sort;
            %          Ranges = [0.2 0.5; 0.6 0.9];
            %          R = S.interpOverRanges(Ranges);
           
            arguments
                Obj
                Ranges(:,2)
                Args.Method char            = 'linear';
                Args.ExtraArgs cell         = {};
                Args.CreateNewObj           = [];
            end
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
            
            Nranges = size(Ranges, 1);
                
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                Wave = Obj(Iobj).Wave;
                for Iranges=1:1:Nranges
                    Flag = Wave > Ranges(Iranges,1) & Wave < Ranges(Iranges,2);
                    Result(Iobj).Data = Result(Iobj).Data(~Flag,:);
                    if ~isempty(Result(Iobj).MaskData.Data)
                        Result(Iobj).MaskData.Data = Result(Iobj).MaskData.Data(~Flag);
                    end
                    Result(Iobj).interp1(Wave, 'CreateNewObj',false, 'Method',Args.Method, 'ExtraArgs',Args.ExtraArgs);
                end
            end
        end
        
        function Result = interpOverNan(Obj, Args)
            % Interpolate AstroSpec object over NaNs.
            % Input  : - An AstroSpec object.
            %          * ...,key,val,...
            %            'Method' - Interpolation method. See interp1 for
            %                   options. Default is 'linear'.
            %            'ExtraArgs' - A cell array of additional arguments
            %                   to pass to interp1. Default is {}.
            %            'DataProp' - Data property in which to look for
            %                   NaNs. Default is 'Flux'.
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with the interpolated spectra.
            %            (NaNs are interpolated over).
            % Author : Eran Ofek (Aug 2021)
            % Example: S = AstroSpec({rand(100,3)});
            %          S.sort;
            %          S.Flux(2:5) = NaN;
            %          R = S.interpOverNan;
           
            arguments
                Obj
                Args.Method char            = 'linear';
                Args.ExtraArgs cell         = {};
                Args.DataProp               = 'Flux';
                Args.CreateNewObj           = [];
            end
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
                            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                Wave = Obj(Iobj).Wave;
                
                Flag = isnan(Obj(Iobj).(Args.DataProp));
                Result(Iobj).Data = Result(Iobj).Data(~Flag,:);
                if ~isempty(Result(Iobj).MaskData.Data)
                    Result(Iobj).MaskData.Data = Result(Iobj).MaskData.Data(~Flag);
                end
                Result(Iobj).interp1(Wave, 'CreateNewObj',false, 'Method',Args.Method, 'ExtraArgs',Args.ExtraArgs);
            end
        end
        
        function Result = length(Obj)
            % Return length of each spectrum in AstroSpec object
            % Input  : - An AstroSpec object.
            % Output : - A vector of lengths of each spectrum.
            % Author : Eran Ofek (Aug 2021)
            % Example: AS = AstroSpec({rand(100,3)});
            %          AS.length
           
            Nobj   = numel(Obj);
            Result = nan(size(Obj));
            for Iobj=1:1:Nobj
                Result(Iobj) = numel(Obj(Iobj).Wave);
            end
        end
        
        function Result = funFlux(Obj, Fun, Args)
            % Apply a function to the Flux, FluxErr, Back columns.
            % Input  : - An AstroSpec object.
            %          - A function handle to apply.
            %          * ...,key,val,...
            %            'FunArgs' - A cell array of additional arguments to pass to
            %                   the function.
            %            'DataProp' - A cell array of data properties on
            %                   which to apply the function.
            %                   Default is {'Flux', 'FluxErr', 'Back'}.
            %            'CreateNewObj' -  [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec objec after aplying the function.
            % Author : Eran Ofek (Aug 2021)
            % Example:  Spec = AstroSpec.synspecGAIA('Temp',[5750 5500 5550],'Grav',[4.5]);
            %           Res  = funFlux(Spec, @log10);
            
            arguments
                Obj
                Fun function_handle
                Args.FunArgs cell         = {};
                Args.DataProp             = {'Flux', 'FluxErr', 'Back'};
                Args.CreateNewObj         = [];
            end
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
           
            Nobj = numel(Obj);
            Nd   = numel(Args.DataProp);
            for Iobj=1:1:Nobj
                for Id=1:1:Nd
                    if ~isempty(Obj(Iobj).(Args.DataProp{Id}))
                        Result(Iobj).(Args.DataProp{Id}) = Fun(Obj(Iobj).(Args.DataProp{Id}), Args.FunArgs{:});
                    end
                end
            end
            
        end
        
        function Result = interpLogSpace(Obj, Args)
            % Interpolate an AstroSpec object into a logarithmic wavelength grid.
            % Input  : - An AstroSpec object.            
            %          * ...,key,val,...
            %            'Res' - Resolution (Dlambda/lambda) to use fot the
            %                   log-spacing. If empty, estimate using
            %                   wave-diff. Default is [].
            %            'Method' - Interpolation method. See interp1 for
            %                   options. Default is 'linear'.
            %            'ExtraArgs' - A cell array of additional arguments
            %                   to pass to interp1. Default is {}.
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            % Output : - An AstroSpec object with logarithmic spaced
            %            wavelength grid.
            % Output : - An AstroSpec object with the interpolated spectra.
            % Author : Eran Ofek (Aug 2021)
            % Example: Spec = AstroSpec.synspecGAIA('Temp',[5750],'Grav',[4.5]);
            %          Result = interpLogSpace(Spec);
            
            arguments
                Obj
                Args.Res               = [];
                Args.Method            = 'linear';
                Args.ExtraArgs cell    = {};
                Args.CreateNewObj      = [];
            end
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                if isempty(Args.Res)
                    % estimate resolution
                    Res = min(Obj(Iobj).Wave(1:end-1)./diff(Obj(Iobj).Wave));
                    Res = Res .* log10(max(Obj(Iobj).Wave));
                else
                    Res = Args.Res .* log10(max(Obj(Iobj).Wave));
                end
                
                NewWave = logspace(log10(min(Obj(Iobj).Wave)), log10(max(Obj(Iobj).Wave)), ceil(Res));
                
                Result(Iobj) = interp1(Result(Iobj), NewWave, 'Method',Args.Method, 'ExtraArgs',Args.ExtraArgs{:}, 'RemoveNan',true, 'CreateNewObj',false);
            end
            
        end
    end
    
    methods % synthetic photometry
        function [Result, Flag, FilterWave] = synphot(Obj, FilterFamily, FilterName, Args)
            % Synthetic photometry on an AstroSpec object spectra
            % Input  : - An AstroSpec object (multi elements supported)
            %          - A cell of filter family names, an AstFilter
            %            object, or a matrix of transmissions.
            %          - A cell array of filter names. The output structure
            %            will have a field name for each one of these names.
            %          * ...,key,val,...
            %            'MagSys' - Mag system: ['AB'] | 'Vega'
            %            'Device' - Device ['photon'] | 'bol'
            %            'Algo' - Algorithm - see astro.spec.synphot
            %                   Default is 'cos'
            %            'Ebv' - E_{B-V} [mag] extinction to apply to
            %                   spectra. Default is 0.
            %            'R' - R_V to use for extinction. Default is 3.08.
            % Output : - A structure array of syntheic magnitudes.
            %            Element per object element, and ach filter is
            %            stored in a field with its name.
            %          - Like Mag results, but for the fraction of
            %            extrapolated part of the filter.
            %            0 means no extrapolation.
            %          - A vector of the filter central wavelengths. 
            % Author : Eran Ofek (Aug 2021)
            % Example: AS = AstroSpec.blackBody((4000:10:9000)', [5000; 6000]);
            %          [Result, Flag, FilterWave] = synphot(AS, {'SDSS','SDSS'}, {'g','r'})
            %          Spec = AstroSpec.synspecGAIA('Temp',[5750 5500 5550],'Grav',[4.5]);
            %          Spec = AstroSpec.synspecGAIA('Temp',[5750],'Grav',[4.0, 4.5]);
            %          T=[5000 0; 5001 1; 5999 1; 6000 0];  % filter transmission
            %          Spec.interpOverNan;
            %          [Result, Flag, FilterWave] = synphot(Spec, T, 'F55');

            
            arguments
                Obj
                FilterFamily       % AstroFilter object, Name, Matrix
                FilterName         % numer in Result
                
                Args.MagSys   = 'AB';
                Args.Device   = 'photon';
                Args.Algo     = 'cos';
                Args.Ebv      = 0;
                Args.R        = 3.08;
            end
           
            [FilterCell, Name] = AstroSpec.read2FilterMatrix(FilterFamily, FilterName);
            
            Nname = numel(Name);
            Nobj  = numel(Obj);
            FilterWave = zeros(1, Nname);
            for Iobj=1:1:Nobj
                Spec = [Obj(Iobj).Wave(:), Obj(Iobj).Flux(:)];
                
                for Iname=1:1:Nname
                    [Mag, FiltFlag, FilterWave(Iname)] = astro.spec.synphot(Spec, FilterCell{Iname}, [], Args.MagSys, Args.Algo, Args.Ebv, Args.R, Args.Device);
                    Result(Iobj).(Name{Iname})     = Mag;
                    Flag(Iobj).(Name{Iname})       = FiltFlag;
                end
            end
        end
    end
    
    methods % filtering
        function Result = filterFun(Obj, Function, varargin)
            % Apply a 1-D function (filter) on the Flux field in AstroSpec
            % object. The function do not check if the wavelength is
            % equally spaced.
            % The function operates on the Flux, FluxErr, and Back fields.
            % Input  : - An AstroSpec object.
            %          - A function handle. E.g., @medfilt1, @hampel,
            %            @sgolayfilt,...
            %          * Additional arguments to pass to the specific
            %            function.
            % Output : - If no output argument is requested, then will modify the input
            %            AstroSpec object. Otherwise, will create a new
            %            copy of the object.
            %            The oupt contains the filtered spectra.
            % Author : Eran Ofek (Aug 2021)
            % Example: AS=AstroSpec.blackBody((4000:10:9000)', [5000; 6000]);
            %          AS.filterFun(@medfilt1,10)
            
            [Result] = createNewObj(Obj, [], nargout, 0);
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                Result(Iobj).Flux = Function(Obj(Iobj).Flux, varargin{:});
            end
        end
        
    end
    
    methods  % fitting
        function Result = fitSpec(Obj, ModelSpec, Args)
            % UNDER CONSTRUCTION
           
            % Example: Spec = AstroSpec.synspecGAIA('Temp',[5750],'Grav',[4.5]);
            %          BB = AstroSpec.blackBody(Spec.Wave, 5750);
            %          Result = fitSpec(Spec, BB)
            
            arguments
                Obj                     % AstroSpec
                ModelSpec               % AstroSpec to fit to Obj
                Args.InterpModel2spec(1,1) logical   = true;
                Args.FunFlux                         = [];
                Args.FunArgs cell                    = {};
                Args.InterpMethod                    = 'linear';
                Args.FitType                         = 'norm';   % 'add' | 'none' | 'norm' | 'normadd' | 'ext'
                Args.R                               = 3.08;
            end
            
            Nobj = numel(Obj);
            Nms  = numel(ModelSpec);
            Nmax = max(Nobj, Nms);
            for Imax=1:1:Nmax
                Iobj = min(Imax, Nobj);
                Ims  = min(Imax, Nms);
                
                if Args.InterpModel2spec
                    % model over obj
                     [NewModelSpec, NewObj] = interpAndKeepOverlap(ModelSpec(Ims), Obj(Iobj), 'Method',Args.InterpMethod, 'CreateNewObj',true);
                     
                else
                    % Obj over model
                    [NewObj, NewModelSpec] = interpAndKeepOverlap(Obj(Iobj), ModelSpec(Ims), 'Method',Args.InterpMethod, 'CreateNewObj',true);
                end
            
                % apply function to spectra
                NewObj       = funFlux(NewObj,       Args.FunFlux, 'FunArgs',Args.FunArgs, 'CreateNewObj',false);
                NewModelSpec = funFlux(NewModelSpec, Args.FunFlux, 'FunArgs',Args.FunArgs, 'CreateNewObj',false);
                
                % fit 
                % scale, additive, extinction
                
                Nw = NewModelSpec.length;
                
                switch lower(Args.FitType)
                    case 'none'
                        ScaledModel = NewModelSpec.Flux;
                        ScaledErr   = NewModelSpec.FluxErr;
                    otherwise
                        % fiiting
                        switch lower(Args.FitType)
                            case 'add'
                                % fit only additive term
                                H    = [ones(Nw,1)];
                            case 'norm'
                                % fit only normalization
                                H    = [NewModelSpec.Flux(:)];
                            case 'normadd'
                                H    = [NewModelSpec.Flux(:), ones(Nw,1)];
                            case 'ext'
                                WaveMicrons       = convert.length(NewModelSpec.WaveUnits, 'micrometer', NewModelSpec.Wave);
                                A_W               = astro.spec.extinction(1, WaveMicrons, [], Args.R);
                                NewModelSpec.Flux = NewModelSpec.Flux.*10.^(-0.4.*A_W);
                                H                 = [NewModelSpec.Flux(:)];
                            otherwise
                        end
                        Y    = NewObj.Flux;
                        ErrY = NewObj.FluxErr;
                        if isempty(ErrY)
                            ErrY = ones(Nw,1);
                        end
                        [Par, ParErr] = lscov(H, Y, (1./ErrY).^2);
                        ScaledModel   = H*Par;
                        ScaledErr     = Par(1).*NewModelSpec.FluxErr(:);
                end
                        
                Result(Imax).Resid = NewObj.Flux - ScaledModel;
                Result(Imax).Ratio = NewObj.Flux ./ ScaledModel;
                Result(Imax).Std   = std(Result(Imax).Resid);
                Result(Imax).Chi2  = sum((Result(Imax).Resid./ScaledErr).^2);
                
            end
        end
    end
    
    methods  % plots
        function H = plot(Obj, varargin)
            % Plot all the spectra in an AstroSpec object
            % Input  : - An AstroSpec object (multi elements supported)
            %          * Additional input arguments to pass to the plot
            %            command.
            % Output : - AN handle for the last plot.
            % Author : Eran Ofek (Aug 2021)
            % Example: Result = AstroSpec.blackBody((4000:10:9000)', [5000; 6000]);
            %          Result.plot  
           
            IsHold = ishold;
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                H = plot(Obj(Iobj).Wave, Obj(Iobj).Flux, varargin{:});
                hold on;
            end
            
            H = xlabel(sprintf('Wavelength [%s]',Obj(1).WaveUnits));
            H.FontSize    = 18;
            H.Interpreter = 'latex';
            H = ylabel(sprintf('Flux [%s]',Obj(1).FluxUnits));
            H.FontSize    = 18;
            H.Interpreter = 'latex';
            
            if ~IsHold
                hold off;
            end
            
            
        end
        
    end
    
    methods  % redshift/extinction/luminosity
        function Result = redshift(Obj, Zout, Zin, Args)
            % Apply redshift to a spectrum
            %       Divide wave by (1+z) and multiply flux by (1+z)
            %       Correct also FluxErr and Back
            % Input  : - An AstroSpec object.
            %          - Output redshift. Use 0, in order to convert the
            %            spectrum to rest frame. Default is 0.
            %          - Input redshift. If empty, then will attempt to
            %            read it from the Z property. Default is [].
            %          * ...,key,val,...
            %            'CreateNewObj' - [], true, false.
            %                   If true, create new deep copy
            %                   If false, return pointer to object
            %                   If [] and Nargout==0 then do not create new copy.
            %                   Otherwise, create new copy. Default is [].
            %            'CorrectFluxErr' - Default is true.
            %            'CorrectBack'    - Default is true.
            % Output : - An updated AstroSpec object.
            %            If output is not requested, then by default will
            %            change the input object (see CreateNewObj arg).
            % Author : Eran Ofek (Aug 2021)
            % Example: S = AstroSpec({rand(100,3)});
            %          NS = AS.copyObject;
            %          NS.redshift=0.5;
            %          NS.Z=0.5;       
            %          NS.redshift(0)  

            arguments
                Obj
                Zout                             = 0;
                Zin                              = [];  % Z of spectra
                Args.CreateNewObj                = [];
                Args.CorrectFluxErr(1,1) logical = true;
                Args.CorrectBack(1,1) logical    = true;
            end
            
            [Result] = createNewObj(Obj, Args.CreateNewObj, nargout, 0);
        
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                if ~isempty(Zin)
                    % reset Z property in object
                    Obj(Iobj).Z   = Zin;
                end
                
                if isempty(Obj(Iobj).Z)
                    error('Z must be specified either in object or as Zin input argument');
                end
                
                % apply redshift to wavelength
                % convert to rest frame
                Result(Iobj).Wave    = Result(Iobj).Wave .* (1 + Zout) ./ (1 + Result(Iobj).Z);
                Result(Iobj).Flux    = Result(Iobj).Flux .* (1 + Result(Iobj).Z) ./ (1 + Zout);
                if (Args.CorrectFluxErr)
                    Result(Iobj).FluxErr = Result(Iobj).FluxErr .* (1 + Result(Iobj).Z) ./ (1 + Zout);
                end
                if (Args.CorrectBack)
                    Result(Iobj).Back    = Result(Iobj).Back .* (1 + Result(Iobj).Z) ./ (1 + Zout);
                end
                
                Result(Iobj).Z       = [];     % needed [so Z setter will not apply the redshift]
                Result(Iobj).Z       = Zout;
            end
            
            
        end
        
        
    end
       
    
    methods (Static)  % unitTest
        Result = unitTest
            % unitTest for AstroSpec

    end
    
end
