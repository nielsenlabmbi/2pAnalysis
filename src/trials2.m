function [all_stimuli, trial,Info,center] = trials2(filePath,fullfile,varargin)
% INPUTS: fullfile is file name, varargin can specify the highpass gaussian
% width or the length of the kernel.
% OUTPUTS: trial is a 1 x ntrials struct with two fields, signal and stimuli.
% trial(i).signal is a 1x1 struct with two fields, signal and signal times.
% trial(i).stimuli is a 1x1 struct with three fields, stimuli, stimuli_times,
% and blank_times.
% Gets the time of each cell response within each trial, adjusting for line
% position. Filters the signal with a highpass gaussian with width 5s
% unless otherwise specified by varagin. Also gets the stimuli and stimulus
% times (converted from frames) for each trial. 

%% Time correction for signals
% this gets the timecourse for each cell by converting frames to seconds and adjusting for line

% for each cell, identify the coordinates of each of the pixels of the cell

%fullfile = 'ftad4_002_006';

fullfile = strcat(filePath,fullfile);

load([fullfile '.segment'],'-mat');
load([fullfile,'.signals'],'-mat');
load([fullfile,'.mat'],'-mat');
load([fullfile,'.image'],'-mat');

ncells = max(mask(:));
center = zeros(ncells,2);
for i = 1:ncells
    [x, y] = find(mask == i);
    center(i,:) = [mean(x) mean(y)];%cell center of mass, 512x796 double
end

% compute the necessary time adjustment per cell
rounded = round(center(:,1)); %round to the nearest line

% line_adjust is the time in s after the onset of imaging the frame that the
% cell was imaged, where the row number denotes the cell. 
line_adjust = (rounded-1)*1/info.resfreq; %subtract 1 such that line 1 is at time 0. 

% adjust for the frame: get time series for the signals
frame_rate = info.resfreq/info.config.lines; %line rate/no.lines
nframes = length(signals(:,1))-1;

frame_adjust= (0:nframes)'*1/frame_rate; %convert frames to seconds, beginning with the zero frame as time 0.

full_line_adjust = repmat(line_adjust',nframes + 1,1); 
full_frame_adjust = repmat(frame_adjust,1,ncells);


cell_timecourse = full_line_adjust + full_frame_adjust; 
%% High-pass filter the cell signal (for the whole session)
filtered_signals = zeros(size(signals));
if nargin > 1 && isnumeric(varargin{1})
    for i = 1:ncells
        filtered_signals(:,i) = highpass_gaussian(varargin{1}, signals(:,i)', frame_rate);
    end
filter_params = struct('type',{'highpass gaussian'},'width_ms',varargin{1}*1000);
else
    for i = 1:ncells
    filtered_signals(:,i) = highpass_gaussian(5, signals(:,i)', frame_rate);
    end
    filter_params = struct('type',{'highpass gaussian'},'width_ms',5*1000);
end

%% Get the stimuli and stimuli timing per trial

load([fullfile '.log'],'-mat');
load([fullfile(1:end-7) 'u' fullfile(end-6:end) '.analyzer'],'-mat');

frame_adjust = info.frame*1/frame_rate; %frames start at 0
line_adjust = info.line*1/info.resfreq; %lines also start at 0

stimuli_timecourse = frame_adjust + line_adjust;

%get the number of trials and stimuli presented 

a = whos(matfile([fullfile,'.log']));
ntrials = size({a(:).name},2)-2*strcmp(a(1).name,'domains'); %two fields occupied by domains and frate
rseeds = [];
[param,loops] = reformat(Analyzer);
[~,triallist] = sort(loops);
for i = 1:ntrials;
    rseeds = [rseeds eval(strcat('rseed',num2str(triallist(i))))];
end


%%
stimulus_by_trial = cell(1,ntrials);
trial_stimulus_timing = cell(1,ntrials);
trial_blanks_timing = cell(1,ntrials);

test_case = strcmp(a(1).name,'domains');
switch test_case
    
    case 0;
    domains.oridom = rseeds(1).oridom';
    domains.sfdom = rseeds(1).sfdom';
    domains.phasedom = rseeds(1).phasedom';
    
   ind = find(info.event_id ==2);
   ind = ind(1:2:end);
   stimuli_timecourse = stimuli_timecourse(ind);
   stim_rate = param.stim_time/param.h_per; %Hz
   stim_dur = param.stim_time; 
   trial_timecourse = repmat([0:1/stim_rate:stim_dur-1/stim_rate],length(stimuli_timecourse),1);
   stimuli_timecourse = trial_timecourse' +repmat(stimuli_timecourse,1,length([0:1/stim_rate:stim_dur-1/stim_rate]))';
   trial_timecourse = trial_timecourse';
   stimuli_timecourse = stimuli_timecourse(:);

   for i = 1:ntrials %for each of the ntrials trials
       idx = ~rseeds(i).blankflag;
       if isfield(rseeds(i),'adaptflag');
           idx2 = ~rseeds(i).adaptflag;
       else
           idx2 = idx;
       end
    stimulus_by_trial{i} = [(domains.oridom(rseeds(i).oriseq(idx & idx2))) domains.sfdom(rseeds(i).sfseq(idx & idx2)) ...
            (domains.phasedom(rseeds(i).phaseseq(idx & idx2)))]; %(domains.colordom(rseeds(i).colorseq(idx))')
    
    idxb =~idx; %blank trials
    
    %let time 0 within each trial be the onset of the first stimulus. each
    %trial has length(info.frame)/ntrials event
    trial_stimulus_timing{i} = trial_timecourse(idx & idx2,i);
    trial_blanks_timing{i} = trial_timecourse(idxb,i);
   end
    nevents = size(trial_timecourse,1);
    
case 1;

for i = 1:ntrials %for each of the ntrials trials
    idx = find(rseeds(i).sfseq < length(domains.sfdom)+1); %stimuli trials
        
    stimulus_by_trial{i} = [(domains.oridom(rseeds(i).oriseq(idx))') domains.sfdom(rseeds(i).sfseq(idx))' ...
            (domains.phasedom(rseeds(i).phaseseq(idx))') (domains.colordom(rseeds(i).colorseq(idx))')]; %
    
    idxb =(rseeds(i).sfseq == length(domains.sfdom)+1); %blank trials
    
    %let time 0 within each trial be the onset of the first stimulus. each
    %trial has length(info.frame)/ntrials events
    nevents = length(info.frame)/ntrials;
    t_stim = stimuli_timecourse(1 + nevents*(i-1):nevents*i) - stimuli_timecourse(1 + nevents*(i-1));
    trial_stimulus_timing{i} = t_stim(idx);
    trial_blanks_timing{i} = t_stim(idxb);
end
end
%% Get the cell response by trial

trials_all = cell2mat(trial_stimulus_timing);
trial_duration = mean(trials_all(end,:));

if nargin > 1 && isa(varargin{1},'cell'); 
    pre_trial = floor(frame_rate*varargin{1}{1});
    post_trial = floor(frame_rate*varargin{1}{2});
elseif nargin > 2 && isa(varargin{2},'cell'); 
    pre_trial = floor(frame_rate*varargin{2}{1});
    post_trial = floor(frame_rate*varargin{2}{2});
else
    pre_trial = floor(frame_rate*.5);
    post_trial = floor(frame_rate*2);
end
%%
trial_length = ceil(trial_duration*frame_rate) + pre_trial + post_trial + 1; % (+1 is for time zero)

trial_cell_response = cell(1,ntrials);
trial_cell_response_time = cell(1,ntrials);

for i = 1:ntrials
    %let time 0 within each trial be the onset of the first stimulus
    for j = 1:ncells
        %find the cell response in the kernel. Default beginning 500ms before trial time onset
        %(i.e. onset of the first stimulus of the trial) through 2000ms
        %after the last stimulus of the trial. This is so that later we can
        %look at the -500ms:2000ms window around each stimulus.
        zero = find(cell_timecourse(:,j) >= stimuli_timecourse(nevents*(i-1)+1),1,'first'); 
        first = zero-pre_trial;
        trial_cell_response_time{i}(:,j) = cell_timecourse(first:first + trial_length,j) - stimuli_timecourse(1 + nevents*(i-1)); %let time  of stimulus be time 0
        trial_cell_response{i}(:,j) = filtered_signals(first:first + trial_length,j);
    end
end
%% Create structures for the trial signals and stimuli and the times associated
for i = 1:ntrials
    trial(i).signal = struct('signal', trial_cell_response(:,i), 'signal_times', trial_cell_response_time(:,i));
    trial(i).stimuli = struct('stimuli', stimulus_by_trial(:,i), 'stimuli_times', trial_stimulus_timing(:,i),...
        'blanks_times', trial_blanks_timing(:,i));
end
%% 
all_stimuli = cell2mat(stimulus_by_trial');

%% create Info struct
Info = struct('ncells',ncells, 'ntrials',ntrials,...
    'stimuli_per_trial', nevents, 'image',avgImage, 'mask', mask, ...
    'maskFlags',maskFlags, 'filter', filter_params);

end
function [filtered_signal] = highpass_gaussian(Width, signal, frame_rate)
% This function takes a signal for a given trial and takes the gaussian
% high pass filter of width Width.

HWidth = Width*frame_rate;
N = length(signal); 
dom = (1:N) - round(N/2);
H = exp(-dom.^2/(2*HWidth^2));
H = -H/sum(H);
H(round(N/2)) = 1 + H(round(N/2));
hh = abs(fft(H));
filtered_signal = ifft(fft(signal).*hh);

end

function [param, loops] = reformat(Analyzer)
% reformats the analyzer parameter file into something more easily
% readable.
for i = 1:length(Analyzer.P.param);
param.(eval(strcat('Analyzer.P.param{',num2str(i),'}{1}'))) = ...
    eval(strcat('Analyzer.P.param{',num2str(i),'}{3}'));
end

for i = 1:length(Analyzer.loops.conds);
    loops(i) = Analyzer.loops.conds{i}.repeats{1}.trialno;
end
end