function [movavg_rpm, movder_rpm, steady, rpm_cache, movavg_rpm_raw, rpm_cache_raw] = moving_avg_analysis(rpm_cache, rpm, rpm_cache_raw, rpm_raw, dt, C)
% Computes average and variance of cached data and moves the cached data.
    % Input:
    %     rpm_cache: cached RPM data
    %     rpm: new RPM
    %     rpm_cache_raw: cached RPM raw data
    %     rpm_raw: new raw RPM
    %     dt: time from between audio capture calls
    %     C: constants struct
    % Output:
    %     movavg_rpm: moving average of RPM
    %     movder_rpm: RPM search interval
    %     steady: whether RPM is steady (i.e., not fluctuating)
    %     rpm_cache: cached RPM data with new RPM
    %     movavg_rpm_raw: moving average of raw RPM
    %     rpm_cache_raw: cached raw RPM data with new raw RPM
    
    movder_rpm = C.MAX_RPMPS*dt;

    rpm_cache = [rpm_cache(2:end) rpm];
    movavg_rpm = mean(rpm_cache, "omitnan");
    movstd_rpm = std(rpm_cache,  "omitnan");
    steady = movstd_rpm < C.STD_THR;

    rpm_cache_raw = [rpm_cache_raw(2:end) rpm_raw];
    movavg_rpm_raw = mean(rpm_cache_raw, "omitnan");

    if abs(movavg_rpm_raw-movavg_rpm) > movder_rpm
        movavg_rpm = movavg_rpm_raw;
        rpm_cache = rpm_cache_raw;
    end
end
