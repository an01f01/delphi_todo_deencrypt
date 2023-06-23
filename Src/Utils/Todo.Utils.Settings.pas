unit Todo.Utils.Settings;

interface

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.IOUtils,

  { JSON }
  System.JSON,
  System.JSON.Builders, System.JSON.Readers,

  REST.Json.Types, REST.Json,

  { TODO }
  Todo.Model.Todo,

  { DEC Library }
  DECCipherBase, DECCipherModes, DECCipherFormats, DECCiphers;

type

  TTodoProgSettings = class
  public
    class function GetSettingsFolder(): string;
    class function GetDefaultSettingsFilename(): string;

    class function OnCipherEncodeAndSave(Path: string; JsonStr: string): integer;
    class function OnCipherDecodeAndLoad(Path: string): string;

    class function SaveTodos(Todos: TListTodo): string;
    class function LoadTodos(): TListTodo;
  end;

implementation

{ TPosthocProgSettings }

class function TTodoProgSettings.GetDefaultSettingsFilename: string;
begin
  Result := TPath.Combine(GetSettingsFolder(), 'init.bin');
end;

class function TTodoProgSettings.GetSettingsFolder: string;
var
  FolderPath: string;
begin
{$IFDEF MACOS}
  FolderPath := TPath.Combine(TPath.GetLibraryPath(), 'todo');
{$ELSE}
  FolderPath := TPath.Combine(TPath.GetHomePath(), 'todo');
{$ENDIF}
  if System.IOUtils.TDirectory.Exists(FolderPath) = False then
  begin
    System.IOUtils.TDirectory.CreateDirectory(FolderPath);
  end;
  Result := FolderPath;
end;

class function TTodoProgSettings.SaveTodos(Todos: TListTodo): string;
begin
    Result := IntToStr(OnCipherEncodeAndSave(GetDefaultSettingsFilename, TJson.ObjectToJsonString(Todos)));
end;

class function TTodoProgSettings.LoadTodos(): TListTodo;
begin
    Result := TJson.JsonToObject<TListTodo>(OnCipherDecodeAndLoad(GetDefaultSettingsFilename));
end;

{ Encryption Methods}

class function TTodoProgSettings.OnCipherDecodeAndLoad(Path: string): string;
var
  Cipher: TCipher_TwoFish;
  CipherKey: RawByteString;
  SourceText: RawByteString;
  IV: RawByteString;
  Input, Output: TBytes;
  Bytes: TBytes;
  Str: string;
begin

  try
    Cipher := TCipher_TwoFish.Create;

    IV := #0#0#0#0#0#0#0#0;
    Output := System.IOUtils.TFile.ReadAllBytes(Path);

    CipherKey := 'ToddoAppCypher';

    // Decrypt
    Cipher.Init(CipherKey, IV, 0);
    Cipher.Mode := cmCBCx;
    Output := Cipher.DecodeBytes(Output);
    // clean up inside the cipher instance, which also removes the key from RAM
    Cipher.Done;

    Result := RawByteString(System.SysUtils.StringOf(Output));
  finally
    Cipher.Free;
end;
end;

class function TTodoProgSettings.OnCipherEncodeAndSave(Path: string; JsonStr: string): integer;
var
  Cipher: TCipher_TwoFish;
  CipherKey: RawByteString;
  SourceText: RawByteString;
  IV: RawByteString;
  Input, Output: TBytes;
begin
  try

    {$IFDEF DEBUG}
      System.IOUtils.TFile.WriteAllBytes(Path + '.json', TEncoding.UTF8.GetBytes(JsonStr));
    {$ENDIF}
    Cipher := TCipher_TwoFish.Create;

    CipherKey := 'ToddoAppCypher';

    IV := #0#0#0#0#0#0#0#0;
    Cipher.Init(CipherKey, IV, 0);
    Cipher.Mode := cmCBCx;

    SourceText := JsonStr;
    Input := System.SysUtils.BytesOf(SourceText);

    Output := Cipher.EncodeBytes(Input);
    Cipher.Done;

    System.IOUtils.TFile.WriteAllBytes(Path, Output);

    // Decrypt
    Cipher.Init(CipherKey, IV, 0);
    Output := Cipher.DecodeBytes(Output);
    // clean up inside the cipher instance, which also removes the key from RAM
    Cipher.Done;

    SourceText := RawByteString(System.SysUtils.StringOf(Output));
    Result := Length(SourceText);

    //ShowMessage('Decrypted data: ' + SourceText);

  finally
    Cipher.Free;
  end;
end;

end.
