object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 549
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 107
    Height = 23
    Caption = 'Coeficiente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 199
    Top = 39
    Width = 107
    Height = 23
    Caption = 'Coeficiente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 69
    Width = 101
    Height = 23
    Caption = 'Exponente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 199
    Top = 68
    Width = 101
    Height = 23
    Caption = 'Exponente'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 8
    Top = 129
    Width = 115
    Height = 23
    Caption = 'Polinomio A'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 199
    Top = 129
    Width = 115
    Height = 23
    Caption = 'Polinomio B'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label7: TLabel
    Left = 390
    Top = 129
    Width = 96
    Height = 23
    Caption = 'Resultado'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object bCrearA: TButton
    Left = 8
    Top = 8
    Width = 185
    Height = 25
    Caption = 'Crear polinomio A'
    TabOrder = 0
    OnClick = bCrearAClick
  end
  object bCrearB: TButton
    Left = 199
    Top = 8
    Width = 185
    Height = 25
    Caption = 'Crear polinomio B'
    TabOrder = 1
    OnClick = bCrearBClick
  end
  object bCargarA: TButton
    Left = 8
    Top = 101
    Width = 185
    Height = 25
    Caption = 'Cargar t'#233'rmino en A'
    TabOrder = 2
    OnClick = bCargarAClick
  end
  object bCargarB: TButton
    Left = 200
    Top = 101
    Width = 184
    Height = 25
    Caption = 'Cargar t'#233'rmino en B'
    TabOrder = 3
    OnClick = bCargarBClick
  end
  object MemoA: TMemo
    Left = 8
    Top = 152
    Width = 185
    Height = 385
    TabOrder = 4
  end
  object MemoB: TMemo
    Left = 200
    Top = 152
    Width = 184
    Height = 385
    TabOrder = 5
  end
  object eCA: TEdit
    Left = 136
    Top = 39
    Width = 57
    Height = 21
    TabOrder = 6
  end
  object eEA: TEdit
    Left = 136
    Top = 72
    Width = 57
    Height = 21
    TabOrder = 7
  end
  object eCB: TEdit
    Left = 319
    Top = 39
    Width = 65
    Height = 21
    TabOrder = 8
  end
  object eEB: TEdit
    Left = 319
    Top = 69
    Width = 65
    Height = 21
    TabOrder = 9
  end
  object MemoR: TMemo
    Left = 390
    Top = 152
    Width = 185
    Height = 385
    TabOrder = 10
  end
  object bSuma: TButton
    Left = 390
    Top = 8
    Width = 185
    Height = 25
    Caption = 'Suma'
    TabOrder = 11
    OnClick = bSumaClick
  end
  object bResta: TButton
    Left = 390
    Top = 39
    Width = 185
    Height = 25
    Caption = 'Resta'
    TabOrder = 12
    OnClick = bRestaClick
  end
  object bMultiplicación: TButton
    Left = 390
    Top = 70
    Width = 185
    Height = 25
    Caption = 'Multiplicaci'#243'n'
    TabOrder = 13
    OnClick = bMultiplicaciónClick
  end
  object bLimpiar: TButton
    Left = 390
    Top = 101
    Width = 185
    Height = 25
    Caption = 'Limpiar memo de resultado'
    TabOrder = 14
    OnClick = bLimpiarClick
  end
end
