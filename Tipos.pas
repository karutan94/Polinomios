unit Tipos;

interface

Uses
  Variants, SysUtils;

Const
  cTab = Char(9); // Tabulador
  cCR = Char(13); // Retorno de carro
  cCRLF= Char(13) + Char(10); // Retorno de Carro + Fin de Linea
  cLF = Char(10); // Fin de Linea solamente

Type
// Tipos Enumerados
// Resultados de camparaciones entre elementos
  Comparacion = (igual, menor, mayor, distinto, error);
// Campo por el cual comparamos o buscamos elementos
  CampoComparar = (CDI, CDR, CDS, CDP, CDV, CDIDS, CDIDR);
// Retorno de errores de los procesos de manejo de estructuras
  Errores = (OK, CError, LLena, Vacia, PosicionInvalida, Otro);
// Datos a Guardar dentro de las estructuras
  TipoElemento = Object
    DI: LongInt;
    DR: Real;
    DS: String;
    DP: Pointer;
    DV: Variant;
    Procedure Inicializar();
    Function CompararTE(X2: TipoElemento; ComparaPor: CampoComparar): Comparacion;
// Se compara con otro segun el Campo a Comparar
    Function ArmarString: String; // Retorno los atributos separados por TAB como texto
    Function CargarTE(S: String): Boolean; // Carga un Texto separado por TAB al tipoelemento
  End;

// Operaciones del TipoElemento
implementation

Procedure TipoElemento.Inicializar();
Begin
  DI := 0;
  DR := 0;
  DS := '';
  DP := Nil;
End;

// Compara 2 Tipos Elementos retornando un enumerado
// La comparacion la hace en funcion de lo que trae campocomparar
Function TipoElemento.CompararTE(X2: TipoElemento; ComparaPor: CampoComparar):Comparacion;
Begin
  Try
    Case ComparaPor Of
// Compara por el dato Entero
      CDI:If DI = X2.DI Then CompararTE := igual
        Else If DI < X2.DI Then CompararTE := menor
        Else CompararTE := mayor;
// Compara por el dato real
      CDR:If DR = X2.DR Then CompararTE := igual
        Else If DR < X2.DR Then CompararTE := menor
        Else CompararTE := mayor;
// Compara por el dato String
      CDS:If DS = X2.DS Then CompararTE := igual
        Else If DS < X2.DS Then CompararTE := menor
        Else CompararTE := mayor;
// Compara por el Dato Pointer
      CDP:If DP = X2.DP Then CompararTE := igual
        Else CompararTE := distinto;
// Compara por el Dato Variant
      CDV:If DV = X2.DV Then CompararTE := igual
        Else CompararTE := distinto;
// Compara por el Dato Entero + String
      CDIDS:If (DI = X2.DI) And (DS = X2.DS) Then CompararTE := igual
        Else CompararTE := distinto;
// Compara por el Dato DI + DR
      CDIDR:If (DI = X2.DI) And (DR = X2.DR) Then CompararTE := igual
        Else CompararTE := distinto;
        Else  CompararTE := error;
    End;
  except
    CompararTE := error;
  End
End;

// Arma un String Separado por Tabuladores a partir del TipoElemento
Function TipoElemento.ArmarString: String;
Var
  SR: String;
  SV: String;
  S: String;
Begin
  Try
    Str(DR:18:4, SR); // 4 decimales de precision
    SV := VarAsType(DV, varString); // se convierte a string el campo variant sin importar lo que tenga
    S := IntToStr(DI) + cTab + SR + cTab + DS + cTab + SV + cTab;
    ArmarString := S;
  except
    ArmarString := '0' + cTab + '0.0000' + cTab +'' + cTab + '' + cTab;
  End
End;

// Arma el TipoElemento a partir de un String Separado por Tabuladores
// Rutina que hace el parsing o split del texto
Function TipoElemento.CargarTE(S: String):Boolean;
Var R: Real;
  X:TipoElemento;
  I: Integer;
Begin
  Try
    CargarTE := False;
    X.Inicializar;
// Saca el Campo DI
    If Trim(Copy(S, 1, Pos(cTab, S)-1)) = '' Then DI := 0
    Else DI := StrToInt(Trim(Copy(s, 1, Pos(cTab, S)-1)));
// Saca el Campo Real
    S := Copy(S, Pos(cTab, S)+1, Length(S));
    If Trim(Copy(s, 1, Pos(cTab, S)-1)) = '' Then DR := 0.0
    Else Begin
      Val(Copy(s, 1, Pos(cTab, S)-1), R, I);
      DR := R;
    End;
// Saca el Campo String
    S := Copy(S, Pos(cTab, S)+1, Length(S));
    DS := Trim(Copy(s, 1, Pos(cTab, S)-1));
// Saca el campo Variant
    S := Copy(S, Pos(cTab, S)+1, Length(S));
    If Trim(Copy(s, 1, Pos(cTab, S)-1)) <> '' Then DV := Trim(Copy(s, 1, Pos(cTab, S)- 1));
// retorno el Tipoelemento
    CargarTE := True;
  except
    CargarTE := False;
  End
End;

end.
