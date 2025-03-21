program ejer1;
type

archivo_enteros = file of integer;

procedure CalculoArchivo(var prom : real; var cant : integer; var enteros: archivo_enteros);
var
actual, canttot, suma : integer;
begin
canttot := 0;
suma := 0;
Reset(enteros);
while(not EOF(enteros))do begin
  canttot := canttot + 1;
  Read(enteros,actual);
  suma := suma + actual;
  if(actual<1500)then
    cant :=  cant + 1;
  end;
prom := suma/canttot
end;

var
enteros : archivo_enteros;
nombre : string;
n, cant : integer;
prom : real;
begin
writeln('ingrese el nombre del archivo');
readln(nombre);

assign(enteros,nombre);
Rewrite(enteros);

writeln('ingrese un numero');
readln(n);
while(n <> 30000)do begin
  Write(enteros,n);
  writeln('ingrese un numero');
  readln(n);
  end;
close(enteros);
  
cant := 0;
prom := 0;  
CalculoArchivo(prom, cant, enteros);
write('la cantidad de numeros menores a 1500 es ');
writeln(cant);
write('el promedio es ');
writeln(prom)
end.
