%% example plot of raw vantage marker data
close all
clear
clc

load('VantageMarkersS_ST74deg.mat')
%load('VantageMarkersS_ST79deg.mat')
%load('VantageMarkersS_ST84deg.mat')

%notes: loads matlab structure S 

fields = fieldnames( S );
numSamples=length(S.(fields{1})); %number of samples
dt=diff(S.(fields{1})(:,2)); %[s]

figure
hold on
n=30; % set sample index or loop through for video
for i=1:length(fields)
    plot3(S.(fields{i})(n,3),S.(fields{i})(n,4),S.(fields{i})(n,5),'o','DisplayName',fields{i})
end
axis equal
xlabel('x(t)')
ylabel('y(t)')
zlabel('z(t)')
camup([0 -1 0])
legend
hold off