% Installer class for AstroPack aux data sets
% In addition to the GitHub distribution, some additional datasets are
% available, and these datasets can be installed using this utility.
%
% The datasets and their properties are listed in the config/Installer.yml
% file.
%
% Author : Eran Ofek (Sep 2021)
% Examples:
% I = Install;  % create installer object
% I.seeAvailableData      % print a table of all available datasets and description and size
% I.install               % install all data sets [very large!]
% I.install({'GAIA_SpecTemplate'}); % install specific datasets
%



classdef Installer < Base
    % Installer class
    
    % Properties
    properties (SetAccess = public)
        InstallationLocation      = [];     
        ConfigFile
        ConfigStruct
    end
    
    %-------------------------------------------------------- 
    methods % constructor
        function Obj = Installer(ConfigFileName)
            % constructor for the Installre class (a utility class for
            % AstroPack installation
            
            arguments 
                ConfigFileName  = 'Installer.yml';
            end
            
            % populate the ConfigStruct field
            Obj.ConfigFile = ConfigFileName;
            
            
        end
    end
    
    
    methods % setters/getters
        function Result = get.InstallationLocation(Obj)
            % getter for InstallationLocation
            if isempty(Obj.InstallationLocation)
                % get from ConfigStruct
                Result = Obj.ConfigStruct.InstallationLocation;
                Obj.InstallationLocation = Result;
            else
                Result = Obj.InstallationLocation;
            end
        end
        
        function Obj = set.ConfigFile(Obj, ConfigFileName)
            % setter for ConfigFile - read config into ConfigStruct prop
            Obj.ConfigFile   = ConfigFileName;
            
            Config = Configuration;
            FullFileName = sprintf('%s%s%s', Config.Path, filesep, ConfigFileName);
            
            Config.loadFile(FullFileName, 'Field',false);
            Obj.ConfigStruct = Config.Data;
            clear Config;
            
        end
        
        function Obj = set.ConfigStruct(Obj, Struct)
            % setter for ConfigStruct - check validity of properties
           
            Ndn = numel(Struct.DataName);
            Nsd = numel(Struct.SubDir);
            Nu  = numel(Struct.URL);
            Ns  = numel(Struct.Size);
            Nt  = numel(Struct.GetTar);
            Nsf = numel(Struct.SearchFile);
            Nd  = numel(Struct.Description);
            
            if Ndn~=Nsd || Ndn~=Nu || Ndn~=Ns || Ndn~=Nt || Ndn~=Nsf || Ndn~=Nd
                error('DataName, SubDir, URL, Size, GetTar, SearchFiule, Description properties in inastaller config files must have the same number of elements');
            end
            
            Obj.ConfigStruct = Struct;
            
        end
    end
    
    methods % main functions
        function install(Obj, DataName, Args)
            % Install AstroPack data directories from AstroPack repository
            % Input  : - An iInstaller object.
            %          - A DataName to install (e.g., 'GAIA_SpecTemplate'),
            %            or a cell array of data names. If empty, install
            %            all data names in ConfigStruct.
            %            Default is empty.
            %          * ...,key,val,...
            %            'Delete' - A logical indicating if to delete
            %                   data before installation.
            %                   Default is true.
            %            'Npwget' - Number of parallel wget. Default is 10.
            %            'wgetPars' - A cell array of additional wget
            %                   arguments. Default is '-q -o /dev/null -U Mozilla --no-check-certificate'.
            % Author : Eran Ofek (Sep 2021)
            % Example: I = Installer; I.install
            
            arguments
                Obj
                DataName                  = [];
                Args.Delete(1,1) logical  = true;
                Args.Npwget               = 10;
                Args.wgetPars             = '-q -o /dev/null -U Mozilla --no-check-certificate';
            end

            if isempty(DataName)
                DataName = Obj.ConfigStruct.DataName;
            else
                if ischar(DataName)
                    DataName = {DataName};
                end
            end
            
            if ~isunix && ~ismac
                % assume windows - replace / with \
                Obj.InstellationLocation = strrep(Obj.InstallationLocation,'/',filesep);
                Obj.CoonfigStruct.SubDir = strrep(Obj.ConfigStructSubDir,'/',filesep);
            else
                Obj.InstallationLocation = strrep(Obj.InstallationLocation,'\',filesep);
                Obj.ConfigStruct.SubDir  = strrep(Obj.ConfigStruct.SubDir,'\',filesep);
            end
    

            PWD = pwd;
            cd('~/');
            mkdir(Obj.InstallationLocation);

            Ndir = numel(DataName);
            
            for Idir=1:1:Ndir    
                % create dir for instellation
                cd(sprintf('~%s',filesep));
                cd(Obj.InstallationLocation);

                Parts = regexp(Obj.ConfigStruct.SubDir{Idir}, filesep, 'split');

                Nparts = numel(Parts);
                SubDir = '';
                for Iparts=1:1:Nparts
                    SubDir = sprintf('%s%s%s',SubDir,filesep,Parts{Iparts});
                    mkdir(Parts{Iparts});
                    cd(Parts{Iparts});
                end        
        
                [List,IsDir,FileName] = www.find_urls(Obj.ConfigStruct.URL{Idir},'match', Obj.ConfigStruct.SearchFile{Idir});
                List     = List(~IsDir);
                FileName = FileName(~IsDir);

                if numel(List)>0
                    % delete content before reload
                    if Args.Delete
                        delete('*');
                    end
                    www.pwget(List(1:2), Args.wgetPars, Args.Npwget);
                end
            end
            cd(PWD);
        end
        
        function Result = seeAvailableData(Obj)
            % print a table of available data sets
            % Example: I = Installer; I.seeAvailableData
            
            Result = cell2table([Obj.ConfigStruct.DataName(:), ...
                   Obj.ConfigStruct.SubDir(:), ...
                   Obj.ConfigStruct.GetTar(:), ...
                   Obj.ConfigStruct.Size(:), ...
                   Obj.ConfigStruct.Description(:),...
                   Obj.ConfigStruct.URL(:)], 'VariableNames',{'DataName', 'SubDir', 'GetTar', 'Size [MB]', 'Description', 'URL'});
            
        end
    end
    
end