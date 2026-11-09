function [okay,unitSI,factor,offset] = make_SI_unit(unit)
%MAKE_SI_UNIT Summary of this function goes here
%   Detailed explanation goes here
% [okay,unitSI,factor,offset] = make_SI_unit(unit)
%
% Sucht die passende SI-Einheit (unitSI) zu Eingabe(unit) und der
% Unrechnungsfaktoren
%
[okay,unitSI,factor,offset] = mex_make_SI_unit(unit);
