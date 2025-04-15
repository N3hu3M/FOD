program ejercicio10;
const
valoralto = 999;
type
subCat = 1..15;
empleado = record
    departamento: integer;
    division: integer;
    num: integer;
    categoria: integer;
    cantHoras: integer;
end;
maestro = file of empleado;
categoria = array[subCat] of real;
procedure crearMaestro(var mae: maestro);
var
    carga: text;
    nombre: string;
    infoMae: empleado;
begin
assign(carga, 'empleados.txt');
reset(carga);
writeln('Ingrese un nombre para el archivo maestro');
readln(nombre);
assign(mae, nombre);
rewrite(mae);
while(not eof(carga)) do
    begin
        with infoMae do
           begin
                readln(carga, departamento, division, num, categoria, cantHoras);
                write(mae, infoMae);
           end;
   end;
writeln('Archivo binario maestro creado');
close(mae);
close(carga);
end;
procedure cargarVector(var vecCat: categoria);
var
txt: text;
categoria: subCat;
monto: real;
begin
assign(txt, 'categoriaValor.txt');
reset(txt);
while(not eof(txt)) do
    begin
        read(txt, categoria, monto);
        vecCat[categoria]:= monto;
    end;
close(txt);
end;
procedure leer(var mae: maestro; var emp: empleado);
begin
if(not eof(mae)) then
    read(mae, emp)
else
    emp.departamento:= valoralto;
end;
procedure corteDeControl(var mae: maestro; vecCat: categoria);
var
emp: empleado;
montoHorasDepto, montoTotalDiv, montoTotalEmp: real;
cantHorasDepto, cantHorasDiv, cantHorasEmp, deptoActual, divActual, empActual, categoria: integer;
begin
reset(mae);
leer(mae, emp);
while(emp.departamento <> valoralto) do
    begin
        writeln();
        writeln('-------Departamento: ', emp.departamento, ' -------');
        deptoActual:= emp.departamento;
        cantHorasDepto:= 0;
        montoHorasDepto:= 0;
        while(deptoActual = emp.departamento) do
            begin
                writeln();
                writeln('Division: ', emp.division);
                montoTotalDiv:= 0;
                cantHorasDiv:= 0;
                divActual:= emp.division;
                writeln('Numero de Empleado     Total de HS    Importe a cobrar');
                while((deptoActual = emp.departamento) and (divActual = emp.division)) do
                    begin
                        montoTotalEmp:= 0;
                        cantHorasEmp:= 0;
                        empActual := emp.num;
                        categoria:= emp.categoria;
                        while((deptoActual = emp.departamento) and (divActual = emp.division) and (empActual = emp.num)) do
                            begin
                                cantHorasEmp:= cantHorasEmp + emp.cantHoras;
                                leer(mae, emp);
                            end;
                        montoTotalEmp:= vecCat[categoria] * cantHorasEmp;
                        writeln(empActual, '                          ', cantHorasEmp, '           ', montoTotalEmp:0:2);
                        montoTotalDiv:= montoTotalDiv + montoTotalEmp;
                        cantHorasDiv:= cantHorasDiv + cantHorasEmp;
                    end;
                writeln('Total de horas por division: ', cantHorasDiv);
                writeln('Monto total por division: ', montoTotalDiv:0:2);
                montoHorasDepto:= montoHorasDepto + montoTotalDiv;
                cantHorasDepto:= cantHorasDepto + cantHorasDiv;
            end;
        writeln();
        writeln('Total horas departamento: ', cantHorasDepto);
        writeln('Monto total departamento: ', montoHorasDepto:0:2);
    end;
end;
var
mae: maestro;
vecCat: categoria;
begin
crearMaestro(mae);
cargarVector(vecCat);
corteDeControl(mae, vecCat);
end.
