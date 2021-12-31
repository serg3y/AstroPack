function [Result, CubePsfSub] = psfPhotCube(Cube, Args)
    % The core function for PSF-fitting photometry.
    %   The input of this function is a cube of stamps of sources, and a
    %   PSF to fit.
    %   The function fits all the stamps simultanously.
    %   The flux fit is fitted linearly, while the positions are fitted
    %   using a one-directional steepest descent style method.
    %   In each iteration the PSF is shifted using fft-sub-pixels-shift.
    % Input  : - A cube of stamps around sources.
    %            The third dimesnion is the stamp index.
    %            The code is debugged only for an odd-size PSF and stamps.
    %          * ...,key,val,...
    %            'PSF' - A PSF stamp to fit. If this is a scalar, then will
    %                   use a Gaussian PSF, which sigma-width is given by
    %                   the scalar. Default is 1.5.
    %            'Std' - Either a vector (element per stamp), or a cube
    %                   (the same size as the input cube) of std in the
    %                   cube. Default is 1.
    %            'Xinit' - A vector of initial X position for the PSF
    %                   position in the stamps. If empty, then 
    %                   use size/2 + 0.5. Default is [].
    %            'Yinit' - Like 'Xinit' but for the Y position.
    %                   Default is [].
    %
    %            Fitting-related parameters:
    %            'SmallStep' - Gradient step size. Default is 1e-4 (pix).
    %            'MaxStep' - Maximum step size in each iteration.
    %                   Default is 1.
    %            'ConvThresh' - Convergence threshold. Default is 1e-4.
    %            'MaxIter' - Max number of iterations. Default is 10.
    % Output : - A structure with the following fields:
    %            .Chi2 - Vector of \chi^2 (element per stamp).
    %            .Dof - The number of degrees of freedom in the fit.
    %                   This is the stamp area minus 3.
    %            .Flux - Vector of fitted fluxes.
    %            .DX - Vector of fitted X positions relative the Xcenter.
    %            .DY - Vector of fitted Y positions relative the Xcenter.
    %            .Xinit - Xinit
    %            .Yinit - Yinit
    %            .Xcenter - Stamp X center.
    %            .Ycenter - Stamp Y center.
    %            .ConvergeFlag - A vector of logicals (one per stamp)
    %                   indicating if the PSF fitting for the stamp
    %                   converged.
    %            .Niter - Number of iterations used.
    %          - The input cube, after subtracting the fitted PSF from each
    %            stamp.
    % Author : Eran Ofek (Dec 2021)
    % Example: P=imUtil.kernel2.gauss;
    %          Ps=imUtil.trans.shift_fft(P,0.4,0.7);
    %          imUtil.sources.psfPhotCube(Ps, 'PSF',P)
    %          P=imUtil.kernel2.gauss(1.5.*ones(4,1));
    %          Ps=imUtil.trans.shift_fft(P,[0.4;0.7;-1.1;3.6],[0.7;-0.2;-0.9;-2.6]);
    %          Ps = Ps.*permute([100 110 200 300],[1 3 2]) + randn(15,15);
    %          Result = imUtil.sources.psfPhotCube(Ps, 'PSF',P(:,:,1))
   
    arguments
        Cube
        Args.PSF        = 1.5;  % scalar will generate a Gaussian PSF - normalized to 1
        Args.Std        = 1;   % vector or cube
        
        Args.Xinit      = [];
        Args.Yinit      = [];
        
        Args.SmallStep  = 1e-4;
        Args.MaxStep    = 1;
        Args.ConvThresh = 1e-4;
        Args.MaxIter    = 10;
    end
    
    if ndims(Args.Std)<3
        Std = permute(Args.Std(:),[3 2 1]);
    else
        Std = Args.Std;
    end
    
    
    [Ny, Nx, Nim] = size(Cube);
    Xcenter = Nx.*0.5 + 0.5;
    Ycenter = Ny.*0.5 + 0.5;
    Dof     = Nx.*Ny - 3;
    
    if isempty(Args.Xinit)
        Args.Xinit = Xcenter;
    end
    if isempty(Args.Yinit)
        Args.Yinit = Ycenter;
    end
    
    if numel(Args.PSF)==1
        Args.PSF = imUtil.kernel2.gauss(Args.PSF);
    end
    
    % measure and subtract background
    
    
    WeightedPSF = sum(Args.PSF.^2, [1 2]); % for flux estimation
    
    X = Args.Xinit;
    Y = Args.Yinit;
    
    StepX = 0;
    StepY = 0;
    DX = X - Xcenter + StepX;
    DY = Y - Ycenter + StepY;
        
    VecD = [0, Args.SmallStep, 2.*Args.SmallStep];
    H    = VecD.'.^[0, 1, 2];
    Ind   = 0;
    NotConverged = true;
    while Ind<Args.MaxIter && NotConverged
        Ind = Ind + 1;
       
        % calc \chi2 and gradient
        Chi2     = internalCalcChi2(Cube, Std, Args.PSF, DX,                   DY,                WeightedPSF);
        Chi2_Dx  = internalCalcChi2(Cube, Std, Args.PSF, DX+Args.SmallStep,    DY,                WeightedPSF);
        Chi2_Dx2 = internalCalcChi2(Cube, Std, Args.PSF, DX+Args.SmallStep.*2, DY,                WeightedPSF);
        
        %ParX     = polyfit(VecD, [Chi2, Chi2_Dx, Chi2_Dx2], 2);
        ParX     = H\[Chi2.'; Chi2_Dx.'; Chi2_Dx2.'];
        
        %Chi2     = internalCalcChi2(Cube, Std, Args.PSF, DX, DY,                  WeightedPSF);
        Chi2_Dy  = internalCalcChi2(Cube, Std, Args.PSF, DX, DY+Args.SmallStep,   WeightedPSF);
        Chi2_Dy2 = internalCalcChi2(Cube, Std, Args.PSF, DX, DY+Args.SmallStep.*2,WeightedPSF);
        
        %ParY     = polyfit(VecD, [Chi2, Chi2_Dy, Chi2_Dy2], 2);
        ParY     = H\[Chi2.'; Chi2_Dy.'; Chi2_Dy2.'];
        
        StepX    = -ParX(2,:)./(2.*ParX(3,:));
        StepY    = -ParY(2,:)./(2.*ParY(3,:));
        
        NotMinimaX = ParX(3,:)<0;
        NotMinimaY = ParY(3,:)<0;
        
        % reverse sign for maxima...
        StepX(NotMinimaX) = -StepX(NotMinimaX);
        StepY(NotMinimaY) = -StepY(NotMinimaY);
        
        
        StepX    = sign(StepX).*min(abs(StepX), Args.MaxStep);
        StepY    = sign(StepY).*min(abs(StepY), Args.MaxStep);
        
        DX       = DX + StepX;
        DY       = DY + StepY;
         
        % stoping criteria
        ConvergeFlag = abs(StepX)<Args.ConvThresh & abs(StepY)<Args.ConvThresh;
        if all(ConvergeFlag)
            NotConverged = false;
        end
        
    end
    % final fit and return flux
    [Result.Chi2, Flux, ShiftedPSF]  = internalCalcChi2(Cube, Std, Args.PSF, DX, DY, WeightedPSF);
    Result.Dof  = Nx.*Ny - 3;
    
    Result.Flux = squeeze(Flux);
    Result.DX = DX(:);
    Result.DY = DY(:);
    Result.Xinit = Args.Xinit;
    Result.Yinit = Args.Yinit;
    Result.Xcenter = Xcenter;
    Result.Ycenter = Ycenter;
    Result.ConvergeFlag = ConvergeFlag;
    Result.Niter   = Ind;
    
    if nargout>1
        % subtract best fit PSFs from cube
        CubePsfSub = Cube - ShiftedPSF.*Flux;
    end
    
end

% Internal functions

function [Chi2,WeightedFlux, ShiftedPSF] = internalCalcChi2(Cube, Std, PSF, DX, DY, WeightedPSF)
    % Return Chi2 for specific PSF and Cube
    % shift PSF
    ShiftedPSF = imUtil.trans.shift_fft(PSF, DX, DY);
    WeightedFlux = sum(Cube.*ShiftedPSF, [1 2], 'omitnan')./WeightedPSF;
    Resid = Cube - WeightedFlux.*ShiftedPSF;
    
    % search / remove outliers

    Chi2  = sum( (Resid./Std).^2, [1 2], 'omitnan');
    Chi2  = squeeze(Chi2);
     
end
