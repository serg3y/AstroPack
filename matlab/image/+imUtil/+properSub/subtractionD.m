function [D_hat, Pd_hat, Fd, D_den, D_num, D_denSqrt] = subtractionD(R_hat, N_hat, Pr_hat, Pn_hat, SigmaR, SigmaN, Fr, Fn, Args)
    % Return the D_hat subtraction image
    % Input  : - R_hat
    %          - N_hat
    %          - Pr_hat
    %          - Pn_hat
    %          - SigmaR
    %          - SigmaN
    %          - Fr
    %          - Fn
    %          * ...,key,val,...
    %            'AbsFun' - absolute value function.
    %                   Default is @(X) abs(X)
    %            'Eps' - A small value to add to the demoninators in order
    %                   to avoid division by zero due to roundoff errors.
    %                   Default is 0. (If needed set to about 100.*eps).
    % Output : - D_hat
    %          - Pd_hat
    %          - Fd
    %          - D_den
    %          - D_num
    %          - D_denSqrt
    % Author : Eran Ofek (Apr 2022)
    
    arguments
        R_hat
        N_hat
        Pr_hat
        Pn_hat
        SigmaR
        SigmaN
        Fr
        Fn
        Args.AbsFun   = @(X) abs(X);
        Args.Eps      = 0;
    end
        
    D_den     = (SigmaN.^2 .* Fr.^2) .* AbsFun(Pr_hat).^2 + (SigmaR.^2 .*Fn.^2) .* AbsFun(Pn_hat).^2 + Args.Eps;
    D_num     = Fr.*Pr_hat.*N_hat - Fn.*Pn_hat.*R_hat;
    D_denSqrt = sqrt(D_den);
    D_hat     = D_num./D_denSqrt;
    
    Fd        = Fr .* Fn ./ sqrt( (SigmaN.*Fr).^2 + (SigmaR.*Fn).^2 );
    
    Pd_num    = Fr .* Fn .* Pr_hat .* Pn_hat;
    Pd_den    = Fd .* D_denSqrt;
    Pd_hat    = Pd_num./Pd_den;
    
end