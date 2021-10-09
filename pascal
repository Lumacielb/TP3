program TP3;
uses crt;

Type

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
         cantidades: array[1..3] of real;
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








procedure menuprincipal();
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
