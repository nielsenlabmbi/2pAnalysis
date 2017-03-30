function [mean_over_phase, sem, max_over_ori, max_over_sf, sf_vect_mx_mx, or_vect_mx_mx, best_ori, best_sf, ...
    time_delay]  = pref_general0(Z_session, Stimuli, Info, window_lims, select, slice_or_avg)

ncells = Info.ncells;
domains.oridom = unique(Stimuli.unique_stimuli(:,1));
domains.sfdom = unique(Stimuli.unique_stimuli(:,2));

kernel_length = length(Info.approx_kernel_times);
kernel_window = find(Info.approx_kernel_times*1000 >=window_lims(1) & Info.approx_kernel_times*1000 < window_lims(2));

mean_over_phase = cell(1,ncells);
sem = cell(1,ncells);
for i = 1:length(domains.oridom);
    for j = 1:length(domains.sfdom);
        IX = Stimuli.unique_stimuli(:,1) == domains.oridom(i) & Stimuli.unique_stimuli(:,2) == domains.sfdom(j);
        for n = 1:ncells
            mean_over_phase{n}(i,j,:)= mean(Z_session(n).mean_dFstim(IX,:),1);
            sem{n}(i,j,:) = std(Z_session(n).mean_dFstim(IX,:),1)/sqrt(length(IX));
        end
    end
end

%% spatial frequency v time

max_over_ori = cell(1,ncells);
sf_vect_mx_mx = zeros(ncells,length(domains.sfdom));
max_over_sf = cell(1,ncells);
or_vect_mx_mx = zeros(ncells,length(domains.oridom));
% best_sf_in_window = zeros(ncells,length(domains.sfdom));
best_ori = zeros(ncells,1);
best_sf = zeros(ncells,1);
time_delay = zeros(ncells,1);
for n = 1:ncells
    max_over_ori{n} = zeros(length(domains.sfdom),kernel_length);
    max_over_sf{n} = zeros(length(domains.oridom),kernel_length);
    
    [~,a] = max(mean_over_phase{n}(:,:,kernel_window),[],3);
    [~,b] = max(max(mean_over_phase{n}(:,:,kernel_window),[],3));
    [~,c] = max(max(max(mean_over_phase{n}(:,:,kernel_window),[],3)));
    time_delay(n) = kernel_window(a(b(c),c));
    
    switch select
        case 'best'
            [a,b] = max(mean_over_phase{n}(:,:,time_delay(n)),[],2);
            [~,d] = max(a);
            best_sf(n) = b(d);
            
            [a,b] = max(mean_over_phase{n}(:,:,time_delay(n)),[],1);
            [~,d] = max(a);
            best_ori(n) = b(d);
            
            max_over_ori{n} = squeeze(mean_over_phase{n}(best_ori(n),:,:));
            max_over_sf{n} = squeeze(mean_over_phase{n}(:,best_sf(n),:));
            
        case 'mode_ori'
            [~,b] = max(mean_over_phase{n}(:,:,time_delay(n)),[],1);
            best_ori(n) = mode(b);
            max_over_ori{n} = squeeze(mean_over_phase{n}(best_ori(n),:,:));
            
            [~,b] = max(mean_over_phase{n}(:,:,time_delay(n)),[],2);
            best_sf(n) = mode(b);
            max_over_sf{n} = squeeze(mean_over_phase{n}(:,best_sf(n),:));
            
    end
    
    switch slice_or_avg
        case 'slice'
            %             [~,b] = max(max(max_over_ori{n}(:,kernel_window),[],1));
            %             time_delay_sf(n) = kernel_window(b);
            sf_vect_mx_mx(n,:) = max_over_ori{n}(:,time_delay(n));
            or_vect_mx_mx(n,:) = max_over_sf{n}(:,time_delay(n));
        case 'avg_window'
            sf_vect_mx_mx(n,:) = mean(max_over_ori{n}(:,kernel_window),2);
            or_vect_mx_mx(n,:) = mean(max_over_sf{n}(:,kernel_window),2);
    end
    %     [~,b] = min(sf_vect_mx_mx(n,:));
    %     least_pref_sf(n) = domains.sfdom(b);
    
end
