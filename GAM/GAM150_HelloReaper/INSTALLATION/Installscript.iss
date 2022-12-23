; Author: Yongwon Cho
; Created: 06/16/2017
; Updated: 06/16/2017
; All content (c) 2017 DigiPen(USA) Corporation, all rights reserved.

; Inno Setup version 5.5.9
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "HelloReaper"
#define MyAppVersion "Version 1.00"
#define MyAppPublisher "DigiPen Institute of Technology"
#define MyAppURL "http://www.digipen.edu/"
#define MyAppExeName "HelloReaper.exe"
#define MyIconName "ReaperIcon.ico"
#define MyDistributionFolder "GAMEDIRECTORY"
#define MyAdditionToolsFolder "REDIST"
#define MyOutputDir "INSTALLER"
                                                                                     
[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{89241D0C-578A-4934-A88F-96797AFE5EB3}       
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\DigiPen/{#MyAppName}
DefaultGroupName=DigiPen/{#MyAppName}
AllowNoIcons=yes
LicenseFile=EULA\DigiPen_EULA.txt
OutputBaseFilename={#MyAppName}_setup
Compression=lzma
SolidCompression=yes
PrivilegesRequired=lowest
SetupIconFile={#MyDistributionFolder}/{#MyIconName}
OutputDir={#MyOutputDir}/
; Prevents the installer asking for a reboot if certian Windows files are modified.
RestartIfNeededByRun=no

; DO NOT CHANGE THIS SECTION
[Code]
#ifdef UNICODE
  #define AW "W"
#else
  #define AW "A"
#endif
type
  HINSTANCE = THandle;

procedure ExitProcess(uExitCode: UINT);
  external 'ExitProcess@kernel32.dll stdcall';
function ShellExecute(hwnd: HWND; lpOperation: string; lpFile: string;
  lpParameters: string; lpDirectory: string; nShowCmd: Integer): HINSTANCE;
  external 'ShellExecute{#AW}@shell32.dll stdcall';

var
  Elevated: Boolean;
  PagesSkipped: Boolean;

function CmdLineParamExists(const Value: string): Boolean;
var
  I: Integer;  
begin
  Result := False;
  for I := 1 to ParamCount do
    if CompareText(ParamStr(I), Value) = 0 then
    begin
      Result := True;
      Break;
    end;
end;

procedure InitializeWizard;
begin
  // initialize our helper variables
  Elevated := CmdLineParamExists('/ELEVATE');
  PagesSkipped := False;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  // if we've executed this instance as elevated, skip pages unless we're
  // on the directory selection page
  Result := not PagesSkipped and Elevated and (PageID <> wpSelectDir);
  // if we've reached the directory selection page, set our flag variable
  if not Result then
    PagesSkipped := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  Params: string;
  RetVal: HINSTANCE;
  TestCreatable: bool;
  Compara: bool;
begin
  Result := True;


  

  if (CurPageID = wpSelectDir) then
  begin
    TestCreatable := SaveStringToFile(ExpandConstant('{app}'),  ' ', false);
    if TestCreatable then
    begin
      DeleteFile(ExpandConstant('{app}'));
    end;
    Compara := not Elevated;
    Compara := Compara and not TestCreatable;
  if (Compara) then
  begin
    // pass the already selected directory to the executing parameters and
    // include our own custom /ELEVATE parameter which is used to tell the
    // setup to skip all the pages and get to the directory selection page
	if TestCreatable then
    begin
	  Params := ExpandConstant('/DIR="{app}"');
    end
	else
    begin
      Params := ExpandConstant('/DIR="{app}" /ELEVATE');
    end
    // because executing of the setup loader is not possible with ShellExec
    // function, we need to use a WinAPI workaround
    RetVal := ShellExecute(WizardForm.Handle, 'runas',
      ExpandConstant('{srcexe}'), Params, '', SW_SHOW);
    // if elevated executing of this setup succeeded, then...
    if RetVal > 32 then
    begin
      // exit this non-elevated setup instance
      ExitProcess(0);
    end
    else
    // executing of this setup failed for some reason; one common reason may
    // be simply closing the UAC dialog
    begin
      // handling of this situation is upon you, this line forces the wizard
      // stay on the current page
      Result := False;
      // and possibly show some error message to the user
      MsgBox(Format('Cannot install at specified path with current privilege settings. Error code: %d.', [RetVal]),
        mbError, MB_OK);
    end;
  end;
end;
end;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
; Creates an installer option to allow/disallow desktop shortcut
; Checked by default
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
; Name: "dxredist"; Description: "Install DirectX Redistributable";
; Name: "msvc2012redist"; Description: "Install Microsoft VS2012 Redistributable";
; Name: "msvc2013redist"; Description: "Install Microsoft VS2013 Redistributable";
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1;
                                         
[Files]
; The game directoy is exaclty what you want your install directory in program files to look like
Source: "./{#MyDistributionFolder}/*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Include the redistributable programs and install them to the temp directory
; Source: "./{#MyAdditionToolsFolder}/redist/DirectXRedist/*"; DestDir: "{tmp}"; Flags: ignoreversion
; Source: "./{#MyAdditionToolsFolder}/redist/MSVC2012Redist/*"; DestDir: "{tmp}"; Flags: ignoreversion
; Source: "./{#MyAdditionToolsFolder}/redist/MSVC2013Redist/*"; DestDir: "{tmp}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
IconFilename: "{app}\{#MyIconName}"; Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; 
IconFilename: "{app}\{#MyAppName}"; Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; 
IconFilename: "{app}\{#MyIconName}"; Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; 
IconFilename: "{app}\{#MyAppName}"; Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; 

[Run]
;Filename: {tmp}\vc_redist.x64.exe; Parameters: /q; StatusMsg: Installing Visual C++ 2015 Redistributable...
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent;
; Filename: "{tmp}\DXSETUP.exe"; Parameters: /silent; StatusMsg: "Installing DirectX Redistributable"; Tasks: dxredist;
; Filename: "{tmp}\vcredist_x86_12.exe"; Parameters: /silent; StatusMsg: "Installing Microsoft VS2012 Redistributable"; Tasks: msvc2012redist;
; Filename: "{tmp}\vcredist_x86.exe"; Parameters: /silent; StatusMsg: "Installing Microsoft VS2013 Redistributable"; Tasks: msvc2013redist;

[UninstallDelete]
Type: files; Name: "{app}\*.*"
