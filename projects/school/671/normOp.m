function [ output_args ] = normOp( input_args , weight)
if nargin < 2
    output_args = sqrt(innerProduct(input_args,input_args));
else
    output_args = sqrt(innerProduct(input_args,input_args,weight));
end
end

