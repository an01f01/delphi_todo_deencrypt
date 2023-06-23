program AppWriterTodo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  Base in '..\Src\Base\Base.pas' {FrmBase},
  Todo.Utils.Settings in '..\Src\Utils\Todo.Utils.Settings.pas',
  Todo.Form.Main in '..\Src\Todo.Form.Main.pas' {FrmMain},
  Todo.Model.Todo in '..\Src\Model\Todo.Model.Todo.pas';

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
