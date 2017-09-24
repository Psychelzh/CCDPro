function [y, m, s] = raw2norm(x, varargin)
%RAW2NORM tansforms raw score to normalized score and scale them.
%   Y = RAW2NORM(X) use the scale 100 mean and 15 deviation, removing NaN's
%   by default.
%
%   Y = RAW2NORM(X, mean, sd) explicitly tells the program the mean and
%   standard deviation for the data X.
%
%   Y = RAW2NORM(X, ..., Name, Value) does the scaling works according to
%   the specified parameters using the following Name, Value pairs:
%               Center - specifies the scaling center for the
%                        normalization, defalut: 100.
%                Scale - specifies the scaling size for the normalization,
%                        default: 15.
%       MissingRemoval - tells the program to remove missing values or not.
%                        Default: true.
%              Missing - explicitly tells the program the missing value of
%                        the data. Default: NaN.

% Author: Zhang, Liang.
% Date: August 2016.
% E-mail: psychelzh@gmail.com

% Parse input arguments.
par = inputParser;
addOptional(par, 'Mean', [], @isnumeric);
addOptional(par, 'Deviation', [], @isnumeric);
parNames   = { 'Center',  'Scale',              'MissingRemoval',      'Missing'  };
parDflts   = {    100,       15,                      true,               nan     };
parValFuns = {@isnumeric, @isnumeric, @(x) islogical(x) | isnumeric(x), @isnumeric};
cellfun(@(x, y, z) addParameter(par, x, y, z), parNames, parDflts, parValFuns);
parse(par, varargin{:});
m    = par.Results.Mean;
s    = par.Results.Deviation;
ctr  = par.Results.Center;
scl  = par.Results.Scale;
rm   = par.Results.MissingRemoval;
miss = par.Results.Missing;
if xor(isempty(m), isempty(s))
    warning('CCDPRO:RAW2NORM', 'Missing input or redundant input arguments found.')
    y = nan;
    return
end
if isempty(m)
    if ~rm
        m = mean(x);
        s = std(x);
    else
        x(arrayfun(@(elem) isequaln(elem, miss), x)) = nan;
        m = nanmean(x);
        s = nanstd(x);
    end
end
%Normalization.
ynorm = (x - m) / s;
y     = ynorm * scl + ctr;
