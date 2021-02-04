function [F6] = EnergyConcentrationMeasure (p)
%Calcula unamedida de la concentración de energía

F6 = sum(sum(abs(p).^0.5))^2;

