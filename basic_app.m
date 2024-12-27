% Lightweight version of the application used for testing without GUI

clear, clc, close all

[mic, fs, disp_rpm, C] = config();

data = zeros(C.SAMPLE_TIME*fs, 1);
movavg_rpm = C.MIN_RPM;
movder_rpm = C.MAX_RPM;
rpm_cache = NaN(1, C.CACHE_LEN);
rpm_cache_raw = NaN(1, C.CACHE_LEN);
time = tic;
while true
    tic
    [data, time, dt] = capture_audio(mic, data, time, C);
    [rpm, rpm_raw] = spectral_analysis_stft_sample(data, fs, movavg_rpm, movder_rpm, C);
    [movavg_rpm, movder_rpm, steady, rpm_cache, ~, rpm_cache_raw] = moving_avg_analysis(rpm_cache, rpm, rpm_cache_raw, rpm_raw, dt, C);
    disp_rpm(rpm, steady);
    while toc < 0.1
        pause(0.01);
    end
end