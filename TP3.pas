program TP3;
uses crt;

Type

// Registros
      Ciudad=RECORD
         codCiudad: string[3];
         nombreCiudad: string[40];
         end;

      Empresa=RECORD
         codEmp: string[3];
         nomEmp: string[40];
         direccion: string[40];
         mail: string[40];
         telefono: string[40];
         codCiudad: string[3];
         cantConsultas: integer;
         end;

      Proyecto=RECORD
         codProy: integer;
         codEmp: string[3];
         etapa: char;
         tipo: char;
         codCiudad: string[3];
         cantidades: array[1..3] of integer; // Cantidad de Productos | Cantidad de Consultas | Cantidad de Vendidos
         end;

      Producto=RECORD
         codProd: integer;
         codProy: integer;
         precio: real;
         estado: char;
         detalle: string[50];
         end;

      Cliente=RECORD
         dni: string;
         nombre: string[40];
         mail: string[40];
         end;

//Archivos
         Ciudades= file of Ciudad;
         Empresas= file of Empresa;
         Proyectos= file of Proyecto;
         Productos= file of Producto;
         Clientes= file of Cliente;
   var
      aCiu:Ciudades; // aCiu,rC
      rC, rA, rB:Ciudad;
      aEmp:Empresas; // Emp,E
      rE:Empresa;
      aProy:Proyectos; // Proy,PY
      rPY:Proyecto;
      aProd:Productos; // Prod,PD
      rPD:Producto;
      aCli:Clientes; // Cli,CL
      rCL:Cliente;
      opcion:char;


// Inicializa Archivos
procedure INICIALIZACION;
begin
  assign(aCiu,'C:\Pascal\Ciudades.dat');
  assign(aEmp,'C:\Pascal\Empresas.dat');
  assign(aProy,'C:\Pascal\Proyectos.dat');
  assign(aProd,'C:\Pascal\Productos.dat');
  assign(aCli,'C:\Pascal\Clientes.dat');
  {$I-}
  reset(aCiu);
  if ioresult = 2 then rewrite(aCiu);
  reset(aEmp);
  if ioresult = 2 then rewrite(aEmp);
  reset(aProy);
  if ioresult = 2 then rewrite(aProy);
  reset(aProd);
  if ioresult = 2 then rewrite(aProd);
  reset(aCli);
  if ioresult = 2 then rewrite(aCli);
  {$I+}
end;

// Búsqueda Dicotómica
function buscaDico (L:string):boolean; 
var
inferior, superior, medio: integer;
band:boolean;

begin
 //writeln('Variable L: ',L);
 //readKey;
 reset (aCiu);
 inferior:=0;
 superior:=filesize(aCiu)-1;
 band:= false;
 while (inferior<=superior) and (band=false) do
 begin
 medio:=(inferior+superior) div 2;
 seek(aCiu,medio);
 read(aCiu,rC);
 //writeln('Variable L: ',L);
 //writeln('Variable RC: ',rC.codCiudad);
 //readkey;
  if L=rC.codCiudad
      then  band:=true
      else if L<rC.codCiudad
         then superior:=medio-1
         else inferior:=medio+1;
 end;
 if band
 then buscaDico:= true

 else buscaDico:= false;
end;

function login(tipo: char): boolean;
var
intentos, i: integer;
clave, clave1, clave2 : string;
c: char;
begin
intentos := 3;
clave := '';
clave1 := 'emp107';
clave2 := 'cli107';
while (intentos > 0) do
begin
   intentos := (intentos-1);
   ClrScr;
   textcolor(11);
   gotoxy(5,2);writeln('Ingrese la clave. ', intentos + 1, ' intentos restantes');

   repeat
   c := readKey;
   ClrScr;
   gotoxy(5,2);writeln('Ingrese la clave. ', intentos + 1, ' intentos restantes');
   gotoxy(5,4);
   if c = #08 then
   begin
      delete(clave,length(clave),1);
      for i := 1 to length(clave) do
      write('*');
   end
   else
   begin
      if c <> #13 then
   begin
      clave := clave + c;
      for i := 1 to length(clave) do
      write('*')
   end;
   end;
   until (c = #13);
   if tipo = '1' then
   begin
   if (clave = clave1) then
      exit(true)    
   else
      clave := '';
      gotoxy(5,3);textcolor(14);writeln('Clave incorrecta espere por favor..');
      delay(1500);
      textcolor(white);
   end;
   if tipo = '2' then
   begin
      if clave = clave2 then
      exit(true)
   else
      clave := '';
      gotoxy(5,3);textcolor(14);writeln('Clave incorrecta espere por favor..');
      delay(1500);
      textcolor(white); 
   end;
 end;
textcolor(4);gotoxy(5,5);writeln('Agotaste los intentos, programa bloqueado temporalmente.');
delay(2000);
Halt(0);
exit(false);
end;
      
// Ordenamiento
procedure ordena;
var
i,j : integer;

begin
reset (aCiu);
for i:= 0 to filesize(aCiu)-2 do
       for j := i+1 to filesize(aCiu)-1 do
          begin
          Seek (aCiu ,i  );
          READ (aCiu, rA);
          Seek (aCiu , j );
          READ (aCiu, rB);
          if rA.codCiudad  > rB.codCiudad
              then
                  begin
                     Seek (aCiu ,i  );
                     Write (aCiu, rB);
                     Seek (aCiu , j );
                     write (aCiu, rA);
                   end;
         end;
end;

// ALTAS

procedure altaCiudades;
begin
   clrscr;
   seek(aCiu,filesize(aCiu)); // Paro el puntero al final del archivo
   gotoxy(30,2); writeln ('Alta de Ciudad');
   gotoxy(30,3); writeln ('..............' );
   writeln( );
   repeat //Nos cercioramos que no permita cargar un código vacio
      write ('Ingrese Codigo de Ciudad ( Fin de Datos = 0 ): ');
      readln (rC.codCiudad);
   until rC.codCiudad <> '';
   while rC.codCiudad <> '0' do
   begin
      if buscaDico(rC.codCiudad) then
         begin 
         clrscr;
         gotoxy(30,2); writeln ('Alta de Ciudad');
         gotoxy(30,3); writeln ('..............' );
         writeln( );
         writeln('La Ciudad ya existe.');
         delay(2000);
         writeln('Por favor, ingrese Codigo de Ciudad nuevamente, o bien, 0 para volver al menu.');
         delay(2000);
         writeln( );
         //rC.codCiudad := '0';
         repeat //Nos cercioramos que no permita cargar un código vacio
            write ('Ingrese Codigo de Ciudad ( Fin de Datos = 0 ): ');
            readln (rC.codCiudad);
         until rC.codCiudad <> '';
         end
      else
         begin
            write ('Ingrese Nombre de Ciudad: ');
            readln (rC.nombreCiudad);
            write(aCiu,rC); // Grabo el registro completo en el archivo, el puntero ya lo posicioné antes al final del archivo
            writeln( );
            writeln( );
            repeat //Nos cercioramos que no permita cargar un código vacio
            write ('Ingrese Codigo de Ciudad ( Fin de Datos = 0 ): ');
            readln (rC.codCiudad);
            until rC.codCiudad <> '';
         end;
   end;
end;

procedure menuClientes();
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

procedure menuEmpresas();
var
   op: char;
begin
   clrscr;
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
         until (op >= '0') and (op <= '5');
      case op of
      '1': altaCiudades;
      //2: altaEmpresas;
      //3: altaProyectos;
      //4: altaProductos;
      //5: ESTADISTICAS;
      end;
      until op = '0';
end;


// MENU PRINCIPAL
begin
   //clrscr;
   INICIALIZACION();
   repeat
      repeat
         clrscr;
         writeln('Menu Principal');
         writeln('1- EMPRESAS');
         writeln('2- CLIENTES');
         write('Ingrese opcion: ');
         readln(opcion);
      until (opcion >= '0') and (opcion <= '2');
      clrscr;
      if login(opcion) then
         case opcion of
            '1': menuEmpresas();
            '2': menuClientes();
         end
      else
      opcion := '0';
   until opcion = '0';
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