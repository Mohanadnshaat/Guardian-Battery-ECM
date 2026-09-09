%% Parameters
Ts = 1;                  
Q_nominal = 50;         
SOC_initial = 80;       

R0 = 0.00070;            
R1 = 0.00160;            
C1 = 17000;
R2 = 0.00035;
C2 = 5200;

NoisePower = 1e-4;
NoiseSampleTime = 1;
NoiseSeed = 23341;

FilterNumerator = [0.02];
FilterDenominator = [1 -0.98];

NoiseUpper = 0.005;      
NoiseLower = -0.005;

%% Load files
DriveCycle = readtable('Guardian_Battery_DriveCycle_Current.csv');
Time_s = DriveCycle.Time_s;
Current_A = DriveCycle.Current_A;
Current_signal = timeseries(Current_A, Time_s);

OCV_Table = readtable('Guardian_Battery_OCV_SOC_Table.csv');
SOC_pct = OCV_Table.SOC_pct;
OCV_V = OCV_Table.OCV_V;