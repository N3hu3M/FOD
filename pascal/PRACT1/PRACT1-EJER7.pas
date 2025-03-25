program ejer7;
type

novela = record
cod : integer;
nombre : String;
genero : String;
precio : real;
end;

archivo = file of novela;

procedure leerCampos(var nov: novela);
begin
  writeln('Ingrese un nombre de novela');
  readln(nov.nombre);
  writeln('Ingrese un genero de novela');
  readln(nov.genero);
  writeln('Ingrese un precio de novela');
  readln(nov.precio);
end;

procedure leerNovela(var nov: novela);
begin
    writeln('Ingrese un codigo de novela');
    readln(nov.cod);
    if(nov.cod <> 0 ) then
        begin
            leerCampos(nov);
        end;
end;

procedure crearArchivo(var a1 : archivo; var tx : Text);
var
n : novela;
nom : String;
begin
writeln('Ingrese el nombre del archivo a crear!');readln(nom);
assign(a1, nom);
rewrite(a1);
reset(tx);
while(not eof(tx))do begin
  with n do
    begin
    readln(tx, cod, precio, genero);
    readln(tx, nombre);
    write(a1, n);
    end;
writeln('Archivo binario cargado');
close(a1);
close(tx);
end;
end;
procedure agregarNovela(var a1 : archivo);
var
    nov: novela;
begin
    reset(a1);
    leerNovela(nov);
    seek(a1, fileSize(a1));
    while(nov.cod <> 0) do
        begin
            write(a1, nov);
            leerNovela(nov);
        end;
    close(a1);
end;

procedure modificarNovela(var a1 : archivo);
var
ok : boolean;
n : novela;
cod : integer;
begin
reset(a1);
ok:= false;
writeln('Ingrese el codigo de novela a modificar');
readln(cod);
while(not EOF(a1)) and (not ok) do begin
  read(a1, n);
  if(n.cod = cod) then
    begin
    ok:= true;
    leerCampos(n);
    seek(a1, filepos(a1)-1);
    write(a1, n);
    writeln('Se modifico la novela con codigo ', cod);
    end;
  end;
  close(a1);
end;

procedure menu(var a1 : archivo);
var
tx : Text;
opc : integer;
begin
assign(tx,'novelas.txt');
writeln('---MENU DE OPCIONES---');
writeln('1: Crear un archivo binario a partir de la informacion almacenada en un archivo de texto');
writeln('2: Agregar una novela');
writeln('3: Modificar una novela');
writeln('4: Salir del menu');
readln(opc);
while(opc <> 4)do begin
  case opc of
    1: crearArchivo(a1, tx);
    2: agregarNovela(a1);
    3: modificarNovela(a1);
  else
    writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
    writeln();
    writeln('MENU DE OPCIONES');
    writeln('1: Crear un archivo binario a partir de la informacion almacenada en un archivo de texto');
    writeln('2: Agregar una novela');
    writeln('3: Modificar una novela');
    writeln('4: Exportar a texto el archivo binario');
    writeln('5: Salir del menu');
    readln(opc);
    end;
end;
end;
var
a1 : archivo;
begin
menu(a1);
end.
