function cps = rpm2cps(rpm, C)
% Convert the RPM of the engine to the frequency of the combustion.
    % Input:
    %     rpm: RPM of the engine
    %     C: Constants struct
    % Output:
    %     frequency of the combustion in Hz (combustion per second) 

    % rps := Revolutions per second
    rps = rpm / 60;
    % cpr := Combustion per revolution
    cpr_cylinder = 2/C.CYCLES;
    cpr_engine = cpr_cylinder * C.CYLINDERS;
    cps = rps * cpr_engine;
end