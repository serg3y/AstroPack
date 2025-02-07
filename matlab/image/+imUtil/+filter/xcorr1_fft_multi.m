function [Lag,XC,Info]=xcorr1_fft_multi(S1, S2, Args)
    % cross correlation of a 1-D series with multiple 1-D serieses using FFT.
    %       The shortest vector will be padded by zeros (at the end).
    %       This function return only the best correlation (and its
    %       shift) among all the columns in the multiple 1-D serieses.
    % Input  : - Matrix in which each column is treated as the first series
    %            (equaly spaced).
    %          - Second vector.
    %          * ...,key,val,...
    %            'Back' - Background subtraction method:
    %                   'none' - do not subtract background.
    %                   'mean' - subtract the mean.
    %                   'median' - subtract the median (default).
    %                   'medfilt' - subtract a median filter, which length is
    %                        specified as the next input argument.
    %            'subtract_back1dArgs' - A cell array of arguments to pass to
    %                   timeSeries.detrend.subtract_back1d
    %                   Default is {}.
    % Output : - Vector of lags.
    %          - Vector of cross-correlation between the two vectors,
    %            corresponding to the lags.
    %          - Structure containing information
    %            about te best shift of the column with the maximal
    %            correlation.
    %            Fields are:
    %            .BestCol - Index of column in the first input matrix,
    %                       which have the maximum correlation.
    %                       All the rest of the output corresponds to this
    %                       column.
    %            .Shift   - Shift of first vector relative to the second vector.
    %            .Corr    - Correlation at shift.
    %            .BestShift - Interpolated position of best shift.
    %            .BestCorr  - Correlation at best shift.
    %            .Best2dr   - 2nd derivative at best shift.
    % See also: xcorr_fft.m
    % Author : Eran Ofek (Sep 2013)
    % Example: R1 = rand(1e5,100); R2 = rand(1e5,1);
    %          R1(2001:2100,100)=100; R2(1001:1100)=100;
    %          [XC,Lag,Info] = imUtil.filter.xcorr1_fft_multi(R1,R2);

    arguments
        S1
        S2
        Args.Back                       = 'median';
        Args.subtract_back1dArgs cell   = {};
    end


    Nser = size(S1,2);
    for Iser=1:1:Nser
       S1(:,Iser) = timeSeries.detrend.subtract_back1d(S1(:,Iser),Args.Back, Args.subtract_back1dArgs{:});
    end
    S2 = timeSeries.detrend.subtract_back1d(S2, Args.Back, Args.subtract_back1dArgs{:});


    N1 = size(S1,1);
    N2 = numel(S2);
    if N1>N2
       % pad S2
       S2 = [S2; zeros(N1-N2,1)];
    end
    if N2>N1
       % pad S1
       S1 = [S1; zeros(N2-N1,Nser)];
    end
    N1 = size(S1,1);
    N2 = numel(S2);

    %XC  = fftshift(real(ifft(fft(S1).*conj(fft(S2)))));
    XC  = fftshift(real(ifft( bsxfun(@times, fft(S1), conj(fft(S2)) ) )),1);

    Lag = [-floor(N1./2):1:ceil(N1./2-1)]'; 
    Factor = 1./(N1.*std(S1).*std(S2));
    XC     = bsxfun(@times,XC,Factor);

    %[Max,MaxInd] = max(XC);
    Buffer = 6;
    [Max,MaxInd] = tools.math.stat.maxnd(XC(Buffer:end-Buffer,:));
    MaxInd(1)    = MaxInd(1) + Buffer - 1;
    XC           = XC(:,MaxInd(2));
    Info.BestCol = MaxInd(2);
    MaxInd       = MaxInd(1);

    Info.Shift   = Lag(MaxInd);
    Info.Corr    = Max;

    if (MaxInd<6 || MaxInd>(length(XC)-5) || isempty(find(~isnan(XC),1)))
       Info.BestShift = NaN;
       Info.BestCorr  = NaN;
       Info.Best2dr   = NaN;
    else    
       Extram = tools.find.find_local_extremum(Lag(MaxInd-5:MaxInd+5),XC(MaxInd-5:MaxInd+5));
       if (isempty(Extram))
           Info.BestShift = NaN;
           Info.BestCorr  = NaN;
           Info.Best2dr   = NaN;
       else
          Imax = find(Extram(:,3)<0);
          if (isempty(Imax))
              Info.BestShift = NaN;
              Info.BestCorr  = NaN;
              Info.Best2dr   = NaN;
          else
              [MaxE,MaxEInd] = max(Extram(Imax,2));
              Info.BestShift = Extram(Imax(MaxEInd),1);
              Info.BestCorr  = Extram(Imax(MaxEInd),2);
              Info.Best2dr   = Extram(Imax(MaxEInd),3);
          end
       end
    end

end
