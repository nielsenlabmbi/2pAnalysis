function [y,f] = normFilt(y,s,n)

% Filter signal, y, with a one-sided gaussian with sigma, s. Filter signal
% over n columns.

% default sigma is 1
if nargin < 2;  s = 1;  end
% defult columns extend as far as the gaussian is greater than 1% of area
if nargin < 3;  n = ceil(s*sqrt(-2*log(.01*sqrt(2*pi)*s)));  end

% get the one-sided gaussian filter
g = normpdf(1-n:0,0,s);
f = g/sum(g);

% convert signal into a column vector for filtering
z = [repmat(y(1),[n-1 1]);y(:)];

% filter the signal
for i = 1:length(y)
    y(i) = f*z(i:i+n-1);
end

