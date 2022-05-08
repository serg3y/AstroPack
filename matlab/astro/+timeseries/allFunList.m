% Functions and Classes list for the timeseries package
% Author : autogenerated (May 2022)
%            timeseries.Contents - 
%                 timeseries.arp - Fit autoregression model for evently spaced time series
%          timeseries.bin_by_eye - Bin data by define bins interactively
%             timeseries.binning - Binning function. Calculate various functions in data bins.
%         timeseries.binningFast - Bin [X,Y] data and apply functions to Y values in each bin defined by X
%    timeseries.binning_adaptive - Construct list of edges for binning, given some bin size criteria
%         timeseries.binning_npt - Binning a time series by equal number of sucssesive points
%         timeseries.binning_old - The old version of the binning function. Use binning instead.
%      timeseries.calib_flux_lsq - Best fit zeropoints and mean magnitudes to a matrix of magnitudes.
%      timeseries.calib_flux_sum - Normalize (calibrate) a matrix of fluxes using sum of flux in each epoch.
%                 timeseries.ccf - ------------------------------------------------------------------------------
%                timeseries.ccf1 - --------------------------------------------------------------------------
%             timeseries.ccf_fft - Cross correlation function of evenly spaced data using fft
%             timeseries.ccf_old - Cross coorelation between two equally spaced series
%             timeseries.cosbell - Cosine bell function (Obsolete: use timeseries.taper instead)
%                 timeseries.dcf - --------------------------------------------------------------------------
%                timeseries.dcf1 - --------------------------------------------------------------------------
%       timeseries.extract_phase - Extract observations take at some phase range
%          timeseries.fitPolyHyp - Hypothesis testing between fitting polynomials of various degrees to
% timeseries.fit_polys_deltachi2 - Fit polynomials of various orders to a time series and calculate chi^2
%               timeseries.fmaxs - ------------------------------------------------------------------------------
%             timeseries.folding - Folding a timeseries by some period
%    timeseries.folding_solarsys - Folding a timeseries for a solar system object
%              timeseries.glsper - Calculates The generalized Lomb-Scargle periodogram (Zechmeister 2009).
%                 timeseries.hjd - --------------------------------------------------------------------------
%            timeseries.interpGP - Interpolate a time series using Gaussian processes
%      timeseries.matched_filter - Matched filter for 1-D time series
%     timeseries.mean_plweighted - Power-law weighted mean of a time series.
%              timeseries.minclp - ------------------------------------------------------------------------------
%                 timeseries.pdm - Periodicity search using period dispersion minimization
%            timeseries.pdm_phot - --------------------------------------------------------------------
%              timeseries.period - Periodicity search in a non-equally spaced time series
%      timeseries.period_complex - Fourier transform of non equally spaced time series
%   timeseries.period_consistent - SHORT DESCRIPTION HERE
%      timeseries.period_entropy - Periodogram using information entropy
%       timeseries.period_events - -----------------------------------------------------------------------------
%          timeseries.period_fft - Power spectrum of evenly spaced time series using fft
%   timeseries.period_fitfourier - Fit a Fourier series to a time series
%           timeseries.period_mi - SHORT DESCRIPTION HERE
% timeseries.period_min_curve_length - Periodicity search using minimum curve length
%         timeseries.period_norm - Normalized power spectrum of non equally spaced time series
% timeseries.period_norm_bootstrap - Run bootstrap normal pertiodogram on a light curve.
%  timeseries.period_norm_order2 - 2nd order harmonic power spectrum of non evenly spaced time series
% timeseries.period_norm_solarsys - Normalized power spectrum for a Solar System object
%       timeseries.period_normnl - Normzlied power spectrum using no loops (may be faster in some cases)
%           timeseries.period_np - SHORT DESCRIPTION HERE
%          timeseries.period_pdm - SHORT DESCRIPTION HERE
%         timeseries.period_plot - SHORT DESCRIPTION HERE
%       timeseries.period_proper - SHORT DESCRIPTION HERE
%      timeseries.period_scargle - Scargle power spectrum of non equally spaced time series
%    timeseries.period_scarglenl - Scargle power spectrum of non equally spaced time series / no loops
%            timeseries.periodia - Classical power spectrum of non-evenly space time series (OBSOLETE)
%            timeseries.periodis - Scargle periodogram. OBSOLETE: Use period.m instead.
%            timeseries.periodit - Calculate the periodogram as a function of time (will be removed)
%    timeseries.periodmulti_norm - Simultanous power spectrum of time series with common times
%       timeseries.phot_event_me - --------------------------------------------------------------------
%     timeseries.plot_inspect_lc - plot and inspect light curve and power spectrum
%  timeseries.plot_period_folder - ------------------------------------------------------------------------------
%            timeseries.polysubs - Fit and subtract polynomials from a timeseries [T,Y].
%        timeseries.ps_whitening - --------------------------------------------------------------------------
% timeseries.random_time_sequence - Generate random times for an astronomical time series.
%    timeseries.resample_uniform - Uniform resampling of a non-evenly spaced time series.
%      timeseries.rmsflux_select - Select points in an flux/mag vs. rms like diagram
%             timeseries.runmean - Running mean of un-evenly spaced time series
%            timeseries.runmean1 - Running mean on equally spaced 1-D vector
%           timeseries.sf_interp - --------------------------------------------------------------------------
%        timeseries.sgolayInterp - Savitzky-Golay filter and interpolation for non equally spaced data.
%       timeseries.simulated_elc - Simulated photons light curve
%             timeseries.specwin - Power spectrum window (use timeseries.period instead)
%            timeseries.stdfilt1 - Standart deviation filter
%     timeseries.subtract_back1d - ------------------------------------------------------------------------------
%              timeseries.sysrem - Apply the Tamuz et al. sysrem decomposition to a matrix of residuals
%               timeseries.taper - Generate a taper function
%            timeseries.unitTest - Package Unit-Test
%               timeseries.xcorr - Calculate the \chi2 and cross correlation between two time series.
 help timeseries.allFunList