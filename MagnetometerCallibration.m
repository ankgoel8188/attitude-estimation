function [bias] = MagnetometerCallibration(imu)
    dlg = warndlg("This function is used to callibrate " + ...
        "the magnetometer of BNO055, " + ...
        "MPU9250 and more. The function runs for 60 seconds. During " + ...
        "this time, move the sensor in a figure 8 pattern; " + ...
        "alternatively, align all the axis for their maximum and " + ...
        "minimum. Press [OK] to continue.", ...
        "Magnetometer Callibration Information");
    waitfor(dlg);
    tic;
    max = zeros(1,3);
    min = max;
    while toc<60
        data = readMagneticField(imu);
        idMax = (data>max);
        idMin = (data<min);
        max(idMax) = data(idMax);
        min(idMin) = data(idMin);
    end
    bias = (max + min) ./ 2;
end