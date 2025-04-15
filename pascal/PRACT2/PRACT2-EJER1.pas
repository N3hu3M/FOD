program ejer1Pract2;
const 
valoralto = -1;
type

empleados = record 
cod : integer;
nom : String;
monto : real;
end;

archivo_empleados = file of empleados;


procedure crearArchivo (var arc : archivo_empleados;var carga : text);
var
  nombre: string;
  emp: empleados;
begin
  writeln('Ingrese un nombre del archivo a crear');
  readln(nombre);
  assign(arc, nombre);
  reset(carga);
  rewrite(arc);//ACA SIMPLEMENTE ABRE EL ARCHIVO CREADO Y REABRE EL DE TEXTO
  while(not eof(carga)) do//FIN DE ITERACION (END OF FILE)
      begin
          with emp do//A LA VARIABLE EMP LE PONE LO DE ABAJO
              begin
                  readln(carga, cod, monto, nom);//valores en la variable emp
                  write(arc, emp);//HA SIDO GUARDADO EN OTRO ARCHIVO
              end;
      end;
  writeln('Archivo binario creado');
  close(arc);
  close(carga);
end;

procedure leer(var arc: archivo_empleados; var dato: empleados);
begin
    if(not(eof(arc))) then
        read(arc, dato)
    else
        dato.cod := valoralto;
end;

procedure actualizarMaestro(var arc : archivo_empleados; var maestro : archivo_empleados);
var
emp, aux : empleados;
total : real;
begin
  assign(maestro, 'archivoCompactado');
  reset(arc);
  rewrite(maestro);
  leer(arc, emp);
  while(emp.cod <> valoralto) do
      begin
          aux:= emp;
          total:= 0;
          while(aux.cod = emp.cod) do
              begin
                  total:= total + emp.monto;
                  leer(arc, emp);
              end;
          aux.monto:= total;
          write(maestro, aux);
      end;
  close(maestro);
  close(arc);
end;

procedure imprimirMaestro(var maestro: archivo_empleados);
var
    emp: empleados;
begin
    reset(maestro);
    while(not EOF(maestro)) do
        begin
            read(maestro, emp);
            writeln('Codigo=', emp.cod, ' Nombre=', emp.nom, ' MontoTotal=', emp.monto:0:2);
        end;
    close(maestro);
end;

var
  arc, maestro: archivo_empleados;
  carga: text;
begin
  assign(carga, 'empleados.txt');
  crearArchivo(arc, carga);
  actualizarMaestro(arc, maestro);
  imprimirMaestro(maestro);
end.
