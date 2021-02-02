program fsr;
{$IF CompilerVersion >= 21.0}
{$WEAKLINKRTTI ON}
{$RTTI EXPLICIT METHODS([]) PROPERTIES([]) FIELDS([])}
{$IFEND}
{$APPTYPE CONSOLE}
{$R *.res}

uses
  Winapi.Windows,
  System.StrUtils,
  System.Types,
  System.IOUtils,
  System.Classes,
  System.SysUtils;

procedure ShowHelp;
begin
  Writeln('���� : ���ļ��н����ַ����������滻');
  Writeln('���� : dbyoung@sina.com');
  Writeln('ʱ�� : 2020-08-16');
  Writeln('��ʽ : fsr [�ļ�·��],[�ļ�����],[���滻�ַ���],[�滻�ַ���],[�Ƿ������Ŀ¼],[�Ƿ����ִ�Сд],[�ļ���������ʽ]');
  Writeln('ʾ�� : fsr ''C:\Windows'',''*.txt'',''AAA'',''BBB'',1,0,''utf8''');
  Writeln('ע�� : �����÷���,�ָ�м䲻���пո�ǰ�ĸ��������룬������������ʡ��');
end;

procedure SearchAndReplaceInFile(const arrFile: TStringDynArray; const bCase: Boolean; const strSearch, strReplace, strEncoding: string);
var
  sFile   : String;
  lstFile : TStringList;
  I       : Integer;
  ft      : TEncoding;
  strTemp : String;
  bReplace: Boolean;
begin
  ft := TEncoding.ASCII;
  if SameText('ASCII', strEncoding) then
    ft := TEncoding.ASCII
  else if SameText('ANSI', strEncoding) then
    ft := TEncoding.ANSI
  else if SameText('Unicode', strEncoding) then
    ft := TEncoding.Unicode
  else if SameText('UTF7', strEncoding) then
    ft := TEncoding.UTF7
  else if SameText('UTF8', strEncoding) then
    ft := TEncoding.UTF8;

  lstFile := TStringList.Create;
  try
    for sFile in arrFile do
    begin
      bReplace := False;
      lstFile.LoadFromFile(sFile, ft);
      for I := 0 to lstFile.Count - 1 do
      begin
        strTemp := lstFile.Strings[I];
        if bCase then
          lstFile.Strings[I] := lstFile.Strings[I].Replace(strSearch, strReplace, [rfReplaceAll])
        else
          lstFile.Strings[I] := lstFile.Strings[I].Replace(strSearch, strReplace, [rfReplaceAll, rfIgnoreCase]);
        bReplace             := bReplace or (not SameText(strTemp, lstFile.Strings[I]));
      end;

      if bReplace then
      begin
        lstFile.SaveToFile(sFile, ft);
        Writeln(Format('%s �滻�ɹ�', [sFile]));
      end;

      lstFile.Clear;
    end;
  finally
    lstFile.Free;
  end;
end;

function MiddleStr(const strValue: string): String;
begin
  Result := MidStr(strValue, 2, Length(strValue) - 2);
end;

procedure SearchAndReplace;
var
  strFilePath: String;
  strFileType: String;
  strSearch  : String;
  strReplace : String;
  bSubDir    : Boolean;
  bCase      : Boolean;
  strEncoding: string;
  arrFiles   : TStringDynArray;
  strParam   : string;
  arrParam   : TStringDynArray;
  I          : Integer;
begin
  strParam := string(GetCommandLine);
  I        := Pos(' ''', strParam);
  strParam := RightStr(strParam, Length(strParam) - I);
  arrParam := strParam.Split([',']);
  if Length(arrParam) < 4 then
  begin
    ShowHelp;
    Exit;
  end;

  bSubDir     := True;
  bCase       := False;
  strFilePath := MiddleStr(arrParam[0]);
  strFileType := MiddleStr(arrParam[1]);
  strSearch   := MiddleStr(arrParam[2]);
  strReplace  := MiddleStr(arrParam[3]);
  if Length(arrParam) = 7 then
  begin
    bSubDir     := StrToBool(arrParam[4]);
    bCase       := StrToBool(arrParam[5]);
    strEncoding := MiddleStr(arrParam[6]);
  end
  else if Length(arrParam) = 6 then
  begin
    bSubDir     := StrToBool(arrParam[4]);
    bCase       := StrToBool(arrParam[5]);
    strEncoding := 'ASCII';
  end
  else if Length(arrParam) = 5 then
  begin
    bSubDir     := StrToBool(arrParam[4]);
    bCase       := False;
    strEncoding := 'ASCII';
  end
  else if Length(arrParam) = 4 then
  begin
    bSubDir     := True;
    bCase       := False;
    strEncoding := 'ASCII';
  end;

  if bSubDir then
    arrFiles := TDirectory.GetFiles(strFilePath, strFileType, TSearchOption.soAllDirectories)
  else
    arrFiles := TDirectory.GetFiles(strFilePath, strFileType, TSearchOption.soTopDirectoryOnly);
  if Length(arrFiles) = 0 then
    Exit;

  SearchAndReplaceInFile(arrFiles, bCase, strSearch, strReplace, strEncoding);
end;

begin
  SearchAndReplace;

end.
