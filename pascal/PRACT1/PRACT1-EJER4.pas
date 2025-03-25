program tres;
type
    empleado = record
        nro:integer;
        nombre:string;
        apellido:string;
        edad:integer;
        dni:integer;
    end;
    archivoEmpleados = file of empleado;
procedure leer(var e:empleado);
begin
    
    
    if(e.apellido <> 'fin') then begin
        
    end;
end;
procedure cargarArchivo(var aE:archivoEmpleados);
var
    e:empleado; nomArc: string;
begin
    writeln('----- NUEVO ARCHIVO -----');
    write('Ingrese el nombre del archivo: '); readln(nomArc);
    assign(aE,nomArc);
    rewrite(aE);
    writeln('Ingrese datos del empleado');
    write('Apellido: '); readln(e.apellido);
    while(e.apellido <> 'fin') do begin
        write('Nro: '); readln(e.nro);
        write('Nombre: '); readln(e.nombre);
        write('Edad: '); readln(e.edad);
        write('DNI: '); readln(e.dni);
        write(aE,e);
        writeln('Ingrese datos del empleado');
        write('Apellido: '); readln(e.apellido);
    end;
    close(aE);
end;
procedure imprimirEmpleado(e:empleado);
begin
    writeln(e.nro,', ',e.nombre,', ',e.apellido,', ',e.edad,', ',e.dni,'.');
end;
procedure listarNomAp(var aE:archivoEmpleados);
var
    nomap:string; e:empleado;
begin
    writeln('Ingrese un nombre o apellido:');
    readln(nomap);
    reset(aE);
    writeln('Empleados con ese nombre o apellido:');
    while(not EOF(aE)) do begin
        read(aE,e);
        if(e.nombre = nomap) or (e.apellido = nomap) then
            imprimirEmpleado(e);
    end;
    close(aE);
end;
procedure listarDeAUno(var aE:archivoEmpleados);
var
    e:empleado;
begin
    reset(aE);
    writeln('Todos los empleados:');
    while(not EOF(aE)) do begin
        read(aE,e);
        imprimirEmpleado(e);
    end;
    close(aE)
end;
procedure listarMayores70(var aE:archivoEmpleados);
var
    e:empleado;
begin
    reset(aE);
    writeln('Empleados mayores de 70:');
    while(not EOF(aE)) do begin
        read(aE,e);
        if(e.edad > 70) then
            imprimirEmpleado(e);
    end;
    close(aE);
end;

function existe(var aE : archivoEmpleados; n : integer): boolean;
var
ok : boolean;
e : empleado;
begin
seek(aE, 0);
ok := false;
while(not eof(aE))and(not ok)do begin
  read(aE, e);
  if(e.nro = n)then
    ok := true;
end;
seek(aE, 0);
existe := ok;
end;

procedure agregarEmpleado(var aE: archivoEmpleados);
var
cant, i : integer;
e : empleado;
begin
writeln('---AGREGAR EMPLEADO/S AL FINAL DEL ARCHIVO---');
writeln('Ingrese la cantidad de empleados a ingresar');readln(cant);
reset(aE);
for i := 1 to cant do begin
  leer(e);
  while(existe(aE, e.nro))do begin
    writeln('El empleado se encuentra en el archivo, ingrese otro');
    leer(e);
  end;
  seek(aE, filesize(aE));
  write(aE, e);
  end;
close(aE);
end;


procedure modificarEdad(var aE: archivoEmpleados);
var
nro, edad : integer;
encontre : boolean;
e : empleado;
begin
writeln('---MODIFICAR EDAD DE UN EMPLEADO---');
writeln('Ingrese el numero del empleado a modificar la edad');readln(nro);
reset(aE);
encontre := false;
while(not eof(aE))and (not encontre)do begin
  read(aE, e);
  if(e.nro = nro)then begin
    writeln('Ingrese la edad del empleado modificada');readln(edad);
    e.edad := edad;
    encontre := true;
    seek(aE, filepos(aE)-1);
    write(aE, e);
    end;
  end;
close(aE);
end;

procedure exportarTexto(var aE: archivoEmpleados);
var
    aTexto:text; e:empleado;
begin
    assign(aTexto,'todos_empleados.txt');
    rewrite(aTexto);
    reset(aE);
    while(not EOF(aE)) do begin
        read(aE,e);
        writeln(aTexto,'NRO: ',e.nro,', Nombre: ',e.nombre,', Apellido: ',e.apellido,', Edad: ',e.edad,', DNI: ',e.dni,'.');
    end;
    close(aE); close(aTexto);
end;

procedure exportarIndocumentados(var aE: archivoEmpleados);
var
docuText : text; 
e : empleado;
begin
assign(docuText, 'faltaDNIEmpleado.txt');
rewrite(docuText);
reset(aE);
while(not eof(aE))do begin
  read(aE, e);
  if(e.dni = 00)then
    write(docuText, 'NRO: ',e.nro,', Nombre: ',e.nombre,', Apellido: ',e.apellido,', Edad: ',e.edad,', DNI: ',e.dni,'.');
  end;
close(aE); close(docuText);
end;


function menu():integer;
var
    opt:integer;
begin
    writeln('----- ABRIR ARCHIVO -----');
    writeln('1. Listar empleados con determinado nombre o apellido');
    writeln('2. Listar todos los empleados');
    writeln('3. Listar empleados mayores de 70');
    writeln('4. Añadir uno o mas empleados al final del archivo');
    writeln('5. Modificar edad de un empleado determinado');
    writeln('6. Exportar contenido del archivo a uno de texto');
    writeln('7. Exportar a un archivo de texto con solo indocumentados');    
    readln(opt);
    menu:= opt;
end;
procedure abrirArchivo(var aE:archivoEmpleados);
begin
    case menu() of
        1: listarNomAp(aE);
        2: listarDeAUno(aE);
        3: listarMayores70(aE);
        4: agregarEmpleado(aE);
        5: modificarEdad(aE);
        6: exportarTexto(aE);
        7: exportarIndocumentados(aE);
    else
        writeln('Opcion incorrecta.');
    end;
end;

var
    aE:archivoEmpleados;
begin
    cargarArchivo(aE);
    abrirArchivo(aE);
end.
