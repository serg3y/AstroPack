function Rad = containment (Args)
    % Measure the radius of signal containment in a PSF stamp at a given level
    % Package: imUtil.psf
    % Description: Measure the radius of signal containment in a PSF stamp at a given level 
    %          - Args.PSF: a 2D array containing the PSF stamp 
    %          - Args.Level: signal containment level [0-1], 0.5 is default
    % Output : - Rad: containment radius in pixels
    %            
    % Tested : Matlab R2020b
    %     By : A. Krassilchtchikov et al.    Feb 2023
    % Example: Rad = containment (PSF, 0.5)
    
    arguments
        
        Args.PSF
        
        Args.Level     =    0.5; % 50% containment
        
    end
    
    % normalize the PSF stamp to 1:
    
    PSF = Args.PSF / sum(Args.PSF,'all');
    
    % find the smaller size of an M x N array:
    
    Size       = min ( size(PSF,1), size(PSF,2) );
    HalfSize   = floor( (Size+1)/2 );
        
    Rad = 0;
    
    Isc      = 0;
    Encircle = 0;

    while Isc < HalfSize && Encircle < Args.Level
    
        Isc   = Isc + 1;
            
        Bl      = max( HalfSize - Isc, 1 );
        Br      = min( HalfSize + Isc, Size);   
        
        Stamp   = PSF(Bl:Br,Bl:Br);

        Encircle = sum( Stamp, 'all' );
     
    end
     
    Rad = Isc; 
    
    if Encircle < Args.Level
        fprintf('Warining! The required level not reached, probably, due to a rectangular PSF matrix!\n');
        fprintf('%s%4.1f','The encircled fraction is only',Encircle);
    end
    
end