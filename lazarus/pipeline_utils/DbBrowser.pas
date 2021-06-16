unit DbBrowser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, PQConnection, SQLDB, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, DBGrids, StdCtrls, ComCtrls, Buttons,
  PythonEngine, Lcl.PythonGUIInputOutput,
  RunProc;

type

  { TDbBrowserForm }

  TDbBrowserForm = class(TForm)
    BtnConvertXlsToSql: TBitBtn;
    BtnSelectXlsxFile: TBitBtn;
    BtnSelectOutputSqlFolder: TBitBtn;
    ComboXlsFile: TComboBox;
    ComboOutputSqlFolder: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ListBox1: TListBox;
    Memo1: TMemo;
    OpenDialogXls: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    PQConnection1: TPQConnection;
    SelectDirectoryDialogOutputSql: TSelectDirectoryDialog;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    TabSheetDbBrowser: TTabSheet;
    TabSheetCreateDb: TTabSheet;
    TabSheetXlsxToSQL: TTabSheet;
    procedure BtnConvertXlsToSqlClick(Sender: TObject);
    procedure BtnSelectOutputSqlFolderClick(Sender: TObject);
    procedure BtnSelectXlsxFileClick(Sender: TObject);
  private

  public

  end;

var
  DbBrowserForm: TDbBrowserForm;

implementation

{$R *.lfm}

{ TDbBrowserForm }

procedure TDbBrowserForm.BtnSelectXlsxFileClick(Sender: TObject);
begin
  //
  if OpenDialogXls.Execute then
  begin
    if FileExists(OpenDialogXls.Filename) then
      ComboXlsFile.Text := OpenDialogXls.Filename;
      ShowMessage(OpenDialogXls.Filename);
  end
  else
    ShowMessage('No file selected');

end;

procedure TDbBrowserForm.BtnSelectOutputSqlFolderClick(Sender: TObject);
begin
  //
  if SelectDirectoryDialogOutputSql.Execute then
  begin
    ComboOutputSqlFolder.Text := SelectDirectoryDialogOutputSql.Filename;

  end;
end;

procedure TDbBrowserForm.BtnConvertXlsToSqlClick(Sender: TObject);
var
  Lines: TStringList;
  ScriptFileName: String;
  Params: String;
  Proc: TRunProc;
  Cmd: String;
begin

  ScriptFileName := 'D:\Ultrasat\AstroPack.git\python\utils\database_utils\xlsx2sql_lang.py';
  Params := 'D:\Ultrasat\AstroPack.git\python\utils\database_utils\db\unittest__tables.xlsx';
  Cmd := ScriptFileName + ' ' + Params;

  Proc := TRunProc.Create;
  Proc.Init;
  Proc.Memo1 := Memo1;
  Proc.Run(Cmd);
  Proc.Destroy();
  {
  Lines := TStringList.Create;
  try
    ScriptFileName := 'D:\Ultrasat\AstroPack.git\python\utils\database_utils\xlsx2sql_lang.py';
    Lines.LoadFromFile(ScriptFileName);
    PythonEngine1.ExecStrings(Lines);
  finally
    Lines.free;
  end;}

end;


end.

