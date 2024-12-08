function [loaded_data, data, time, dt, done] = capture_audio_simulation(loaded_data, data, fs, time)
% Emulates microphone audio capture by reading from audio file
    % Input:
    %     loaded_data: data from audio file 
    %     data: data sample cuptured up to this point
    %     fs: sampling frequency
    %     time: time from last capture of audio
    % Output:
    %     loaded_data: data from audio file withoud read data
    %     data: new data sample
    %     time: time from this capture of audio
    %     dt: time between this and last audio capture
    %     done: EOF
    done = false;
    lld = length(loaded_data);
    dt = toc(time);
    ds = ceil(fs*dt);
    if lld == 0
        done = true;
        return
    elseif ds > lld
        ds = lld;
        dt = lld/fs;
        done = true;
    end
    data_new = loaded_data(1:ds);
    loaded_data = loaded_data(ds+1:end);
    time = tic;
    data = replace_data(data, data_new);
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