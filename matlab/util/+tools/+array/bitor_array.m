function Val=bitor_array(Array, Dim, UseMex)
% Perform a bitor operation along all elements in an array.
% Package: Util.array
% Description: Perform a bitor operation along all elements in an array
%              along a specific dimension.
% Input  : - An array of integers.
%          - Dimension along to perform the bitor operation. Default is 1.
%          - Flag, true to use MEX optimization if possible. Default is 1.
% Output : - The result of the bitor operation.
% See also: sum_bitor.m (the same)
% License: GNU general public license version 3
% Tested : Matlab R2015b
%     By : Eran O. Ofek                    Jun 2016
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example: Val=tools.array.bitor_array(Array);
% Reliable: 2
%--------------------------------------------------------------------------

if (nargin==1)
    Dim = 1;
end

if (nargin < 3)
    UseMex = false;
end

C = lower(class(Array));
switch C
    case {'uint8','int8'}
        Nbit = 8;
        Fun  = @uint8;
    case {'uint16','int16'}
        Nbit = 16;
        Fun  = @uint16;
    case {'uint32','int32'}
        Nbit = 32;
        Fun  = @uint32;
    case {'uint64','int64'}
        Nbit = 64;
        Fun  = @uint64;
    otherwise
        error('Unknown class - only integers are allowed');
end

% Check if we can use MEX implementation, convert input to uint64
if UseMex && (ndims(Array) <= 3)
    if ~strcmp(C, 'int64') && ~strcmp(C, 'uint64')
        Array = uint64(Array);
    end
    Val = mex_bitor_array64(Array, Dim);
    if ~strcmp(C, 'int64') && ~strcmp(C, 'uint64')
        Val = Fun(Val);
    end
        
else
    Val = 0;
    for Ibit=1:1:Nbit
        Val = Val + (2.^(Ibit-1)).*any(bitget(Array,Ibit),Dim);
    end

    % transform back to uint
    Val = Fun(Val);    
end


