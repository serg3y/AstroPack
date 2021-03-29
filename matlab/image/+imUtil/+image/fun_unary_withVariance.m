function [Result,ResultVar,FlagBad,FunH]=fun_unary_withVariance(Operator, Mat, Var, OpArg)
% Applay an operator on an array and its variance.
% Input  : - Operator handle (e.g., @sin).
%          - An array in which to apply the operator.
%          - A variance array or scalar of the array. Default is [].
%          - A cell array of additional parameters to pass to the function
%            operator. Default is {}.
% Output : - The result of applying the operator to the matrix.
%          - The result of applying the operator to the variance.
%          - A matrix of logicals indicating if a resulted matrix value is
%            NaN or Inf, or the resulted Variance is NaN.
%          - The function handle for the derivative function (only if was
%            found symbolically).
% Author : Eran Ofek (Mar 2021)
% Example: [Result,ResultVar,Flag,FunH]=imUtil.image.fun_unary_withVariance(@sin, randn(5,5), rand(5,5).*0.01)
%          [Result,ResultVar,Flag,FunH]=imUtil.image.fun_unary_withVariance(@mean, randn(2,2), rand(2,2).*0.01)
%          [Result,ResultVar,Flag,FunH]=imUtil.image.fun_unary_withVariance(@mean, randn(2,2), rand(2,2).*0.01,{'all'})
%          [Result,ResultVar,Flag,FunH]=imUtil.image.fun_unary_withVariance(@tanh, randn(2,2), rand(2,2).*0.01);

    arguments
        Operator 
        Mat          {mustBeNumeric(Mat)}
        Var          {mustBeNumeric(Var)} = [];
        OpArg cell                        = {};
    end
    
    FunH      = [];
    
    Result    = Operator(Mat, OpArg{:});
    if isempty(Var)
        % Variance is not provided
        ResultVar = [];
        FlagBad   = [];
    else
        switch func2str(Operator)
            case 'sin'
                ResultVar = Var.*cos(Mat).^2;
            case 'cos'
                ResultVar = Var.*sin(Mat).^2;
            case 'tan'
                ResultVar = Var.*sec(Mat).^2;
            case 'log'
                ResultVar = Var./(Mat.^2);
            case 'log10'
                ResultVar = Var./((log(10).*Mat).^2);
            case 'sum'
                if numel(Var)==1
                    ResultVar = numel(Mat).*Var;
                else
                    ResultVar = Operator(Var, OpArg{:});
                end
            case 'mean'
                if numel(Var)==1
                    ResultVar = Var;
                else
                    ResultVar = Operator(Var, OpArg{:})./numel(Mat);
                end
            
            otherwise
                % Unknown unary operator option
                % attempt to use symbolic math
                syms x;
                SymFun = eval(sprintf('diff(%s(x))', func2str(Operator)));
                if SymFun==1
                    error('Function derivative could not be found symbolically');
                end
                FunH   = matlabFunction(SymFun);
                ResultVar = Var.*FunH(Mat);
                warning('The variance was propagated using symbolic math - For speed consider adding this function to the list of built in functions');
        end
        FlagBad = isinf(Mat) | isnan(Mat) | isnan(Var);
    end
    
end

