program ejercicio13;
const
    valoralto = 999;
type
    infoMaestro = record
        usuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cant: integer;
    end;
    infoDetalle = record
        usuario: integer;
        destino: string;
        cuerpo: string;
    end;
    maestro = file of infoMaestro;
    detalle = file of infoDetalle;
procedure crearMaestro(var mae: maestro);
var
    carga: text;
    nombre: string;
    infoMae: infoMaestro;
begin
    assign(carga, 'logmail.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo maestro');
    readln(nombre);
    assign(mae, nombre);
    rewrite(mae);
    while(not eof(carga)) do
        begin
            with infoMae do
                begin
                    readln(carga, usuario, cant, nombreUsuario);
                    readln(carga, nombre);
                    readln(carga, apellido);
                    write(mae, infoMae);
                end;
        end;
    writeln('Archivo binario maestro creado');
    close(mae);
    close(carga);
end;
procedure crearDetalle(var det: detalle);
var
    carga: text;
    nombre: string;
    infoDet: infoDetalle;
begin
    assign(carga, 'detalle.txt');
    reset(carga);
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(det, nombre);
    rewrite(det);
    while(not eof(carga)) do
        begin
            with infoDet do
                begin
                    readln(carga, usuario, destino);
                    readln(carga, cuerpo);
                    write(det, infoDet);
                end;
        end;
    writeln('Archivo binario detalle creado');
    close(det);
    close(carga);
end;
procedure leer(var det: detalle; var infoDet: infoDetalle);
begin
    if(not eof(det)) then
        read(det, infoDet)
    else
        infoDet.usuario:= valoralto;
end;
procedure exportarTexto(var mae: maestro); //Opcion I
var
    infoMae: infoMaestro;
    txt: text;
begin
    reset(mae);
    assign(txt, 'usuarios.txt');
    rewrite(txt);
    while(not eof(mae)) do
        begin
            read(mae, infoMae);
            writeln(txt, infoMae.usuario, ' ', infoMae.cant);
        end;
    close(txt);
    close(mae);
end;
procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
    infoMae: infoMaestro;
    infoDet: infoDetalle;
    cant: integer;
    txt: text;
begin
    assign(txt, 'usuarios2.txt');
    rewrite(txt);
    reset(mae);
    reset(det);
    leer(det, infoDet);
    while(infoDet.usuario <> valoralto) do
        begin
            read(mae, infoMae);
            while(infoDet.usuario <> infoMae.usuario) do
                read(mae, infoMae);
            while(infoDet.usuario = infoMae.usuario) do
                begin
                    infoMae.cant:= infoMae.cant + 1;
                    leer(det, infoDet);
                end;
            writeln(txt, infoMae.usuario, ' ', infoMae.cant); //Opcion II
            seek(mae, filepos(mae)-1);
            write(mae, infoMae);
        end;
    reset(txt);
    close(mae);
    close(det);
end;
var
    mae: maestro;
    det: detalle;
begin
    crearDetalle(det);
    crearMaestro(mae);
    actualizarMaestro(mae, det);
    exportarTexto(mae);
end.
