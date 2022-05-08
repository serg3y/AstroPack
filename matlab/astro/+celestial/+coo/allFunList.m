% Functions and Classes list for the celestial.coo package
% Author : autogenerated (May 2022)
%       celestial.coo.aberration - Apply aberration of light to source position
%       celestial.coo.add_offset - Offset a position by angular distance and position angle
%          celestial.coo.airmass - Airmass from time and object and observer position
%           celestial.coo.alt2ha - Convert altitude and declnation to hour angle
%        celestial.coo.altha2dec - Convert altitude and hour angle to declination
%      celestial.coo.angle_in2pi - Convert an angle to the 0 to 2*pi range
% celestial.coo.area_sphere_polygon - Area of a polygon on a sphere
%      celestial.coo.azalt2hadec - Convert Az/Alt to HA/Dec
%   celestial.coo.boundingCircle - fit the smallest-radius bounding circle to set of X, Y points
%          celestial.coo.calc_pm - --------------------------------------------------------------------------
% celestial.coo.cel_annulus_area - Area within a celestial annulus
%   celestial.coo.celestial_circ - Grid of coordinates on a small spherical circle
%   celestial.coo.center2corners - Return field corners given its center and size
%             celestial.coo.coco - Convert between different coordinates (OBSOLETE: use convert_coo)
%   celestial.coo.continuousLong - Given a matrix of longitude, make the longitude in columns or rows continuous.
% celestial.coo.convert2equatorial - Convert coordinates/name to apparent equatorial coordinates.
%      celestial.coo.convert_coo - Convert between different coordinates
%       celestial.coo.convertdms - Convert between various representations of coordinates and time
%      celestial.coo.convertdms1 - --------------------------------------------------------------------------
%          celestial.coo.coo2box - Calculate box vertices around coordinates (OBSOLETE: use coo2box)
%      celestial.coo.coo2cosined - Coordinates to cosine directions
%     celestial.coo.coo_resolver - Resolve coordinates or target name into RA/Dec
%          celestial.coo.cosined - Convert between coordinates and cosine directions
%      celestial.coo.cosined2coo - Cosine direction to coordinates
%          celestial.coo.dome_az - --------------------------------------------------------------------------
% celestial.coo.ecliptic2helioecliptic - Ecliptic longitude to Helio-ecliptic longitude
% celestial.coo.fit_proper_motion - SHORT DESCRIPTION HERE
%      celestial.coo.fit_scircle - 
%   celestial.coo.geocentric2lsr - Geocentric or heliocentric velocity to velocity relative to the LSR
%  celestial.coo.get_skytile_coo - -----------------------------------------------------------------------
%           celestial.coo.ha2alt - Hour angle to altitude and airmass
%            celestial.coo.ha2az - Convert hour angle and declination to azimuth, altitude and airmass
%      celestial.coo.hadec2azalt - Convert HA/Dec to Az/Alt
%           celestial.coo.hardie - The Hardie airmass formula
%       celestial.coo.hardie_inv - Convert hardie airmass to altitude
%        celestial.coo.horiz_coo - Celestial equatorial coordinates to horizontal coordinates
%           celestial.coo.in_box - Check if celestial coordinates are in a box (approximate).
% celestial.coo.inside_celestial_box - Check if coorduinates are within box
%       celestial.coo.interp_coo - Interpolate celestial coordinates as a function of time
% celestial.coo.is_coordinate_ok - Check that coordinates satisfy some observability conditions
% celestial.coo.light_abberation - --------------------------------------------------------------------------
% celestial.coo.light_deflection - ------------------------------------------------------------------------------
%      celestial.coo.nearest_coo - ------------------------------------------------------------------------------
%         celestial.coo.nutation - Intermidiate accuracy IAU 1984 nutation
%     celestial.coo.nutation1980 - --------------------------------------------------------------------------
%  celestial.coo.nutation2rotmat - --------------------------------------------------------------------------
%  celestial.coo.nutation_lowacc - --------------------------------------------------------------------------
%        celestial.coo.obliquity - Calculate the obliquity of the Earth ecliptic.
%   celestial.coo.parallactic2ha - Convert parallactic angle and declinatio to hour angle
% celestial.coo.parallactic_angle - ------------------------------------------------------------------------------
%    celestial.coo.parseCooInput - Parse RA/Dec coordinates
%  celestial.coo.pm2space_motion - --------------------------------------------------------------------------
%        celestial.coo.pm_eq2gal - SHORT DESCRIPTION HERE
%        celestial.coo.pm_vector - --------------------------------------------------------------------------
%        celestial.coo.points2gc - Convert two points on a sphere to great circle representation (Lon, Lat, Az)
%  celestial.coo.polar_alignment - Calculate the RA/Dec drift due to equatorial polar alignemnt error.
% celestial.coo.polar_alignment_drift - Calculate the RA/Dec drift due to equatorial polar alignemnt error.
% celestial.coo.polar_alignment_tracking_error - 
% celestial.coo.pole_from2points - Find pole of a great circle defined by two points on the sphere.
%       celestial.coo.precession - Calculate the Earth precession parameters
%    celestial.coo.proper_motion - Applay proper motion to a catalog
% celestial.coo.proper_motion_parallax - Applay proper motion and parallax to a catalog
%       celestial.coo.refraction - Estimate atmospheric refraction, in visible light.
% celestial.coo.refraction_coocor - Atmospheric refraction correction for equatorial coordinates.
%  celestial.coo.refraction_wave - --------------------------------------------------------------------------
%         celestial.coo.rotm_coo - Rotation matrix for coordinate conversion
%        celestial.coo.shift_coo - Shift spherical coordinates by lon/lat.
% celestial.coo.sky_area_above_am - Calculate sky area observable during the night above a specific airmass.
% celestial.coo.solve_alignment6dof_problem - 
%      celestial.coo.sphere_dist - angular distance and position angle between two points on the sphere
% celestial.coo.sphere_dist_cosd - Angular distance between a set of two cosine vector directions.
% celestial.coo.sphere_dist_fast - --------------------------------------------------------------------------
% celestial.coo.sphere_dist_fastSmall - Spherical distance approximation for small angular distances
% celestial.coo.sphere_dist_fastThresh - Calculate angular distances only for sources with Dec diff below threshold.
% celestial.coo.sphere_dist_fast_thresh - --------------------------------------------------------------------------
% celestial.coo.sphere_dist_thresh - --------------------------------------------------------------------------
%      celestial.coo.sphere_move - Applay offset to RA and Dec
%    celestial.coo.sphere_offset - --------------------------------------------------------------------------
% celestial.coo.spherical_tri_area - ------------------------------------------------------------------------------
% celestial.coo.spherical_triangle_circum_circle - Calculate the radius of the circum circle of a spherical triangle
% celestial.coo.spherical_triangle_inscribed_circle - Calculate the radius of the inscribed circle of a spherical triangle
% celestial.coo.star_conjunctions - Calculate conjuctions between stars given their proper motion.
% celestial.coo.star_conjunctions_montecarlo - SHORT DESCRIPTION HERE
%     celestial.coo.tile_the_sky - Tile the celestial sphere
% celestial.coo.topocentricVector - Calculate the topocentric vector of an observer.
%  celestial.coo.topocentric_vec - --------------------------------------------------------------------------
%         celestial.coo.unitTest - 
 help celestial.coo.allFunList