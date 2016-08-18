function distance=metric(x,y)
% Currently represents hamming distances. work on changing it to euclidian
% distances

%% Hamming distances


%% Euclidean distance when value is not real; otherwise Hamming distance
if ~isfloat(x) && ~isfloat(y)
%     fprintf('Hamming\n');
    if x==y
        distance=0;
    else
        distance=1;
    end
else
%     fprintf('Euclidean\n');
    distance = sqrt((real(y)-real(x))^2+(imag(y)-imag(x))^2);
end

end
