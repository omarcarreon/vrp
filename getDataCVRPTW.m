function [nc,x,y,d,e,l,s,numeroVehiculos,capacidad] = getDataCVRPTW(dir, fname)

%% Entrada de datos

dirIni = pwd;
cd(dir)

% Leo datos del problema
fileID = fopen(strcat(fname,'.txt'));
C = textscan(fileID,'%n %n %n %n %n %n %n','Delimiter',' ', 'TreatAsEmpty',{'RC106','VEHICLE', 'NUMBER     CAPACITY', 'CUSTOMER', 'CUST NO.  XCOORD.    YCOORD.     DEMAND  READY TIME   DUE DATE   SERVICE TIME'});
fclose(fileID);
A = cell2mat(C);
numeroVehiculos = A(1, 6);
capacidad = A(1, 7);
A = A(4:size(A,1),:);


%A.data = A.data(1:45,:); % recorte
nc = A(:,1); % número de cliente
x = A(:,2); % coordenada x 
y = A(:,3); % coordenada y
d = A(:,4); % demanda
e = A(:,5); % ready time
l = A(:,6); % due date
s = A(:,7); % service time

fprintf('Problema %5s, Capacidad=%d, Número max de vehículos=%d\n',fname,capacidad,numeroVehiculos)

% Regreso al directorio original
cd(dirIni)
