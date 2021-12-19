function [Mean, Var] = constructPSF_cutouts(Image, XY, Args)
    % Given a background-subtracted image and PSF star positions, construct a mean PSF stamp from cutouts
    % Input  : - A 2-D image, or a cube of cutouts around sources.
    %            If a cube then the image index must be in the 3rd
    %            dimesniosn.
    %          - A two column matrix of [X, Y] sources positions.
    %            Not relevant if first input is a cube.
    %            Default is [].
    %          * ...,key,val,...
    %            'Norm' - Vector of normalizations per cutrouts.
    %                   These are the flux normalization one has to
    %                   multiply each cutout, before summation.
    %            'SumMethod' - One of the following summation of PSFs:
    %                    'sigclip' - Use imUtil.image.mean_sigclip.
    %                    'mean' - Mean of PSFs.
    %                    'median' - Median of PSFs.
    %                    Default is 'sigclip'.
    %            'mean_sigclipArgs' - A cell array of arguments to pass to  
    %                   imUtil.image.mean_sigclip if SumMethod='sigclip'.
    %                   Default is {}.
    %            'PostNormBySum' - A logical indicating if post
    %                   normalization is by sum (true), or by peak (false).
    %            'PostNorm' - Post normalization value. If [], do not
    %                   perform post normalization. Default is 1.
    %
    %            'mexCutout' - use imUtil.image.mexCutout.m (true) or
    %                   imUtil.image.find_within_radius_mat (false).
    %                   Default is true.
    %            'Circle' - If true, then will set all points outside the radius to NaN.
    %                   Default is false.
    %            'MomRadius' - radius for 2nd moment calculations.
    %                   Default is 8.
    %            'ShiftMethod' - Options are:
    %                   'lanczos' - Lanczos interpolation.
    %                   'fft' - Sinc interpolation.
    %            'A' - Order of Lanczos interpolation.
    %                   Default is 2.
    %            'IsCircFilt' - Is circular filtering.
    %                   Relevant for shift_lanczos.
    %                   Default is true.
    %            'PadVal' - Padding value for interpolation.
    %                   Default is 0.
    % Output : - Mean cutout (PSF).
    %          - Variance of all cutouts.
    % Author : Eran Ofek (Dec 2021)
    % Example: 
    
    arguments
        Image                             % 2D image or cube of cutouts
        XY                         = [];  % XY positions of sources in image
        
        Args.Norm                  = [];  % vector of normalization per cutout
        Args.SumMethod             = 'sigclip';
        Args.mean_sigclipArgs cell = {};
        Args.PostNormBySum logical = true;
        Args.PostNorm              = 1;
        
        Args.mexCutout logical     = true;
        Args.Circle logical        = false;
        %Args.ReCenter logical      = true;    % call moment2
        Args.MomRadius             = 8;
                
        Args.ShiftMethod           = 'lanczos';   % 'lanczos' | 'fft'
        Args.A                     = 2;
        Args.IsCircFilt logical    = true;
        Args.PadVal                = 0;
    end
            
    if isempty(Args.Norm)
        error('Norm argument musu be provided');
    end
    
    MaxRadius = Args.MomRadius;
    
    if isempty(XY)
        X = [];
        Y = [];
    else
        X = XY(:,1);
        Y = XY(:,2);
    end
    
    [Cube, RoundX, RoundY, X, Y] = imUtil.image.image2cutouts(Image, X, Y, MaxRadius, 'mexCutout',Args.mexCutout, 'Circle',Args.Circle);
    Dim = 3;
    
    %if Args.ReCenter
    M1 = imUtil.image.moment2(Cube, X, Y, 'MomRadius',Args.MomRadius);
    %end
    
    SizeCube = size(Cube);
    Ncube    = SizeCube(3);
    Xcen     = SizeCube(2).*0.5;
    Ycen     = SizeCube(1).*0.5;
    
    ShiftXY  = [Xcen - M1.X, Ycen - M1.Y];
    
    switch lower(Args.ShiftMethod)
        case 'lanczos'
            [ShiftedCube] = imUtil.trans.shift_lanczos(Cube, ShiftXY, Args.A, Args.IsCircFilt, Args.PadVal);
        case 'fft'
            Icube = 1;
            ShiftedCube = zeros(Cube);
            
            [ShiftedCube(:,:,Icube),NY,NX,Nr,Nc] = imUtil.trans.shift_fft(Cube(:,:,Icube), ShiftXY(Icube,1), ShiftXY(Icube,2));
            for Icube=2:1:Ncube
                ShiftedCube(:,:,Icube) = imUtil.trans.shift_fft(Cube(:,:,Icube), ShiftXY(Icube,1), ShiftXY(Icube,2), NY,NX,Nr,Nc);
            end
            
        otherwise
            error('Unknown ShiftMethod option');
    end
    
    % cutouts normalization
    if numel(Args.Norm)==1
        Args.Norm = repmat(Args.Norm,1,Ncube);
    end
    
    Args.Norm = reshape(Args.Norm, 1,1, Ncube);  % put Norm in 3rd dim
    ShiftedCube = ShiftedCube.*Args.Norm;
    
    % cutout summation
    switch lower(Args.SumMethod)
        case 'sigclip'
            [Mean,Var,FlagGood,GoodCounter] = mean_sigclip(ShiftedCube, Dim, Args.mean_sigclipArgs{:});
        case 'mean'
            Mean = mean(ShiftedCube, Dim, 'omitnan');
            Var  = var(ShiftedCube,1, Dim, 'omitnan');
        case 'median'
            Mean = median(ShiftedCube, Dim, 'omitnan');
            Var  = var(ShiftedCube,1, Dim, 'omitnan');
        otherwise
            error('Unknown SumMethod option');
    end
    
    if ~isempty(Args.PostNorm)
        if Args.PostNormBySum
            Norm = 1./(Args.PostNorm.*sum(Mean, 'all'));
        else
            % norm by peak
            Norm = 1./(Args.PostNorm.*max(Mean,[],'all'));
        end

        Mean = Mean .* Norm;
        Var  = Var  .* Norm;
    end
        
end