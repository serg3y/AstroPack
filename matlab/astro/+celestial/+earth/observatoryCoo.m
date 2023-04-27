function [Result]=observatoryCoo(Args)
    % Database of observatories coordinates
    %   Search for observatory coordinates by name or telescope diameter.
    % Package: celestial.earth
    % Input  : * ...,key,val,...
    %            'Name' - Observatory name to search using the contains
    %                   function. If empty, returm all observatories.
    %                   Default is [].
    %            'TelDiam' - Telescope diamameter range [min, max] in cm.
    %                   If empty, returm all observatories.
    %                   Default is [].
    % Output : - A structure array of found observatories.
    % Author : Eran Ofek (Apr 2023)
    % Example: [Result]=celestial.earth.observatoryCoo('Name','Wise')

    arguments
        Args.Name     = [];
        Args.TelDiam  = [];
    end

    I = 0;
    I = I + 1;
    Obs(I).Name     = 'W-FAST (Wise observatory)';
    Ons(I).TelDiam  = 55;    % cm
    Obs(I).Height   = 876;   % m
    Obs(I).Lon      = 34.762054900000003;
    Obs(I).Lat      = 30.596806899999997;
    Obs(I).TimeZone = 2;
    Obs(I).ObsCode  = [];

    I = I + 1;
    Obs(I).Name     = 'Wise observatory (1m)';
    Obs(I).TelDiam  = 40.*2.54;  % cm
    Obs(I).Height   = 876;   % m
    Obs(I).Lon      = 34.762194;
    Obs(I).Lat      = 30.597389;
    Obs(I).TimeZone = 2;
    Obs(I).ObsCode  = '097';

    I = I + 1;
    Obs(I).Name     = 'Large Array Survey Telescope (Node 1; Combined)';
    Obs(I).TelDiam  = 11.*2.54.*sqrt(48);  % cm
    Obs(I).Height   = 415.4;   % m
    Obs(I).Lon      = 35.0407331;
    Obs(I).Lat      = 30.0529838;
    Obs(I).TimeZone = 2;
    Obs(I).ObsCode  = [];

    I = I + 1;
    Obs(I).Name     = 'Palomar observatory (Hale telescope; 200-inch)';
    Obs(I).TelDiam  = 200.*2.54;  % cm
    Obs(I).Height   = 1712;   % m
    Obs(I).Lon      = -116.8650;
    Obs(I).Lat      = 33.3564;
    Obs(I).TimeZone = 2;
    Obs(I).ObsCode  = '675';

    I = I + 1;
    Obs(I).Name     = 'Palomar observatory (Oschin Schmidt telescope; 48-inch)';
    Obs(I).TelDiam  = 48.*2.54;  % cm
    Obs(I).Height   = 1712;   % m
    Obs(I).Lon      = -116.86194;
    Obs(I).Lat      = 33.35806;
    Obs(I).TimeZone = 2;
    Obs(I).ObsCode  = [];

    Nobs = numel(Obs);
    
    % search
    
    if isempty(Args.Name)
        Flag.Name = true(Nobs,1);
    else
        Flag.Name = contains({Obs.Name}.', Args.Name);
    end
    if isempty(Args.TelDiam)
        Flag.TelDiam = true(Nobs,1);
    else
        if numel(Args.TelDiam)==1
            Args.TelDiam = Args.TelDiam.*ones(1,2);
        end
        Flag.TelDiam = [Obs.TelDiam]>=min(Args.TelDiam) & [Obs.TelDiam]<=max(Args.TelDiam);
    end
    
    Flag.All = Flag.TelDiam & Flag.Name;
    
    Result = Obs(Flag.All);


end