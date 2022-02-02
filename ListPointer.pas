unit ListPointer;

interface

Uses Tipos, stdctrls, SysUtils, Variants;

Const
  MIN = 1;
  MAX = 10; // Corte de Lista Llena
  Nulo= Nil; // Indica posicion invalida de la lista

Type
  PosicionLista = ^NodoLista;
  NodoLista = Object // Casillero en la Memoria de la lista
    Datos: TipoElemento;
    Ante,Prox: PosicionLista;
  End;
  Lista = Object
    Private
    Inicio, Final: PosicionLista;
    Q_Items: Integer;
// Comportamiento privado
    Procedure Intercambio (P,Q: PosicionLista);
    Public
// Comportamiento del objeto (Operaciones)
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

// Escribir la implementacion del Objeto LISTA
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
  EsLLena := (Q_items = MAX);
End;

// Agrega un Items al Final de Lista
Function Lista.Agregar(X:TipoElemento): Errores;
Var Q: PosicionLista;
Begin
  Agregar := CError;
  If EsLlena Then Agregar := LLena
  Else Begin
    New(Q); // DM ---> Casillero de la lista
    Q^.Datos := X;
    Q^.Prox := Nulo;
    Q^.Ante := Final;
    If EsVacia Then Inicio := Q // Primer elemento de la lista
    Else Final^.Prox := Q;
    Final := Q;
    Inc(Q_Items);
    Agregar := OK;
  End;
End;

// Inserta un Item entre el Inicio y el Final de Lista
Function Lista.Insertar(X:TipoElemento; P:PosicionLista): Errores;
Var Q: PosicionLista;
Begin
  Insertar := CError;
  If EsLlena Then Insertar := Llena
  Else Begin
    If ValidarPosicion(P) Then Begin
      New(Q); // DM ---> Casillero de la lista
      Q^.Datos := X;
      Q^.Prox := P;
      Q^.Ante := P^.Ante;
      If P = Inicio Then Inicio := Q // Caso que cambia el Inicio
      Else P^.Ante^.Prox := Q;
      P^.Ante := Q;
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
Var Q: PosicionLista;
  I: Integer;
Begin
  Ordinal := Nulo;
  If Not EsVacia Then Begin
    I := 1;
    Q := Inicio;
    While (I < PLogica) And (Q <> Nulo) Do Begin
      Inc(I);
      Q := Q^.Prox;
    End;
    If Q <> Nulo Then Ordinal := Q;
  End;
End;

// Elimina un elemento de cualquier posicion de la lista.
Function Lista.Eliminar (P:PosicionLista): Errores;
Var Q: PosicionLista;
Begin
  Eliminar := CError;
  If EsVacia() Then Eliminar := Vacia
  Else Begin
    If ValidarPosicion(P) Then Begin
      Q := P;
      If (P = Inicio) And (P = Final) Then Crear() // Unico de la lista. Se crea vacia
      Else Begin
        If (P = Inicio) Then Begin // Se elimina el primer elemento. Cambia el inicio
          Inicio := Inicio^.Prox;
          Inicio^.Ante := NULO;
        End
        Else If (P = Final) Then Begin // Se elimina el ultimo elemento. Cambia el Final
          Final := Final^.Ante;
          Final^.Prox := NULO;
        End
          Else Begin // Se elimina en cualquier otro lugar que no es ni Inicio, ni Final
            P^.Ante^.Prox := P^.Prox;
            P^.Prox^.Ante := P^.Ante;
          End;
        Dispose(Q); // Elimino la posicion de memoria
      End;
      Dec(Q_Items);
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
  While (Q <> Nulo) And Not(Encontre) Do Begin
    If Q^.Datos.CompararTE(X, ComparaPor) = igual then Encontre := True
    Else Q := Q^.Prox;
  End;
// Controla si lo encontro, si es asi retorno la posicion Q
  If Encontre Then Buscar := Q;
End;

// retorna el siguiente de una Posicion siempre que sea valida
// SINO retorna NULO
Function Lista.Siguiente(P:PosicionLista): PosicionLista;
Begin
  Siguiente := Nulo;
  If ValidarPosicion(P) Then Siguiente := P^.Prox;
End;

// retorna el anterior de una Posicion siempre que sea valida
// SINO retorna NULO
Function Lista.Anterior(P:PosicionLista): PosicionLista;
Begin
  Anterior := Nulo;
  If ValidarPosicion(P) Then Anterior := P^.Ante;
End;

// retorna por referencia en X el item de la lista
Function Lista.Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
Begin
  Recuperar := CError;
  If ValidarPosicion(P) Then Begin
    X := P^.Datos;
    Recuperar := OK;
  End
  Else
    Recuperar := PosicionInvalida;
  End;

// Cambia un Item dentro de la lista
Function Lista.Actualizar(X:TipoElemento; P:PosicionLista): Errores;
Begin
  Actualizar := CError;
  If ValidarPosicion(P) Then Begin
    P^.Datos := X;
    Actualizar := OK;
  End
  Else
    Actualizar := PosicionInvalida;
End;

// Valida una posicion de la lista
Function Lista.ValidarPosicion(P:PosicionLista): Boolean;
Var Q: PosicionLista;
  Encontre: Boolean;
Begin
  ValidarPosicion := False;
  If Not EsVacia() Then Begin
    Q := Inicio;
    Encontre := False;
    While (Q <> Nulo) And Not(Encontre) Do Begin
      If Q = P Then Encontre := True
      Else Q := Q^.Prox;
    End;
// Si encontro la posicion retorna verdadero
    If Encontre Then ValidarPosicion := True;
  End;
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

// Abre y Carga la lista de un archivo de TEXTOS
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
  Crear;
  X.Inicializar;
  Randomize;
  While Not EsLLena Do Begin
    X.DI := Random(RangoHasta);
    Agregar(X);
  End;
  LlenarRandom := OK;
End;

end.
