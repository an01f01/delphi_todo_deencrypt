unit Todo.Form.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Base, Skia, FMX.Layouts, Skia.FMX, FMX.Controls.Presentation, FMX.Objects,

  Todo.Utils.Settings,
  Todo.Model.Todo,

  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TFrmMain = class(TFrmBase)
    RctSave: TRectangle;
    BtnSave: TSpeedButton;
    SkLabel2: TSkLabel;
    RctLoad: TRectangle;
    BtnLoad: TSpeedButton;
    SkLabel3: TSkLabel;
    Memo1: TMemo;
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Todos: TListTodo;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.BtnSaveClick(Sender: TObject);
begin
  inherited;
  Memo1.Lines.Add('Saving...');
  Memo1.Lines.Add(TTodoProgSettings.GetSettingsFolder);
  Memo1.Lines.Add(TTodoProgSettings.GetDefaultSettingsFilename);

  Todos.Name := 'test me';
  TTodoProgSettings.SaveTodos(Todos);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  ItemTodo: TItemTodo;
begin
  inherited;
  Todos := TListTodo.Create;

  ItemTodo := TItemTodo.Create('First things to do in AM', False);
  Todos.Todos.Add(ItemTodo);

  ItemTodo := TItemTodo.Create('last thing to do in the PM', False);
  Todos.Todos.Add(ItemTodo);

  Memo1.Lines.Add(Todos.ToString);
end;

procedure TFrmMain.BtnLoadClick(Sender: TObject);
begin
  inherited;
  Memo1.Lines.Add('Loading...');
  Memo1.Lines.Add(TTodoProgSettings.GetSettingsFolder);

  Todos := TTodoProgSettings.LoadTodos();
  Memo1.Lines.Add(Todos.Name);
end;

end.
