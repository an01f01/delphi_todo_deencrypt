unit Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, Skia, Skia.FMX, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFrmBase = class(TForm)
    RctContent: TRectangle;
    RctHeader: TRectangle;
    SbxContent: TScrollBox;
    BtnBack: TSpeedButton;
    SkLabel1: TSkLabel;
    SvgBackArrow: TSkSvg;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmBase: TFrmBase;

implementation

{$R *.fmx}

end.
