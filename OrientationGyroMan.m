function [orientation, timeEnd] = OrientationGyroMan(imu, orientation, ...
                                                        bias, time)
% Computes orientation using gyroscope forsensors such as the BNO055. An
%initial orientation is required, and gyro bias has to be known before
%hand.
[gyro, timeEnd] = readAngularVelocity(imu);
gyro = gyro - bias;
gyro = [    0,          -gyro(3),       gyro(2);
            gyro(3),    0,              -gyro(1);
            -gyro(2),   gyro(1),        0];
orientationDer = - gyro * orientation;
orientation = orientation + toc * orientationDer;
end