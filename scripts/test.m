%% Setup
clear, clc, close all

subindex = @(A, r) A(r);
file_path = "data/ford_custom_open_2014-4.MOV";
[data, fs] = load_audio_from_file(file_path);

C.SAMPLE_TIME = 0.5; % in sec
C.CYLINDERS = str2double(subindex(split(subindex(split(file_path, "."), 1), "-"), 2));
C.CYCLES = 4;
C.MIN_RPM = 500;
C.MAX_RPM = 4500;
C.CACHE_LEN = 5;
C.MAX_RPMPS = 1000;
C.CPSTFT = 10;
C.STD_THR = 100;

%% App emulation from file

rpms = zeros(1,ceil(length(data)/(C.SAMPLE_TIME*fs))-1);
movavg_rpms = [];
movder_rpms = [];
movavg_rpm = C.MIN_RPM;
movder_rpm = C.MAX_RPM;
rpm_cache = NaN(1, C.CACHE_LEN);

rpms_raw = zeros(1,ceil(length(data)/(C.SAMPLE_TIME*fs))-1);
movavg_rpms_raw = [];
movder_rpms_raw = [];
movavg_rpm_raw = C.MIN_RPM;
movder_rpm_raw = C.MAX_RPM;
rpm_cache_raw = NaN(1, C.CACHE_LEN);
steadys = [];
for i = 1:length(rpms)
    data_sample = data(ceil((i-1)*C.SAMPLE_TIME*fs+1):ceil(i*C.SAMPLE_TIME*fs+1));
    [rpm_sample, rpm_sample_raw] = spectral_analysis_stft_sample(data_sample, fs, movavg_rpm, movder_rpm, C);
    [movavg_rpm, movder_rpm, steady, rpm_cache, movavg_rpm_raw, rpm_cache_raw] = moving_avg_analysis(rpm_cache, rpm_sample, rpm_cache_raw, rpm_sample_raw, C.SAMPLE_TIME, C);
    rpms(i) = rpm_sample;
    rpms_raw(i) = rpm_sample_raw;
    movavg_rpms = [movavg_rpms movavg_rpm];
    movder_rpms = [movder_rpms movder_rpm];
    movavg_rpms_raw = [movavg_rpms_raw movavg_rpm_raw];
    movder_rpms_raw = [movder_rpms_raw movder_rpm_raw];
    steadys = [steadys steady];
end

t = (1:length(rpms)) * C.SAMPLE_TIME;
figure
plot(t, rpms, "b-", "LineWidth", 2)
hold on
plot(t, rpms_raw, "g:", "LineWidth", 2)
plot(t,movavg_rpms+movder_rpms, "r--", t, movavg_rpms-movder_rpms, "r--")
xlabel("time [s]")
ylabel("RPM")
xlim([0, max(t)])
ylim([C.MIN_RPM, C.MAX_RPM])
legend("RPM", "RPM Raw", "AVG +- STD")
title("RPM from app")
grid on

%% Simple STFT

[s,f,t] = spectral_analysis_stft(data, fs, C);
% Calculate the frequency of the maximum value in each column
idxs = argmax(abs(s));
freqs_max = f(idxs);
% Convert the frequency to RPM
rpms = cps2rpm(freqs_max, C);

%% Plot the spectrogram

figure
plot_s = abs(s);
plot_s(plot_s < min(20*log10(max(plot_s)))) = 0.9*min(20*log10(max(plot_s)));
imagesc(t, cps2rpm(f, C), plot_s)
colormap jet
axis xy
xlabel("time [s]")
ylabel("frequency [Hz]")
title("Spectrogram")
c=colorbar;
c.Label.String="20\cdot log_{10}(|X|) [dB]";

%% Plot RPM

figure
plot(t, rpms)
xlabel("time [s]")
ylabel("RPM")
xlim([0, max(t)])
title("RPM from STFT")
grid on















