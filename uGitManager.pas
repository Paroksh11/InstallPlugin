unit uGitManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSLOpenSSL,
  IdAuthentication,
  Soap.EncdDecd, IdCoder, IdCoder3to4, IdCoderMIME, IdMultipartFormData,
  StrUtils,
  System.IOUtils, System.Types, System.Generics.Collections, DBXJSON, uUtils,
  idUri;

type
  TGitManager = class
  private
    PluginArray: array of string;
    pluginstrlist: TstringList;
    pluginName: string;
    // directorypath:String;
 //   function getAuthURL(ClientID: string): string;
 //   function getAuthCode():string;
//    function getAccessToken(): string;

  public
    function listOfPlugins(): string;
    function initConnection(): string;
    function SelectPlugin(PluginCount: integer): String;
    function CreateFolderStructure(GURL: String; Fpath: String): string;
    function PluginInstallation(): string;
    function DownloadFile(const URL, FileName: string): string;
    function pullcompressfile(FileName: string;
      var Response: TStringStream): string;
  end;

implementation

function TGitManager.listOfPlugins(): string; // 001
var
  IdHTTP1: TIdHTTP;

  GitURL, pluginName, key: string;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  JSONObject, JObject: TJSONObject;
  JSONValue, JVALUE: TJSONValue;
  JsonArray: TJSONArray;
  I, J, Jcount: integer;
  NameValue: string;
  plugJvalue: TJSONValue;
  keyName: string;
  JSONGet: String;
  // giving username password we will get token
begin
  try
    IdHTTP1 := TIdHTTP.Create(nil);
    initConnection();
    SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP1);
    SSLIOHandler.SSLOptions.Method := sslvTLSv1_2;
    IdHTTP1.IOHandler := SSLIOHandler;
    IdHTTP1.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + Access_Token);
    JSONObject := TJSONObject.Create;
    JObject := TJSONObject.Create;
    // GitURL:=Format('https://api.github.com/repos/%s/%s/contents/%s/',[Owner,reponame,'Plugin']);
    GitURL := GitPluginURL;
    // writeln('Invoking URL :' + GitURL);
    IdHTTP1.HandleRedirects := True;
    try
      JSONGet := IdHTTP1.Get(TidUri.URLEncode(GitURL));
      JSONValue := TJSONObject.ParseJSONValue(JSONGet);
    except
      on F: Exception do
      begin
        console_write('    -  Error during HTTP request for plugin listing: ' + F.Message,12);
        writeln;
        readln;
      end;
    end;
    JsonArray := TJSONObject.ParseJSONValue(JSONGet) as TJSONArray;
    Jcount := JsonArray.size;
    SetLength(PluginArray, Jcount);
    writeln;
    writeln('Available plugins');
    writeln('==================');
    pluginstrlist := TstringList.Create;
    for I := 0 to Jcount - 1 do
    begin
      keyName := 'name';
      JObject := JsonArray.Get(I) as TJSONObject;
      NameValue := JObject.Get(keyName).JSONValue.value;
      PluginArray[I] := NameValue;
      Console_Write(IntToStr(I + 1) + '. ', 12);
      writeln(NameValue);
      // SetConsoleTextAttribute(inttostr(I+1)+'. ', 4);

      pluginstrlist.Add(IntToStr(I + 1) + '=' + NameValue);
    end;
    SelectPlugin(length(PluginArray));
  except
    on E: Exception do
    begin
      console_write('    - Error while listing plugins: ' + E.Message,12);
      writeln;
      readln;
    end;
  end;
end;

function TGitManager.initConnection(): string;
begin
 // Access_Token := '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'; //'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';//
  Owner := 'Paroksh11';
  reponame := 'Axpert';

end;

function TGitManager.SelectPlugin(PluginCount: integer): String; // 2
var
  I, J, IDX, PluginIdx: integer;
  ISFound: Boolean;
  Response: string;
begin
  try
    curdir := GetCurrentDir();
    writeln;
    // writeln(curdir);  //C:\Users\paroksh.AGILELABS\Desktop\Git_plugin
    ForceDirectories(pluginLocalPath);
    // pluginLocalPath := curdir + '\Plugin\';
    writeln('Choose the plugin number you want to install..');
    readln(pluginName);
    if ((strToInt(pluginName) <= 0) or (strToInt(pluginName) > PluginCount))
    then
    begin
      repeat
      begin
        writeln('Give Plugin number within range..');
        readln(pluginName);
        writeln;
      end;
      until ((strToInt(pluginName) > 0) and
        (strToInt(pluginName) <= PluginCount));
    end;

    writeln;
    // repeat
    // begin
    //
    // end;
    // until (pluginame=);

    // Before to the below line , validate whether the given input is valid number
    // and plugin available for that selected no
    PluginIdx := strToInt(pluginName);
    // PluginIdx := PluginIdx - 1;//-1 added since stringlist starts from 0
    ISFound := False;
    writeln('Selected plugins for Installations:');
    writeln('=====================================');
    IDX := 0;
    (*
      //Old code //commented on 13/03/2024 - This code can be reused when handling multiple plugins
      for I := 0 to Length(PluginArray)-1 do
      begin
      //writeln(pluginstrlist.ValueFromIndex[I]);                               //
      if LowerCase(pluginName)=LowerCase(pluginstrlist.ValueFromIndex[I]) then //PluginArray[I]
      begin
      inc(IDX);
      writeln(IntToStr(IDX)+'.'+pluginstrlist.ValueFromIndex[I]);
      //writeln('-----------------------------');
      writeln;
      selectedPlugin:=pluginstrlist.ValueFromIndex[I];
      ForceDirectories(pluginLocalPath+selectedPlugin);
      CreateFolderStructure('https://api.github.com/repos/Paroksh11/Axpert/contents/','Plugin/'+selectedPlugin);
      Result:=pluginstrlist.ValueFromIndex[I];
      ISFound:=True;
      break;
      end;
      for J :=0 to pluginstrlist.count do
      begin
      if pluginName=intToStr(J) then
      begin
      pluginName:=pluginstrlist.ValueFromIndex[J-1];
      selectedPlugin:=pluginName;
      ISFound:=True;
      break;
      end;
      end;

      end;
    *)

    // New code for checking plugin
    IDX := 0;
    if (pluginstrlist.IndexOfName(IntToStr(PluginIdx))) >= 0 then
    begin
      Inc(IDX);
      selectedPlugin := pluginstrlist.ValueFromIndex[PluginIdx - 1];
      // strlist starts index from 0
      Console_Write(IntToStr(IDX) + '. ', 12);
      write(selectedPlugin);
      writeln;
      writeln;
      Console_Write('Note: If the selected plugin already exists, continuing will overwrite the existing plugin files.',14);
      writeln;
      writeln;
      write('Do you want to continue with this installation? ');
      Console_Write('[y/n]', 12);
      writeln;
      readln(Response);
      writeln;
      if LowerCase(Response) = 'y' then
      begin
        // ISFound:=True;
        // writeln('PLUGIN INSTALLATION PROCESS');
        // writeln('=============================');
        // writeln;
        // ForceDirectories(pluginLocalPath+selectedPlugin);
        // writeln;
        // Console_write('1. Pulling Plugin Files from GIT:',3);
        // writeln;
        // writeln('  - '+selectedPlugin+' selected.');
        // writeln('  - Pulling '+selectedPlugin+' files from GIT one by one:');
        // writeln;
        // CreateFolderStructure('https://api.github.com/repos/Paroksh11/Axpert/contents/','Plugin/'+selectedPlugin);
        // writeln;
        // writeln('   - All '+selectedplugin+' files pulled successfully.');
        // writeln;
        // Result:=pluginstrlist.ValueFromIndex[I];
        PluginInstallation();
      end;
      if LowerCase(Response) = 'n' then
      begin
        writeln('Installation aborted...');
        writeln;
        listOfPlugins();
      end
    end;
    if (LowerCase(Response) <> 'y') and (LowerCase(Response) <> 'n') then
    begin
      repeat
      begin
        writeln('Give response in y or n only ');
        readln(Response);
      end;
      until (LowerCase(Response) = 'y') or (LowerCase(Response) = 'n');
      if LowerCase(Response) = 'y' then
      begin
        PluginInstallation();
      end;
      if LowerCase(Response) = 'n' then
      begin
        listOfPlugins();
      end;

    end;

    // if response='n' then






    // Give correct Plugin name or serial number. Plugin may not be available,Please check spelling

    // Choose the plugin number you want to install..
    // if ISFound=False then
    // if (lowercase(response)<>'n') and (lowercase(response)<>'y') then
    // begin
    // WriteLn('Give response in y or n only ');
    // if response='y' then
    // begin
    //
    // end;
    //
    // selectplugin();
    // end;
  except
    on E: Exception do
    begin
      Console_write('    - Error: ' + E.Message,12);
      writeln;
      readln;
    end;
  end;
end;

function TGitManager.PluginInstallation(): string;
var
  CheckExistancePath:string;
begin
  // ISFound:=True;
  writeln('PLUGIN INSTALLATION PROCESS');
  writeln('=============================');
  writeln;
  ForceDirectories(pluginLocalPath + selectedPlugin);
  writeln;
  Console_Write('1. Pulling Plugin Files from GIT:', 3);
  writeln;
  writeln('  - ' + selectedPlugin + ' selected.');
  writeln('  - Pulling ' + selectedPlugin + ' files from GIT one by one:');
  CheckExistancePath:=GetCurrentDir+'\AxPlugins\'+selectedPlugin;
  if DirectoryExists(CheckExistancePath) then
  begin
    TDirectory.Delete(CheckExistancePath, True);
    //RemoveDir(CheckExistancePath);
    CreateDir(CheckExistancePath)
  end;
  CreateFolderStructure(GitPluginURL, selectedPlugin);
  Console_Write('    - All ', 10);
  write(selectedPlugin);
  Console_Write(' files pulled successfully.', 10);
  writeln;
  writeln;
end;

function ExtractLastSegmentFromURL(const URL: string): string;
var
  URLSegments: TStringDynArray;
begin
  // Split the URL by '\' delimiter
  URLSegments := SplitString(URL, '\');
  // Return the last segment
  Result := URLSegments[High(URLSegments)];
end;

function RemoveLastSegmentFromURL(URL: string): string;
var
  LastSlashPos: integer;
begin
  // Find the last occurrence of '/' in the URL
  LastSlashPos := LastDelimiter('/', URL);

  // If a slash is found, remove everything after it
  if LastSlashPos > 0 then
  begin
    URL := Copy(URL, 1, LastSlashPos - 1);
    LastSlashPos := LastDelimiter('/', URL);
    URL := Copy(URL, 1, LastSlashPos);
    Result := URL;
  end
  else
    Result := URL; // No slash found, return original URL
end;

function RemoveFirstSegmentFromURLPath(const URLPath: string): string;
var
  FirstSlashPos: integer;
begin
  // Find the first occurrence of '/' in the URL path
  FirstSlashPos := Pos('/', URLPath);

  // If a slash is found, remove everything before it including the slash
  if FirstSlashPos > 0 then
    Result := Copy(URLPath, FirstSlashPos + 1, length(URLPath) - FirstSlashPos)
  else
    Result := URLPath; // No slash found, return original URL path
end;

function TGitManager.CreateFolderStructure(GURL, Fpath: string): string;
var
  IdHTTP1: TIdHTTP;
  Compressedpath: string;
  CompressedFileSavingpath: string;
  Response: TStringStream;
  OutJson: String;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  JsonArray: TJSONArray;
  JSONObject, JObject: TJSONObject;
  JSONSize, I: integer;
  JSONText, JText: string;
  FolderPath, UpFolderPath, FilePath, FileType, FileContent,
    download_url: String;
  TxtFile: TextFile;
  aftfirstseg: string;
  downloadPath: string;
begin
  try
    begin
   // writeln(selectedplugin);
      IdHTTP1 := TIdHTTP.Create(nil);
      initConnection();
      SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP1);
      SSLIOHandler.SSLOptions.Method := sslvTLSv1_2;
      IdHTTP1.IOHandler := SSLIOHandler;
      IdHTTP1.Request.CustomHeaders.AddValue('Authorization',
        'Bearer ' + Access_Token);
      // writeln('Invoking URL : '+TidUri.URLEncode(GURL + Fpath));
      // writeln;
      JSONText := IdHTTP1.Get(TidUri.URLEncode(GURL + Fpath));
      JsonArray := TJSONObject.ParseJSONValue(JSONText) as TJSONArray;
      JSONSize := JsonArray.size;

      for I := 0 to JSONSize - 1 do
      begin
        JSONObject := JsonArray.Get(I) as TJSONObject;
        FileType := JSONObject.Get('type').JSONValue.value;
        if FileType = 'dir' then
        begin
          FolderPath := JSONObject.Get('path').JSONValue.value;
          UpFolderPath := StringReplace(FolderPath, '/', '\', [rfReplaceAll]);
          ForceDirectories(curdir + '\' + UpFolderPath);
          // RemoveLastSegmentFromURL is callled to remove last segment of url(Plugin folder name)
          // sience plugin folder was already there in our url
          aftfirstseg := RemoveFirstSegmentFromURLPath(FolderPath);
          CreateFolderStructure(GURL, aftfirstseg);
        end
        else
        begin
          FilePath := JSONObject.Get('path').JSONValue.value;
          FilePath := StringReplace(FilePath, '/', '\', [rfReplaceAll]);
          download_url := JSONObject.Get('download_url').JSONValue.value;
          downloadPath := GetCurrentDir + '\' + FilePath;
          Fpath := ExtractLastSegmentFromURL(GURL) + '/' + Fpath;
          Fpath := StringReplace(Fpath, '/', '\', [rfReplaceAll]);
          writeln('    - Pulling ' + ExtractFileName(FilePath) + ' from ...\' +
            FilePath);
          if Copy(ExtractFileName(FilePath), 0, 3) = 'c__' then
          begin
            DownloadFile(download_url, downloadPath)
            /// /          FileContent:=pullcompressfile(ExtractFileName(FilePath),Response);
            // //   CompressedFileSavingpath:='D:\Axpert_Project\Axpert\AxPlugins\Task Management\Structures\Iview\Export\'+ExtractFileName(FilePath);
            // //   FileStream := TFileStream.Create(CompressedFileSavingpath, fmCreate);
            // //   IdHTTP1.Request.ContentEncoding := 'utf-8';
            // //  Compressedpath:=RemoveLastSegmentFromURL(GURL)+FilePath;
            // //  Compressedpath := StringReplace(Compressedpath, '/', '\', [rfReplaceAll]);
            // //  JText:=IdHTTP1.Get(Compressedpath);
            // //  JObject:=TJSONObject.ParseJSONValue(JText) as TJSONObject;
            // //  download_url := JSONObject.Get('download_url').JSONValue.value;
            // //  IdHTTP1.Get(download_url,FileStream);
            // // download_url := JSONObject.Get('download_url').JSONValue.value;
            // // HandleResponse(IdHTTP1.ResponseCode);
          end
          else
          begin
            FileContent := IdHTTP1.Get(TidUri.URLEncode(download_url));

            // Fpath:=StringReplace(FPath,'/','\',[rfReplaceAll]);

            // if Copy(ExtractFileName(FilePath),0,3)='c__' then
            // begin
            // FileStream := TFileStream.Create(FilePath, fmCreate);
            // try
            // IdHTTP1.Request.ContentEncoding := 'utf-8';
            // IdHTTP1.Get('http://example.com/file-to-download.txt', FileStream);
            // finally
            //
            // end;
            // end
            // else
            // begin
            AssignFile(TxtFile, (curdir + '\' + trim(FilePath)));
            // end;
            Rewrite(TxtFile);
            write(TxtFile, trim(FileContent));
            Flush(TxtFile);
            CloseFile(TxtFile);
          end;
          write('    -');
          Console_Write(' ' + ExtractFileName(FilePath), 10);
          write(' pulled successfully.');
          writeln;
        end;
      end;
    end;

  except
    on E: Exception do
    begin
      Console_write('    - Error: ' + E.Message,12);
      writeln;
      readln;
    end;
  end;
end;

function TGitManager.pullcompressfile(FileName: string;
  var Response: TStringStream): String;
const
  GitHubUsername = 'Paroksh11';
  GitHubRepository = 'Axpert';
  GitHubRawURL = 'https://raw.githubusercontent.com/' + GitHubUsername + '/' +
    GitHubRepository + '/main/';
var
  IdHTTP: TIdHTTP;
  SFileContent: String;
  BFileContent: TBytes;
  Stream: TMemoryStream;
  Encoding: TEncoding;
  FullURL: string;
  I: integer;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
  StringList: TstringList;
begin
  // Result := False;
  FullURL := GitHubRawURL +
    'AxPlugins/Task%20Management/Structures/Iview/Export/' +
    ExtractFileName(FileName);
  IdHTTP := TIdHTTP.Create(nil);
  Stream := TMemoryStream.Create;
  StringList := TstringList.Create;
  SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(IdHTTP);
  SSLIOHandler.SSLOptions.Method := sslvTLSv1_2;

  try
    IdHTTP.IOHandler := SSLIOHandler;

    // IdHTTP.Request.Accept := 'text/plain; charset=utf-8';
    // IdHTTP.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3';

    SFileContent := IdHTTP.Get(FullURL);
    Encoding := TEncoding.UTF8;
    BFileContent := Encoding.GetBytes(SFileContent);
    Result := Encoding.GetString(BFileContent);
    /// ///////////////////////////////////////////////////////////////////////
    // IdHTTP.Get(FullURL,Stream);
    // stream.Position:=0;
    // SetLength(BFileContent,stream.Size);
    // stream.ReadBuffer(BFileContent[0],stream.Size);
    // for I:=Low(BFileContent) to High(BFileContent) do
    // begin
    // StringList:=StringList.Add(chr(BFileContent[I]));
    // end;
    // Result:=StringList.ToString;

    // Stream.Position := 0;
    // SetLength(Result, Stream.Size);
    // FileContent:=Trim(FileContent);
    // Stream.ReadBuffer(Result[0], Stream.Size);
    // Result := TEncoding.UTF8.GetString(FileContent);
    // Result:=TStringStream.Create('', TEncoding.UTF8).ReadString(MemoryStream.Size, MemoryStream);
  finally
    IdHTTP.Free;
    // SSLIOHandler.Free;
  end;
end;

function TGitManager.DownloadFile(const URL, FileName: string): string;
var
  HTTP: TIdHTTP;
  FileStream: TFileStream;
  SSLIOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    HTTP.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36';
    SSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(HTTP);
    // HTTP.IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    SSLIOHandler.SSLOptions.Method := sslvTLSv1_2;
    SSLIOHandler.SSLOptions.Mode := sslmClient;
    SSLIOHandler.SSLOptions.VerifyMode := [];
    HTTP.IOHandler := SSLIOHandler;

    FileStream := TFileStream.Create(FileName, fmCreate);
    try
      HTTP.Get(URL, FileStream);
    finally
      FileStream.Free;
    end;
  finally
    HTTP.Free;
  end;
end;



//function GetAuthorizationURL(const ClientID: string): string;
//begin
//  Result := 'https://github.com/login/oauth/authorize?';
//  Result := Result + 'client_id=' + Client_id;
//  Result := Result + '&scope= repo';
//  Result := Result + '&redirect_uri=http://localhost:8080/callback';
//end;
//
//function getAuthCode():string;
//var
//  AuthURL:String;
//begin
//
//end;

end.
