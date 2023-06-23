unit Todo.Model.Todo;

interface

uses
  System.SysUtils,
  REST.Json.Types,
  Generics.Collections;

type

  ITodo = interface
  end;

  TErrorTodo = class(TInterfacedObject, ITodo)
    public
      [JSONMarshalled(True)][JSONName('error_message')]
      ErrorMessage: string;

      constructor Create(ErrorMessage: string);
      function GetSelf: TObject;

      function ToString: string;
  end;

  TItemTodo = class(TInterfacedObject, ITodo)
    public
      [JSONMarshalled(True)][JSONName('task')]
      Task: string;
      [JSONMarshalled(True)][JSONName('is_completed')]
      IsCompleted: Boolean;

      constructor Create(Task: string; IsCompleted: Boolean);
      function GetSelf: TObject;

      function ToString: string;
  end;

  TListTodo = class(TInterfacedObject, ITodo)
  private
    public
      [JSONMarshalled(True)][JSONName('name')]
      Name: string;
      [JSONMarshalled(True)][JSONName('todos')]
      Todos: TList<TItemTodo>;

      constructor Create();
      destructor Destroy; override;
      function GetSelf: TObject;

      function ToString: string;
  end;

implementation

{ TErrorTodo }

constructor TErrorTodo.Create(ErrorMessage: string);
begin
  self.ErrorMessage := ErrorMessage;
end;

function TErrorTodo.GetSelf: TObject;
begin
  Result := Self;
end;

function TErrorTodo.ToString: string;
begin
  Result := 'Todo Error: ' + ErrorMessage;
end;

{ TItemTodo }

constructor TItemTodo.Create(Task: string; IsCompleted: Boolean);
begin
  self.Task := Task;
  Self.IsCompleted := IsCompleted;
end;

function TItemTodo.GetSelf: TObject;
begin
  Result := Self;
end;

function TItemTodo.ToString: string;
begin
  Result := Task + ' ? ' + Boolean.ToString(IsCompleted);
end;

{ TListTodo }

constructor TListTodo.Create();
begin
  Name := 'New List';
  Todos := TList<TItemTodo>.Create;
end;

destructor TListTodo.Destroy;
begin
  Todos.Free;
end;

function TListTodo.GetSelf: TObject;
begin
  Result := Self;
end;

function TListTodo.ToString: string;
var
  Str: string;
  I: integer;
begin
  Str := 'Name: ' + Name;
  for I := 0 to (Todos.Count-1) do
    Str := Str + Chr(13) + Chr(10) + Todos[I].ToString;
  Result := Str;
end;


end.
