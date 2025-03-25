program ejer5;
type

celular = record
cod : integer;
nombre : string;
desc : string;
marca : string;
precio : real;
stockMin : integer;
stockDisp : integer;
end;

c = file of celular;

procedure cargarArchivo(var c : c);
var
    aTXT:text; cel:celular; nomBIN, nomTXT:string;
begin
    writeln('-- NUEVO ARCHIVO --');
    write('Archivo .txt para extraer informacion: '); readln(nomTXT);
    assign(aTXT,nomTXT);
    write('Nombre del nuevo archivo: '); readln(nomBIN);
    assign(c,nomBIN);
    rewrite(c);
    reset(aTXT);
    while(not EOF(aTXT)) do begin
        with cel do begin
            readln(aTXT,cod,precio,marca);
            readln(aTXT,stockDisp,stockMin,desc);
            readln(aTXT,nombre);
            write(c,cel);
        end;
    end;
    close(c);
    close(aTXT);
end;

procedure informarCelular(c:celular);
begin
    writeln('Codigo: ',c.cod);
    writeln('Nombre: ',c.nombre);
    writeln('Descripcion: ',c.desc);
    writeln('Marca: ',c.marca);
    writeln('Precio: ',c.precio);
    writeln('Stock minimo: ',c.stockMin,'; Stock actual: ',c.stockDisp);
end;

procedure stockMenor(var c : c);
var
    cel:celular;
begin
    writeln('-- LISTADO DE CELULARES CON STOCK MENOR AL MINIMO --');
    reset(c);
    while(not EOF(c)) do begin
        read(c,cel);
        if(cel.stockDisp < cel.stockMin) then
            informarCelular(cel);
    end;
    close(c);
end;

procedure buscarCadena(var c:c);
var
    cel:celular;descr:string;
begin
    writeln('-- LISTADO DE CELULARES CON DESCRIPCION DETERMINADA --');
    reset(c);
    write('Ingrese una descripcion: '); readln(descr);
    while(not EOF(c)) do begin
        read(c,cel);
        if(cel.desc = descr) then
            informarCelular(cel);
    end;
    close(c);
end;
procedure Exportar(var c:c);
var
    nomTXT:string; aTXT:text; cel:celular;
begin
    writeln('-- EXPORTAR A TXT --');
    reset(c);
    write('Nombre del archivo nuevo .txt: '); readln(nomTXT);
    assign(aTXT,nomTXT);
    rewrite(aTXT);
    while(not eof(c)) do begin
            read(c, cel);
            with cel do begin
                    writeln(aTXT, cod, ' ', precio:0:2, marca);
                    writeln(aTXT, stockDisp, ' ', stockMin, desc);
                    writeln(aTXT, nombre);
            end;
    end;
    close(aTXT);
    close(c);
    writeln('(!) Archivo .txt creado.')
end;

function menu():integer;
var
    opt:integer;
begin
    writeln('----- ABRIR ARCHIVO -----');
    writeln('1. Listar los datos de aquellos celulares que tengan un stock menor al stock mínimo');
    writeln('2. Listar los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario');
    writeln('3. Exportar el archivo creado a un archivo de texto');
    readln(opt);
    menu:= opt;
end;
procedure menuPrincipal(var c : c);
begin
    case menu() of
        1: stockMenor(c);
        2: buscarCadena(c);
        3: Exportar(c);
    else
        writeln('Opcion incorrecta.');
    end;
end;

var
cel : c;
begin
cargarArchivo(cel);
menuPrincipal(cel);
end.
