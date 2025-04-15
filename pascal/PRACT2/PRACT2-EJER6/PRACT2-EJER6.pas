{7. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de Buenos Aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
program ejer6;
const
valoralto = 999;
DF = 10;
type
subRango = 1..DF;

infoD = record
    localidad: integer;
    cepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
end;

infoM = record
    localidad: integer;
    cepa: integer;
    cantActivos: integer;
    cantNuevos: integer;
    cantRecuperados: integer;
    cantFallecidos: integer;
    nombreCepa: string;
    nombreLocalidad: string;
end;

detalle = file of infoD;
maestro = file of infoM;

vecD = array [subRango] of detalle;
vecRegistros = array [subRango] of infoD;

procedure crear1Detalle(var d : detalle);
var
nom : string;
txt : text;
inD : infoD;
begin
writeln('Ingrese la direccion del archivo de texto');
readln(nom);
assign(txt, nom);
writeln('Ingrese el nombre del archivo detalle');
readln(nom);
assign(d, nom);
reset(txt);
rewrite(d);
while(not eof(txt))do begin
  with inD do
      begin
      readln(txt, localidad, cepa, cantActivos, cantNuevos, cantRecuperados, cantFallecidos);
      write(d, inD);
      end;
  end;
writeln('Archivo binario detalle creado');
close(d);
close(txt);
end;

procedure crearDetalles(var v : vecD);
var
i : subrango;
begin
for i := 1 to DF do
  crear1Detalle(v[i]);
end;

procedure leer(var d : detalle; var inD : infoD);
begin
if(not eof(d))then
  read(d, inD)
else
  inD.localidad := valoralto;

end;

procedure crearMaestro(var m : maestro);
var
txt: text;
inM: infoM;
nombre: string;
begin
assign(txt, 'casos.txt');
reset(txt);
writeln('Ingrese un nombre para el archivo maestro');
readln(nombre);
assign(m, nombre);
rewrite(m);
while(not eof(txt)) do
    begin
        with inM do
            begin
                readln(txt, localidad, cepa, cantActivos, cantNuevos, cantRecuperados, cantFallecidos, nombreCepa);
                readln(txt, nombreLocalidad);
                write(m, inM);
            end;
    end;
writeln('Archivo binario maestro creado');
close(txt);
close(m);
end;

procedure minimo(var vec: vecD; var vecReg: vecRegistros; var min: infoD);
var
    i, pos: subrango;
begin
    min.localidad := valoralto;
    for i:= 1 to DF do
        begin
            if (vecReg[i].localidad < min.localidad) or ((vecReg[i].localidad = min.localidad) and (vecReg[i].cepa < min.cepa)) then
                begin
                    min:= vecReg[i];
                    pos:= i;
                end;
        end;
    if(min.localidad <> valoralto) then
        leer(vec[pos], vecReg[pos]);
end;
procedure actualizarMaestro(var mae: maestro; var vec: vecD);
var
min: infoD;
infoMae: infoM;
vecReg: vecRegistros;
i: subrango;
cantCasosLocalidad, cantLocalidades: integer;
begin
reset(mae);
for i:= 1 to DF do
    begin
        reset(vec[i]);
        leer(vec[i], vecReg[i]);
    end;
minimo(vec, vecReg, min);
cantLocalidades:= 0;
read(mae, infoMae);
while(min.localidad <> valoralto) do
    begin
        cantCasosLocalidad:= 0;
        while(infoMae.localidad <> min.localidad) do
            read(mae, infoMae);
        while(infoMae.localidad = min.localidad) do
            begin
                while(infoMae.cepa <> min.cepa) do
                    read(mae, infoMae);
                while(infoMae.localidad = min.localidad) and (infoMae.cepa = min.cepa) do
                    begin
                        infoMae.cantFallecidos:= infoMae.cantFallecidos + min.cantFallecidos;
                        infoMae.cantRecuperados:= infoMae.cantRecuperados + min.cantRecuperados;
                        cantCasosLocalidad:= cantCasosLocalidad + min.cantActivos;
                        infoMae.cantActivos:= min.cantActivos;
                        infoMae.cantNuevos:= min.cantNuevos;
                        minimo(vec, vecReg, min);
                    end;
                seek(mae, filepos(mae)-1);
                write(mae, infoMae);
            end;
        writeln('Cantidad de casos en la localidad: ', cantCasosLocalidad);
        if(cantCasosLocalidad > 50) then
            cantLocalidades:= cantLocalidades + 1;
    end;
close(mae);
for i:= 1 to DF do
    close(vec[i]);
writeln('La cantidad de localidades con mas de 50 casos activos es: ', cantLocalidades);
end;

procedure imprimirMaestro(var m: maestro);
var
inM: infoM;
begin
reset(m);
while(not eof(m)) do
    begin
        read(m, inM);
        writeln('Localidad=', inM.localidad, ' Cepa=', inM.cepa, ' CA=', inM.cantActivos, ' CN=', inM.cantNuevos, ' CR=', inM.cantRecuperados, ' CF=', inM.cantFallecidos, ' NombreCepa=', inM.nombreCepa, ' NombreLocalidad=', inM.nombreLocalidad);
    end;
close(m);
end;

var
mae : maestro;
vec : vecD;
begin
crearDetalles(vec);
crearMaestro(mae);
actualizarMaestro(mae, vec);
imprimirMaestro(mae);
end.
