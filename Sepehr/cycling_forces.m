rpm = 80; %rotations/min
cadence = rpm*60; %deg/sec
degrees = 360; %deg
revolutions = 5;

t = linspace(0,(degrees*revolutions)/cadence, degrees*revolutions);

time = t';

data = readtable( 'Pedal Force Data - Bini (2013).xlsx' ) ;

data = data{:,:};

A = [data(1:360,2);data(1:360,2);data(1:360,2);data(1:360,2);data(1:360,2)];

A(isnan(A))=0;

ground_force_vx = [data(1:360,4);data(1:360,4);data(1:360,4);data(1:360,4);data(1:360,4)];
ground_force_vy = [data(1:360,3);data(1:360,3);data(1:360,3);data(1:360,3);data(1:360,3)];
ground_force_vz = A;

ground_force_px = A;
ground_force_py = A;
ground_force_pz = A;

T = table(time, ground_force_vx, ground_force_vy, ground_force_vz, ground_force_px, ground_force_py, ground_force_pz);

writetable(T, 'cycling_grf.txt','Delimiter',' ')