 {7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de 
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre, 
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo 
maestro está ordenado por código de alumno. 
Además, se tienen dos archivos detalle con información sobre el desempeño académico de 
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de 
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro 
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la 
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales 
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de 
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle 
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o 
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia 
muchas veces, así como también podría rendir el final de una materia en múltiples 
ocasiones. 
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad 
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la 
información de los archivos detalle. Las reglas de actualización son las siguientes: 
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas 
aprobadas. 
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad 
de materias con final aprobado. 
Notas: 
● Los archivos deben procesarse en un único recorrido. 
● No es necesario comprobar que no haya inconsistencias en la información de los 
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una 
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar 
ocurre con los exámenes finales.}
program ejer7;
const


type

alumnoM = record
cod : integer;
apellido : string;
nombre : string; 
cursadas_aprobadas : integer; 
materias_final : integer
end;

cursada = record
cod : integer;
cod_materia : integer;
ano : integer;
resultado : boolean;//si fue aprobada o no
end;

finales = record
cod : integer;
cod_materia : integer;
fecha : string,
nota : real;
end;

maestro = file of alumnoM;
detalleC = file of cursada;
detalleF = file of finales;

procedure crearMaestro(var mae : maestro);
var
txt: text;
infoMae: alumnoM;
nombre: string;
begin
assign(txt, 'alumnos.txt');
reset(txt);
writeln('Ingrese un nombre para el archivo maestro');
readln(nombre);
assign(mae, nombre);
rewrite(mae);
while(not eof(txt)) do
   begin
       with infoMae do
            begin 
                readln(txt, cod, cursadas_aprobadas, materias_final, nombre);
                readln(txt, apellido);
                write(mae, infoMae);
            end;
    end;
writeln('Archivo binario maestro creado');
close(txt);
close(mae);
end;

procedure crearDetalles(var dC : detalleC; var dF : detalleF);
var
txtC, txtF : text;
nom : string;
c : cursada;
f : finales;
begin
assign(txtC, 'cursadas.txt');
reset(txtC);
assign(txtF, 'finales.txt');
reset(txtF);
writeln('Ingrese un nombre para el archivo de cursadas');
readln(nom);
assign(dC, nom);
rewrite(dF);
writeln('Ingrese un nombre para el archivo de finales');
readln(nom);
assign(dF, nom);
rewrite(dF);
while(not eof(txtC)) do
   begin
       with c do
            begin 
                readln(txtC, cod, cod_materia, ano, resultado);
                write(dC, c);
            end;
    end;
writeln('Archivo binario maestro creado');
close(txtC);
close(dC);nd;
while(not eof(txtF)) do
   begin
       with f do
            begin 
                readln(txtF, cod, cod_materia, nota, fecha);
                write(dF, f);
            end;
    end;
writeln('Archivo binario maestro creado');
close(txtF);
close(dF);
end;

procedure actualizarMaestro(var m : maestro;var dC : detalleC;var dF : detalleF);
var



begin
alumnoAct :=
codAct :=
leer(dC,dF,infoC,infoF)
while(infoC.cod <> valoralto)and(infoF.cod <> valoralto)do
  begin
  codActC =
  codActF =
  while()
  
  
  end;

end;
Ambos archivos detalle 
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o 
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia 
muchas veces, así como también podría rendir el final de una materia en múltiples 
ocasiones. 
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad 
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la 
información de los archivos detalle. Las reglas de actualización son las siguientes: 
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas 
aprobadas. 
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad 
de materias con final aprobado. 
Notas: 
● Los archivos deben procesarse en un único recorrido. 
● No es necesario comprobar que no haya inconsistencias en la información de los 
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una 
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar 
ocurre con los exámenes finales.
var
m : maestro;
dC : detalleC;
dF : detalleF;
begin
crearMaestro(m);
imprimirMaestro(m);
crearDetalles(dC,dF);
actualizarMaestro(m, dC, dF);
imprimirMaestro(m);
end;
