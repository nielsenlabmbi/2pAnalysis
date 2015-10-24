function S = oriAdd(S)

% Add parameter using ori parameter

% length of current params
n = length(S.params);
% index of ori param
i = find(strcmp(S.params,'ori'));

% add names of ori2 and dir
S.params{n+1} = 'ori2';
S.params{n+2} = 'dir';

% add events of ori2 and dir
S.events(:,n+1:n+2) = [S.events(:,i) S.events(:,i)];
S.events(S.events(:,i) > 179,n+1) = S.events(S.events(:,i) > 179,n+1) - 180;
S.events(S.events(:,i) < 180,n+2) = 1;
S.events(S.events(:,i) > 179,n+2) = -1;
