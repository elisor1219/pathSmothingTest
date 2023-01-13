function [pointsCarmull,fakePoints, timer, forTimer] = bSpline(path,pointsPerSection)
%CARMULL_TWOFORLOOPS By using the Carmull-rom spline, compute the curve
%   Detailed explanation goes here

timer = zeros(1,6);

%Characteristic matrix
tic
charMat = (1/6.*[1 4 1 0; -3 0 3 0; 3 -6 3 0; -1 3 -3 1]);
timer(1) = toc;

%Carmull = @(t, P_0, P_1, P_2, P_3) [1 t t^2 t^3] * (1/2.*[0 2 0 0; -1 0 1 0; 2 -5 4 -1; -1 3 -3 1]) * [P_0; P_1; P_2; P_3];

tic
firstFakePoint = -(path(:,2) - path(:,1)) + path(:,1);
lastFakePoint = -(path(:,end-1) - path(:,end)) + path(:,end);
fakePoints = [firstFakePoint lastFakePoint];
timer(2) = toc;

tic
numOfSection = size(path,2) - 1;
t = linspace(0,numOfSection-1,pointsPerSection)';
intPart = floor(t);
decPart = t - intPart;
disp("Decimal part " + decPart)
disp("t " + t)
%T-matrix
tMat = [t.^0 t t.^2 t.^3];
disp(tMat)
pathAndFake = [firstFakePoint path lastFakePoint]';
pointsCarmull = zeros(2, (size(path,2)-1)*size(t,2));
sectionSize = size(t,1);
timer(3) = toc;

forTimer = zeros(4, size(pathAndFake,1)-3);

%One problem right now is that the last point of a section is also the
%first point in the next section.
%This could effect the car in bad ways.
%One fix would be to skip on (j==1 || i>1), mostly temporary
%A better fix would be to do a linspace from 0, to #sections, this will
%ensure that all the points are diffrent.
%However, this method will not guarantee that the curve has a point exactly
%at a path-point.

tStart = tic;
for i = 1:size(t)
    %Point Matrix
    tic
    pMat = [pathAndFake(intPart(i)+1,:); pathAndFake(intPart(i)+2,:); pathAndFake(intPart(i)+3,:); pathAndFake(intPart(i)+4,:)];
    forTimer(1,i) = toc;
    tic
    startWind = (sectionSize)*(i-1)+1;
    forTimer(2,i) = toc;
    tic
    endWind = (sectionSize)*(i);
    forTimer(3,i) = toc;
    tic
    pointsCarmull(:,startWind:endWind) = (tMat * charMat * pMat)';
    forTimer(4,i) = toc;
end
timer(4) = toc(tStart);

end

