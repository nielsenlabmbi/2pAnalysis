function correctedInfo = correctInfoFile(info,lastStimEventChan,isOnOffEvent,truncateAfterNEvents)
    correctedInfo = info;
    a = find(correctedInfo.event_id == lastStimEventChan);
    if isOnOffEvent
        a = a(2:2:end);
    end
    correctedInfo.event_id = correctedInfo.event_id(1:a(truncateAfterNEvents));
    correctedInfo.frame = correctedInfo.frame(1:length(correctedInfo.event_id));
    correctedInfo.line = correctedInfo.line(1:length(correctedInfo.event_id));
end