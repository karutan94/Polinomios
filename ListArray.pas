unit ListArray;

interface

Uses Tipos, stdctrls, SysUtils, Variants;

Const
  MIN = 1;
  MAX = 100; // Corte de lista llena
  Nulo= 0; // Indica posicion invalida de la lista

Type
  PosicionLista = LongInt;
  Lista = Object
    Private
    Elementos: Array [MIN .. MAX] Of TipoElemento;
    Inicio, Final: PosicionLista;
    Q_Items: Integer;
// Comportamiento privado
    Procedure Intercambio (P,Q: PosicionLista);
    Public
// Comportamiento del objeto (Operaciones del TAO)
    Procedure Crear();
    Function EsVacia(): Boolean;
    Function EsLLena(): Boolean;
    Function Agregar(X:TipoElemento): Errores;
    Function Insertar(X:TipoElemento; P:PosicionLista): Errores;
    Function Eliminar(P:PosicionLista): Errores;
    Function Buscar(X:TipoElemento; ComparaPor:CampoComparar):PosicionLista;
    Function Siguiente(P:PosicionLista): PosicionLista;
    Function Anterior(P:PosicionLista): PosicionLista;
    Function Ordinal(PLogica: Integer): PosicionLista;
    Function Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
    Function Actualizar(X:TipoElemento; P:PosicionLista): Errores;
    Function ValidarPosicion(P:PosicionLista): Boolean;
    Function RetornarString(): String;
    Function LlenarRandom(RangoHasta: LongInt): Errores;
    Procedure Sort(ComparaPor: CampoComparar);
    Procedure Salvar(sFileName: String);
    Procedure Cargar(sFileName: String);
    Function Comienzo: PosicionLista;
    Function Fin: PosicionLista;
    Function CantidadElementos: LongInt;
  End;

// Escribir la implementación del Objeto LISTA
implementation

Procedure Lista.Crear();
Begin
  Inicio := Nulo;
  Final := Nulo;
  Q_Items := 0;
End;

Function Lista.EsVacia(): Boolean;
Begin
  EsVacia := (Inicio = Nulo);
End;

Function Lista.EsLLena(): Boolean;
Begin
  EsLLena := (Final = MAX);
End;

// Agrega un Items al Final de Lista
Function Lista.Agregar(X:TipoElemento): Errores;
Begin
  Agregar := CError;
  If EsLlena Then
  Agregar := LLena
  Else Begin
    Final := Final + 1;
    Elementos[Final] := X;
    Inc(Q_Items);
    If EsVacia Then Inicio := Final;
      Agregar := OK;
  End;
End;

// Inserta un Item entre el Inicio y el Final de Lista
Function Lista.Insertar(X:TipoElemento; P:PosicionLista): Errores;
Var Q: PosicionLista;
Begin
  Insertar := CError;
  If EsLLena Then
    Insertar := LLena
  Else Begin
    If ValidarPosicion(P) Then Begin
      For Q := Final DownTo P Do
        Elementos[Q+1] := elementos[Q]; // Genera el hueco dentro de la lista
// Ahora pego el dato en la posicion recibida (P)
      Elementos[P] := X;
      Inc(Final);
      Inc(Q_Items);
      Insertar := OK;
    End
    Else
      Insertar := PosicionInvalida;
  End;
End;

// Retorno la posicion fisica que se corresponde con la logica
// En este caso particular coinciden ambas
Function Lista.Ordinal(PLogica: Integer): PosicionLista;
Begin
  Ordinal := PLogica;
End;

// Elimina un item de la lista. Cualquier posicion Valida
Function Lista.Eliminar(P:PosicionLista): Errores;
Var Q: PosicionLista;
Begin
  Eliminar := CError;
  If EsVacia Then
    Eliminar := Vacia
  Else Begin
    If ValidarPosicion(P) Then Begin
      For Q := P To (Final - 1) Do
        Elementos[Q] := elementos[Q + 1]; // Aplasta el item a borrar
// Actualizo el final y la cantidad
      Dec(Final);
      Dec(Q_Items);
      If Final < Inicio Then Crear(); //Si borrar el unico que hay se crea vacia
        Eliminar := OK;
    End
    Else
      Eliminar := PosicionInvalida;
  End;
End;

// Busca un elemento dentro de la lista en función de un dato
// Retorna la posición o NULO según corresponda
Function Lista.Buscar(X:TipoElemento; ComparaPor: CampoComparar): PosicionLista;
Var Q: PosicionLista;
  Encontre: Boolean;
Begin
  Buscar := Nulo;
  Encontre:= False;
// Arranca por el Inicio y con Q recorre la lista
  Q := Inicio;
  While (Q <> Nulo) And (Q <= Final) And Not(Encontre) Do Begin
    If Elementos[Q].CompararTE(X, ComparaPor) = igual then Encontre := True
    Else Q := Q + 1;
  End;
// Controla si lo encontro, si es asi retorno la posicion Q
  If Encontre Then Buscar := Q;
End;

// retorna el siguiente de una Posicion siempre que sea valida
// SINO retorna NULO
Function Lista.Siguiente(P:PosicionLista): PosicionLista;
Begin
  Siguiente := Nulo;
  If ValidarPosicion(P) And (P < Final) Then Siguiente := P + 1;
End;

// retorna el anterior de una Posicion siempre que sea valida
// SINO retorna NULO
Function Lista.Anterior(P:PosicionLista): PosicionLista;
Begin
  Anterior := Nulo;
  If ValidarPosicion(P) And (P > Inicio) Then Anterior := P - 1;
End;

// retorna por referencia en X el item de la lista
Function Lista.Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
Begin
  Recuperar := CError;
  If ValidarPosicion(P) Then Begin
    X := Elementos[P];
    Recuperar := OK;
  End;
End;

// Cambia un Item dentro de la lista
Function Lista.Actualizar(X:TipoElemento; P:PosicionLista): Errores;
Begin
  Actualizar := CError;
  If ValidarPosicion(P) Then Begin
    Elementos[P] := X;
    Actualizar := OK;
  End;
End;

// Valida una posicion de la lista
Function Lista.ValidarPosicion(P:PosicionLista): Boolean;
Begin
  ValidarPosicion := False;
  If Not EsVacia and (P >= Inicio) And (P <= Final) Then ValidarPosicion := True;
End;

// Intercambia los datos entre 2 posiciones de la misma lista
Procedure Lista.Intercambio (P,Q: PosicionLista);
Var X1, X2: TipoElemento;
Begin
  Recuperar(X1, P);
  Recuperar(X2, Q);
  Actualizar(X2, P);
  Actualizar(X1, Q);
End;

// Ordena la lista. Ordena los strings sencible a Mayusculas y Minusculas
Procedure Lista.Sort(ComparaPor: CampoComparar);
Var P, Q: PosicionLista;
  X1, X2: TipoElemento;
Begin
  X1.Inicializar;
  X2.Inicializar;
// Ordeno por metodo de burbuja
  P := Inicio;
  While P <> Nulo Do Begin
    Q := Inicio;
    While Q <> Nulo Do begin
      Recuperar(X1, Q);
      If Siguiente(Q) <> Nulo Then Begin
        Recuperar(X2, Siguiente(Q));
        Case ComparaPor Of
          CDI: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q,Siguiente(Q));
          CDR: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q,Siguiente(Q));
          CDS: If X1.CompararTE(X2, ComparaPor) = mayor Then Intercambio(Q,Siguiente(Q));
        End;
      End;
      Q := Siguiente(Q);
    End;
    P := Siguiente(P);
  End;
End;

// Retorna un string con todos los elementos de lista
// Cada campo de cada item separado por Tabuladores
// Cada Item separado por Retorno de Carro + Final de Linea
Function Lista.RetornarString():String;
Var Q: PosicionLista;
  X: TipoElemento;
  S, SS: String;
Begin
  SS:= '';
  Q := Inicio;
  While Q <> Nulo Do Begin
    Recuperar(X, Q);
    S := X.ArmarString;
    SS := SS + S + cCRLF;
    Q := Siguiente(Q);
  End;
  RetornarString := SS;
End;

// Graba la lista en un archivo de TXT separado por Tabuladores
Procedure Lista.Salvar(sFileName: String);
Var Q: PosicionLista;
  X: TipoElemento;
  S: String;
  T: TextFile;
Begin
  AssignFile(T, sFileName);
  Rewrite(T);
  Q := inicio;
  While Q <> Nulo Do Begin
    Recuperar(X, Q);
    S := X.ArmarString;
    Q := Siguiente(Q);
    Writeln(T, S);
  End;
  CloseFile(T);
End;

// Abre la lista de un archivo de TEXTOS
Procedure Lista.Cargar(sFileName: String);
Var X: TipoElemento;
  T: TextFile;
  S: String;
Begin
  AssignFile(T, sFileName);
  Reset(T);
  Crear;
  While Not Eof(T) Do Begin
    Readln(T, S);
    X.CargarTE(S);
    Agregar(X);
  End;
  CloseFile(T);
End;

Function Lista.Comienzo: PosicionLista;
Begin
  Comienzo := Inicio;
End;

Function Lista.Fin: PosicionLista;
Begin
  Fin := Final;
End;

Function Lista.CantidadElementos: LongInt;
Begin
  CantidadElementos := Q_Items;
End;

// Llena la lista de 0 a <RangoHasta> el atributo DI de la lista
Function Lista.LlenarRandom(RangoHasta: LongInt): Errores;
Var X: TipoElemento;
Begin
  LlenarRandom := CError;
  Crear; // Siempre la Crea vacia
  X.Inicializar;
  Randomize;
  While Not EsLLena Do Begin
    X.DI := Random(RangoHasta);
    Agregar(X);
  End;
  LlenarRandom := OK;
End;

end.
