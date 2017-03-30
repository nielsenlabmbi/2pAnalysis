function [Z_session, Stimuli, Info] = z_scored3(fname,trial,all_stimuli, center, Info, varargin)
%% Z-score the cell population, then take the mean and standard error of the z-scored responses for each unique stimuli

load(fname,'-mat');
frame_rate = info.resfreq/info.config.lines; %line rate/no.lines
%%
ntrials = size(trial,2);
z_score = cell(ntrials,1);
z_kernel_stim = cell(Info.ncells,1);
z_kernel_blanks = cell(Info.ncells,1);
z_stim_times = cell(Info.ncells,1);
z_blank_times = cell(Info.ncells,1);
%%
if nargin > 5 && isa(varargin{1},'cell'); 
    kernel_pre = floor(frame_rate*varargin{1}{1});
    kernel_post = floor(frame_rate*varargin{1}{2});
else
    kernel_pre = floor(frame_rate*.5); %within 500ms before the stimulus
    kernel_post = floor(frame_rate*2); %within 2s after the stimulus
end

kernel_length = kernel_pre + kernel_post + 1; 
kernel_times = (1:kernel_length)*1/frame_rate - (kernel_pre+1)*1/frame_rate;

%get z-scores per trial, the times of the stimulus, and the respective
%kernels
%%
for i = 1:ntrials
    z_score{i} = zscore(trial(i).signal.signal);
    bins = [trial(i).stimuli.stimuli_times; trial(i).stimuli.stimuli_times(end)+.5];
    [~, index] = histc(trial(i).signal.signal_times,bins);
    if ~isempty(trial(1).stimuli.blanks_times)
    bins2 = [trial(i).stimuli.blanks_times; trial(i).stimuli.blanks_times(end)+.5];
    [~, index2] = histc(trial(i).signal.signal_times,bins2);
    end
    for k = 1:Info.ncells
        [uniques, Zeros] = unique(index(:,k));
        Zeros = Zeros(uniques > 0);
        range = repmat(Zeros,1,length(-kernel_pre:kernel_post)) + repmat((-kernel_pre:kernel_post),length(Zeros),1);
        reps = repmat(z_score{i}(:,k),1,length(Zeros));
        z_kernel_stim{k}{i} = reps(range);
        
        reps = repmat(trial(i).signal.signal_times(:,k),1,length(Zeros));         
        z_stim_times{k} = [z_stim_times{k};reps(range)];  
        
        if ~isempty(trial(1).stimuli.blanks_times)
        [uniques,Zeros] = unique(index2(:,k));
        Zeros = Zeros(uniques > 0);
        range = repmat(Zeros,1,length(-kernel_pre:kernel_post)) + repmat((-kernel_pre:kernel_post),length(Zeros),1);
        reps = repmat(z_score{i}(:,k),1,length(Zeros));
        z_kernel_blanks{k}{i} = reps(range);
        
        reps = repmat(trial(i).signal.signal_times(:,k),1,length(Zeros));         
        z_blank_times{k} = [z_blank_times{k};reps(range)];  
        end
    end
end
%%
%get the mean within trial
trial_mean = cell(Info.ncells,1);
trial_blanks = cell(Info.ncells,1);
all_unique_stim = cell(ntrials,1);
    for j = 1:ntrials
    [all_unique_stim{j}, ixx] = unique(trial(j).stimuli.stimuli,'rows');
        for k = 1:length(all_unique_stim{j})
            unique_occurrence = ismember(trial(j).stimuli.stimuli,trial(j).stimuli.stimuli(ixx(k),:), 'rows');
            for i = 1:Info.ncells
            trial_mean{i}{j}(k,:) = mean(z_kernel_stim{i}{j}(unique_occurrence,:),1);
            if ~isempty(trial(1).stimuli.blanks_times)
            trial_blanks{i}{j} = mean(z_kernel_blanks{i}{j},1);
            end
            end
        end
    end
    all_unique = cell2mat(all_unique_stim);
%%
%get the unique stimuli, the occurrences of each of the stimuli in the session, and how
%often they occurred (how many trials they occured in)
%%
[unique_stimuli, IX] = unique(all_unique,'rows');
unique_all_occurrence = false(length(all_unique),length(unique_stimuli));
n_all_occurrences = zeros(1,length(unique_stimuli));

for j = 1:length(unique_stimuli)
    unique_all_occurrence(:,j) = ismember(all_unique,all_unique(IX(j),:), 'rows');
    n_all_occurrences(j) = length(find(unique_all_occurrence(:,j)));
end
%%
%get the mean and standard error z-score responses 
mean_session_stim = cell(Info.ncells,1);
stde_session_stim = cell(Info.ncells,1);
mean_session_blanks = cell(Info.ncells,1);
stde_session_blanks = cell(Info.ncells,1);

for i = 1:Info.ncells
    trial_mean{i} = cell2mat(trial_mean{i}');
    trial_blanks{i} = cell2mat(trial_blanks{i}');
    z_kernel_stim{i} = cell2mat(z_kernel_stim{i}');
    if ~isempty(trial(1).stimuli.blanks_times)
    z_kernel_blanks{i} = cell2mat(z_kernel_blanks{i}');
    end
    for j = 1:length(unique_stimuli)
        unique_responses = trial_mean{i}(unique_all_occurrence(:,j),:);
        mean_session_stim{i}(j,:) = mean(unique_responses,1);
        stde_session_stim{i}(j,:) = std(unique_responses)/sqrt(n_all_occurrences(j));
    end
    if ~isempty(trial(1).stimuli.blanks_times)
    mean_session_blanks{i} = mean(trial_blanks{i},1);
    stde_session_blanks{i} = std(trial_blanks{i})/sqrt(size(trial_blanks{i},1));

    mean_session_stim{i} = mean_session_stim{i} - repmat(mean_session_blanks{i},[length(mean_session_stim{i}),1]);
    end
end
%%
% get the cell position
xPix = round(center(:,1));
xPix = num2cell(xPix);
yPix = round(center(:,2));
yPix = num2cell(yPix);
%%
Z_session = struct('mean_dFstim', mean_session_stim, 'mean_blanks',...
    mean_session_blanks, 'stde_stim', stde_session_stim,'stde_blanks',...
    stde_session_blanks, 'all_stim', z_kernel_stim, 'stim_times',z_stim_times,'all_blanks', ...
    z_kernel_blanks, 'blank_times',z_blank_times,'xPix', xPix, 'yPix',yPix);

Stimuli = struct('all_stimuli',all_stimuli,'unique_stimuli',unique_stimuli);
Stimuli.params = {'orientation' 'spatial frequency' 'spatial phase' 'color'};

Info.approx_kernel_times = kernel_times;
Info.occurrences = n_all_occurrences;
