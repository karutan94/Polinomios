Unit ListCursor;

Interface

Uses Tipos, stdctrls, SysUtils, Variants;

Const
  MIN = 1;
  MAX = 10; // Corte de lista llena
  NULO= 0; // Indica posicion invalida de la lista

Type
  PosicionLista = Integer;
  Nodo_Lista = Object
    Dato: Tipoelemento;
    Prox, Ante: PosicionLista;
  End;
  Lista = Object
    Private
    Cursor: Array[MIN..MAX] Of Nodo_Lista;
    Inicio, Final, Libre: PosicionLista;
    Q_Items: LongInt;
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

Implementation

Procedure Lista.Crear();
Var Q: PosicionLista;
Begin
  For Q := MIN To MAX - 1 Do // Encadenamientos de Libres
    Cursor[Q].Prox := Q + 1;
  Cursor[MAX].Prox := NULO;
  Libre := MIN;
  Inicio := NULO;
  Final := NULO;
  Q_items := 0;
End;

Function Lista.EsVacia(): Boolean;
Begin
  EsVacia := (Inicio = NULO);
End;

Function Lista.EsLlena(): Boolean;
Begin
  EsLlena := (Libre = NULO);
End;

Function Lista.Siguiente (P:PosicionLista): PosicionLista;
Var Q: PosicionLista;
Begin
  If EsVacia() Or (P = NULO) Then Q := NULO
  Else Q := Cursor[P].Prox;
  Siguiente := Q;
End;

Function Lista.Anterior (P:PosicionLista): PosicionLista;
Var Q: PosicionLista;
Begin
  If EsVacia() Or (P = NULO) Then Q := NULO
  Else Q := Cursor[P].Ante;
  Anterior := Q;
End;

// Agrega elementos al final de la lista. Despues del ultimo.
Function Lista.Agregar(X:TipoElemento): Errores;
Var Q: PosicionLista;
Begin
  Agregar := CError;
  If Not(Esllena()) Then Begin
    Q := Libre; // Tomo el primer libre disponible
    Libre := Cursor[Libre].Prox; // Encadeno el resto de los libres
    Cursor[Q].Dato := X;
    Cursor[Q].Prox := NULO;
    Cursor[Q].Ante := Final;
    If EsVacia() Then Inicio := Q // Controlo si es el primer elemento de la lista
    Else Cursor[Final].Prox := Q;
    Final := Q;
    Inc(Q_items);
    Agregar := OK;
  End
  Else
    Agregar := Llena;
End;

// Inserta un elemento en cualquier lugar de la lista.
Function Lista.Insertar(X:TipoElemento; P:PosicionLista): Errores;
Var Q: PosicionLista;
Begin
  Insertar := CError;
  If Esllena() Then Insertar := LLena
  Else Begin
  If ValidarPosicion(P) Then Begin
    Q := Libre; // Tomo el primer libre disponible
    Libre := Cursor[Libre].Prox; // Encadeno el resto de los libres
    Cursor[Q].Dato := X;
    Cursor[Q].Prox := P;
    Cursor[Q].Ante := Cursor[P].Ante;
    Cursor[P].Ante := Q;
    If P = Inicio Then Inicio := Q
    Else Cursor[Cursor[Q].Ante].Prox := Q;
    Inc(Q_items);
    Insertar := OK;
  End
  Else
    Insertar := PosicionInvalida;
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
        Inicio := Cursor[Inicio].Prox;
        cursor[Inicio].Ante := NULO;
        End
        Else If (P = Final) Then Begin // Se elimina el ultimo elemento. Cambia el Final
          Final := cursor[Final].Ante;
          Cursor[Final].Prox := NULO;
        End
          Else Begin // Se elimina en cualquier otro lugar que no es ni Inicio, ni Final
            Cursor[Cursor[P].Ante].Prox := Cursor[P].Prox;
            Cursor[Cursor[P].Prox].Ante := Cursor[P].Ante;
          End;
        Cursor[Q].Prox := Libre; // retorno a Libres el Nodo Eliminado
        Libre := Q;
      End;
      Dec(Q_Items);
      Eliminar := OK;
    End
    Else
      Eliminar := PosicionInvalida;
  End;
End;

Function Lista.Buscar(X:TipoElemento; ComparaPor: CampoComparar): PosicionLista;
Var Q: PosicionLista;
  Encontre: Boolean;
Begin
// Asumimos que no existe
  Buscar := NULO;
  Q := Inicio;
  Encontre := False;
// Comienza la busqueda desde inicio a fin
  While (Q <> NULO) And (Not(Encontre)) Do Begin
    If X.CompararTE(Cursor[Q].Dato, ComparaPor) <> igual Then
      Q := Cursor[Q].Prox
    Else
      Encontre := True;
  End;
// Si la encontro retorno Q = Posicion del Primer elemento encontrado.
  If Encontre Then Buscar := Q;
End;

// Recupera el elemento de la posicion P, retornandolo en X
Function Lista.Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
Begin
  Recuperar := CError;
  If EsVacia() Then Recuperar := Vacia
  Else Begin
    If (P <> NULO) And ValidarPosicion(P) Then Begin
      X := Cursor[P].Dato;
      Recuperar := OK;
    End
    Else
    Recuperar := PosicionInvalida;
    End;
End;

// Actualiza La posicion P. Sobreescribe todo el elemento sin importar su contenido
Function Lista.Actualizar (X:TipoElemento; P:PosicionLista): Errores;
Begin
  Actualizar := CError;
  If EsVacia() Then Actualizar := Vacia
  Else Begin
    If (P <> NULO) And ValidarPosicion(P) Then Begin
      Cursor[P].Dato := X;
      Actualizar := OK;
    End
    Else
    Actualizar := PosicionInvalida;
  End;
End;

// Retorna la posicion fisica de la lista a partir de la posicion ordinal
// de inicio a final
Function Lista.Ordinal(PLogica: Integer): PosicionLista;
Var Q: PosicionLista;
  I: Integer;
Begin
  Ordinal := Nulo;
  If Not EsVacia() Then Begin
    I := 1;
    Q := Inicio;
    While (I < PLogica) And (Q <> Nulo) Do Begin
      Inc(I);
      Q := cursor[Q].Prox;
    End;
    If Q <> Nulo Then Ordinal := Q;
  End;
End;

// Valida que la posicion P pertenezca a esta lista
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
    Else Q := cursor[Q].Prox;
  End;
// Si encontro la posicion retorna verdadero
  If Encontre Then ValidarPosicion := True;
  End;
End;

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

// Retorna toda la lista en un string para luego mostrarla en un memo
// Directamente
Function Lista.RetornarString(): String ;
Var Q: PosicionLista;
  X: TipoElemento;
  S: String;
  SS:String;
Begin
  SS := '';
  Q := Inicio;
  While Q <> Nulo Do Begin
    Recuperar(X, Q);
    S:= X.ArmarString; // Concatena separado por TAB los atributos de X
    SS := SS + S + cCRLF; // Retorno que carro + fin de linea
    Q := Siguiente(Q);
  End;
  RetornarString := SS;
End;

// Guarda la lista en un archivo TXT pasado por parametro separado por TAB
Procedure Lista.Salvar(sFileName: String);
Var Q: PosicionLista;
  X: TipoElemento;
  S: String;
  T: TextFile;
Begin
  AssignFile(T, sFileName);
  Rewrite(T); //Siempre se sobreescribe el archivo
  Q := Inicio;
  While Q <> Nulo Do Begin
    Recuperar(X, Q);
    X.ArmarString;
    Writeln(T, S);
    Q := Siguiente(Q);
  End;
  CloseFile(T);
End;

// Carga desde un archivo TXT separado por TAB los 3 primeros atributos del
// tipoelemento
Procedure Lista.Cargar(sFileName: String);
Var X: TipoElemento;
  T: TextFile;
  S: String;
Begin
  AssignFile(T, sFileName);
  Reset(T); //Abre el archivo como lectura
  Crear; // Crea la lista vacia
  While Not Eof(T) Do Begin
    Readln(T, S);
    X.CargarTE(S);
    Agregar(X);
  End;
  CloseFile(T);
End;

// Llena la lista de 0 a <RangoHasta> el atributo DI de la lista
Function Lista.LlenarRandom(RangoHasta: LongInt): Errores;
Var X: TipoElemento;
Begin
  LlenarRandom := CError;
  Crear; // Siempre la crea vacia
  X.Inicializar;
  Randomize;
  While Not EsLLena Do Begin
    X.DI := Random(RangoHasta);
    Agregar(X);
  End;
  LlenarRandom := OK;
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

End.
