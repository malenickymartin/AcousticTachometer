function [data, time, dt] = capture_audio(mic, data, time, C)
% Captures audio signal from microphone for given time
    % Input:
    %     mic: microphone ofject of type audiorecorder or 
    %     data: data sample cuptured up to this point
    %     time: time from last capture of audio
    %     C: Constants struct
    % Output:
    %     data: audio data
    %     time: time from last capture of audio
    %     dt: time between audio cpatures

    if C.DEVICE_TYPE == "pc"
        while mic.TotalSamples < 1
            pause(0.05);
        end
        data_new = getaudiodata(mic);
        dt = toc(time);
        time = tic;
        data = replace_data(data, data_new);
        if mic.TotalSamples > 1e6 % Clean buffer
            stop(mic);
            record(mic);
        end
    elseif C.DEVICE_TYPE == "mobile"
        while mic.Microphone.getAvailableSamples < 1
            pause(0.05);
        end
        data_new = readAudio(mic); % This function cleans buffer by default
        dt = toc(time);
        time = tic;
        data = replace_data(data, data_new);
    end
end

function [data] = replace_data(data_old, data_new)
    len_old = length(data_old);
    len_new = length(data_new);
    if len_old <= len_new
        data = data_new(end-len_old+1:end);
    else
        data = [data_old(len_new+1:end); data_new];
    end
end