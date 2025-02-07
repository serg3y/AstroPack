function BolMag=blackbody_bolmag(Temp,Radius,Dist)
% Bolometric magnitude of black body spectrum
% Package: astro.spec
% Description: Calculate the bolometric magnitude of a black body spectrum,
%              given its temperature, radius and distance.
% Input  : - Vector of black body temperature [K].
%          - Black body radius [cm], default is 1cm.
%          - Distance [pc], default is 10pc.
% Output : - Black body bolometric magnitude.
%            Normalized such m_bol=0 = 2.48e-5 erg cm^-2 s^-1.
%            Sun bol lum = 3.845e33 erg s^-1 = bol mag +4.74.
% Tested : Matlab 7.0
%     By : Eran O. Ofek                    Feb 2007
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% See Also: blackbody_mag_c.m
% Example: BolMag=AstroUtil.spec.blackbody_bolmag([5700;6000],696000e5,10);
% Reliable: astro
%------------------------------------------------------------------------------
Pc  = constant.pc;

Def.Radius = 1;
Def.Dist   = 10;
if (nargin==1)
   Radius = Def.Radius;
   Dist   = Def.Dist;
elseif (nargin==2)
   Dist   = Def.Dist;
elseif (nargin==3)
   % do nothing
else
   error('Illegal number of input arguments');
end

Nt = length(Temp);

if (length(Radius)==1)
   Radius = Radius.*ones(Nt,1);
end

if (length(Dist)==1)
   Dist = Dist.*ones(Nt,1);
end



WaveRange = logspace(2,6,1000).';
BolMag    = zeros(Nt,1).*NaN;
for It=1:1:Nt
   %[Il,If] = black_body(Temp(It),WaveRange);
   Il      = astro.blackbody(Temp(It),WaveRange,'cgs/A','ang','mat');
   %Spec    = [WaveRange, Il.*1e-8 .* 4.*pi.* Radius(It).^2 ./(4.*pi.*(Dist(It).*Pc).^2)];
   Spec    = [WaveRange, Il(:,2) .* 4.*pi.* Radius(It).^2 ./(4.*pi.*(Dist(It).*Pc).^2)];
   BolMag(It) = -2.5.*log10(trapz(Spec(:,1),Spec(:,2))./2.48e-5);
end
