function rpm = cps2rpm(cps, C)
% Convert the frequency of the combustion to the RPM of the engine.
    % Input:
    %     cps: frequency of the combustion in Hz (combustion per second)
    %     C: Constants struct
    % Output:
    %     RPM of the engine
    
    % cpr := Combustion per revolution
    cpr_cylinder = 2/C.CYCLES;
    cpr_engine = cpr_cylinder * C.CYLINDERS;
    % rps := Revolutions per second
    rps = cps / cpr_engine;
    rpm = rps * 60;
end