function [s, f, t] = spectral_analysis_stft(data, fs, C)
% Perform the spectral analysis of audio file.
% Takes large data vector, devide it into multiple time frames using STFT,
% and computes spectrogram
    % Input:
    %     data: audio clip
    %     fs: sampling frequency
    %     C: Constants struct
    % Output:
    %     xf: frequency
    %     yf: magnitude
    
    samples_duration = round(C.SAMPLE_TIME * fs);
    overlap = round(samples_duration/2);
    f = linspace(rpm2cps(C.MIN_RPM, C), rpm2cps(C.MAX_RPM, C), samples_duration/2);
    [s,f,t] = spectrogram(data, samples_duration, overlap, f, fs);
end