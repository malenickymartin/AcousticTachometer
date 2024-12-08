function [mic, fs, display_rpm, C] = config()
% Definition of default values and creation of default objects for basic
% apps
    % Output:
    %     mic: microphone object (depending on device)
    %     fs: sampling frequency of mic
    %     display_rpm: display function handle
    %     C: constants struct

    % Default values
    C.SAMPLE_TIME = 0.5; % in sec
    C.CYLINDERS = 4;
    C.CYCLES = 4;
    C.MIN_RPM = 500;
    C.MAX_RPM = 4500;
    C.CPSTFT = 10; % combustions per STFT window (for length of STFT window)

    % RPM fluctuation
    C.CACHE_LEN = 5;
    C.STD_THR = 100; % standart deviation threshold
    C.MAX_RPMPS = 1000; % acceleration (RPM per second)
    
    % Manual config
    if input("Start configuration? [y/n]: ", "s") == "y"
        C.CYCLES = input("Specify number of engine STROKES [4/2]: ");
        C.SAMPLE_TIME = input("Specify SAMPLE TIME <0.1; 1.0> seconds: ");
        C.MIN_RPM = input("Specify MIN engine RPM: ");
        C.MAX_RPM = input("Specify MAX engine RPM: ");
        C.CYLINDERS = input("Specify number of Cylinders: ");
    end
    
    % Mic setup
    if ispc || ismac
        C.DEVICE_TYPE = "pc";
        fs = 44100;
        mic = audiorecorder(fs, 16, 1);
        record(mic);
    else
        C.DEVICE_TYPE = "mobile";
        mic = mobiledev;
        mic.MicrophoneEnabled = 1;
        mic.logging = 1;
        fs = mic.Microphone.SampleRate;
    end
    display_rpm = @(rpm, steady) display_handle(rpm, steady);
end

function display_handle(rpm, steady)
    if steady 
        steady_disp = "";
    else
        steady_disp = " RPM fluctuates!";
    end
    clc;
    fprintf("%d RPM %s", int32(rpm), steady_disp);
end




