unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Tipos, ListArray;

type
  TForm1 = class(TForm)
    bCrearA: TButton;
    bCrearB: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    bCargarA: TButton;
    bCargarB: TButton;
    MemoA: TMemo;
    MemoB: TMemo;
    eCA: TEdit;
    eEA: TEdit;
    eCB: TEdit;
    eEB: TEdit;
    Label7: TLabel;
    MemoR: TMemo;
    bSuma: TButton;
    bResta: TButton;
    bMultiplicación: TButton;
    bLimpiar: TButton;
    procedure bCrearAClick(Sender: TObject);
    procedure bCrearBClick(Sender: TObject);
    procedure bCargarAClick(Sender: TObject);
    procedure bCargarBClick(Sender: TObject);
    procedure bLimpiarClick(Sender: TObject);
    procedure bSumaClick(Sender: TObject);
    procedure bRestaClick(Sender: TObject);
    procedure bMultiplicaciónClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  x, y: tipoelemento;
  lA, lB, lSuma, lResta, lMultiplicacion: lista;

implementation

{$R *.dfm}

function suma(lA,lB:lista;x:tipoelemento):lista;    //Suma
var
  aux: tipoelemento;
  laux: lista;
  qA, qB: posicionlista;
begin
  aux.Inicializar;
  laux.Crear;
  qA:= lA.Comienzo;
  if (lA.CantidadElementos>=lB.CantidadElementos) then                  //Si A es mas grande o igual que B
    begin                                   //la uso como lista principal y salgo a buscar los datos en la B
      while (qA<>nulo) do
        begin
          lA.Recuperar(x,qA);
          aux.DI:= x.DI;
          aux.DR:= x.DR;
          qB:= lB.Buscar(x,CDI);
          if (qB<>nulo) then
            begin
              lB.Recuperar(x,qB);
              aux.DR:= aux.DR + x.DR;
            end;
          laux.Agregar(aux);
          qA:= lA.Siguiente(qA);
        end;
    end
  else                                    //Sino B es mas grande que A
    begin                                 //uso B como principal y busco los terminos en A
      qB:= lB.Comienzo;
      while (qB<>nulo) do
        begin
          lB.Recuperar(x,qB);
          aux.DI:= x.DI;
          aux.DR:= x.DR;
          qA:= lA.Buscar(x,CDI);
          if (qA<>nulo) then
            begin
              lA.Recuperar(x,qA);
              aux.DR:= aux.DR + x.DR;
            end;
          laux.Agregar(aux);
          qB:= lB.Siguiente(qB);
        end;
    end;
  suma:= laux;
end;

function resta(lA,lB:lista;x:tipoelemento):lista;    //Resta
var
  aux: tipoelemento;
  laux: lista;
  qA, qB, qBuscar: posicionlista;
begin
  aux.Inicializar;
  laux.Crear;
  qA:= lA.Comienzo;
  if (lA.CantidadElementos>=lB.CantidadElementos) then    //Si A es mas grande o igual que B
    begin                                                 //la uso como lista principal y salgo a buscar los datos en la B
      while (qA<>nulo) do
        begin
          lA.Recuperar(x,qA);
          aux.DI:= x.DI;
          aux.DR:= x.DR;
          qB:= lB.Buscar(x,CDI);
          if (qB<>nulo) then
            begin
              lB.Recuperar(x,qB);
              aux.DR:= aux.DR - x.DR;
            end;
          laux.Agregar(aux);
          qA:= lA.Siguiente(qA);
        end;
    end
  else                                    //Sino B es mas grande que A
    begin                                 //uso B como principal y busco los terminos en A
      qB:= lB.Comienzo;
      while (qB<>nulo) do
        begin
          lB.Recuperar(x,qB);
          aux.DI:= x.DI;
          aux.DR:= x.DR;
          qA:= lA.Buscar(x,CDI);
          if (qA<>nulo) then
            begin
              lA.Recuperar(x,qA);
              aux.DR:= aux.DR - x.DR;
            end;
          laux.Agregar(aux);
          qB:= lB.Siguiente(qB);
        end;
    end;
  resta:= laux;
end;

function multiplicacion(lA,lB:lista;x:tipoelemento):lista;    //Multiplicacion
var
  y, aux: tipoelemento;
  laux, lresultado: lista;
  qA, qB: posicionlista;
begin
  y.Inicializar;
  aux.Inicializar;
  laux.Crear;
  lresultado.Crear;
  for qA:= lA.Comienzo to lA.Fin do
    begin
      lA.Recuperar(x,qA);                    //Recupero el primer elemento de la lista 1
      for qB:= lB.Comienzo to lB.Fin do
        begin
          lB.Recuperar(y,qB);
          aux.DI:= x.DI + y.DI;              //Sumo los exponentes
          aux.DR:= x.DR * y.DR;              //Multiplico los coeficientes
          laux.Agregar(aux);
        end;
    end;
  multiplicacion:= laux;
end;

procedure TForm1.bCargarAClick(Sender: TObject);

begin
  x.DI:= strtoint(eEA.Text);
  x.DR:= strtofloat(eCA.Text);
  lA.Agregar(x);
  memoA.Clear;
  lA.Sort(CDI);
  memoA.Lines.Add('Exponente           Coeficiente');
  memoA.Lines.Add(lA.RetornarString);
end;

procedure TForm1.bCargarBClick(Sender: TObject);
var
  exp: integer;
  coe: real;
begin
  y.DI:= strtoint(eEB.Text);
  y.DR:= strtofloat(eCB.Text);
  lB.Agregar(y);
  lB.Sort(CDI);
  memoB.Clear;
  memoB.Lines.Add('Exponente           Coeficiente');
  memoB.Lines.Add(lB.RetornarString);
end;

procedure TForm1.bCrearAClick(Sender: TObject);
begin
  x.Inicializar;
  lA.Crear;
end;

procedure TForm1.bCrearBClick(Sender: TObject);
begin
  y.Inicializar;
  lB.Crear;
end;

procedure TForm1.bLimpiarClick(Sender: TObject);
begin
  memoR.Clear;
end;

procedure TForm1.bMultiplicaciónClick(Sender: TObject);
begin
  lMultiplicacion.Crear;
  lMultiplicacion:= Multiplicacion(lA,lB,x);
  lMultiplicacion.Sort(CDI);
  memoR.Lines.Add('Exponente           Coeficiente');
  memor.Lines.Add(lMultiplicacion.RetornarString);
end;

procedure TForm1.bRestaClick(Sender: TObject);
begin
  lResta.Crear;
  lResta:= resta(lA,lB,x);
  lResta.Sort(CDI);
  memoR.Lines.Add('Exponente           Coeficiente');
  memor.Lines.Add(lResta.RetornarString);
end;

procedure TForm1.bSumaClick(Sender: TObject);
begin
  lSuma.Crear;
  lSuma:= suma(lA,lB,x);
  lSuma.Sort(CDI);
  memoR.Lines.Add('Exponente           Coeficiente');
  memor.Lines.Add(lSuma.RetornarString);
end;

end.
