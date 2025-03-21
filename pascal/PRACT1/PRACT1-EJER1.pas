program ejer1;
type

archivo_enteros = file of integer;

var
enteros : archivo_enteros;
nombre : string;
n : integer;
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
end.
