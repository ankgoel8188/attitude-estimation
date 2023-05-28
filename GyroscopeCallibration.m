function [bias, radius] = GyroscopeCallibration(imu)
    dlg = warndlg("This function is used to obtain the mean and " + ...
        "standard deviation of the white noise for sensors such as " + ...
        "BNO055, MPU9250, and more. Please keep the device " + ...
        "stationary, press [OK], and wait about 5 seconds.", ...
        "Gyroscope Callibration Information");
    waitfor(dlg);
    data = zeros(100, 3);
    for i = 1:length(data)
        data(i, :) = readAngularVelocity(imu);
    end
    bias = mean(data);
    radius = std(data);
end