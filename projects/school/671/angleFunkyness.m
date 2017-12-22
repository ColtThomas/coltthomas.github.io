function [theta] = angleFunkyness(V1,V2,incr,t)
%angleFunkyness - Calculates the angle between two vectors

tmp = V1.*V1*incr;
normV1 = sum(tmp(1:length(t)-1));

tmp = V2.*V2*incr;
normV2 = sum(tmp(1:length(t)-1));

tmp = V1.*V2*incr;
dotProd = sum(tmp(1:length(t)-1));
theta = acos(dotProd/(normV1 * normV2))/pi*180;

end

