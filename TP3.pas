program TP3;
uses crt;

Type

// Registros
      rCiudad=RECORD
         codCiudad: string[3];
         nombreCiudad: string[40];
         end;

      rEmpresa=RECORD
         codEmp: string[3];
         nomEmp: string[40];
         direccion: string[40];
         mail: string[40];
         telefono: string[40];
         codCiudad: string[3];
         cantConsultas: integer;
         end;

      rProyecto=RECORD
         codProy: integer;
         codEmp: string[3];
         etapa: char;
         tipo: char;
         codCiudad: string[3];
         cantidades: array[1..3] of integer; // Cantidad de Productos | Cantidad de Consultas | Cantidad de Vendidos
         end;

      rProducto=RECORD
         codProd: integer;
         codProy: integer;
         precio: real;
         estado: char;
         detalle: string[50];
         end;

      rCliente=RECORD
         dni: string;
         nombre: string[40];
         mail: string[40];
         end;

//Archivos
         aCiudades= file of rCiudad;
         aEmpresas= file of rEmpresa;
         aProyectos= file of rProyecto;
         aProductos= file of rProducto;
         aClientes: file of rCliente;
   var
      Ciu:aCiudades; // Ciu,C
      C:rCiudad;
      Emp:aEmpresas; // Emp,E
      E:rEmpresa;
      Proy:aProyectos; // Proy,PY
      PY:rProyecto;
      Prod:aProductos; // Prod,PD
      PD:rProducto;
      Cli:aClientes; // Cli,CL
      CL:rCliente;


// Inicializa Archivos
procedure INICIALIZACION;
begin
  assign(aCiudades,'c:\pascal\Ciudades.dat');
  assign(aEmpresas,'c:\pascal\Empresas.dat');
  assign(aProyectos,'c:\pascal\Proyectos.dat');
  assign(aProductos,'c:\pascal\Productos.dat');
  assign(aClientes,'c:\pascal\Clientes.dat');
  {$I-}
  reset(aCiudades);
  if ioresult = 2 then rewrite(aCiudades);
  reset(aEmpresas);
  if ioresult = 2 then rewrite(aEmpresas);
  reset(aProyectos);
  if ioresult = 2 then rewrite(aProyectos);
  reset(aProductos);
  if ioresult = 2 then rewrite(aProductos);
  reset(aClientes);
  if ioresult = 2 then rewrite(aClientes);
  {$I+}
end;

// Búsqueda Dicotómica
function buscaDico (L:string[3]):boolean; 
begin
reset (aCiu);
 inferior:=0;
 superior:=filesize(aCiu)-1;
 band:= false;
 while (inferior<=superior) and (band=false) do
 begin
 medio:=(inferior+superior) div 2;
 seek(aCiu,medio);
 read(aCiu,C);
  if L=C.codCiudad
      then  band:=true
         else if L<C.codCiudad
         then superior:=medio-1
         else inferior:=medio+1;
 end;
 if band
 then buscaDico:= true
 else buscaDico:= false;
end;
      
// Valida Clave
function validarClave (x: string) : string;
var
   clave, ocult : string;
begin
   n := 0;
   ocult :='';
   clave := '';
   repeat
      write('Ingrese clave: ');
      ocult := readkey;
      while ocult <> #13 do
      begin
         clave += ocult;
         write('*');
         ocult := readkey;
      end;
      n +=1;
      if (clave <> x) then
      begin
         clave := '';
         writeln();
         textcolor(red);
         writeln('Clave INCORRECTA');
         textcolor(yellow);
      end;
   until (clave = x) or (n = 3);
   validacionClave := clave;
   if (clave = x) and (n <= 3) then
   begin
      writeln();
      textcolor(green);
      writeln('CLAVE CORRECTA');
      textcolor(yellow);
      write('Presione una tecla para continuar.. ');
      readkey;
   end;
end;

// Ordenamiento
procedure ordena;
begin
reset (Als);
for i:= 0 to filesize(Als)-2 do
       for j := i+1 to filesize(Als)-1 do
          begin
          Seek (Als ,i  );
          READ (Als, A);
          Seek (Als , j );
          READ (Als, B);
          if A.legajo  > B.legajo
              then
                  begin
                     Seek (Als ,i  );
                     Write (Als, B);
                     Seek (Als , j );
                     write (Als, A);
                   end;
         end;
end;

// ALTAS

procedure altaCiudades;
begin
   clrscr;
   seek(Ciu,filesize(Ciu)); // Paro el puntero al final del archivo
   gotoxy(30,2); writeln ('Alta de Ciudad');
   gotoxy(30,3); writeln ('................................' );
   writeln( );
   write ('Ingrese Código de Ciudad ( Fin de Datos = 0 ): ');
   readln (C.codCiudad);
   if buscaDico(C.codCiudad) then 
      writeln('La ciudad ya existe')
   else
      while C.codCiudad <> 0 do
      begin
         write ('Ingrese Nombre de Ciudad: ');
         readln (C.nombreCiudad);
         write(Ciu,C); // Grabo el registro completo en el archivo, el puntero ya lo posicioné antes al final del archivo
         writeln( );
         writeln( );
         write ('Ingrese Código de Ciudad ( Fin de Datos = 0 ): ');
         readln (C.codCiudad);
      end;
   end;
end;

procedure clientes;
begin
   clrscr;
   writeln('1. Alta de CLIENTE');
      // Al seleccionar esta opción se muestra un "Ingrese DNI", entonces
      // Se procede a comprobar si el cliente existe, en caso de que no, se lo carga
      // Luego, se muestran las siguientes opciones:
         // A. Consulta de PROYECTOS 
         // B. Compra de PRODUCTO
   writeln('0. Volver al menu principal');
end;

procedure empresas;
var
   op: Integer;
   clave : string;
begin
   clave:= validacionClave(claveEmp);
   clrscr;
   if (clave = claveEmp) and (n <= 3) then
   begin
      repeat
         repeat
            clrscr;
            writeln('Menu Empresas Desarrolladoras');
            writeln('1- Alta CIUDADES');
            writeln('2- Alta EMPRESAS');
            writeln('3- Alta PROYECTOS');
            writeln('4- Alta PRODUCTOS');
            writeln('5- ESTADISTICAS');
            writeln('0- Volver al Menu Principal');
            write('Ingrese opcion: ');
            readln(op);
         until (op >= 0) and (op <= 5);
      case op of
      1: altaCiudades;
      2: altaEmpresas;
      3: altaProyectos;
      4: altaProductos;
      5: ESTADISTICAS;
      end
      until op = 0;
   end
   else
   begin
      textcolor(red);
      writeln('Clave INCORRECTA. Supera los tres intentos');
      textcolor(yellow);
      write('Presione una tecla para volver al Menu Principal.. ');
      readkey;
   end;
   clrscr;
end;

procedure menuPrincipal;
var
   op : integer;
begin
   clrscr;
   repeat
      repeat
         //clrscr;
         writeln('Menu Principal');
         writeln('1- EMPRESAS');
         writeln('2- CLIENTES');
         write('Ingrese opcion: ');
         readln(op);
      until (op >= 0) and (op <= 2);
      clrscr;
      case op of
         1: EMPRESAS;
         2: CLIENTES;
      end
   until op = 0;
end.

// MENU PRINCIPAL
// 1. EMPRESAS
// 2. CLIENTES
// 0. Salir

// ------------

    // MENU EMPRESAS DESARROLLADORAS
    // 1. Alta de CIUDADES
    // 2. Alta de EMPRESAS
    // 3. Alta de PROYECTOS
    // 4. Alta de PRODUCTOS
    // 5. ESTADISTICAS
    // 0. Volver al menú principal

// ------------

    // MENU CLIENTES
    // 1. Alta de CLIENTE
        // A. Consulta de PROYECTOS 
        // B. Compra de PRODUCTO
    // 0. Vover al menú principal