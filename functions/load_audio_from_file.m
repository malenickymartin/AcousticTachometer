function [data, fs] = load_audio_from_file(file_path)
% Loads data from path
    % Input:
    %     file_path
    % Output:
    %     data
    %     fs: sample frequency
    [data, fs] = audioread(file_path);
    data = data / max(abs(data));
end