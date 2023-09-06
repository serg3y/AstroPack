function [MatchedCat,MatchedRef,Res,IndBest,H2]=pattern_match_shift_rot(Cat,Ref,VecRot,Flip,varargin)
% Match two [X,Y] catalogs by shift and rotation and pattern recognition 
% Package: ImUtil.Im
% Description: Given two catalogs of coordinates X,Y - look for pattern
%              matching in shift and rotation (without scale change).
%              For each trial rotation use pattern_match_shift.m
% Input  : - An AstCat object containing a single catalog.
%            Sorted by Y coordinate.
%          - A reference AstCat object containing a single catalog.
%            Sorted by Y coordinate.
%          * Arbitrary number of pairs of arguments: ...,keyword,value,...
%            where keyword are one of the followings:
%            'VecRot'   - Vector of rotations [degress] to check.
%                         Default is (-2:0.5:2).';
%            'ColCatXY' - Cell array of column names or vector of column
%                         indices containing the X/Y columns in the input
%                         catalog. Default is [1 2].
%            'ColRefXY' - Cell array of column names or vector of column
%                         indices containing the X/Y columns in the input
%                         reference. Default is [1 2].
%            'CatSel'   - A string containing a selection criteria for rows
%                         in the input catalog to use in the matching.
%                         E.g., 'APER_MAG>14 & APER_MAG<18'.
%                         Alternatively, this can be a vector of indices or
%                         a vector of logicals indicating which rows to
%                         use. If empty use all. Default is empty.
%            'RefSel'   - A string containing a selection criteria for rows
%                         in the input reference to use in the matching.
%                         E.g., 'APER_MAG>14 & APER_MAG<18'.
%                         Alternatively, this can be a vector of indices or
%                         a vector of logicals indicating which rows to
%                         use. If empty use all. Default is empty.
%            'MaxPeaksCheckI' - MaxPeaksCheck while checking for individual
%                         rotations. Default is 0.
%            'MaxPeaksCheckF' - MaxPeaksCheck while checking for the final
%                         rotations. Default is 10.
%            'MatchShiftPar' - Cell array of key,val arguments to pass to
%                         pattern_match_shift.m. Default is {}.
%            --- Additional parameters
%            Any additional key,val, that are recognized by one of the
%            following programs:
%            AstCat/pattern_match_shift.m, pattern_match_shift.m
% Output : - [MatchedCat,MatchedRef,Res,IndBest,BestRotation,H2]
% License: GNU general public license version 3
% Tested : Matlab R2015b
%     By : Eran O. Ofek                    Mar 2016
%    URL : http://weizmann.ac.il/home/eofek/matlab/
% Example:
% [MatchedCat,MatchedRef,Res,IndBest,BestRotation,H2]=ImUtil.Im.pattern_match_shift_rot(Cat,Ref);
% Reliable: 2
%--------------------------------------------------------------------------

DefV.ColCatXY           = [1 2];
DefV.ColRefXY           = [1 2];
DefV.VecRot             = (-2:0.5:2).';
DefV.Flip               = [1 1];  % flips to check
%DefV.CatSel             = [];
%DefV.RefSel             = [];
DefV.MaxPeaksCheckI     = 0;
DefV.MaxPeaksCheckF     = 10;
DefV.ImSize             = [];
DefV.MatchShiftPar      = {};
%InPar = set_varargin_keyval(DefV,'n','use',varargin{:});
InPar = InArg.populate_keyval(DefV,varargin,mfilename);

OrigColXY = {'dup_X','dup_Y'};

%--- reference catalog ---
% X/Y columns in Ref
%RefColInd = colname2ind(Ref,InPar.ColRefXY);
% Select specific rows from Ref
% if (~isempty(InPar.RefSel)),
%     RefFlag   = col_arith(Ref,InPar.RefSel,'mat');
%     Ref       = row_select(Ref,RefFlag);
% end

%--- input catalog ---
% X/Y columns in Cat
%CatColInd = colname2ind(Cat,InPar.ColCatXY);
% Select specific rows from Cat
% if (~isempty(InPar.CatSel)),
%     CatFlag   = col_arith(Cat,InPar.CatSel,'mat');
%     Cat       = row_select(Cat,CatFlag);
% end

% ImSize must be supplied:
% This is needed for 1. Flips, 2. Center the coordinate system
if (isempty(InPar.ImSize))
    error('ImSize must be specified');
end

Nrot   = numel(InPar.VecRot);
Nflip  = size(InPar.Flip,1);
VecNm  = zeros(Nrot,Nflip);
for Iflip=1:1:Nflip
    % For each Flip option in InPar.Flip:
    %CatFlip = flip_center(Cat,InPar.Flip(Iflip,:),InPar.ImSize.*0.5,InPar.ColCatXY);
    
    Cat = ImUtil.Im.flip_coo_list(Cat,Flip(Iflip,:),InPar.ImSize.*0.5,InPar.ColCatXY);
   
    for Irot=1:1:Nrot
        % For each rotation value in InPar.VecRot:
        
        % Build rotation transformation
        CatRot = ImUtil.Im.list_rotate(Cat,InPar.VecRot(Irot),[0 0]);
        %[CatRot] = cat_rotate(Cat,InPar.VecRot(Irot),[0 0]);
        
        %AstT = cell2asttran({'x_shift',0;'y_shift',0;'xy_rot',[cosd(InPar.VecRot(Irot)), sind(InPar.VecRot(Irot))]});
        % apply rotation
        %[CatRot]=transform(AstT,CatFlip);

        % sort Sim catalog by Y
        if (InPar.MaxPeaksCheckI>0)
            CatRot = sortrows(CatRot,2);
        end

        % Assuming the Flip and Rotation look for the best
        % pattern matching:
        [Res,IndBest]=ImUtil.Im.pattern_match_shift(CatRot,Ref,InPar.MatchShiftPar{:},...
                                            'CatSelect',{},...
                                            'RefSelect',{},...
                                            'MaxPeaksCheck',InPar.MaxPeaksCheckI);

        %[Res(IndBest).Nmatch, Res(IndBest).Std]  
        if (isempty(IndBest))
            VecNm(Irot,Iflip) = 0;
        else
            if (InPar.MaxPeaksCheckI>0)
                VecNm(Irot,Iflip) = Res(IndBest).Nmatch;
            else
                VecNm(Irot,Iflip) = Res(IndBest).MaxHistMatch;
            end
        end
    end

end
% look for rotation with largest number of matches
if (all(VecNm==0))
    % no match found
    MatchedCat     = Cat;
    Ncol           = size(Cat.Cat,2);
    MatchedCat.Cat = zeros(0,Ncol);
    MatchedRef     = Ref;
    Ncol           = size(Ref.Cat,2);
    MatchedRef.Cat = zeros(0,Ncol);
    Res            = [];
    IndBest        = [];
    H2             = [];
else
    [~,Imax] = Util.stat.maxnd(VecNm);
    BestFlip = InPar.Flip(Imax(2),:);
    BestRot  = InPar.VecRot(Imax(1));

    % duplicate original X/Y columns at the end of cat
    %Cat     = col_duplicate(Cat,CatColInd,OrigColXY);
    
    % flip and rotate X/Y
    % but note there is a copy of the original values in the catalog
    %CatFlip = flip_center(Cat,BestFlip,InPar.ImSize.*0.5,CatColInd);
    CatFlip = ImUtil.Im.flip_coo_list(Cat,BestFlip,InPar.ImSize.*0.5,InPar.ColCatXY);

    CatRot = ImUtil.Im.list_rotate(CatFlip,BestRot,[0 0]);
    
%     AstT = cell2asttran({'x_shift',0;'y_shift',0;'xy_rot',[cosd(BestRot), sind(BestRot)]});
%     [CatRot,~]=transform(AstT,CatFlip);

    % sort Sim catalog by Y
    CatRot = sortrows(CatRot,2);

    %[Res,IndBest,H2]=pattern_match_shift(SimCFrot.Cat,RC.Cat,...
    [Res,IndBest,H2]=ImUtil.Im.pattern_match_shift(CatRot,Ref,InPar.MatchShiftPar{:},...
                                            'CatSelect',{},...
                                            'RefSelect',{},...
                                            'MaxPeaksCheck',InPar.MaxPeaksCheckF);

    % unrotate catalog
    Cat = ImUtil.Im.list_rotate(CatRot,-BestRot,[0 0]);
    
%     AstT = cell2asttran({'x_shift',0;'y_shift',0;'xy_rot',[cosd(-BestRot), sind(-BestRot)]});
%     [Cat,~]=transform(AstT,CatRot);
    % copy origonal values
    %Cat.Cat(:,1:2) = CatRot.Cat(:,3:4);
    
    MatchedCat = Cat(Res(IndBest).IndCat,:);
    MatchedRef = Ref(Res(IndBest).IndRef,:);
    
    %MatchedCat = row_select(Cat,Res(IndBest).IndCat);
    %MatchedRef = row_select(Ref,Res(IndBest).IndRef);

    Res(IndBest).BestRot  = BestRot;
    Res(IndBest).BestFlip = BestFlip;
end