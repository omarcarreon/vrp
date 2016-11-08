%% Problema de CVRPTW

%% Entrada de datos

%dirIni = pwd;

dir = '/Users/omarcarreon/Downloads/Proyecto/PSolomon';
fname = 'r102';                % archivo de datos

dirIni = pwd;
cd(dir);

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
cd(dirIni);

%cd(dir)

% Leo datos del problema
%fname = 'r102';                % archivo de datos
%A = importdata(strcat(fname,'.txt'), ' ',9);
%v = sscanf(A.textdata{5},'%d');
%numeroVehiculos = v(1);
%capacidad = v(2);
%
%
%%A.data = A.data(1:45,:); % recorte
%
%nc = A.data(:,1); % número de cliente
%x = A.data(:,2); % coordenada x 
%y = A.data(:,3); % coordenada y
%d = A.data(:,4); % demanda
%e = A.data(:,5); % ready time
%l = A.data(:,6); % due date
%s = A.data(:,7); % service time

%fprintf('Problema %5s, Capacidad=%d, Número max de vehículos=%d\n',fname,capacidad,numeroVehiculos)
%
%% Leer datos de la solución
%fid = fopen(strcat(fname,'_sol.txt'));
%AA = textscan(fid,'%s');
%fclose(fid);
%BB = AA{1};
%nRutas = str2num(BB{2});
%
%u2 = {[1 1 2 3 4 32 6 7 9 10 11 1]
%    [1 33 13 14 15 16 68 18 19 20 21 1]
%    [1 22 23 24 25 26 48 28 29 30 31 1]
%    [1 5 12 34 65 36 85 38 39 40 41 1]
%    [1 42 91 44 45 46 47 27 78 50 51 1]
%    [1 52 53 54 55 56 57 58 59 60 96 1]
%    [1 62 63 64 35 66 67 17 69 70 71 1]
%    [1 72 73 74 75 76 88 49 79 80 81 1]
%    [1 82 83 84 37 86 87 77 89 90 43 1]
%    [1 92 93 94 95 61 97 98 99 100 101 1]};
%disp(u2);

rows=1;
acumCapacidad = 0;
utemp = [];
u = {};
for i=2:101
    acumCapacidad = acumCapacidad + d(i);
    if nc(i) == 100
      if acumCapacidad > 200
        u{rows} = utemp;
        u{rows+1} = [100];
      else 
        u{rows} = [utemp 100];
      end
      
    end
    if acumCapacidad > 200 
      acumCapacidad = 0;
      u{rows} = utemp;
      rows = rows + 1;
      utemp = [];
    end
   
    utemp = [utemp nc(i)];
end

for i=1:length(u)
  u{i} = [1 u{i} 1];
end
%disp(u);
% u = {};
% for i=1:nRutas
%   tmp = BB{2+i};
%   tmp = textscan(tmp,'%d-');
%   t = tmp{1}'+1;
%   u{i} = [1 t(1:end-1) 1];
% end


% Regreso al directorio original


%% Gráfica de clientes

delta = -0.5;
clf
dg = 5;
plot(x(1),y(1),'sr',x(2:end),y(2:end),'ob','MarkerSize',12)
xlim([min(x)-dg max(x)+dg])
ylim([min(y)-dg max(y)+dg])
legend('     almacen','      clientes','Location','BestOutside')
xlabel('x')
ylabel('y')
title(sprintf('distribucion de clientes VRP: %s',fname))
hold on
for i=1:length(x)
   text(x(i)+delta,y(i)+delta,sprintf('%2d',nc(i)),'FontSize',8)
end
hold off

%% Funcion para revisar capacidad
%function [capRow1,capRow2] = calculaCapacidad(i,iRand,uRetTemp,d)
%    capRow1 = 0;
%    capRow2 = 0;
%    for j=1:length(uRetTemp)
%      capRow1 = capRow1 + d(uRetTemp{i}(j));
%      capRow2 = capRow2 + d(uRetTemp{iRand}(j));
%    end
%end

%% Funcion de vecindad
function uReturn = vecindad(u)
  uReturn = u;
  for i=1:length(u)
    
    funcrand = int32(rand * 1) + 1;
    indexRowSwap = int32(rand * (length(uReturn)-1)) + 1;
      
    if ~isempty(uReturn{i}) & ~isempty(uReturn{indexRowSwap})
      if funcrand == 1 %Exchange operator 
        index1Swap = int32(rand * (length(uReturn{i})-3)) + 2;
        index2Swap = int32(rand * (length(uReturn{indexRowSwap})-3)) + 2;
        
        temp = uReturn{i}(index1Swap);
        uReturn{i}(index1Swap) = uReturn{indexRowSwap}(index2Swap);
        uReturn{indexRowSwap}(index2Swap) = temp;
        
      elseif funcrand == 2 % relocate operator
        index1Swap = int32(rand * (length(uReturn{i})-3)) + 2;
        index2Swap = int32(rand * (length(uReturn{indexRowSwap})-3)) + 2;
        
        temp = uReturn{i}(index1Swap);
        rest = uReturn{indexRowSwap}(index2Swap:end);
        
        uReturn{i}(index1Swap) = [];
        uReturn{indexRowSwap} = [uReturn{indexRowSwap}(1:index2Swap-1) temp rest];
        
      elseif funcrand == 3 % cross exchange
        index1Swap = int32(rand * (length(uReturn{i})-3)) + 2;
        index2Swap = int32(rand * (length(uReturn{i})-3)) + 2;
        
        min1 = min(index1Swap,index2Swap);
        max1 = max(index1Swap,index2Swap);
          
        index3Swap = int32(rand * (length(uReturn{indexRowSwap})-3)) + 2;
        index4Swap = int32(rand * (length(uReturn{indexRowSwap})-3)) + 2;
        min2 = min(index3Swap,index4Swap);
        max2 = max(index3Swap,index4Swap);
          
        temp = uReturn{i}(min1:max1);
        temp2 = uReturn{indexRowSwap}(min2:max2);
          
        rest1 = uReturn{i}(max1+1:end);
        rest2 = uReturn{indexRowSwap}(max2+1:end);
          
        uReturn{i}(min1:max1) = [];
        uReturn{indexRowSwap}(min2:max2) = [];

        uReturn{i} = [uReturn{i}(1:min1-1) temp2 rest1];
        uReturn{indexRowSwap} = [uReturn{indexRowSwap}(1:min2-1) temp rest2];

      end
    end
  end
end

% Gráfica y evaluación de una solución u

[costo,~,~,~] = costoVRP(u);
intentos = 0;
while(intentos ~= 10000)
    uTemp = u;
    costoTemp = costo;
    u = vecindad(u);
    [costo,~,~,~] = costoVRP(u);

    %SI costo del vecino es menor que el actual se acepta.
    if costo > costoTemp
      u = uTemp;
      costo = costoTemp;
    end
    intentos = intentos + 1;
end

costoVRP(nc,x,y,d,e,l,s,capacidad)
[costo,b,cap,term] = costoVRP(u);
delta = 0.5;
clf
colores = {'m','r','b','k','g'};
formas = {'.','o','x','+','s','d','v','^','p','<','>','h'};
nformas = length(formas);
ncolores = length(colores);
plot(x(1),y(1),'sb', 'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10)
xlim([min(x)-dg max(x)+dg])
ylim([min(y)-dg max(y)+dg])
xlabel('x')
ylabel('y')
title(sprintf('VRP-%s, %d clientes, costo=%f, %d rutas',fname,length(nc)-1,costo,length(u)))
hold on
leg = {};
leg{1} = '     almacen';
for i=1:length(u)
   str = sprintf('%c-%c',formas{mod(i,nformas)+1},colores{mod(i,ncolores)+1});
   plot(x(u{i}),y(u{i}),str,'MarkerSize',6)
   leg{i+1} = sprintf('%2d: (%d) %3d',i,length(u{i})-2,cap(i));
end
plot(x(1),y(1),'sb', 'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10)
legend(leg,'Location','BestOutside')
for i=1:length(x)
   text(x(i)+delta,y(i)+delta,sprintf('%2d',nc(i)),'FontSize',8)
end
hold off


%% Tabulación de solución 

fprintf('\n')
fprintf('  Costo total: %f\n',costo)
fprintf('Tiempo máximo: %f\n',max(term))
fprintf('    Capacidad: %d\n',capacidad)
fprintf('Rutas:\n')
for i=1:length(u)
   
   
   
   fprintf('%3d: (%2d)',i,length(u{i})-2)
   fprintf(' [term=%5.2f,cap=%3d] ',term(i),cap(i))
   fprintf(' %d',nc(u{i}(2:end-1)))
   fprintf('\n')
end
fprintf('\n')

%% Tabulación de clientes procesados

r = zeros(size(e));
for i=2:length(r)
   for j=1:length(u)
      if ~isempty(find(i==u{j},1))
         r(i) = j;
         break
      end
   end
end
cond1 = e<=b; % atender después de ready time
cond2 = b<=l; % atender antes de due date
fprintf('\n')
fprintf(' nc     d       e       b       l   e<=b   b<=l  ruta\n')
for i=2:length(nc)
   fprintf('%3d: %4d %7.0f %7.0f %7.0f %5d %6d %5d\n',...
      nc(i),d(i),e(i),b(i),l(i),cond1(i),cond2(i),r(i))
end



%







