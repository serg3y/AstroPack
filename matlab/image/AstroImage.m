% BaseImage handle class - all images inherits from this class
% Package: @BaseImage
% Description: 
% Tested : Matlab R2018a
% Author : Eran O. Ofek (Mar 2021)
% Dependencies: @convert, @celestial
% Example : 
% Reliable: 2
%--------------------------------------------------------------------------

classdef AstroImage < Component
    % Component should contain:
    % UserData
    % Config
    
    properties (Dependent) % Access image data directly        
        Image 
        Back 
        Var
        Mask 
        Header  % e.g., Header, Header('EXPTIME'), Header({'EXPTIME','IMTYPE'}), Header('IMTYPE',{additional args to keyVal})
        Key
        Cat     % e.g., Cat, Cat([1 3]), Cat('RA'), Cat({'RA','Dec'})
        PSF
        %WCS
    end
    
    properties (SetAccess = public)
        % Data
        %ImageData(1,1) NoisyImage
        
        ImageData(1,1) SciImage              %= SciImage;
        BackData(1,1) BackImage              %= BackImage;
        VarData(1,1) VarImage                %= VarImage;
        MaskData(1,1) MaskImage              %= MaskImage;
        
        HeaderData(1,1) AstroHeader          %= AstroHeader;
        CatData(1,1) AstroCatalog            %= AstroCatalog;
        PSFData(1,1) AstroPSF                %= AstroPSF;
        WCS   % not ready: AstroWCS
        
        PropagateErr(1,1) logical          = false;
        
    end
    
    properties (Hidden, Constant)
        % set the relation between the Dependent prop and the data prop
        Relations   = struct('Image','ImageData',...
                             'Back','BackData',...
                             'Var','VarData',...
                             'Mask','MaskData');
        
        
    end
    
    methods % Constructor
       
        function Obj = AstroImage(FileNames, Args)
            % Constructor and image reader for AstroImage class
            %
            % Under development
            %
            % Example:
            %          AI = AstroImage([2 2]);
            %          AI = AstroImage(FileNames,'HDU',1);
            %          AI = AstroImage(FileNames,'HDU',1,'Back',FileNames,'BackHDU',2);
            %          AI = AstroImage(FileNames,'HDU',1,'Back',FileNamesBack,'BackHDU',1);
            %          AI = AstroImage({rand(10,10)},'Back',{rand(5,5)},'BackScale',2,'var',{rand(5,5)},'VarScale',2);
            
            arguments
                FileNames                     = [];
                Args.HDU                      = 1;
                Args.Scale                    = [];
                Args.ReadHeader(1,1) logical  = true;
                
                Args.Back                     = []; % if empty and BackHDU is not empty, them read from the primary FileNames
                Args.BackHDU                  = [];
                Args.BackScale                = [];
                
                Args.Var                      = [];
                Args.VarHDU                   = [];
                Args.VarScale                 = [];
                
                Args.Mask                     = [];
                Args.MaskHDU                  = [];
                Args.MaskScale                = [];
                
                Args.FileType                 = [];
                Args.UseRegExp(1,1) logical   = false;
                
            end
            
            if isempty(FileNames)
                % create a single elemeny empty object
                % must initilaize all the internal objects
                Obj.ImageData   = SciImage;
                Obj.BackData    = BackImage;
                Obj.VarData     = VarImage;
                Obj.MaskData    = MaskImage;
                Obj.HeaderData  = AstroHeader;
                Obj.CatData     = AstroCatalog;
                Obj.CatData     = AstroCatalog;
                Obj.PSFData     = AstroPSF;
                Obj.WCS         = [];            % FFU: update when WCS class is ready
                
            else
                if isnumeric(FileNames)
                    Nobj = prod(FileNames);
                    for Iobj=1:1:Nobj
                        Obj(Iobj) = AstroImage([]);
                    end
                    Obj = reshape(Obj, FileNames);
                    
                else
                    if isa(FileNames,'AstroImage')
                        Obj = FileNames;
                    elseif isa(FileNames,'SIM')
                        % convert SIM to AstroImage
                        
                    elseif isa(FileNames,'imCl')
                        % convert imCl to AstroImage
                        
                    else
                        % ImageData
                        Obj = AstroImage.readImages2AstroImage(FileNames,'HDU',Args.HDU,...
                                                                        'Obj',[],...
                                                                        'FileType',Args.FileType,...
                                                                        'UseRegExp',Args.UseRegExp,...
                                                                        'Scale',Args.Scale,...
                                                                        'ReadHeader',Args.ReadHeader,...
                                                                        'DataProp','ImageData');
                                                                        
                        % Other data properties
                        ListProp  = {'Back','Var','Mask'};
                        ListData  = {'BackData','VarData','MaskData'};
                        ListHDU   = {'BackHDU','VarHDU','MaskHDU'};
                        ListScale = {'BackScale','VarScale','MaskScale'};
                        
                        Nlist = numel(ListProp);
                        for Ilist=1:1:Nlist
                            if ~isempty(Args.(ListHDU{Ilist})) && isempty(Args.(ListProp{Ilist}))
                                % read the Back/Var/... images from the science images
                                % (FileNames), but from a different HDU.
                                Args.(ListProp{Ilist}) = FileNames;
                            end
                            if ~isempty(Args.(ListProp{Ilist}))
                                % do not read header
                                Obj = AstroImage.readImages2AstroImage(Args.(ListProp{Ilist}),'HDU',Args.(ListHDU{Ilist}),...
                                                                            'Obj',Obj,...
                                                                            'FileType',Args.FileType,...
                                                                            'UseRegExp',Args.UseRegExp,...
                                                                            'Scale',Args.(ListScale{Ilist}),...
                                                                            'ReadHeader',false,...
                                                                            'DataProp',ListData{Ilist});
                            end
                        end
                        
                        
                                   
                            
                    end
                    
                end
            end
                    
                
            
            
            
            
%             % this is here for testing only
%             Obj.ImageData  = SciImage({300 + 10.*randn(100,100)});
%             Obj.VarData    = VarImage({10.*ones(100,100)});
%             Obj.BackData   = BackImage({300});
%             Obj.HeaderData.Data = {'EXPTIME',1,'';'FILTER','R',''}; 
%             
%             arguments
%                 AnotherObj            = [1 1];
%                 Args.
%             end
            
            
            
        end

    end

    methods (Static) % utilities
        function Obj = imageIO2AstroImage(ImIO, DataProp, Scale, CopyHeader, Obj)
            % Convert an ImageIO object into an AstroImage object
            % Input  : - An ImageIO object.
            %          - data property in which to store the image.
            %          - Scale of the image.
            %          - A logical indicating if to copy the header.
            %          - An AstroImage object in which to put the data.
            %            If empty, create a new object. Default is empty.
            % Output : - An AstroImage object.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI=AstroImage.imageIO2AstroImage(ImIO, 'ImageData', [], true)
       
            if nargin<5
                % create new Obj
                Obj = [];
            end
            
            if isempty(Obj)
                Obj  = AstroImage(size(ImIO));
            else
                % use supplied object
                if ~isa(Obj,'AstroImage')
                    error('Obj (argument at position 5) must be an AstroImage object');
                end
            end
            
            Nobj = numel(Obj);
            if Nobj~=numel(ImIO)
                error('Supplied AstroImage object and ImageIO object must have the same size');
            end
            
            for Iobj=1:1:Nobj
                Obj(Iobj).(DataProp).Data  = ImIO(Iobj).Data;
                Obj(Iobj).(DataProp).Scale = Scale;
                if CopyHeader
                    Obj(Iobj).HeaderData.Data = ImIO(Iobj).Header;
                end
            end
        end
        
        function Obj = readImages2AstroImage(FileName, Args)
            % Create AstroImage object and read images into a specific property.
            % Input  : - Either:
            %            [] - will return a single element empty object.
            %            [N, M,...] - will return an empty objects
            %                   which size is [N, M,...].
            %            A table to put in the Data property.
            %            A cell array of matrices to put in the Data
            %                   property.
            %            FileName with or without wild cards or regexp, 
            %                   or a cell of file names to read.
            %          * ...,key,val,...
            %            'Obj' - An AstroImage object in which to put the
            %                   data in. If empty create a new object.
            %                   Default is empty.
            %            'HDU' - HDU number or Dataset name from which to
            %                   read the images.
            %            'FileType' - See ImageIO. Default is [].
            %            'UseRegExp' - See ImageIO. Default is false.
            %            'Scale' - The scale of the image (see definition
            %                   in ImageComponent). Default is [].
            %            'DataProp' - AstroImage data property in wjich to
            %                   store the data. Default is 'ImageData'.
            %            'ReadHeader' - Default is true.
            % Outout : - An AstroImage object with the images stored in the
            %            requested field.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI=AstroImage.readImages2AstroImage('*.fits', 'DataProp', 'ImageData');
            %          AI=AstroImage.readImages2AstroImage([]);
            %          AI=AstroImage.readImages2AstroImage([1 2]);
            %          AI=AstroImage.readImages2AstroImage({rand(10,10), rand(5,5)});
            %          AI=AstroImage.readImages2AstroImage({rand(10,10), rand(5,5)},'DataProp','VarData');
            %          AI=AstroImage.readImages2AstroImage({rand(10,10), rand(20,20)},'DataProp','ImageData');
            %          AI=AstroImage.readImages2AstroImage({rand(10,10), rand(20,20)},'DataProp','BackData','Obj',AI);
            %          AI=AstroImage.readImages2AstroImage({rand(5,5), rand(10,10)},'DataProp','VarData','Obj',AI,'Scale',2);
            
            
            arguments
                FileName
                Args.Obj                    = [];
                Args.HDU                    = 1;
                Args.FileType               = [];
                Args.UseRegExp(1,1) logical = false;
                Args.Scale                  = [];
                Args.DataProp               = 'ImageData';
                Args.ReadHeader             = true;
            end
            
                
            switch lower(Args.DataProp)
                case {'imagedata','backdata','vardata','maskdata'}
                    ImIO = ImageIO(FileName, 'HDU',Args.HDU,...
                                             'FileType',Args.FileType,...
                                             'IsTable',false,...
                                             'ReadHeader',Args.ReadHeader,...
                                             'UseRegExp',Args.UseRegExp);
                case {'cat','catdata'}
                    ImIO = ImageIO(FileName, 'HDU',Args.HDU,...
                                             'FileType',Args.FileType,...
                                             'IsTable',true,...
                                             'ReadHeader',Args.ReadHeader,...
                                             'UseRegExp',Args.UseRegExp);
                otherwise
                    error('DataProp %s is not supported',Args.DataProp);
            end
            Obj = AstroImage.imageIO2AstroImage(ImIO, Args.DataProp, Args.Scale, Args.ReadHeader, Args.Obj);
            
            
        end
                                         
    end

 
    methods % Setters/Getters
        function Obj = set.Image(Obj, Data)
            % setter for Image - store image in ImageData property
            %Obj.(Relations.Image).Image = Data;  % can use this instead
            Obj.ImageData.Image = Data;
        end
        
        function Data = get.Image(Obj)
            % getter for Image - get image from ImageData property
            Data = Obj.ImageData.Image;
        end    
        
        function Obj = set.Back(Obj, Data)
            % setter for BackImage
            Obj.BackData.Image = Data;
        end
        
        function Data = get.Back(Obj)
            % getter for BackImage
            Data = Obj.BackData.Image;
        end
        
        function Obj = set.Var(Obj, Data)
            % setter for VarImage
            Obj.VarData.Image = Data;
        end
        
        function Data = get.Var(Obj)
            % getter for VarImage
            Data = Obj.VarData.Image;
        end
        
        function Obj = set.Mask(Obj, Data)
            % setter for MaskImage
            Obj.MaskData.Image = Data;
        end
        
        function Data = get.Mask(Obj)
            % getter for MaskImage
            Data = Obj.MaskData.Image;
        end
        
        function Data = get.Header(Obj)
            % getter for Header
            Data = Obj.HeaderData.Data;
        end
        
        function Data = get.Key(Obj)
            % getter for Header keys
            Data = Obj.HeaderData.Key;
        end
        

    end
    
    methods (Static)  % static methods
       
    end
    
%     methods % translate Data property names
%         function DataName = translateDataPropName(Obj, DataProp)
%             % translate the Data propert names (e.g., 'Image' -> 'ImageData')
%             % Output : - A cell array of Data property names.;
%             % Example: AI.translateDataPropName('Var')
%             %          AI.translateDataPropName({'Back','Var'})
%             
%             if ischar(DataProp)
%                 DataProp = {DataProp};
%             end
%             
%             Nprop    = numel(DataProp);
%             DataName = cell(1,Nprop);
%             for Iprop=1:1:Nprop
%                 if isfield(Obj(1).Relations,DataProp{Iprop})
%                     DataName{Iprop} = Obj(1).Relations.(DataProp{Iprop});
%                 else
%                     % do not translate - return as is
%                     DataName{Iprop} = DataProp{Iprop};
%                     %error('Requested DataProp: %s - can not be translated into valid data property name',DataProp{Iprop});
%                 end
%             end
%             
%         end
%     end
    
    methods % empty and size
        function varargout = isemptyImage(Obj, Prop)
            % Check if data images in AstroImage object are empty
            % Input  : - An AstroImage object (multi elements supported).
            %          - A cell array of data properties for which to check
            %            if empty.
            %            Default is {'Image','Back','Var','Mask'}.
            % Output : * One output per requested data property. For each
            %            data property, this is an array of logical
            %            indicating if the data isempty.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI=AstroImage;
            %          [a,b]=AI.isemptyImage({'Image','Back'})
            
            arguments
                Obj
                Prop        = {'Image','Back','Var','Mask'};
            end
            
            if ischar(Prop)
                Prop = {Prop};
            end
            
            Nprop = numel(Prop);            
            Nobj = numel(Obj);
            varargout = cell(1,nargout);
            if nargout>Nprop
                error('Number of requested output (%d) must be equal or smaller then number of reqested data properties (%d)',nargout,Nprop);
            else
                Prop  = Prop(1:nargout);
                Nprop = nargout;
            end
            for Iprop=1:1:Nprop
                varargout{Iprop} = false(size(Obj));
                for Iobj=1:1:Nobj
                    [varargout{Iprop}(Iobj)] = isempty(Obj(Iobj).(Prop{Iprop}));
                end
            end
            
        end
        
        function [Nx, Ny] = sizeImage(Obj, Prop)
            % Return the size of images in AstroImage object
            % Input  : - An AstroImage object (multi elements supported).
            %          - A single propery name (char array)
            % Output : - Number of rows in each AstroImage element.
            %          - Number of columns in each AstroImage element.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI=AstroImage;
            %          [Ny, Nx] = AI.sizeImage
            %          [Ny, Nx] = AI.sizeImage('Back')
            
            arguments
                Obj
                Prop char       = 'Image';
            end
            
            Nobj = numel(Obj);
            Nx   = zeros(size(Obj));
            Ny   = zeros(size(Obj));
            for Iobj=1:1:Nobj
                [Ny, Nx] = size(Obj(Iobj).(Prop));
            end
            
        end
        
    end
    
    methods (Access=private)
        function [Obj2, Obj2IsCell] = prepOperand2(Obj1, Obj2)
            % Prepare the 2nd operand for binary operation
            
            % make sure Obj2 is in the right format
            if isnumeric(Obj2)
                % If Obj2 is an array with the same size as Obj1, then
                % convert into a cell array of scalars.
                %if all(size(Obj1)==size(Obj2))
                %    Obj2 = num2cell(Obj2);
                %else
                    % otherwise a single element cell
                    Obj2 = {Obj2};
                %end
            end
            % at this stage Obj2 must be a cell, AstroImage or an ImageComponent
            if iscell(Obj2)
                Obj2IsCell = true;
            else
                Obj2IsCell = false;
            end
            if isa(Obj2,'ImageComponent')
                Obj2IsCell = true;
                error('ImageComponent input is not yet supported');
                %Obj2       = convert ImageComponent to cell of images
            end
                
            if ~Obj2IsCell && ~isa(Obj2,'ImageComponent') && ~isa(Obj2,'AstroImage')
                error('Obj2 must be a cell, or AstroImage, or ImageComponent, or a numeric array');
            end
            
        end
    end
    
    
    methods % class conversion
        function varargout = astroImage2ImageComponent(Obj, Args)
            % Convert an AstroImage data into SciImage, BackImage, etc. objects.
            % Input  : - An AstroImage object (multiple elements supported)
            %          * ...,key,val,...
            %            'ReturnImageComponent' - A logical indicating if
            %                   to return an ImageComponent class, or the
            %                   native class of the data object (e.g.,
            %                   SciImage). Default is false.
            %            'CreateNewObj' - A logical indicating if to create
            %                   a new object. Default is false.
            %                   Note this parameter must be a logical and
            %                   it is independent of nargout.
            %            'DataProp' - A list of Data properties to copy.
            %                   Default is {'ImageData','BackData',
            %                   'VarData', 'MaskData'}.
            %                   The output are returned by this order.
            % Output : * An object per requested DataProp.
            %            By default, the first output arg is a SciImage
            %            object containing all the Images, etc.
            % Author : Eran Ofek (Apr 2021)
            % Example: [S,B] = astroImage2ImageComponent(AI)
            %          [S,B] = astroImage2ImageComponent(AstroImage([2 2]))
            %          [S,B] = astroImage2ImageComponent(AI,'CreateNewObj',true)
            %          [S,B] = astroImage2ImageComponent(AI,'CreateNewObj',true,'ReturnImageComponent',true)
            
            arguments
                Obj
                Args.ReturnImageComponent(1,1) logical  = false;
                Args.CreateNewObj(1,1) logical          = false;
                Args.DataProp                           = {'ImageData','BackData', 'VarData', 'MaskData'};
            end
            
            
            if ischar(Args.DataProp)
                Args.DataProp = {Args.DataProp};
            end
            
            if nargout>numel(Args.DataProp)
                error('Number of requested ImageComponent is larger than the number of elements in DataProp list');
            end
            
            Nobj = numel(Obj);
            
            varargout = cell(1,nargout);
            for Iout=1:1:nargout
                if Args.ReturnImageComponent
                    OutClass = @ImageComponent;
                else
                    OutClass = str2func(class(Obj(1).(Args.DataProp{Iout})));
                end
                varargout{Iout} = OutClass(size(Obj));
                for Iobj=1:1:Nobj
                    if Args.CreateNewObj
                        varargout{Iout}(Iobj) = Obj(Iobj).(Args.DataProp{Iout}).copyObject;
                    else
                        varargout{Iout}(Iobj) = Obj(Iobj).(Args.DataProp{Iout});
                    end
                end
            end
             
            
        end
        
        function Result = astroImage2AstroCatalog(Obj, Args)
            % Convert the CataData in AstroImage object into an AstroCatalog object array.
            % Input  : - An AstroImage object (multi components supported).
            %          * ...,key,val,...
            %            'CreateNewObj' - A logical indicating if to create
            %                   a new object or to provide and handle to
            %                   the existing object. Default is false.
            % Output : - An astroCatalog object.
            %            Note that if CreateNewObj=false then changes in
            %            this object will take place also in the original
            %            AstroImage object.
            % Author : Eran Ofek (Apr 2021)
            % Example: AC= astroImage2AstroCatalog(AI);
            %          AC= astroImage2AstroCatalog(AI,'CreateNewObj',true);
            
            arguments
                Obj
                Args.CreateNewObj(1,1) logical          = false;
            end
            
            Result = AstroCatalog(size(Obj));
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                if Args.CreateNewObj
                    Result(Iobj) = Obj(Iobj).CatData.copyObject;
                else
                    Result(Iobj) = Obj(Iobj).CatData;
                end
            end
        end
    end
    
    methods % functions on specific data properties
        
        
        function Result = funCat(Obj, Fun, varargin)
            % Apply function of Cat properties in AstroImage array
            % This function doesn't create a new object
            % Input  : - AstroImage object
            %          - An AstroCatalog function handle.
            %          * Additional arguments to pass to the function.
            % Output : * If no output argument is specified then this
            %            will modify the input object with the updated Cat.
            %            If output argument is specified then the output will be
            %            written to this output.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({rand(10,10), rand(10,10)});
            %          AI(1).CatData.Catalog=rand(10,2);
            %          AI(2).CatData.Catalog=rand(10,2);
            %          funCat(AI,@sortrows,1);
            
            Nobj = numel(Obj);
            if nargout==0
                Result = Obj;
            end
            for Iobj=1:1:Nobj
                if nargout>0
                    Result = Fun(Obj(Iobj).CatData, varargin{:});
                else
                    Fun(Result(Iobj).CatData, varargin{:});
                end
            end
            
        end
        
        function Result = funHeader(Obj, Fun, varargin)
            % Apply function of HeaderData properties in AstroImage array
            % This function doesn't create a new object
            % Input  : - AstroImage object
            %          - An AstroHeader function handle.
            %          * Additional arguments to pass to the function.
            % Output : * If no output argument is specified then this
            %            will modify the input object with the updated Header.
            %            If output argument is specified then the output will be
            %            written to this output.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({rand(10,10), rand(10,10)});
            %          funHeader(AI,@insertKey,{'GAIN',2,''});
            
            Nobj = numel(Obj);
            if nargout==0
                Result = Obj;
            end
            for Iobj=1:1:Nobj
                if nargout>0
                    Result(Iobj) = Fun(Obj(Iobj).HeaderData, varargin{:});
                else
                    Fun(Result(Iobj).HeaderData, varargin{:});
                end
            end
            
        end
        
        function Result = funWCS(Obj, Fun, ArgsToFun)
            % Apply function of WCS properties in AstroImage array
        end
        
        function Result = funPSF(Obj, Fun, ArgsToFun)
            % Apply function of PSF properties in AstroImage array
        end
        
        function Result = maskSet(Obj, Flag, BitName, SetVal, Args)
            % Set the value of a bit in a bit mask (Maskdata) in AstroImage
            % Input  : - An AsstroImage Object.
            %          - A matrix of logicals, with the same size as the
            %            Image in the MaskData.Image, in which values which are
            %            true will be set.
            %            Alternatively, this can be a vector of indices.
            %          - Bit name, or bit index (start from 0), to set.
            %          - Value to set (0 | 1). Default is 1.
            %          * ...,key,val,...
            %            'CreateNewObj' - Indicating if the output
            %                   is a new copy of the input (true), or an
            %                   handle of the input (false).
            %                   If empty (default), then this argument will
            %                   be set by the number of output args.
            %                   If 0, then false, otherwise true.
            %                   This means that IC.fun, will modify IC,
            %                   while IB=IC.fun will generate a new copy in
            %                   IB.
            % Output : - An AstroImage object.
            % Author : Eran Ofek (May 2021)
            % Example: AI = AstroImage({rand(3,3)},'Mask',{uint32(zeros(3,3))})
            %       AI.MaskData.Dict=BitDictionary('BitMask.Image.Default')
            %       Flag = false(3,3); Flag(1,2)=true;
            %       Result = AI.maskSet(Flag,'Saturated')
            %       Result = AI.maskSet(Flag,'Streak')
            
            arguments
                Obj
                Flag                         % matrix of logicals
                BitName                      % name or bit index (start with zero)
                SetVal                 = 1;
                Args.CreateNewObj      = [];
            end
            
            if isempty(Args.CreateNewObj)
                if nargout==0
                    Args.CreateNewObj = false;
                    Result = Obj;
                else
                    % create new obj
                    Args.CreateNewObj = true;
                    Result = Obj.copyObject;
                end
            else
                if Args.CreateNewObj
                    Result = Obj.copyObject;
                else
                    Result = Obj;
                end
            end
                    
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                Result.MaskData = maskSet(Result(Iobj).MaskData, Flag, BitName, SetVal, 'CreateNewObj', Args.CreateNewObj);
            end
         
        end
        
    end
    
    methods % specific header functions
        function Result = isImType(Obj, ImTypeVal, Args)
            % Check if header IMTYPE keyword value equal some type
            % Input  : - An AstroImage object.
            %          - IMTYPE type to check (e.g., 'bias').
            %          * ...,key,val,...
            %            'UseDict' - Indicating if to use dictionary or to
            %                   perform an exact search. Default is true.
            %            'CaseSens' - Default is true.
            %            'SearchAlgo' - ['strcmp'] | 'regexp'.
            %                   or 'last' match.
            %            'IsInputAlt' - If true, then the input keyword
            %                   will be assumed to be in the list of
            %                   alternate names. If false, then this must
            %                   be the primary key name in the dictionary.
            %                   For example, if you would like to search
            %                   by 'AEXPTIME' use true.
            %                   Default is false.
            %            'KeyDict' - An optional keyword dictionary (a s
            %                   tructure) that will override the object
            %                   dictionary.
            % Output : - An array of logicals (one per AstroImage element)
            %            indicating if the IMTYPE value equal the requested
            %            value.
            % Author : Eran Ofek (Apr 2021)
            % Example: H=AstroImage('*.fits');
            %          Ans = isImType(H, 'bias')
            
            arguments
                Obj
                ImTypeVal
                Args.ImTypeKeyName                                   = 'IMTYPE';
                Args.UseDict(1,1) logical                            = true;
                Args.CaseSens(1,1) logical                           = true;
                Args.SearchAlgo                                      = 'strcmp'; 
                Args.IsInputAlt(1,1) logical                         = true;
                Args.KeyDict                                         = [];
            end
            
            Nobj   = numel(Obj);
            Result = false(size(Obj));
            for Iobj=1:1:Nobj
                Result(Iobj) = isImType(Obj(Iobj).HeaderData, ImTypeVal, 'ImTypeKeyName',Args.ImTypeKeyName,...
                                                                         'UseDict',Args.UseDict,...
                                                                         'CaseSens',Args.CaseSens,...
                                                                         'SearchAlgo',Args.SearchAlgo,...
                                                                         'IsInputAlt',Args.IsInputAlt,...
                                                                         'KeyDict',Args.KeyDict);
            end
            
        end
        
        
    end
    
    methods % basic functionality: funUnary, funUnaryScalar, funBinary, funStack, funTransform
        
        function Result = funUnary(Obj, Operator, Args)
            % Apply an unary function on AstroImage object.
            %       This include applying the function  on specific data
            %       fields, and or image sections (CCDSEC), and error
            %       propagation.
            %       Note that error propgation is activated using the
            %       AstroImage.PropagateErr property (default is false).
            % Input  : - An AstroImage object (multi elements supported)
            %          - Operator (function_handle) (e.g., @sin)
            %          * ...,key,val,...
            %            'OpArgs' - A cell array of additional arguments to
            %                   pass to the operator. Default is {}.
            %            'PropagateErr' - If empty, will use the object
            %                   PropagateErr property. Otherwise will set
            %                   it using the new value. Default is [].
            %            'CreateNewObj' - Logical indicating if the output
            %                   is a new copy of the input (true), or an
            %                   handle of the input (false)
            %                   Default is false (i.e., input object will
            %                   be modified).
            %            'CCDSEC' - CCDSEC on which to operate:
            %                   [Xmin, Xmax, Ymin, Ymax].
            %                   Use [] for the entire image.
            %                   If not [], then DataPropIn/Out will be
            %                   modified to 'Image'.
            %            'OutOnlyCCDSEC' - A logical indicating if the
            %                   output include only the CCDSEC region, or
            %                   it is the full image (where the opeartor,
            %                   operated only on the CCDSEC region).
            %                   Default is true.
            %            'CalcImage' - A logical indicating if to apply the
            %                   operator to the Image field.
            %                   Default is true.
            %            'CalcVar' - A logical indicating if to apply the
            %                   operator to the Var field.
            %                   Default is true.
            %            'CalcBack' - A logical indicating if to apply the
            %                   operator to the Back field.
            %                   Default is true.
            %            'ReturnBack' - A logical indicating if to return
            %                   the background to the image before applying
            %                   the operator. Default is true.
            %            'ReRemoveBack' - A logical indicating if to remove
            %                   the background from the image after
            %                   applying the operator (relevant only if the
            %                   SciImage.IsBackSubtracted=true).
            %                   Default is true.
            %            'UpdateHeader' - A logical indicating if to update
            %                   the header of the output image.
            %                   Default is true.
            %            'AddHistory' - A logical indicating if to add an
            %                   HISTORY line in the header specifying the
            %                   operation. Default is true.
            %            'NewUnits' - If empty do nothing. If provided will
            %                   put this value in the header 'UNITS' key.
            %                   Default is [].
            %            'InsertKeys' - A cell array of 3 columns cell
            %                   array {key,val,comment}, to insert to the
            %                   header. Default is {}.
            %            'ReplaceKeys' - A cell array of keywords to
            %                   replace. Default is {}.
            %            'ReplaceVals' - A cell array of keywords values to
            %                   replace (corresponding top ReplaceKeys).
            %                   Default is {}.
            %            'replaceValArgs' - A cell array of additional
            %                   arguments to pass to the replaceVal function.
            %                   Default is {}.
            %            'insertKeyArgs' - A cell array of additional
            %                   arguments to pass to the insertKey function.
            %                   Default is {}.
            %            'DeleteCat' - A logical indicating if to delete
            %                   the catalog data. Default is false.
            %            'ImCompDataPropIn' - Data property in the
            %                   ImageComponent on which the operator
            %                   will be operated. Default is 'Data'.
            %            'ImCompDataPropOut' - Data property in the
            %                   ImageComponent in which the output
            %                   will be stored. Default is 'Data'.
            % Output : - An AstroImage object with the operator applied on
            %            the data.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({10.*ones(10,10)},'Back',{ones(5,5)},'BackScale',2,'var',{ones(5,5)},'VarScale',2);
            %          B=AI.funUnary(@sin,'CreateNewObj',true)
            %          B=AI.funUnary(@mean,'OpArgs',{'all'}) 
            %          AI.PropagateErr=true; B=AI.funUnary(@mean,'OpArgs',{'all'})
            %          B=AI.funUnary(@median,'OpArgs',{'all'}); % must result in error
            %          B=AI.funUnary(@median,'OpArgs',{'all'},'PropagateErr',false,'OperateOnVar',true) 
            
            arguments
                Obj
                Operator function_handle
                Args.OpArgs cell                = {};
                Args.PropagateErr               = []; % empty, false or true - if not empty, set PropagateErr property.
                Args.OperateOnVar(1,1) logical  = true;  % only if PropagateErr=false
                
                Args.CreateNewObj(1,1) logical  = false;
                Args.CCDSEC                     = [];
                Args.OutOnlyCCDSEC(1,1) logical = true;
                
                Args.CalcImage(1,1) logical     = true;
                Args.CalcVar(1,1) logical       = true;
                Args.CalcBack(1,1) logical      = true;
                Args.ReturnBack(1,1) logical    = true;
                Args.ReRemoveBack(1,1) logical  = true;
                
                Args.UpdateHeader(1,1) logical  = true;
                Args.AddHistory(1,1) logical    = true;
                Args.NewUnits                   = []; % if empty don't change
                Args.InsertKeys                 = {};
                Args.ReplaceKeys                = {};
                Args.ReplaceVals                = {};
                Args.replaceValArgs             = {};
                Args.insertKeyArgs              = {};
               
                Args.DeleteCat(1,1) logical     = false;
                
%                 Args.DataPropIn                 = {'Image','Back','Var'};  % should not operate on Mask
%                 Args.DataPropOut                = {};
                Args.ImCompDataPropIn           = 'Image';   % don't change unless you understand
                Args.ImCompDataPropOut          = 'Image';   % don't change unless you understand
            end
        
            
            if ~isempty(Args.PropagateErr)
                [Obj(1:1:numel(Obj)).PropagateErr] = deal(Args.PropagateErr);
            end
            
%             if isempty(Args.DataPropOut)
%                 Args.DataPropOut = Args.DataPropIn;
%             end
%             % translate all the requested property names to "Data"
%             % properties
%             Args.DataPropIn  = translateDataPropName(Obj(1), Args.DataPropIn);
%             Args.DataPropOut = translateDataPropName(Obj(1), Args.DataPropOut);
            
            
            if Args.CreateNewObj
                Result = Obj.copyObject;
            else
                Result = Obj;
            end
            
            Nobj  = numel(Obj);
            for Iobj=1:1:Nobj
                
                VarMat = Obj(Iobj).VarData.(Args.ImCompDataPropIn);
                
                % return background to image if needed
                if Args.ReturnBack && Obj(Iobj).ImageData.IsBackSubtracted && ~isempty(Obj(Iobj).BackData.(Args.ImCompDataPropIn))
                    ImageMat = Obj(Iobj).ImageData.(Args.ImCompDataPropIn) + Obj(Iobj).BackData.(Args.ImCompDataPropIn);
                    RetBack  = true;
                else
                    ImageMat = Obj(Iobj).ImageData.(Args.ImCompDataPropIn);
                    RetBack  = false;
                end
                    
               [ResultFun,ResultVar,Flag,FunH] = imUtil.image.fun_unary_withVariance(Operator, ImageMat,...
                                                                                       VarMat,...
                                                                                       'OpArgs',Args.OpArgs,...
                                                                                       'CCDSEC',Args.CCDSEC,...
                                                                                       'OutOnlyCCDSEC',Args.OutOnlyCCDSEC,...
                                                                                       'OperateOnVar',Args.OperateOnVar,...
                                                                                       'PropagateErr',Obj(Iobj).PropagateErr && Args.CalcVar);
                
                if Args.CalcImage                                                                 
                    if RetBack && Args.ReRemoveBack
                        % remove background from image
                        ResultFun = ResultFun - Obj(Iobj).BackData.(Args.ImCompDataPropIn);
                        Obj(Iobj).ImageData.IsBackSubtracted = true;
                    else
                        Obj(Iobj).ImageData.IsBackSubtracted = false;
                    end
                    Result(Iobj).ImageData.(Args.ImCompDataPropOut) = ResultFun;
                end
                
                if Args.CalcVar
                    Result(Iobj).VarData.(Args.ImCompDataPropOut) = ResultVar;
                end
                if Args.CalcBack && ~isempty(Result(Iobj).Back)
                    % use funUnary of ImageComponent
                    Result(Iobj).BackData = funUnary(Result(Iobj).BackData, Operator, 'OpArgs',Args.OpArgs,...
                                                                                      'CreateNewObj',Args.CreateNewObj,...
                                                                                      'CCDSEC',Args.CCDSEC,...
                                                                                      'OutOnlyCCDSEC',Args.OutOnlyCCDSEC,...
                                                                                      'DataPropIn',Args.ImCompDataPropIn,...
                                                                                      'DataPropOut',Args.ImCompDataPropOut);
                end
                
                % update Header
                Result(Iobj).HeaderData = funUnary(Result(Iobj).HeaderData, Operator, 'OpArgs',Args.OpArgs,...
                                                                                      'UpdateHeader',Args.UpdateHeader,...                                                                        
                                                                                      'AddHistory',Args.AddHistory,...
                                                                                      'NewUnits',Args.NewUnits,...
                                                                                      'InsertKeys',Args.InsertKeys,...
                                                                                      'ReplaceKeys',Args.ReplaceKeys,...
                                                                                      'ReplaceVals',Args.ReplaceVals,...
                                                                                      'CreateNewObj',false,...
                                                                                      'replaceValArgs',Args.replaceValArgs,...
                                                                                      'insertKeyArgs',Args.insertKeyArgs);
                                                                                  
                
                
                if Args.DeleteCat
                    Obj(Iobj).CatData.deleteCatalog;
                end
                
                % Do not modify: PSF, WCS
                
                
            end
            
        
        end
            
        function varargout = funUnaryScalar(Obj, Operator, Args)
            % Apply a unary operator that return scalar on AstroImage and return an numeric array
            % Input  : - An AstroImage object (multi elements supported)
            %          - Operator (a function handle, e.g., @mean).
            %          * ...,key,val,...
            %            'OpArgs' - A cell array of additional arguments to
            %                   pass to the operator. Default is {}.
            %            'CCDSEC' - CCDSEC on which to operate:
            %                   [Xmin, Xmax, Ymin, Ymax].
            %                   Use [] for the entire image.
            %                   If not [], then DataPropIn/Out will be
            %                   modified to 'Image'.
            %            'DataProp' - A cell array of AstroImage data
            %                   properties on which the operator will operated.
            %                   Default is
            %                   {'ImageData','BackData','VarData','MaskData'}.
            %            'DataPropIn' - Data property in the ImageComponent 
            %                   on which the operator
            %                   will be operated. Default is 'Data'.
            % Output : - An array in which each element corresponds to the operator applied
            %            to an element in the ImageComponent object.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({randn(100,100), randn(100,100)},'Back',{randn(100,100), randn(100,100)});
            %          [A,B] = funUnaryScalar(AI, @mean, 'OpArgs',{'all'})
            %          [A,B] = funUnaryScalar(AI, @std, 'OpArgs',{[],'all'})
            
            arguments
                Obj
                Operator function_handle
                Args.OpArgs cell                = {};
                Args.CCDSEC                     = [];
                Args.DataProp                   = {'ImageData','BackData','VarData','MaskData'};
                Args.DataPropIn                 = 'Data';
            end    
            
            % Convert AstroImage to (up to 4) ImageComponent objects
            % CellIC is a cell array of ImageComponent objects
            [CellIC{1:1:nargout}] = astroImage2ImageComponent(Obj, 'CreateNewObj',false, 'ReturnImageComponent',false, 'DataProp',Args.DataProp);
            
            Nic = numel(CellIC); % Number of output arguments
            varargout = cell(1,Nic);
            for Iic=1:1:Nic
                Nim = numel(CellIC{Iic}); % number of images in each output arg
                varargout{Iic} = CellIC{Iic}.funUnaryScalar(Operator, 'OpArgs',Args.OpArgs, 'CCDSEC',Args.CCDSEC, 'DataPropIn',Args.DataPropIn{Iic});
            end
        end
                
        function Result = funBinaryProp(Obj1, Obj2, Operator, Args)
            % Apply binary function on a single property of AstroImage
            %       without error propagation.
            % Input  : - 1st operand - An AstroImage object.
            %          - 2nd operand - An AstroImage object or a
            %            cell array of matrices, or an array of numbers.
            %            If a cell array each element of the cell array
            %            will be treated as the 2nd operand image.
            %            If a vector than this will be treated as a single
            %            image.
            %          - Operator (a function handle). E.g., @plus.
            %          * ...,key,val,...
            %            'OpArgs' - A cell array of additional arguments to
            %                   pass to the operator. Default is {}.
            %            'CreateNewObj' - Indicating if the output
            %                   is a new copy of the input (true), or an
            %                   handle of the input (false).
            %                   If empty (default), then this argument will
            %                   be set by the number of output args.
            %                   If 0, then false, otherwise true.
            %                   This means that IC.fun, will modify IC,
            %                   while IB=IC.fun will generate a new copy in
            %                   IB.
            %            'CCDSEC1' - [Xmin Xmax Ymin Ymax] CCDSEC for the
            %                   1st oprand. The Operator will be applied
            %                   only on this section.
            %                   If empty, use all image. Default is [].
            %            'CCDSEC2' - The same as CCDSEC1, but for the 2nd
            %                   operand. Default is [].
            %            'CCDSEC' - The CCDSEC in the output image. Must be
            %                   of the same size as CCDSEC1 and CCDSEC2.
            %            'DataProp' - Data property on which to operate.
            %                   Default is 'ImageData'.
            %            'DataPropIn' - Data property of the ImageComponent
            %                   on which to operate. Default is 'Data'.
            %            'UseOrForMask' - A logical indicating if to use
            %                   the @bitor operator instead of the input operator
            %                   if the requested data property is
            %                   'MaskImage'. Default is true.
            %            'Result' - An AstroImage object in which the
            %                   results will be written. If empty, then use
            %                   the CreateNewObj scheme.
            %                   Default is [].
            % Output : - An AstroImage object.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI=AstroImage({ones(3,3)});
            %          Res = funBinaryProp(AI,3,@plus);
            %          Res = funBinaryProp(AI,[3 2 1 2],@plus);
            %          Res = funBinaryProp(AI,{2 1},@plus);
            %          Res = funBinaryProp(AI,AI,@minus)
           
            arguments
                Obj1
                Obj2
                Operator function_handle
                Args.OpArgs                    = {};
                Args.DataProp                  = 'ImageData';
                Args.DataPropIn                = 'Data';
                Args.CCDSEC                    = [];
                Args.CCDSEC1                   = [];
                Args.CCDSEC2                   = [];
                Args.UseOrForMask(1,1) logical = true;
                Args.CreateNewObj              = [];
                Args.Result                    = [];
            end
            
            if isempty(Args.Result)
                if isempty(Args.CreateNewObj)
                    if nargout>0
                        Args.CreateNewObj = true;
                    else
                        Args.CreateNewObj = false;
                    end
                end
            
                if Args.CreateNewObj
                    Result = Obj1.copyObject;
                else
                    Result = Obj1;
                end
            else
                Result = Args.Result;
            end
            
            % convert Obj2 to a cell array of images or keep as AstroImage
            [Obj2, Obj2IsCell] = prepOperand2(Obj1, Obj2);
            
            Nobj1 = numel(Obj1);
            Nobj2 = numel(Obj2);
            Nres = max(Nobj1, Nobj2);
            for Ires=1:1:Nres
                Iobj1 = min(Ires, Nobj1);
                Iobj2 = min(Ires, Nobj2);
                
                if isempty(Args.CCDSEC1)
                    Tmp1 = Obj1(Iobj1).(Args.DataProp).(Args.DataPropIn);
                else
                    Tmp1 = Obj1(Iobj1).(Args.DataProp).(Args.DataPropIn)(Args.CCDSEC1(3):Args.CCDSEC1(4), Args.CCDSEC1(1):Args.CCDSEC1(2));
                end
                
                if isempty(Args.CCDSEC2)
                    if Obj2IsCell
                        Tmp2 = Obj2{Iobj2};
                    else
                        Tmp2 = Obj2(Iobj2).(Args.DataProp).(Args.DataPropIn);
                    end
                else
                    if Obj2IsCell
                        Tmp2 = Obj2{Iobj2}(Args.CCDSEC2(3):Args.CCDSEC2(4), Args.CCDSEC2(1):Args.CCDSEC2(2));
                    else
                        Tmp2 = Obj2(Iobj2).(Args.DataProp).(Args.DataPropIn)(Args.CCDSEC2(3):Args.CCDSEC2(4), Args.CCDSEC2(1):Args.CCDSEC2(2));
                    end
                end
                
                % make sure Tmp1 and Tmp2 are not empty
                if isempty(Tmp1) && ~isempty(Tmp2)
                    Tmp1 = 0;
                end
                if isempty(Tmp2) && ~isempty(Tmp1)
                    Tmp2 = 0;
                end
            
                if isa(Obj1(Iobj1).(Args.DataProp),'MaskImage') && Args.UseOrForMask
                    if isempty(Args.CCDSEC)
                        Result(Ires).(Args.DataProp).(Args.DataPropIn) = bitor(Tmp1, Tmp2);
                    else
                        Result(Ires).(Args.DataProp).(Args.DataPropIn)(Args.CCDSEC(3):Args.CCDSEC(4), Args.CCDSEC(1):Args.CCDSEC(2)) = bitor(Tmp1, Tmp2);
                    end
                else
                    if isempty(Args.CCDSEC)
                        Result(Ires).(Args.DataProp).(Args.DataPropIn) = Operator(Tmp1, Tmp2, Args.OpArgs{:});
                    else
                        Result(Ires).(Args.DataProp).(Args.DataPropIn)(Args.CCDSEC(3):Args.CCDSEC(4), Args.CCDSEC(1):Args.CCDSEC(2)) = perator(Tmp1, Tmp2, Args.OpArgs{:});
                    end
                end
                
            
            end
            
        end
        
        function Result = funBinaryImVar(Obj1, Obj2, Operator, Args)
            % Apply a binary operator with error propagation to the
            % ImageData and VarData in an AstroImage object.
            % Input  : - 1st operand - An AstroImage object.
            %          - 2nd operand - An AstroImage object or a
            %            cell array of matrices, or an array of numbers.
            %            If a cell array each element of the cell array
            %            will be treated as the 2nd operand image.
            %            If a vector than this will be treated as a single
            %            image.
            %          - Operator (a function handle). E.g., @plus.
            %          * ...,key,val,...
            %            'OpArgs' - A cell array of additional arguments to
            %                   pass to the operator. Default is {}.
            %            'CreateNewObj' - Indicating if the output
            %                   is a new copy of the input (true), or an
            %                   handle of the input (false).
            %                   If empty (default), then this argument will
            %                   be set by the number of output args.
            %                   If 0, then false, otherwise true.
            %                   This means that IC.fun, will modify IC,
            %                   while IB=IC.fun will generate a new copy in
            %                   IB.
            %            'CCDSEC1' - [Xmin Xmax Ymin Ymax] CCDSEC for the
            %                   1st oprand. The Operator will be applied
            %                   only on this section.
            %                   If empty, use all image. Default is [].
            %            'CCDSEC2' - The same as CCDSEC1, but for the 2nd
            %                   operand. Default is [].
            %            'CCDSEC' - The CCDSEC in the output image. Must be
            %                   of the same size as CCDSEC1 and CCDSEC2.
            %            'DataPropIn' - Data property of the ImageComponent
            %                   on which to operate. Default is 'Data'.
            %            'Result' - An AstroImage object in which the
            %                   results will be written. If empty, then use
            %                   the CreateNewObj scheme.
            %                   Default is [].
            % Output : - An AstroImage object.
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({ones(3,3)},'Var',{ones(3,3)})
            %          Res = funBinaryImVar(AI,AI,@plus);
            %          Res = funBinaryImVar(AI,AI,@minus);
            %          Res = funBinaryImVar(AI,3,@times);
            
            arguments
                Obj1
                Obj2
                Operator function_handle
                Args.OpArgs                    = {};
                Args.DataPropIn                = 'Data';
                Args.CCDSEC                    = [];
                Args.CCDSEC1                   = [];
                Args.CCDSEC2                   = [];
                Args.CreateNewObj              = [];
                Args.Result                    = [];
            end
            
            DataPropImage  = 'ImageData';
            DataPropVar    = 'VarData';
            
            if isempty(Args.Result)
                if isempty(Args.CreateNewObj)
                    if nargout>0
                        Args.CreateNewObj = true;
                    else
                        Args.CreateNewObj = false;
                    end
                end
            
                if Args.CreateNewObj
                    Result = Obj1.copyObject;
                else
                    Result = Obj1;
                end
            else
                Result = Args.Result;
            end
            
            % convert Obj2 to a cell array of images or keep as AstroImage
            [Obj2, Obj2IsCell] = prepOperand2(Obj1, Obj2);
            
            Nobj1 = numel(Obj1);
            Nobj2 = numel(Obj2);
            Nres = max(Nobj1, Nobj2);
            for Ires=1:1:Nres
                Iobj1 = min(Ires, Nobj1);
                Iobj2 = min(Ires, Nobj2);
                
                if isempty(Args.CCDSEC1)
                    TmpImage1 = Obj1(Iobj1).(DataPropImage).(Args.DataPropIn);
                    TmpVar1   = Obj1(Iobj1).(DataPropVar).(Args.DataPropIn);
                else
                    TmpImage1 = Obj1(Iobj1).(DataPropImage).(Args.DataPropIn)(Args.CCDSEC1(3):Args.CCDSEC1(4), Args.CCDSEC1(1):Args.CCDSEC1(2));
                    TmpVar1   = Obj1(Iobj1).(DataPropVar).(Args.DataPropIn)(Args.CCDSEC1(3):Args.CCDSEC1(4), Args.CCDSEC1(1):Args.CCDSEC1(2));
                end
                
                if isempty(Args.CCDSEC2)
                    if Obj2IsCell
                        TmpImage2 = Obj2{Iobj2};
                        TmpVar2   = [];
                    else
                        TmpImage2 = Obj2(Iobj2).(DataPropImage).(Args.DataPropIn);
                        TmpVar2   = Obj2(Iobj2).(DataPropVar).(Args.DataPropIn);
                    end
                else
                    if Obj2IsCell
                        TmpImage2 = Obj2{Iobj2}(Args.CCDSEC2(3):Args.CCDSEC2(4), Args.CCDSEC2(1):Args.CCDSEC2(2));
                        TmpVar2   = [];
                    else
                        TmpImage2 = Obj2(Iobj2).(DataPropImage).(Args.DataPropIn)(Args.CCDSEC2(3):Args.CCDSEC2(4), Args.CCDSEC2(1):Args.CCDSEC2(2));
                        TmpVar2   = Obj2(Iobj2).(DataPropVar).(Args.DataPropIn)(Args.CCDSEC2(3):Args.CCDSEC2(4), Args.CCDSEC2(1):Args.CCDSEC2(2));
                    end
                end
                
                if isempty(Args.CCDSEC)
                    [Result(Ires).(DataPropImage).(Args.DataPropIn)  ,Result(Ires).(DataPropVar).(Args.DataPropIn)] = ...
                                imUtil.image.fun_binary_withVariance(Operator, TmpImage1, TmpImage2, TmpVar1, TmpVar2, 0, Args.OpArgs);
                else
                    [Result(Ires).(DataPropImage).(Args.DataPropIn)(Args.CCDSEC(3):Args.CCDSEC(4), Args.CCDSEC(1):Args.CCDSEC(2))  ,...
                     Result(Ires).(DataPropVar).(Args.DataPropIn)(Args.CCDSEC(3):Args.CCDSEC(4), Args.CCDSEC(1):Args.CCDSEC(2))] = ...
                            imUtil.image.fun_binary_withVariance(Operator, TmpImage1, TmpImage2, TmpVar1, TmpVar2, 0, Args.OpArgs);
                end

                
            end
            
        end
                
        function Result = funBinary(Obj1, Obj2, Operator, Args)
            % Apply a binary operator to AstroImage
            % Input  : - 1st operand - An AstroImage object.
            %          - 2nd operand - An AstroImage object or a
            %            cell array of matrices, or an array of numbers.
            %            If a cell array each element of the cell array
            %            will be treated as the 2nd operand image.
            %            If a vector than this will be treated as a single
            %            image.
            %          - Operator (a function handle). E.g., @plus.
            %          * ...,key,val,...
            %            'OpArgs' - A cell array of additional arguments to
            %                   pass to the operator. Default is {}.
            %            'CalcImage' - A logical that state if to apply the
            %                   operator to the ImageData property.
            %                   Default is true.
            %            'CalcBack' - A logical that state if to apply the
            %                   operator to the BackData property.
            %                   Default is true.
            %            'CalcVar' - A logical that state if to apply the
            %                   operator to the VarData property.
            %                   Default is true.
            %            'CalcMask' - A logical that state if to apply the
            %                   operator to the MaskData property.
            %                   Default is true.
            %            'CalcPSF' - A logical that state if to apply the
            %                   operator to the PSF property.
            %                   Default is true.
            %            'PropagateErr' - A logical stating if to apply
            %                   error propagation. If empty, then use the
            %                   object PropagateErr property. Default is
            %                   [].
            %                   NOTE THAT the first element state dicatates
            %                   all the rest.
            %            'DeleteCat' - A logical indicating if to delete
            %                   the catalog data. Default is false.
            %            'UpdateHeader' - a logical indicating if to update
            %                   the header. Default is true.
            %            'DataPropIn' - Data property of the ImageComponent
            %                   on which to operate. Default is 'Data'.
            %            'CCDSEC1' - [Xmin Xmax Ymin Ymax] CCDSEC for the
            %                   1st oprand. The Operator will be applied
            %                   only on this section.
            %                   If empty, use all image. Default is [].
            %            'CCDSEC2' - The same as CCDSEC1, but for the 2nd
            %                   operand. Default is [].
            %            'CCDSEC' - The CCDSEC in the output image. Must be
            %                   of the same size as CCDSEC1 and CCDSEC2.
            %            'UseOrForMask' - A logical indicating if to use
            %                   the @bitor operator instead of the input operator
            %                   if the requested data property is
            %                   'MaskImage'. Default is true.
            %            'CreateNewObj' - Indicating if the output
            %                   is a new copy of the input (true), or an
            %                   handle of the input (false).
            %                   If empty (default), then this argument will
            %                   be set by the number of output args.
            %                   If 0, then false, otherwise true.
            %                   This means that IC.fun, will modify IC,
            %                   while IB=IC.fun will generate a new copy in
            %                   IB.
            %            'Result' - An AstroImage object in which the
            %                   results will be written. If empty, then use
            %                   the CreateNewObj scheme.
            %                   Default is [].
            % Output : An AstroImage object
            % Author : Eran Ofek (Apr 2021)
            % Example: AI = AstroImage({ones(3,3)});
            %          Result = funBinary(AI,3,@plus)
            %          AI = AstroImage({3.*ones(3,3)}, 'Back',{ones(3,3)}, 'Var',{3.*ones(3,3)});
            %          Result = funBinary(AI,3,@plus)
            %          Result = funBinary(AI,3,@plus,'PropagateErr',true)
            
            arguments
                Obj1
                Obj2
                Operator function_handle
                Args.OpArgs                    = {};
                Args.CalcImage(1,1) logical    = true;
                Args.CalcBack(1,1) logical     = true;
                Args.CalcVar(1,1) logical      = true;
                Args.CalcMask(1,1) logical     = true;
                Args.CalcPSF(1,1) logical      = false;
                Args.PropagateErr              = [];
                Args.DeleteCat(1,1) logical    = false;
                Args.UpdateHeader(1,1) logical = true;
                Args.DataPropIn                = 'Data';
                Args.CCDSEC                    = [];
                Args.CCDSEC1                   = [];
                Args.CCDSEC2                   = [];
                Args.UseOrForMask(1,1) logical = true;
                Args.CreateNewObj              = [];
                Args.Result                    = [];
            end
            
            if isempty(Args.Result)
                if isempty(Args.CreateNewObj)
                    if nargout>0
                        Args.CreateNewObj = true;
                    else
                        Args.CreateNewObj = false;
                    end
                end
            
                if Args.CreateNewObj
                    Result = Obj1.copyObject;
                else
                    Result = Obj1;
                end
            else
                Result = Args.Result;
            end
            
            if ~isempty(Args.PropagateErr)
                [Obj1(1:1:numel(Obj1)).PropagateErr] = deal(Args.PropagateErr);
            end
            
            % Use PropagateErr from Obj1(1) only
            if Obj1(1).PropagateErr
                if Args.CalcImage || Args.CalcVar
                    % propagate errors Image/Var
                    Result = funBinaryImVar(Obj1, Obj2, Operator, 'OpArgs',Args.OpArgs,...
                                                                  'DataPropIn',Args.DataPropIn,...
                                                                  'CCDSEC',Args.CCDSEC,...
                                                                  'CCDSEC1',Args.CCDSEC1,...
                                                                  'CCDSEC2',Args.CCDSEC2,...
                                                                  'CreateNewObj',Args.CreateNewObj,...
                                                                  'Result',Result);
                end
            else
                if Args.CalcImage 
                    Result = funBinaryProp(Obj1, Obj2, Operator, 'OpArgs',Args.OpArgs,...
                                                                 'DataProp','ImageData',...
                                                                 'DataPropIn',Args.DataPropIn,...
                                                                 'CCDSEC',Args.CCDSEC,...
                                                                 'CCDSEC1',Args.CCDSEC1,...
                                                                 'CCDSEC2',Args.CCDSEC2,...
                                                                 'CreateNewObj',Args.CreateNewObj,...
                                                                 'UseOrForMask',Args.UseOrForMask,...
                                                                 'Result',Result);
                end
                if Args.CalcVar
                    Result = funBinaryProp(Obj1, Obj2, Operator, 'OpArgs',Args.OpArgs,...
                                                                 'DataProp','VarData',...
                                                                 'DataPropIn',Args.DataPropIn,...
                                                                 'CCDSEC',Args.CCDSEC,...
                                                                 'CCDSEC1',Args.CCDSEC1,...
                                                                 'CCDSEC2',Args.CCDSEC2,...
                                                                 'CreateNewObj',Args.CreateNewObj,...
                                                                 'UseOrForMask',Args.UseOrForMask,...
                                                                 'Result',Result);
                end
            end
               
            if Args.CalcBack
                Result = funBinaryProp(Obj1, Obj2, Operator, 'OpArgs',Args.OpArgs,...
                                                                 'DataProp','BackData',...
                                                                 'DataPropIn',Args.DataPropIn,...
                                                                 'CCDSEC',Args.CCDSEC,...
                                                                 'CCDSEC1',Args.CCDSEC1,...
                                                                 'CCDSEC2',Args.CCDSEC2,...
                                                                 'CreateNewObj',Args.CreateNewObj,...
                                                                 'UseOrForMask',Args.UseOrForMask,...
                                                                 'Result',Result);
            end
            if Args.CalcMask
                Result = funBinaryProp(Obj1, Obj2, Operator, 'OpArgs',Args.OpArgs,...
                                                                 'DataProp','MaskData',...
                                                                 'DataPropIn',Args.DataPropIn,...
                                                                 'CCDSEC',Args.CCDSEC,...
                                                                 'CCDSEC1',Args.CCDSEC1,...
                                                                 'CCDSEC2',Args.CCDSEC2,...
                                                                 'CreateNewObj',Args.CreateNewObj,...
                                                                 'UseOrForMask',Args.UseOrForMask,...
                                                                 'Result',Result);
            end
                
            if Args.CalcPSF
                error('PSF funBinary is not implemented yet');
            end
            
            if Args.DeleteCat
                Result.deleteCatalog;
            end
            
            % header
            if Args.UpdateHeader
                Nres = numel(Result);
                for Ires=1:1:Nres
                    funUnary(Result(Ires).HeaderData, Operator, 'OpArgs',Args.OpArgs, 'UpdateHeader',Args.UpdateHeader);
                end
            end
            
            
        end
        
        function varargout = images2cube(Obj, Args)
            % Convert the images in AstroImage object into a cube.
            %       Each data property (e.g., 'ImageData', 'BackData')
            %       produce a cube.
            % Input  : - An array of AstroImage objects.
            %          * ...,key,val,...
            %            'CCDSEC' - A 4 column matrix of CCDSEC of each
            %                   image in ImageComponent to insert into the
            %                   cube [Xmin, Xmax, Ymin, Ymax].
            %                   If single line, then use the same CCDSEC
            %                   for all images. If empty, use entore image.
            %                   Default is [].
            %            'DataPropIn' - Data property, in ImageComponent,
            %                   from which to take
            %                   the image. Default is 'Image'.
            %            'DimIndex' - Cube dimension of the image index.
            %                   Either 1 or 3. Default is 3.
            %            'DataProp' - The data properties for which the
            %                   cubes will be calculated.
            %                   Default is {'ImageData','BackData',
            %                   'VarData', 'MaskData'}.
            % Output : * A cube for each DataProp, by the order of their
            %            appearnce in DataProp.
            % Author : Eran Ofek (Apr 2021)
            % Notes  : Doing this operation directly (without
            %       astroImage2ImageComponent) will be only a few percents
            %       faster.
            % Example: AI = AstroImage({rand(1000,1000), rand(1000,1000), rand(1000,1000)})
            %          [CubeImage, CubeBack] = images2cube(AI)
            %          [CubeImage] = images2cube(AI,'CCDSEC',[1 2 2 5])
            
            arguments
                Obj
                Args.CCDSEC                        = [];
                Args.DataPropIn                    = 'Image';
                Args.DimIndex                      = 3;
                Args.DataProp                      = {'ImageData','BackData', 'VarData', 'MaskData'};
            end
            
            [Out{1:nargout}] = astroImage2ImageComponent(Obj, 'CreateNewObj',false,...
                                                'ReturnImageComponent',false,...
                                                'DataProp',Args.DataProp);
            
            varargout = cell(1,nargout);
            for Iarg=1:1:nargout          
                varargout{Iarg} = images2cube(Out{Iarg}, 'CCDSEC',Args.CCDSEC,...
                                                         'DataPropIn',Args.DataPropIn,...
                                                         'DimIndex',Args.DimIndex);
            end

        end

        function [CutoutCube, ActualXY] = cutouts(Obj, XY, Args)
            % Break a single image to a cube of cutouts around given positions
            %       including optional sub pixel shift.
            %       Uses ImageComponent/cutouts.
            % Input  : - A single element AstroImage object.
            %          - A two column matrix of [X, Y] positions around
            %            which to generate the cutouts.
            %          * ...,key,val,...
            %            'HalfSize' - Cutout half size (actual size will be
            %                   1+2*HalfSize. Default is 8.
            %            'PadVal' - padding value for cutouts near edge or
            %                   without circular shifts.
            %            'CutAlgo' - Algorithm: ['mex'] | 'wmat'.            
            %            'IsCircle' - If true then will pad each cutout
            %                   with NaN outside the HalfSize radius.
            %                   Default is false.
            %            'Shift' - A logical indicating if to shift
            %            'ShiftAlgo' - Shift algorithm ['lanczos3'] |
            %                   'lanczos2' | 'fft'.
            %            'IsCircFilt' - While using lanczos, is circshift
            %                   is circular or not. Default is false.
            %            'DataPropIC' - Data property inside ImageComponent,
            %                   from which to extract
            %                   the cutouts. Default is 'Image'.
            %            'DataProp' - Data property from which to extract
            %                   the cutouts. Default is 'ImageData'.
            % Outout : - A cube of size 1+2*HalfSize X 1+2*HalfSize X
            %               numberOfCutouts. each layer contain a cutout
            %               and 3rd dim is for cutout index.
            %          - A two column matrix of the actual positions
            %            [X,Y], around which the cutouts are extracted.
            %            These may be rounded if 'RoundPos' is set to true.
            % Author : Eran Ofek (Apr 2021)
            % Example: IC = ImageComponent({rand(1000,1000)});
            
            % Example: AI=AstroImage({rand(1000,1000)});
            %          XY = rand(10000,2).*900 + 50;
            %          Cube = cutouts(AI, XY);
            %          Cube = cutouts(AI, XY,'Shift',true);
            %          Cube = cutouts(AI, XY,'Shift',true,'IsCircFilt',true);
            arguments
                Obj(1,1)
                XY(:,2)                     = zeros(0,2);
                Args.DataProp               = 'ImageData';
                Args.DataPropIC             = 'Image';
                Args.HalfSize               = 8;
                Args.PadVal                 = NaN;
                Args.CutAlgo                = 'mex';  % 'mex' | 'wmat'
                Args.IsCircle               = false;
                Args.Shift(1,1) logical     = false;
                Args.ShiftAlgo              = 'lanczos3';  % 'fft' | 'lanczos2' | 'lanczos3' | ...
                Args.IsCircFilt(1,1) logical = true;
            end
            
            [CutoutCube, ActualXY] = cutouts(Obj.(Args.DataProp), XY, 'DataProp',Args.DataPropIC,...
                                                     'HalfSize',Args.HalfSize,...
                                                     'PadVal',Args.PadVal,...
                                                     'CutAlgo',Args.CutAlgo,...
                                                     'IsCircle',Args.IsCircle,...
                                                     'Shift',Args.Shift,...
                                                     'ShiftAlgo',Args.ShiftAlgo,...
                                                     'IsCircFilt',Args.IsCircFilt);
            
        end
        
        % function crop(Obj, CCDSEC, Args)
        
        
        function Result = image2subimages(Obj, BlockSize, Args)
            % Partition an AstroImage image into sub images
            % Input  : - An AstroImage object with a single element.
            %          - BlockSize [X, Y] of sub images. or [X] (will be copied as [X, X]).
            %            If empty, will use imUtil.image.subimage_grid
            %            Default is [256 256].
            %          * Arbitrary number of pairs of input arguments ...,key,val,...
            %            The following keywords are available:
            %            'Output' - Output type {['cell'] | 'struct'}
            %            'FieldName' - Field name in a struct output in which to store
            %                       the sub images. Default is 'Im'.
            %            'SubSizeXY' - Sub image size [X,Y]. Default is [128 128].
            %            'CCDSEC' - CCDSEC of image to partition. If empty,
            %                   use full image. Default is empty.
            %            'Nxy' - Number of sub images along each dimension [Nx, Ny].
            %                    If empty then use SubSizeXY. Default is [].
            %            'OverlapXY' - Overlapping extra [X, Y] to add to SubSizeXY
            %                    from each side. Default is [32 32].
            % Example: AI = AstroImage({rand(1024, 1024)},'Back',{rand(1024, 1024)});
            %          Result = image2subimages(AI,[256 256])
            
            arguments
                Obj(1,1)
                BlockSize             = [256 256];   % If empty, will use imUtil.image.subimage_grid
                Args.CCDSEC           = [];   % [xmin xmax ymin ymax] If given, override BlockSize
                Args.Nxy              = [];   % If empty then use SubSizeXY. Default is [].
                Args.OverlapXY        = 10;   % Optionally [overlapX overlapY]
                
                Args.UpdateCat(1,1) logical        = true;
                Args.ColX                          = {'X','XWIN_IMAGE','XWIN','XPEAK','X_PEAK'};
                Args.ColY                          = {'Y','YWIN_IMAGE','YWIN','YPEAK','Y_PEAK'};
                Args.AddX                          = {};  % additional X-coo to update
                Args.AddY                          = {};
                Args.UpdateXY(1,1) logical         = true;
            end
           
            % find the correct partition
            PropList = {'ImageData','BackData','VarData','MaskData'};
            Nprop    = numel(PropList);
            Ind      = 0;
            Nsub     = NaN;
            Result   = [];
            for Iprop=1:1:Nprop
                Prop = PropList{Iprop};
                if ~isempty(Obj.(Prop).Data)
                    Ind = Ind + 1;
                    if Ind==1
                        [Sub,EdgesCCDSEC,ListCenters,NoOverlapCCDSEC,NewNoOverlap] = ...
                                imUtil.image.partition_subimage(Obj.(Prop).Image, Args.CCDSEC,...
                                       'Output','struct',...
                                       'FieldName','Im',...
                                       'SubSizeXY',BlockSize,...
                                       'Nxy',Args.Nxy,...
                                       'OverlapXY',Args.OverlapXY);
                        Nsub   = numel(Sub);
                        Result = AstroImage([1,Nsub]);
                    else
                        [Sub] = ...
                                imUtil.image.partition_subimage(Obj.(Prop).Image, Args.CCDSEC,...
                                       'Output','struct',...
                                       'FieldName','Im',...
                                       'SubSizeXY',BlockSize,...
                                       'Nxy',Args.Nxy,...
                                       'OverlapXY',Args.OverlapXY);
                    end
                    
                    for Isub=1:1:Nsub
                        Result(Isub).(Prop).Data   = Sub.Im;
                        Result(Isub).(Prop).Scale  = [];
                        Result(Isub).(Prop).CCDSEC = EdgesCCDSEC(Isub,:);
                    end
                end
            end
            
            if ~isnan(Nsub)
                % set the Mask data for edge and overlapping pixels

                % update the header
                KeyNames = {'NAXIS1','NAXIS2','CCDSEC','ORIGSEC','ORIGUSEC','UNIQSEC'};
                KeyVals  = cell(size(KeyNames));
                for Isub=1:1:Nsub
                    % 
                    KeyVals{1} = size(Result(Isub).ImageData.Image,2);  % NAXIS1
                    KeyVals{2} = size(Result(Isub).ImageData.Image,1);  % NAXI2
                    KeyVals{3} = imUtil.ccdsec.ccdsec2str([1, KeyVals{1}, 1, KeyVals{2}]); % CCDSEC of current image
                    KeyVals{4} = imUtil.ccdsec.ccdsec2str(EdgesCCDSEC(Isub,:));            % ORIGSEC : SEC of subimage in full image
                    KeyVals{5} = imUtil.ccdsec.ccdsec2str(NoOverlapCCDSEC(Isub,:));        % ORIGUSEC : SEC of non-overlapping sub image in full image
                    KeyVals{6} = imUtil.ccdsec.ccdsec2str(NewNoOverlap(Isub,:));           % UNIQSEC : SEC of non-overlapping sub image in new sub image
                    
                    Result(Isub).HeaderData.replaceVal(KeyNames, KeyVals);
                end
                    
                % update the PSF
                warning('Update PSF is not implenmented');
                
                % update the WCS
                warning('Update WCS is not implenmented');
                
                % update the Catalog
                if Args.UpdateCat
                    for Isub=1:1:Nsub
                        cropXY(Result(Isub).CatData, EdgesCCDSEC(Isub,:), 'ColX',Args.ColX,...
                                                                          'ColY',Args.ColY,...
                                                                          'AddX',Args.AddX,...
                                                                          'AddY',Args.AddY,...
                                                                          'UpdateXY',Args.UpdateXY);
                    end
                end                
            end
        end
        
        
        
        function varargout = object2array(Obj,DataProp)
            % Convert an AstroImage object that contains scalars into an array
            % Input  : - An AstroImage object.
            %          - A cell array of data properties to collect. Each
            %            property must contains a scalar.
            %            Default is {'Image'}.
            % Output : * Number of output arguments equal to the number of
            %            data properties.
            %            Each output argument is an array which size is
            %            equal to size(Obj), and contains all the scalars
            %            in the corresponding data property.
            % Author : - Eran Ofek (Apr 2021)
            % Example: 
            
            arguments
                Obj
                DataProp                    = {'Image','Back','Var'};
            end
            
            if ischar(DataProp)
                DataProp = {DataProp};
            end
            
            % select only the requested data properties
            DataProp = DataProp(1:1:nargout);
            
            Nprop = numel(DataProp);
            Nobj  = numel(Obj);
            
            varargout = cell(1,Nprop);
            for Iprop=1:1:Nprop
                varargout{Iprop} = nan(size(Obj));
                for Iobj=1:1:Nobj
                    varargout{Iprop}(Iobj) = Obj.(DataProp{Iprop});
                end
            end
            
        end
                
    end
    
    
    

    methods % specific functionality and overloads
        function Result = conv(Obj, Args)
            % Convolve images with their PSF, or another PSF
            arguments
                Obj
                Args.PSF                         = [];
                Args.ArgsPSF                     = {};
                Args.DataPropIn                  = {'ImageData'}
                Args.DataPropOut                 = {'Image'};
                Args.CreateNewObj(1,1) logical   = true;
                Args.IsOutObj(1,1) logical       = true;
            end
            
            if isempty(Args.CreateNewObj)   
                if nargout==0
                    Args.CreateNewObj = false;
                else
                    Args.CreateNewObj = true;
                end
            end
            if Args.CreateNewObj
                Result = Obj.copyObject;
            else
                Result = Obj;
            end
            
            Nobj = numel(Obj);
            for Iobj=1:1:Nobj
                if isempty(Args.PSF)
                    % take PSF from PSFData
                    Args.PSF = Obj(Iobj).getPSF(Args.ArgsPSF);
                end
                if isa(Args.PSF,'AstroPSF')
                    
                end
            end
            
                
            
            
            
            
        end
        
        function xcorr(Obj, Args)
            % cross correlate images with their PSF, or another PSF
            arguments
                Obj
                Args.PSF
            end
        end
        
        function subtractBack(Obj, Args)
            % subtract (and de-subtract) background from images
        end
        
        
        
        
        function coadd(Obj, Args)
            %
            
        end
        
        function background(Obj, Args)
            %
            
            arguments
                Obj
                Args.IsGlobal(1,1) logical            = false;
                
            end            
        end
        

        
        
        % ARE THESE FUNS PER IMAGE OR FVER MULTIPLE IMAGES????
        % possible solution: imFun.single.mean, imFun.stack.mean
        
        function NewObj = sum(Obj, Args)
            %
            
            arguments
                Obj
                Args.IsOutObj(1,1) logical        = false;
                Args.Dim                          = 'all';
                Args.DataPropIn                   = {'Image'};
                Args.DataPropOut                  = {'Image'};
                Args.CreateNewObj(1,1) logical    = true;
            end
            
        end
        
        function NewObj = mean(Obj)
            %
        end
        
        function NewObj = median(Obj)
            %
        end
        
        function NewObj = min(Obj)
            %
        end
        
        function NewObj = max(Obj)
            %
        end
        
        function NewObj = std(Obj)
            %
        end
        
        function NewObj = rstd(Obj)
            %
        end
        
        function NewObj = var(Obj)
            %
        end
        
        function NewObj = rvar(Obj)
            %
        end
        
        function NewObj = quantile(Obj)
            %
        end
        
        function NewObj = plus(Obj1, Obj2)
            %
        end
        
        function NewObj = minus(Obj1, Obj2)
            %
        end
        
        function NewObj = times(Obj1, Obj2)
            %
        end
        
        function NewObj = rdivide(Obj1, Obj2)
            %
        end
        
    end
    
    methods (Static) % Unit-Test
        function Result = unitTest()
            Astro = AstroImage;
            
            
            % funBinaryProp
            % funBinary for a single property / no error propagation
            AI=AstroImage({ones(3,3)});
            Res = funBinaryProp(AI,3,@plus);
            if ~all(Res.Image==4)
                error('funBinaryProp failed');
            end
            Res = funBinaryProp(AI,[3 2 1],@plus);
            if ~all(Res.Image==[4 3 2])
                error('funBinaryProp failed');
            end
            Res = funBinaryProp(AI,{2 1},@plus);
            if numel(Res)~=2
                error('funBinaryProp failed');
            end
            if ~all(Res(1).Image==3,'all') || ~all(Res(2).Image==2,'all')
                error('funBinaryProp failed');
            end
            Res = funBinaryProp(AI,AI,@minus);
            if ~all(Res.Image==0)
                error('funBinaryProp failed');
            end
            Res = funBinaryProp(AI,AI,@minus,'DataProp','VarData');
            if ~all(Res.Image==1)
                error('funBinaryProp failed');
            end
            
            
            
            
            
            % image2subimages
            AI = AstroImage({rand(1024, 1024)},'Back',{rand(1024, 1024)});
            Result = image2subimages(AI,[256 256]);
            
            
            
            Result = true;
        end
    end
    

end

            
