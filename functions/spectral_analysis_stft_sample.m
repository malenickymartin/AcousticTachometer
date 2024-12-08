function [rpm, rpm_raw] = spectral_analysis_stft_sample(data, fs, movavg_rpm, movder_rpm, C)
% Perform the spectral analysis of short audio sample.
% Takes short audio recording and computes RPM using STFT.
    % Input:
    %     data: audio clip
    %     fs: sampling frequency
    %     movavg_rpm: moving average RPM
    %     movder_rpm: moving variance of RPM
    %     C: Constants struct
    % Output:
    %     rpm: RPM from data
    %     rpm_raw: RPM measured without consdering the moving average error interval

    % number of STFT intervals
    n_div = max(1, ceil((rpm2cps(movavg_rpm, C)*C.SAMPLE_TIME)/C.CPSTFT));
    samples_duration = ceil((fs*C.SAMPLE_TIME)/n_div);
    overlap = round(samples_duration/2);
    f = linspace(rpm2cps(C.MIN_RPM, C), rpm2cps(C.MAX_RPM, C), samples_duration/2);
    [s,f,~] = spectrogram(data, samples_duration, overlap, f, fs);
    abs_s = abs(s);

    movavg_freq = rpm2cps(movavg_rpm, C);
    movder_freq = rpm2cps(movder_rpm, C);
    range = (f<(movavg_freq+movder_freq))&(f>(movavg_freq-movder_freq));
    f_range = f(range);
    abs_s_range = abs_s(range,:);
    idxs = argmax(abs_s_range);
    f_max = f_range(idxs);
    rpms = cps2rpm(f_max, C);
    rpm = mean(rpms);

    idxs_raw = argmax(abs_s);
    f_max_raw = f(idxs_raw);
    rpms_raw = cps2rpm(f_max_raw, C);
    rpm_raw = mean(rpms_raw);
end

function [rpm_uncertainty] = calculate_rpm_uncertainty(s, f, f_max_raw, C)
    uncertainties = zeros(size(f_max_raw));
    for i = 1:length(uncertainties)
        [peaks, peaks_id] = findpeaks(s(:,i));
        if length(peaks) < 2 
            continue
        end
        [max_peaks, max_peaks_id] = maxk(peaks, 2);
        peaks_f = f(peaks_id(max_peaks_id));
        uncertainties(i) = (abs(peaks_f(1)-peaks_f(2)))/(max_peaks(1)/max_peaks(2));
    end
    rpm_uncertainty = mean(cps2rpm(uncertainties, C));
end