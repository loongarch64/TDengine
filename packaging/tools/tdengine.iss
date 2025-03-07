#define MyAppName "TDengine"
#define MyAppPublisher "taosdata"
#define MyAppURL "http://www.taosdata.com/"
#define MyAppBeforeInstallTxt "windows_before_install.txt"
#define MyAppIco "favicon.ico"
#define MyAppInstallDir "C:\TDengine"
#define MyAppOutputDir "./"
#define MyAppSourceDir "C:\TDengine"
;#define MyAppAllFile "\*"
#define MyAppCfgName "\cfg\*"
#define MyAppDriverName "\driver\*"
#define MyAppConnectorName "\connector\*"
#define MyAppExamplesName "\examples\*"
#define MyAppIncludeName "\include\*"
#define MyAppExeName "\*.exe"
#define MyAppTaosExeName "\taos.bat"
#define MyAppTaosdemoExeName "\taosBenchmark.exe"
#define MyAppDLLName "\driver\*.dll"
;#define MyAppVersion "3.0"
;#define MyAppInstallName "TDengine"
;#define MyAppInstallName "TDengine"
[Setup]
VersionInfoVersion={#MyAppVersion}
AppId={{A0F7A93C-79C4-485D-B2B8-F0D03DF42FAB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={#MyAppInstallDir}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
InfoBeforeFile={#MyAppBeforeInstallTxt}
OutputDir={#MyAppOutputDir}
OutputBaseFilename={#MyAppInstallName}
SetupIconFile={#MyAppIco}
Compression=lzma
SolidCompression=yes
DisableDirPage=yes
Uninstallable=yes

[Languages]
Name: "chinesesimp"; MessagesFile: "compiler:Default.isl"
;Name: "english"; MessagesFile: "compiler:Languages\English.isl"

[Files]
;Source: {#MyAppSourceDir}{#MyAppAllFile}; DestDir: "{app}"; Flags: igNoreversion recursesubdirs createallsubdirs 
Source: taos.bat; DestDir: "{app}\include"; Flags: igNoreversion;
;Source: taosdemo.png; DestDir: "{app}\include"; Flags: igNoreversion;
;Source: taosShell.png; DestDir: "{app}\include"; Flags: igNoreversion;
Source: favicon.ico; DestDir: "{app}\include"; Flags: igNoreversion;
Source: {#MyAppSourceDir}{#MyAppDLLName}; DestDir: "{win}\System32"; Flags: 64bit;Check:IsWin64;
Source: {#MyAppSourceDir}{#MyAppCfgName}; DestDir: "{app}\cfg"; Flags: igNoreversion recursesubdirs createallsubdirs onlyifdoesntexist uninsneveruninstall
Source: {#MyAppSourceDir}{#MyAppDriverName}; DestDir: "{app}\driver"; Flags: igNoreversion recursesubdirs createallsubdirs
;Source: {#MyAppSourceDir}{#MyAppConnectorName}; DestDir: "{app}\connector"; Flags: igNoreversion recursesubdirs createallsubdirs
;Source: {#MyAppSourceDir}{#MyAppExamplesName}; DestDir: "{app}\examples"; Flags: igNoreversion recursesubdirs createallsubdirs
Source: {#MyAppSourceDir}{#MyAppIncludeName}; DestDir: "{app}\include"; Flags: igNoreversion recursesubdirs createallsubdirs
Source: {#MyAppSourceDir}{#MyAppExeName}; DestDir: "{app}"; Excludes: {#MyAppExcludeSource} ; Flags: igNoreversion recursesubdirs createallsubdirs
Source: {#MyAppSourceDir}{#MyAppTaosdemoExeName}; DestDir: "{app}"; Flags: igNoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Name: {app}\driver; Type: filesandordirs 
Name: {app}\connector; Type: filesandordirs
Name: {app}\examples; Type: filesandordirs
Name: {app}\include; Type: filesandordirs

[Tasks]
Name: "desktopicon";Description: "{cm:CreateDesktopIcon}"; GroupDescription:"{cm:AdditionalIcons}"; Flags: checkablealone

[Icons]
Name:"{group}\Taos Shell"; Filename: "{app}\include\{#MyAppTaosExeName}" ; Parameters: "taos.exe" ; IconFilename: "{app}\include\{#MyAppIco}" 
Name:"{group}\Open TDengine Directory"; Filename: "{app}\" 
Name:"{group}\Taosdemo"; Filename: "{app}\include\{#MyAppTaosExeName}" ; Parameters: "taosdemo.exe" ; IconFilename: "{app}\include\{#MyAppIco}" 
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}" ; IconFilename: "{app}\include\{#MyAppIco}" 
Name:"{commondesktop}\Taos Shell"; Filename: "{app}\include\{#MyAppTaosExeName}" ; Parameters: "taos.exe" ; Tasks: desktopicon; WorkingDir: "{app}" ; IconFilename: "{app}\include\{#MyAppIco}" 


[Messages]
ConfirmUninstall=Do you really want to uninstall TDengine from your computer?%n%nPress [Y] to completely delete %1 and all its components;%nPress [N] to keep the software on your computer.
