function [OfromAtoD] = OrientationAccMagMan(imu, magBias, dataType)
% Computes orientation using magnetometer and accelerometer for stationary
% or near-stationary sensors. Bias for magnetometer has to be known.
if dataType=="timetable"
    [data] = read(imu);
    acc = data.Acceleration;
    mag = data.MagneticField;
end
if dataType=="matrix"
    [acc, gyro, mag] = read(imu);
end
mag = mag - magBias;
k = acc ./ norm(acc);
magUnit = mag ./ norm(mag);
j = cross(k, magUnit);
i = cross(k, j);
OfromAtoD = [i; j; k];
end