program AxPluginInstaller;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  uInItApp,
  uUtils in 'uUtils.pas',
  uConfig in 'uConfig.pas',
  uGitManager in 'uGitManager.pas',
  uInstallation in 'uInstallation.pas',
  uDbConnect in 'uDbConnect.pas',
  uGitAccessToken in 'uGitAccessToken.pas',
  uImportStructures in 'uImportStructures.pas',
  xcallservice in '\\192.168.2.6\Axpert2\Ver3.3\Desktop\xcallservice.pas',
  uTreeObj in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.5\Commonchanges for 64bit\uTreeObj.pas',
  UTprovideprintdata in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.5\Commonchanges for 64bit\UTprovideprintdata.pas',
  uTPrinterSettings in '\\192.168.2.6\Axpert2\Ver 8.6.8.2\uTPrinterSettings.pas',
  UDosPrint in '\\192.168.2.6\Axpert2\Ver 8.4.8\UDosPrint.pas',
  UDosPrintDoc in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.5\UDosPrintDoc.pas',
  UDocObject in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.5\Commonchanges for 64bit\UDocObject.pas',
  uMRPRun in '\\192.168.2.6\Axpert2\Ver 8.9.0.4\uMRPRun.pas',
  ufmASB in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.6\ufmASB.pas' {ASBModule: TWebModule},
  MessageDigest_5 in '\\192.168.2.6\ASB8.9-XE3\ASB 64 Bit for SIPF\Ver 8.9.0.7\MessageDigest_5.pas',
  uDosObject in '\\192.168.2.6\Axpert9-XE3\Ver 9.3\uDosObject.pas',
  UPrintReport in '\\192.168.2.6\Axpert9-XE3\Ver 9.3\UPrintReport.pas',
  uBOM in '\\192.168.2.6\Axpert9-XE3\Ver 9.4\uBOM.pas',
  uFillStruct in '\\192.168.2.6\Axpert9-XE3\Ver 9.4\uFillStruct.pas',
  uUpdateDependencies in '\\192.168.2.6\Axpert9-XE3\Ver 9.4\uUpdateDependencies.pas',
  uPDFPrint in '\\192.168.2.6\Axpert9-XE3\Ver 9.5\uPDFPrint.pas',
  uStructUpgrade in '\\192.168.2.6\Axpert9-XE3\Ver 9.0\ASB\uStructUpgrade.pas',
  UConvSGridToHtml in '\\192.168.2.6\Axpert9-XE3\Ver 9.7\UConvSGridToHtml.pas',
  uMSWord in '\\192.168.2.6\Axpert9-XE3\Ver 9.7\uMSWord.pas',
  uAES in '\\192.168.2.6\Axpert9-XE3\Ver 9.7\Fix2\uAES.pas',
  uElAES in '\\192.168.2.6\Axpert9-XE3\Ver 9.7\Fix2\uElAES.pas',
  uAxpertLic in '\\192.168.2.6\Axpert9-XE3\Ver 9.8\New Licensing Changes - 9.8latest\Asb\uAxpertLic.pas',
  uMDMap in '\\192.168.2.6\Axpert9-XE3\Ver 9.8\uMDMap.pas',
  uUpdateMgr in '\\192.168.2.6\Axpert9-XE3\Ver 10.2\AxpManager\uUpdateMgr.pas',
  uUpdateMgrVerDetails in '\\192.168.2.6\Axpert9-XE3\Ver 10.2\AxpManager\uUpdateMgrVerDetails.pas',
  uASBT in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uASBT.pas',
  uASBTStruct in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uASBTStruct.pas',
  uWMIHardwareID in '\\192.168.2.6\Axpert9-XE3\Ver 10.1\Fix2\uWMIHardwareID.pas',
  AXMLibrary in '\\192.168.2.6\Axpert9-XE3\Ver 10.3\asb\AXMLibrary.pas',
  AXMConnection in '\\192.168.2.6\Axpert9-XE3\Ver 10.3\asb\AXMConnection.pas',
  uCompress in '\\192.168.2.6\Axpert9-XE3\Ver 10.3\uCompress.pas',
  uViewDef in '\\192.168.2.6\Axpert9-XE3\Ver 9.4\AxpManager\uViewDef.pas',
  uStoreDependencies in '\\192.168.2.6\Axpert9-XE3\Ver 10.5\AxpManager\uStoreDependencies.pas',
  uAgileCloudObj in '\\192.168.2.6\Axpert9-XE3\Ver 9.4\Asb\uAgileCloudObj.pas',
  uListView in '\\192.168.2.6\Axpert9-XE3\Ver 9.9\New UI  Changes\uListView.pas',
  uSearchVal in '\\192.168.2.6\Axpert9-XE3\Ver 10.3\WebFix5\uSearchVal.pas',
  uFrameSQL in '\\192.168.2.6\Axpert9-XE3\Ver 10.6\uFrameSQL.pas',
  uWorkFlow in '\\192.168.2.6\Axpert9-XE3\Ver 10.8\uWorkFlow.pas',
  uTasks in '\\192.168.2.6\Axpert9-XE3\Ver 10.1\WebFix3\uTasks.pas',
  uDataExport in '\\192.168.2.6\Axpert9-XE3\Ver 10.8\Webfix2\uDataExport.pas',
  uDataImport in '\\192.168.2.6\Axpert9-XE3\Ver 10.8\Webfix2\uDataImport.pas',
  uPrintDocs in '\\192.168.2.6\Axpert9-XE3\Ver 10.9\uPrintDocs.pas',
  Redis.Client in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\Redis.Client.pas',
  Redis.Command in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\Redis.Command.pas',
  Redis.Commons in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\Redis.Commons.pas',
  Redis.NetLib.Factory in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\Redis.NetLib.Factory.pas',
  Redis.NetLib.INDY in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\Redis.NetLib.INDY.pas',
  RedisMQ.Commands in 'D:\ParokshAgile\Delphi Supporting Files\REDIS CLIENT - DELPHI XE3 Support\sources\RedisMQ.Commands.pas',
  uPropsXML in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\uPropsXML.pas',
  uCreateStructure in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\Asb\uCreateStructure.pas',
  uConnect in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\uConnect.pas',
  uWorkFlowRuntime in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uWorkFlowRuntime.pas',
  uLicMgr in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\uLicMgr.pas',
  UProfitEVal in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\UProfitEVal.pas',
  uIViewTables in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\Asb\uIViewTables.pas',
  uExecuteSQL in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\Asb\uExecuteSQL.pas',
  uCreateIviewStructure in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\Asb\uCreateIviewStructure.pas',
  UParse in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\UParse.pas',
  uASBTStructObj in 'uASBTStructObj.pas',
  uAutoPageCreate in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\Asb\uAutoPageCreate.pas',
  uXSMTP in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\uXSMTP.pas',
  uStoredata in 'uStoredata.pas',
  uASBCommonObj in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uASBCommonObj.pas',
  uAxProvider in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uAxProvider.pas',
  uDBManager in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uDBManager.pas',
  uDoDebug in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uDoDebug.pas',
  uGeneralFunctions in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uGeneralFunctions.pas',
  uProvidelink in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uProvidelink.pas',
  uXDS in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uXDS.pas',
  uProfitQuery in '\\192.168.2.6\Axpert9-XE3\Ver 10.9\WebFix4\uProfitQuery.pas',
  uStructInTable in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uStructInTable.pas',
  uiViewXML in '\\192.168.2.6\Axpert9-XE3\Ver 11.0\uiViewXML.pas',
  uImportDiff in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uImportDiff.pas',
  uImportStructDef in '\\192.168.2.6\Axpert9-XE3\Ver 11.1\uImportStructDef.pas',
  uAxPEG in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\ASBPegRest_XE8\uAxPEG.pas',
  uValidate in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uValidate.pas',
  uStructDef in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uStructDef.pas',
  uAxAmend in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\ASBPegRest_XE8\uAxAmend.pas',
  uAxPEGActions in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\ASBPegRest_XE8\uAxPEGActions.pas',
  uImport in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uImport.pas',
  uDoCoreAction in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uDoCoreAction.pas',
  uCreateIview in '\\192.168.2.6\Axpert9-XE3\Ver 11.2\uCreateIview.pas',
  uGetDependencies in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uGetDependencies.pas',
  uAutoPrint in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uAutoPrint.pas',
  uDataExchQueue in 'uDataExchQueue.pas',
  uDbCall in 'uDbCall.pas',
  uFormNotifications in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uFormNotifications.pas',
  uAxfastRun in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uAxfastRun.pas',
  uPublishToRMQ in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uPublishToRMQ.pas',
  uASBDataObj in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uASBDataObj.pas',
  uValueStock in '\\192.168.2.6\Axpert9-XE3\Ver 9.7\Fix24\uValueStock.pas',
  uDWBExport in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uDWBExport.pas',
  uDWBPublish in '\\192.168.2.6\Axpert9-XE3\Ver 11.3\AsbCommonObjs\uDWBPublish.pas',
  uInstallDbScripts in 'uInstallDbScripts.pas',
  uInstallRMQClients in 'uInstallRMQClients.pas';
 // uGitAccessToken in 'uGitAccessToken.pas';

/// \\192.168.2.6\Axpert9-XE3\Ver 11.0 Binaries\POS\uASBARS.pas

type
  TMain = class
  private
    Welcome: TInItApp;
  //  Welcome:TGitAccessToken;
    Config: TConfig;
    git: TGitManager;
    inst: Tinstallation;
    database: TDbConnect;
    // importStructure:TImportStructures;

    procedure startplugin;
    procedure GetConfig;
    procedure GitOperation;
    procedure InstallOperation;
    procedure ConnectDbOperation;
    procedure InIt;
    // procedure ImportAxpertStrucure;

  public
    constructor Create;
    destructor Destroy; override;
    // procedure PullPluginOperation;
  end;

constructor TMain.Create;
begin
  Welcome := nil;
  Config := nil;
  git := nil;
  inst := nil;
  database := nil;
  InIt;
end;

destructor TMain.Destroy;
begin
  FreeAndNil(Welcome);
  FreeAndNil(Config);
  FreeAndNil(git);
  FreeAndNil(inst);
  FreeAndNil(database);
  inherited;
end;

procedure TMain.startplugin;
begin
  Welcome := TInItApp.Create;
 // welcome.StartHTTPServer;
  Welcome.WelcomeUser();

end;

procedure TMain.GetConfig;
begin
  Config := TConfig.Create;

  Config.IsConfigFound();

end;

procedure TMain.GitOperation;
var
  GitHubURL: String;
begin
  // GitHubURL:='https://api.github.com/repos/Paroksh11/Axpert/contents/';
  git := TGitManager.Create;
  git.listOfPlugins();
end;

procedure TMain.InstallOperation;
var
  spath: string;
begin
  inst := Tinstallation.Create;
  // spath:='D:\Workspace\install_plugin\Win64\Debug\Plugin\Plugin1\Webfiles';
  inst.InstallPlugin(selectedPlugin);
end;

procedure TMain.ConnectDbOperation;
begin
  database := TDbConnect.Create;
  database.DatabaseConnection();
end;

procedure TMain.InIt;
begin
  pluginLocalPath := GetCurrentDir + '\' + cPlugins + '\';
  ForceDirectories(pluginLocalPath);
end;

var
  MainInstance: TMain;

begin
  MainInstance := TMain.Create;
  try
    MainInstance.startplugin;
    /// ///    //writeln(isProceedNext);
    if isProceedNext = True then
      MainInstance.GetConfig;
    MainInstance.GitOperation;
    MainInstance.InstallOperation; // InstallOperation
    MainInstance.ConnectDbOperation;
    readln;
    readln;
  finally
    // FreeAndNil(MainInstance);
  end;

end.
