function [] = OrientationViewerArrows(endPoints)
%Plots orientation of rotation matrix. End points should be rows, otherwise
% use transpose before hand.
% https://www.mathworks.com/help/matlab/ref/drawnow.html
    origin = zeros(3,3);
    % Negatives are given to fix direction
    q = quiver3(origin(:,1),origin(:,2),origin(:,3), ...
        endPoints(:,1),endPoints(:,2),endPoints(:,3));
    colormap(jet);
    SetQuiverColor(q,jet);
    xlim([-1, 1]);
    ylim([-1, 1]);
    zlim([-1, 1]);
    drawnow
end