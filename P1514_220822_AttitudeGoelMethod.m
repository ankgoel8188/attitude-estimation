%% P1514 Comparing Orientation Estimation Between Methods
% Author:       Turibius Rozario
% Professor:    Dr. Ankit Goel
% Date:         2022-08-22
%{
 This script requires the "MATLAB Support Package for Arduino Hardware",
"STOPLOOP", and "Quiver Color and Length management" add ons.
Additionally, the following custom functions should be present:
'GyroscopeCallibration', 'MagnetometerCallibration',
'OrientationAccMagMan', 'OrientationGyroMan', 'OrientationViewerArrows'.

Make sure that the Arduino is connected to the computer. If this is the
first time using an Arduino with your computer, ensure that Arduino USB
drivers are installed; generally the Arduino Explorer (tool obtained
after installing the add ons above) prompt if you would like the USB
drivers to be installed; if it does not, make sure you have the drivers.

The SCL pin is A5, and the SDA pin is A4. Connect these properly to the
IMU sensors. Currently, the script is for Adafruit BNO055, which can
accept V_in of 5V.

Make sure to change some settings such as the board name and the COM port.

During the first run, dialog boxes will pop up describing the usage or
current event. Note that each FIGURES are designed to run indefinitely,
unless the "Ok" button is pressed on the dialog box (the figure might end
up covering the dialog box).
%}


% During re-runs of the script, it is not necessary to obtain callibration
% data. However, if the sensor has been relocated or it has been some time,
% clearing the variables is recommended
clearvars -except magBias gyroBias gyroRadius dataType
format short; format compact;

% An object is created below for the Arduino. Ensure that the COM port and
% the board name is correct below in the user's use case.
uno = arduino('COM6', 'Uno', 'Libraries', 'I2C');
v = 200; % frequency, can be lowered
T_s = 1 / v; % period of sample
dataType = "matrix";
samples = 1;
bno = bno055(uno, ...
    "TimeFormat","duration", ...
    "OutputFormat", dataType, ...
    "OperatingMode","amg", ...
    "SamplesPerRead", samples, ...
    "ReadMode", "latest");
msg1 = 'If you are finished with viewing this, press [OK]';
msg2 = 'This will exit the loop and continue the script';

%% Callibration
dlg = warndlg("Callibration is required only once. " + ...
    "Comment the lines in the 'Callibration' section", ...
    "Warning");
waitfor(dlg);
magBias = MagnetometerCallibration(bno);
[gyroBias, gyroRadius] = GyroscopeCallibration(bno);

%% Orientation Using Accelerometer and Magnetometer
figure("Name","Accelerometer-Magnetometer")
tic;
FS = stoploop({msg1,msg2});
while ~FS.Stop()
    Orientation = OrientationAccMagMan(bno, magBias, dataType);
    OrientationViewerArrows(Orientation);
end
FS.Clear()
clear FS

%% Orientation Using Gyroscope
% Requires initial orientation from Acc-Mag
figure("Name","Gyroscope")
tic;
FS = stoploop({msg1,msg2});
while ~FS.Stop()
    [Orientation,timeEnd] = OrientationGyroMan(bno, Orientation, ...
        gyroBias, T_s);
    tic;
    disp(Orientation);
    OrientationViewerArrows(Orientation);
end
FS.Clear()
clear FS

%% Release
% When not in use, release, otherwise data will still be streamed!
release(bno);
