program ejer5;
const
valoralto =-1;
DF = 5;
type
logs = record
cod_usuario : integer;
fecha : string;
tiempo_sesion : integer;
end;

maestro = file of logs;
detalle = file of logs;

vec = array[1..DF] of detalle;
vecL = array[1..DF] of logs;

procedure leer(var det: detalle; var infoDet: logs);
begin
if(not eof(det)) then
    read(det, infoDet)
else
    infoDet.cod_usuario := valoralto;
end;

procedure minimo(var vec: vec; var vecReg: vecL; var min: logs);
var
i, pos: integer;
begin
min.cod_usuario:= valoralto;
min.fecha:= 'ZZZZ';
for i:= 1 to DF do
    if (vecReg[i].cod_usuario < min.cod_usuario) or ((vecReg[i].cod_usuario = min.cod_usuario) and (vecReg[i].fecha < min.fecha)) then
        begin
            min:= vecReg[i];
            pos:= i;
        end;
if(min.cod_usuario <> valoralto) then
    leer(vec[pos], vecReg[pos]);
end;

procedure crearMaestro(var mae : maestro;var vec: vec);
var
min, aux: logs;
vecReg: vecL;
i: integer;
begin
//assign(mae, './var/log'); No funciona;
assign(mae, 'ArcMaestro');
rewrite(mae);
for i:= 1 to DF do
    begin
        reset(vec[i]);
        leer(vec[i], vecReg[i]);
    end;
minimo(vec, vecReg, min);
while(min.cod_usuario <> valoralto) do
    begin
        aux.cod_usuario:= min.cod_usuario;
        while(aux.cod_usuario = min.cod_usuario) do
            begin
                aux.fecha:= min.fecha;
                aux.tiempo_sesion:= 0;
                while(aux.cod_usuario = min.cod_usuario) and (aux.fecha = min.fecha) do
                    begin
                        aux.tiempo_sesion:= aux.tiempo_sesion + min.tiempo_sesion;
                        minimo(vec, vecReg, min);
                    end;
                write(mae, aux);
            end;
    end;
close(mae);
for i:= 1 to DF do
    close(vec[i]);
end;

procedure crearUnDetalle(var d : detalle);
var
nom: string;
s : logs;
carga : text;
begin
writeln('Ingrese la ruta del detalle');
readln(nom);
assign(carga, nom);
reset(carga);
writeln('Ingrese un nombre para el archivo detalle');
readln(nom);
assign(d, nom);
rewrite(d);
while(not eof(carga)) do
    begin
        with s do begin
            readln(s.cod_usuario, s.tiempo_sesion, s.fecha);
            write(d, s);
        end;
    end;
writeln('Archivo binario detalle creado');
close(d);
close(carga);
end;

procedure crearDetalles(var v : vec);
var
i : integer;
begin
for i:= 1 to DF do
  crearUnDetalle(v[i]);
end;

var
v : vec;
mae : maestro;
begin
crearDetalles(v);
crearMaestro(mae,v);

end.
