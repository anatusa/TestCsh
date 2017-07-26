;    Together Fuzzy Search
;    Copyright (C) 2011 Together Teamsolutions Co., Ltd.
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or 
;    (at your option) any later version.
; 
;    This program is distributed in the hope that it will be useful, 
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
;    GNU General Public License for more details.
; 
;    You should have received a copy of the GNU General Public License
;    along with this program. If not, see http://www.gnu.org/licenses
;-----------------------------------------------------------------------

;----------------------------------------------------------------------------------
; TFS installation script
;	All output message will be written to file ..\..\log_TFS.txt
;----------------------------------------------------------------------------------
;Use only for testing with makensisw.exe
;!define VERSION "1.0" 	; Uncomment this for build with makensisw.exe
;!define RELEASE "17" ; Uncomment this for build with makensisw.exe
;!define OUTPUT_DIR "..\..\distributions\${SHORT_NAME}-${VERSION}-${RELEASE}\${SHORT_NAME}"
;----------------------------------------------------------------------------------
!include 'LogicLib.nsh'
!include WinMessages.nsh
!include "togStartOption.nsh"
!include "togDirectory.nsh"
!include "FileFunc.nsh"   ; for ${GetSize} for EstimatedSize registry entry
!include "x64.nsh"

;!define SHORT_NAME "tfs"
;!define SHORT_UPPER_NAME "TFS"
;bsremove !define APPLICATION_DIR "..\..\output\${SHORT_NAME}-${VERSION}-${RELEASE}"
!define APPLICATION_DIR "..\..\output"
!define ROOT_DIR "..\..\"
;!define NAME "Together Fuzzy Search"
!define EDITION_SHORT ""

;Version Information
VIProductVersion "${VERSION}.${RELEASE}.0"
  
Name "${APP_FULL_NAME} ${VERSION}-${RELEASE}" ;Define your own software name here

!define MUI_ICON "tog.ico"
!define MUI_UNICON "tog-uninstall.ico"

!include "MUI.nsh"
;!include "AddRemove.nsh"
!include Sections.nsh

RequestExecutionLevel admin

BrandingText "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
;---------------------------------------------------------------------------------------
;Configuration
;---------------------------------------------------------------------------------------
; General

;Remember install folder
InstallDirRegKey HKCU "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}" ""

!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "Header.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "Header.bmp"
!define MUI_ABORTWARNING

;ShowInstDetails show

; Compress
;------------
SetCompress          auto
SetCompressor        bzip2
SetDatablockOptimize on
SetDateSave          on

;--------------------------------
;Modern UI Configuration

  !define MUI_CUSTOMPAGECOMMANDS

  !define MUI_WELCOMEPAGE

; smaller fonts
  !define MUI_WELCOMEPAGE_TITLE_3LINES

  !define MUI_WELCOMEFINISHPAGE_BITMAP "Wizard.bmp"
  !define MUI_LICENSEPAGE
 ; !define MUI_DIRECTORYPAGE
  !define MUI_FINISHPAGE

; smaller fonts
	!define MUI_FINISHPAGE_TITLE_3LINES
		
	!define MUI_FINISHPAGE_LINK "Visit ${APP_FULL_NAME} Homepage"
	!define MUI_FINISHPAGE_LINK_LOCATION "http://www.together.at/prod/database/${SHORT_NAME}"

	!define MUI_FINISHPAGE_NOAUTOCLOSE ;To allow ShowInstDetails log
;	!define MUI_FINISHPAGE_RUN
;	!define MUI_FINISHPAGE_RUN_FUNCTION "RunApplication"
	;!define MUI_FINISHPAGE_CANCEL_ENABLED

;	!define MUI_TEXT_FINISH_RUN "Start ${APP_FULL_NAME} ${VERSION}-${RELEASE}"

	
	!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\doc\${SHORT_NAME}-current.doc.pdf"
	!define MUI_FINISHPAGE_SHOWREADME_TEXT "Show Documentation"
	!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED

	;!define MUI_UNTEXT_CONFIRM_TITLE $(MUI_UNTEXT_CONFIRM_TITLE)

  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE

;--------------------------------
;Variables

  Var STARTUP_MENU_NAME
  Var STARTMENU_FOLDER
  Var MUI_TEMP
  Var DEFAULT_BROWSER
  Var ADD_STARTMENU
  Var ADD_QUICKLAUNCH
  Var ADD_DESKTOP
  Var SILENT
  Var DefaultDir

OutFile "${OUTPUT_DIR}\${SHORT_NAME}-${VERSION}-${RELEASE}.exe" ; The file to write

; Folder-selection page
InstallDir "$PROGRAMFILES\${SHORT_NAME}-${VERSION}-${RELEASE}"

;==========================================================================

!ifdef INNER
  !echo "Inner invocation"                  ; just to see what's going on
  OutFile "$%TEMP%\tempinstaller.exe"       ; not really important where this is
  SetCompress off                           ; for speed
!else
  !echo "Outer invocation"

  ; Call makensis again, defining INNER.  This writes an installer for us which, when
  ; it is invoked, will just write the uninstaller to some location, and then exit.
  ; Be sure to substitute the name of this script here.
   
  !system "$\"${NSISDIR}\makensis$\" /DINNER /O..\..\src\bin\log_inner.txt /DAPP_FULL_NAME=$\"${APP_FULL_NAME}$\" /DSHORT_NAME=$\"${SHORT_NAME}$\" /DSHORT_UPPER_NAME=$\"${SHORT_UPPER_NAME}$\" /DVERSION=${VERSION} /DRELEASE=${RELEASE} /DLICENSE=${LICENSE} /DBUILDID=${BUILDID} /DCOPYRIGHT_YEAR=${COPYRIGHT_YEAR} TFS.nsi" = 0
  
  ; So now run that installer we just created as %TEMP%\tempinstaller.exe.  Since it
  ; calls quit the return value isn't zero.
 
  !system "$%TEMP%\tempinstaller.exe" = 2
 
  ; That will have written an uninstaller binary for us.  Now we sign it with your
  ; favourite code signing tool.
  
  !if "${SERVER_TIMEOUT}" == "true"
    ;time out and not found signtool_path  can't sign ->error
      !if "${SIGNTOOL_PATH}" != ""
             !error
     !endif
  !else
     ;normal mode[return success/fail]
	 !if "${SIGNTOOL_PATH}" != ""
		!echo "Return Value"
			 !if "${TIMESTAMP_URL}" == ""
				!system "$\"${SIGNTOOL_PATH}$\" sign /f $\"${KEY_PATH}$\" /p ${PASSWORD} /d $\"${FULL_NAME}$\" /du $\"http://www.together.at$\" $\"$%TEMP%\uninstall.exe$\"" = 0
			 !else
				!system "$\"${SIGNTOOL_PATH}$\" sign /f $\"${KEY_PATH}$\" /p ${PASSWORD} /d $\"${FULL_NAME}$\" /du $\"http://www.together.at$\" /t $\"${TIMESTAMP_URL}$\" $\"$%TEMP%\uninstall.exe$\"" = 0
			 !endif
	 !endif
  !endif

  ; Good.  Now we can carry on writing the real installer.
 
	OutFile "${OUTPUT_DIR}\${SHORT_NAME}-${VERSION}-${RELEASE}.exe" ; The file to write
  SetCompressor /SOLID lzma
!endif

;==========================================================================
;----------------------------------------------------------------------------------
;--------------------------------
;Pages Define our own pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "$(license_text)"
  ;!insertmacro MUI_PAGE_DIRECTORY
  !insertmacro TOG_CUSTOMPAGE_DIRECTORY "${APP_FULL_NAME} ${VERSION}-${RELEASE}" $DefaultDir  ;
 ; !insertmacro TOG_CUSTOMPAGE_STARTOPTION "${APP_FULL_NAME} ${VERSION}-${RELEASE}" $ADD_STARTMENU $STARTMENU_FOLDER $ADD_DESKTOP $ADD_QUICKLAUNCH ;
 ; !insertmacro TOG_CUSTOMPAGE_STARTOPTION "${APP_FULL_NAME} ${VERSION}-${RELEASE}" $ADD_STARTMENU $STARTMENU_FOLDER "off" $ADD_DESKTOP "off" $ADD_QUICKLAUNCH ;
  	!insertmacro TOG_CUSTOMPAGE_STARTOPTION "${APP_FULL_NAME} ${VERSION}-${RELEASE}" $ADD_STARTMENU $STARTMENU_FOLDER "off" $ADD_DESKTOP "off" $ADD_QUICKLAUNCH
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ;--------------------------------
;Languages
# LANG_ENGLISH
  !include "Language files\MUI_English.nsh"
  
  ;---------------------------------
# License page
   LicenseLangString license_text ${LANG_ENGLISH} "..\..\licenses\License.txt"
   LicenseForceSelection checkbox
;--------------------------------

# Things that need to be extracted on startup (keep these lines before any File command!)
# Only useful for BZIP2 compression
# Use ReserveFile for your own Install Options ini files too!
  !insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
   ReserveFile "set-shortcuts.ini"

;---------------------------------------------------------------------------------------
;Modern UI System
;---------------------------------------------------------------------------------------
;Installer Sections
;---------------------------------------------------------------------------------------
Section "Install" Install

  SectionIn 1 2 3 
   SetOverwrite try
   SetShellVarContext all

   Push $R0
      
  	Push $STARTMENU_FOLDER
	Call RemoveSpecialChar
	Call Trim
	Pop $STARTMENU_FOLDER
   
	SetOutPath $INSTDIR
	File /r /x "${SHORT_NAME}-${VERSION}-${RELEASE}.doc.*" /x "${SHORT_NAME}-current.doc.chm" /x *test.pdf "${APPLICATION_DIR}\*"
	File tog.ico
		
   Pop $0   

  !ifndef INNER
	  File $%TEMP%\uninstall.exe
  !endif   
  
  ClearErrors	
  DetailPrint "${APP_FULL_NAME} installation succeded (output: $0)"

  ${If} ${RunningX64}
    SetRegView 64
  ${EndIf}
  ; Write the installation path into the registry
  WriteRegStr HKLM "SOFTWARE\${APP_FULL_NAME} ${VERSION}-${RELEASE}" "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  ; Write the installation path into the registry
  WriteRegStr HKLM "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}" "InstDir" "$INSTDIR"

  ;Create shortcuts
  ${If} $ADD_STARTMENU != '0'
  CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
 
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Homepage.lnk" \
                 "http://www.together.at/prod/database/${SHORT_NAME}"\
                 "" \
                 $DEFAULT_BROWSER
	IfSilent createShortCutUninstallSilent
	
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" \
  				 "$INSTDIR\uninstall.exe" \
  				 "" \
  				 "$INSTDIR\uninstall.exe" 0	
	Goto endShortCut
	createShortCutUninstallSilent:
  CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" \
  				 "$INSTDIR\uninstall.exe" \
  				 "/SILENT" \
  				 "$INSTDIR\uninstall.exe" 0
	endShortCut:
								
   CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation"
   CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual HTML.lnk" \
                 "$INSTDIR\doc\${SHORT_NAME}-current.doc.html" \
                 "" \
                 $DEFAULT_BROWSER
				 
   CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual PDF.lnk" \
                 "$INSTDIR\doc\${SHORT_NAME}-current.doc.pdf" \
                 "" \
                 ""
	${endif}
	
  ; get cumulative size of all files in and under install dir
  ; report the total in KB (decimal)
  ; place the answer into $0  ($1 and $2 get other info we don't care about)
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  ; Convert the decimal KB value in $0 to DWORD
  ; put it right back into $0
  IntFmt $0 "0x%08X" $0
  
  ; Create/Write the reg key with the dword value
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \ 
                    "EstimatedSize" "$0"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
                    "DisplayName" "${APP_FULL_NAME}"
	IfSilent writeRegStrSilent
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  					"UninstallString" '"$INSTDIR\uninstall.exe"'
	Goto continueWriteReg
	writeRegStrSilent:
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  					"UninstallString" '"$INSTDIR\uninstall.exe" /SILENT'

	continueWriteReg:

  WriteRegStr HKLM  "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
                                     "DisplayIcon" "$INSTDIR\tog.ico"
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"Publisher" "Together Teamsolutions Co., Ltd."
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"DisplayVersion" "${VERSION}-${RELEASE}-${BUILDID}"
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"URLInfoAbout" "http://www.together.at/services"
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"URLUpdateInfo" "http://www.together.at/prod/database/${SHORT_NAME}"
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"HelpLink" "http://www.together.at/prod/database/${SHORT_NAME}"
  WriteRegStr HKLM 	"Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" \
  									"StartMenuFolder" "$STARTMENU_FOLDER"																		
 
  ;WriteUninstaller "uninstall.exe"
# Make the directory "$INSTDIR" read write accessible by all users
  AccessControl::GrantOnFile "$INSTDIR" "(S-1-1-0)" "FullAccess"
SectionEnd
;----------------------------------------------------------------------
;Function .onInstSuccess
;	ReadEnvStr $0 COMSPEC

;FunctionEnd
;---------------------------------------------------------------------------------------
;Installer Functions
;---------------------------------------------------------------------------------------
Function .onInit
!ifdef INNER
 
  ; If INNER is defined, then we aren't supposed to do anything except write out
  ; the installer.  This is better than processing a command line option as it means
  ; this entire code path is not present in the final (real) installer.
 
  WriteUninstaller "$%TEMP%\uninstall.exe"
  Quit  ; just bail out quickly when running the "inner" installer
!endif

    ${If} ${RunningX64}
          StrCpy $INSTDIR "$PROGRAMFILES64\${SHORT_NAME}-${VERSION}-${RELEASE}"
    ${else}
          StrCpy $INSTDIR "$PROGRAMFILES\${SHORT_NAME}-${VERSION}-${RELEASE}"
    ${EndIf}
	
    StrCpy $DefaultDir $INSTDIR
  ;Extract Install Options INI Files
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "set-shortcuts.ini"

; Read default browser path
  ReadRegStr $R9 HKCR "HTTP\shell\open\command" ""
	
  Push $R9 ;original string
  Push '"' ;needs to be replaced
  Push '' ;will replace wrong characters
  Call StrReplace
  
  Push "-"
  Call GetFirstPartRest
  Pop $DEFAULT_BROWSER
    #------- seting silent installation -----------------#
  IfFileExists "$EXEDIR\${SHORT_NAME}-${VERSION}-${RELEASE}.silent.properties" silent normal
  silent:
  SetSilent silent
  StrCpy $SILENT "YES"
  StrCpy $STARTMENU_FOLDER "${APP_FULL_NAME} ${VERSION}-${RELEASE}" 
  Goto start_silent_initialization
  normal:
  SetSilent normal
  StrCpy $SILENT "NO"
  Goto start_initialization
  
  start_silent_initialization:
  IfFileExists "$EXEDIR\${SHORT_NAME}-${VERSION}-${RELEASE}.silent.properties" "" continue
  continue:
  FileOpen $9 "$EXEDIR\${SHORT_NAME}-${VERSION}-${RELEASE}.silent.properties" r
  
  loop:
    FileRead $9 $8 
    IfErrors loopend
    Push $8
    Call TrimNewlines
    Push "="
    Call GetFirstPartRest
    Pop $R0 ;1st part 
    Pop $R1 ;rest 
    StrCmp $R0 "inst.dir" setinstdir
	StrCmp $R0 "startup.menu.name" setstartupmenuname
	StrCmp $R0 "create.start.menu.entry" setstartmenu

  Goto loop
  setinstdir:
    StrCpy $INSTDIR $R1
    Goto loop
  setstartupmenuname:
    StrCpy $STARTUP_MENU_NAME $R1
	Goto loop
  setstartmenu:
    Push $R1
    Call ConvertOptionToDigit
	Pop $R1
    StrCpy $ADD_STARTMENU $R1
    Goto loop
  loopend:
    FileClose $9
	StrCpy $STARTMENU_FOLDER $STARTUP_MENU_NAME
	${if} $STARTMENU_FOLDER == ""
			StrCpy $STARTMENU_FOLDER "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
			StrCpy $STARTUP_MENU_NAME "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
	${endif}

  #------- seting silent installation -----------------#
  
  start_initialization:
  ${if} $STARTMENU_FOLDER == ""
			StrCpy $STARTMENU_FOLDER "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
			StrCpy $STARTUP_MENU_NAME "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
			StrCpy $ADD_STARTMENU 1
 ${endif}
  IfSilent end_splash_screen
# start splash screen
# the plugins dir is automatically deleted when the installer exits
		InitPluginsDir
		File /oname=$PLUGINSDIR\splash.bmp "Splash.bmp"
#optional
#File /oname=$PLUGINSDIR\splash.wav "C:\myprog\sound.wav"
		advsplash::show 1000 600 400 -1 $PLUGINSDIR\splash
		Pop $0 ; $0 has '1' if the user closed the splash screen early,
		                ; '0' if everything closed normal, and '-1' if some error occured.
  end_splash_screen:
  
 ; Call IsDotNETInstalled
 ; Pop $0
 ; StrCmp $0 1 +3 
 ; MessageBox MB_OK "    Missing .NET Framework 2.0, please install it."
 ; Abort

  ;Extract Install Options INI Files
  !insertmacro MUI_INSTALLOPTIONS_EXTRACT "set-shortcuts.ini"

;  StrCpy $JAVAHOME ""

	Push $STARTMENU_FOLDER
	Call RemoveSpecialChar
	Call Trim
	Pop $STARTMENU_FOLDER

FunctionEnd
;---------------------------------------------------------------------------------
 ; ConvertOptionToDigit
 ; input, top of stack  (e.g. whatever$\r$\n)
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies "on" to 1 and "off" to 2.
Function ConvertOptionToDigit
  ClearErrors
							  ; Stack: <value>
  Exch $0                     ; Stack: $0
  ;$0=value
  StrCmp $0 "on" setOne setZero
  setOne:
  StrCpy $0 '1'
  Goto endset
  setZero:
  StrCpy $0 '0'
  endset:
  Exch $0
FunctionEnd
;---------------------------------------------------------------------------------
 ; TrimNewlines
 ; input, top of stack  (e.g. whatever$\r$\n)
 ; output, top of stack (replaces, with e.g. whatever)
 ; modifies no other variables.

 Function TrimNewlines
   Exch $R0
   Push $R1
   Push $R2
   StrCpy $R1 0
 
 loop:
   IntOp $R1 $R1 - 1
   StrCpy $R2 $R0 1 $R1
   StrCmp $R2 "$\r" loop
   StrCmp $R2 "$\n" loop
   IntOp $R1 $R1 + 1
   IntCmp $R1 0 no_trim_needed
   StrCpy $R0 $R0 $R1
 
 no_trim_needed:
   Pop $R2
   Pop $R1
   Exch $R0
 FunctionEnd
 
;---------------------------------------------------------------------------------------
;Descriptions
;---------------------------------------------------------------------------------------
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
;---------------------------------------------------------------------------------------
;Uninstaller Section
;---------------------------------------------------------------------------------------
!ifdef INNER
Section "Uninstall"
  SetShellVarContext all

  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "SOFTWARE\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  
;  ReadEnvStr $0 COMSPEC

  ; MUST REMOVE UNINSTALLER, too
  Delete $INSTDIR\uninstall.exe

  RMDir /r "$INSTDIR"

  
  ; remove shortcuts, if any.
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Homepage.lnk"
 ; Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} ${VERSION}-${RELEASE}.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual HTML.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual PDF.lnk"
 ; Delete "$DESKTOP\$STARTMENU_FOLDER.lnk"
 ; Delete "$QUICKLAUNCH\$STARTMENU_FOLDER.lnk"
  RMDir "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation"
  RMDir "$SMPROGRAMS\$STARTMENU_FOLDER"

  ;Delete empty start menu parent diretories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"

  startMenuDeleteLoop:
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."

    IfErrors startMenuDeleteLoopDone

    StrCmp $MUI_TEMP $SMPROGRAMS startMenuDeleteLoopDone startMenuDeleteLoop
  startMenuDeleteLoopDone:

  ; remove registry keys
  DeleteRegKey HKCU "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}"

SectionEnd
!endif
;---------------------------------------------------------------------------------------
;Uninstaller Functions
;---------------------------------------------------------------------------------------
Function un.onInit

	Push $2
	Push $R0
	
	ClearErrors
	${GetParameters} $R0 ; read options
	${GetOptions} "$R0" "/SILENT" $2 ; check the option by non-case sensitive
	IfErrors init_cmd_normal ; if error, the option not found
	SetSilent silent
	
	init_cmd_normal:
	
	${If} ${RunningX64}
		SetRegView 64
	${EndIf}
	;Get language from registry
	ReadRegStr $LANGUAGE HKCU "Software\${APP_FULL_NAME}" "Installer Language"
	ReadRegStr $STARTMENU_FOLDER HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}" "StartMenuFolder"
	
	Pop $R0
	Pop $2
FunctionEnd
;------------------------------------------------------------------------------
; Call on installation failed
;------------------------------------------------------------------------------
Function .onInstFailed
	Call Cleanup
FunctionEnd
;------------------------------------------------------------------------------
; Call when installation failed or when uninstall started
;------------------------------------------------------------------------------
Function Cleanup
  SetShellVarContext all

  ; remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "SOFTWARE\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  
;  ReadEnvStr $0 COMSPEC

  ; MUST REMOVE UNINSTALLER, too
  Delete $INSTDIR\uninstall.exe

  RMDir /r "$INSTDIR"

  ; remove shortcuts, if any.
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Homepage.lnk"
 ; Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} ${VERSION}-${RELEASE}.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual HTML.lnk"
  Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation\${SHORT_UPPER_NAME} Manual PDF.lnk"
 ; Delete "$DESKTOP\$STARTMENU_FOLDER.lnk"
 ; Delete "$QUICKLAUNCH\$STARTMENU_FOLDER.lnk"
  RMDir "$SMPROGRAMS\$STARTMENU_FOLDER\${SHORT_UPPER_NAME} Documentation"
  RMDir "$SMPROGRAMS\$STARTMENU_FOLDER"

  ;Delete empty start menu parent diretories
  StrCpy $MUI_TEMP "$SMPROGRAMS\$MUI_TEMP"

  startMenuDeleteLoop:
    RMDir $MUI_TEMP
    GetFullPathName $MUI_TEMP "$MUI_TEMP\.."

    IfErrors startMenuDeleteLoopDone

    StrCmp $MUI_TEMP $SMPROGRAMS startMenuDeleteLoopDone startMenuDeleteLoop
  startMenuDeleteLoopDone:

  ; remove registry keys
  DeleteRegKey HKCU "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  DeleteRegKey HKLM "Software\${APP_FULL_NAME} ${VERSION}-${RELEASE}"

FunctionEnd
;-------------------------------------------------------------------------------
; input, top of stack = string for replace string to search for
;        top of stack-1 = string to search for
;        top of stack-2 = string to search in
; output, top of stack string to search in replaces with the string for replace
; modifies no other variables.
;
; Usage:
;   Push "Start @JAVA_DIR@\bin\java.exe"
;   Push "@JAVA_DIR@"
;   Push "C:\j2sdk1.4.0"
;   Call StrReplace
;   Pop $R0
;  ($R0 at this point is "Start C:\j2sdk1.4.0\bin\java.exe")
;-------------------------------------------------------------------------------
Function StrReplace
  Exch $0 ;this will replace wrong characters
  Exch
  Exch $1 ;needs to be replaced
  Exch
  Exch 2
  Exch $2 ;the orginal string
  Push $3 ;counter
  Push $4 ;temp character
  Push $5 ;temp string
  Push $6 ;length of string that need to be replaced
  Push $7 ;length of string that will replace
  Push $R0 ;tempstring
  Push $R1 ;tempstring
  Push $R2 ;tempstring
  StrCpy $3 "-1"
  StrCpy $5 ""
  StrLen $6 $1
  StrLen $7 $0
  Loop:
 IntOp $3 $3 + 1
  StrCpy $4 $2 $6 $3
  StrCmp $4 "" ExitLoop
  StrCmp $4 $1 Replace
  Goto Loop
  Replace:
  StrCpy $R0 $2 $3
  IntOp $R2 $3 + $6
  StrCpy $R1 $2 "" $R2
  StrCpy $2 $R0$0$R1
  IntOp $3 $3 + $7
  Goto Loop
  ExitLoop:
  StrCpy $0 $2
  Pop $R2
  Pop $R1
  Pop $R0
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0
FunctionEnd

;------------------------------------------------------------------------------
; ReplaceChar
; input, input string  (C:\JBuilder\jdk1.3.1)
;        char to need replaced (\)
;        char to with replaced (/)
; output, top of stack (C:/JBuilder/jdk1.3.1)
; modifies no other variables.
;
; Usage:
;   Push $1 ; "C:\JBuilder\jdk1.3.1"
;   Push "\"
;   Push "/"
;   Call ReplaceChar
;   Pop $0
;   ; at this point $0 will equal "C:/JBuilder/jdk1.3.1"
;------------------------------------------------------------------------------
Function ReplaceChar
					; stack="/","\","C:\JBuilder\jdk1.3.1", ... (from top to down)
  Exch $2 ; $2="/", stack="2-gi param","\","C:\JBuilder\jdk1.3.1", ...
  Exch  	; stack="\","2-ti param","C:\JBuilder\jdk1.3.1", ...
  Exch $1 ; $1="\", stack="1-vi param","2-gi param","C:\JBuilder\jdk1.3.1", ...
  Exch    ; stack="2-gi param","1-vi param","C:\JBuilder\jdk1.3.1", ...
	Exch 2	; stack="C:\JBuilder\jdk1.3.1","1-vi param","2-gi param", ...
  Exch $0 ; $0="C:\JBuilder\jdk1.3.1", stack="0-ti param","1-vi param","2-gi param", ...
  Exch 2  ; stack="2-gi param","1-vi param","0-ti param", ...

  Push $3	; Len("C:\JBuilder\jdk1.3.1")
  Push $4	; index of string
  Push $5 ; tmp - form strat to found char witch need to change
  Push $6 ; tmp - from found char witch need to change + 1 to end ($3)
  Push $7 ; tmp - position where found char witch need to change + 1
  StrLen $3 $0
  StrCpy $4 0
  loop:
    StrCpy $5 $0 1 $4
    StrCmp $5 "" exit
    StrCmp $5 $1 change
    IntOp $4 $4 + 1
  Goto loop
  change:
  	StrCpy $6 $4				; pozition where found char witch need to change
  	StrCpy $5 $0 $6   	; $5="C:"
  	StrCpy $5 "$5$2"   	; $5="C:/"
  	StrCpy $7 $4				; pozition where found char witch need to change
  	IntOp $7 $7 + 1 		; next pozition
  	StrCpy $6 $0 $3 $7  ; $6="JBuilder\jdk1.3.1"
  	StrCpy $0 $5				; $0="C:/"
  	StrCpy $0 "$0$6" 		; $0="C:/JBuilder\jdk1.3.1"
  Goto loop
  exit:
    Pop $7
    Pop $6
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Exch $0 ; put $0 on top of stack, restore $0 to original value
FunctionEnd

;------------------------------------------------------------------
; Usage:
;   Push "original_text";   
;   Call RemoveSpecialChar
;   Pop $R0
;  ($R0 is text without special character")
;------------------------------------------------------------------
Function RemoveSpecialChar
	Pop $R1
	StrCpy $0 "|\/:*?<>"
	StrLen $3 $0
	StrCpy $1 0
	; remove special character
	Loop_Replace:
	StrCpy $R2 $0 1 $1
	Push $R1
	Push $R2
	Push " "
	Call ReplaceChar
	Pop $R1
	IntOp $1 $1 + 1
	IntCmp $1 $3 Loop_Replace Loop_Replace 0	
	; remove empty spaces
	StrLen $3 $R1
	StrCpy $1 0
	Loop_Remove:
	Push $R1
	Push "  "
	Push " "
	Call StrReplace
	Pop $R1
	IntOp $1 $1 + 1
	IntCmp $1 $3 Loop_Remove Loop_Remove 0	
	Push $R1
FunctionEnd
 
;----------------------------------------------      
; input:
; Push "HelloAll I am Afrow UK, and I love NSIS" ; Input string 
; Push " " ; search string 
; Call GetFirstStrPart 
; output:
; Pop "$R0" ; first part
; Pop "$R1" ; rest of string
;----------------------------------------------      
Function GetFirstPartRest
  Exch $R1  ; search string
#  Dumpstate::debug
  Exch
#  Dumpstate::debug
  Exch $R0   ; Input string
#  Dumpstate::debug
  Exch
  Push $R2
  Push $R3
  Push $R4
  StrCpy $R4 $R0
  StrLen $R2 $R0
  IntOp $R2 $R2 + 1
#  Dumpstate::debug
  loop:
#     MessageBox MB_OK "loop:-1"
#     Dumpstate::debug
    IntOp $R2 $R2 - 1
#   StrCpy user_var(destination) str [maxlen] [start_offset]
    StrCpy $R3 $R0 1 -$R2
#     MessageBox MB_OK "loop:-2"
#     Dumpstate::debug
    StrCmp $R2 0 exit0
    StrCmp $R3 $R1 exit1 loop ; check if find (go to exit1 otherwise loop)

  exit0:
#  MessageBox MB_OK "exit0"
#  Dumpstate::debug
#  StrCpy $R2 ""
  StrCpy $R1 ""
  StrCpy $R0 ""
  Goto exit2

  exit1:
#  MessageBox MB_OK "exit1"
#  Dumpstate::debug
    IntOp $R2 $R2 - 1
    StrCpy $R3 $R0 "" -$R2
    IntOp $R2 $R2 + 1
    StrCpy $R0 $R0 -$R2
#  MessageBox MB_OK "exit1-1"
#  Dumpstate::debug
     StrLen $R2 $R0
    IntOp $R2 $R2 + 1
    StrCpy $R3 $R4 "" $R2
#  MessageBox MB_OK "exit1-2"
#  Dumpstate::debug
    StrCpy $R1 $R3

  exit2:
#  MessageBox MB_OK "exit2"
#  Dumpstate::debug
    Pop $R4
    Pop $R3
    Pop $R2
#  Dumpstate::debug
#    Exch  
    Exch $R1
    Exch
#  Dumpstate::debug
    Exch $R0
#  Dumpstate::debug
FunctionEnd
;------------------------------------------------------------------------------
Function SetShortcuts

  Push $R0
  !insertmacro MUI_HEADER_TEXT "Choose Start Options" "Select from the following start options."

  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 1" "State" "${APP_FULL_NAME} ${VERSION}-${RELEASE}"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 3" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 3" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 4" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 4" "Flags" "DISABLED"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 5" "State" "0"
  !insertmacro MUI_INSTALLOPTIONS_WRITE "set-shortcuts.ini" "Field 5" "Flags" "DISABLED"
  
  !insertmacro MUI_INSTALLOPTIONS_DISPLAY_RETURN "set-shortcuts.ini"
	Pop $R0
  StrCmp $R0 "cancel" end
  StrCmp $R0 "back" end
  StrCmp $R0 "success" "" error
  Goto end

  error:
  MessageBox MB_OK|MB_ICONSTOP "Shortcuts Error: $R0$\r$\n"
  Goto end

  end:
  Pop $R0
  !insertmacro MUI_INSTALLOPTIONS_WRITE "ioSpecial.ini" "Settings" "BackEnabled" "0"
FunctionEnd
;------------------------------------------------------------------------------
Function CheckShortcuts
  Push $R0
  Push $R1
  !insertmacro MUI_INSTALLOPTIONS_READ $STARTMENU_FOLDER "set-shortcuts.ini" "Field 1" "State"
  SetOutPath $INSTDIR
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "set-shortcuts.ini" "Field 2" "State"
  StrCpy $ADD_STARTMENU $R0					 
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "set-shortcuts.ini" "Field 3" "State"
  StrCpy $ADD_QUICKLAUNCH $R0
				
  !insertmacro MUI_INSTALLOPTIONS_READ $R0 "set-shortcuts.ini" "Field 4" "State"
  StrCpy $ADD_DESKTOP $R0
              
  Pop $R1
  Pop $R0
FunctionEnd

Function un.GetParameters

   Push $R0
   Push $R1
   Push $R2
   Push $R3

   StrCpy $R2 1
   StrLen $R3 $CMDLINE

   ;Check for quote or space
   StrCpy $R0 $CMDLINE $R2
   StrCmp $R0 '"' 0 +3
	 StrCpy $R1 '"'
	 Goto loop
   StrCpy $R1 " "

   loop:
	 IntOp $R2 $R2 + 1
	 StrCpy $R0 $CMDLINE 1 $R2
	 StrCmp $R0 $R1 get
	 StrCmp $R2 $R3 get
	 Goto loop

   get:
	 IntOp $R2 $R2 + 1
	 StrCpy $R0 $CMDLINE 1 $R2
	 StrCmp $R0 " " get
	 StrCpy $R0 $CMDLINE "" $R2

   Pop $R3
   Pop $R2
   Pop $R1
   Exch $R0

FunctionEnd
;------------------------------------------------------------------
; StrStr
; input, top of stack = string to search for
;        top of stack-1 = string to search in
; output, top of stack (replaces with the portion of the string remaining)
; modifies no other variables.
;
; Usage:
;   Push "this is a long ass string"
;   Push "ass"
;   Call StrStr
;   Pop $R0
;  ($R0 at this point is "ass string")
;------------------------------------------------------------------
 Function un.StrStr
 Exch $R1 ; st=haystack,old$R1, $R1=needle
   Exch    ; st=old$R1,haystack
   Exch $R2 ; st=old$R1,old$R2, $R2=haystack
   Push $R3
   Push $R4
   Push $R5
   StrLen $R3 $R1
   StrCpy $R4 0
   ; $R1=needle
   ; $R2=haystack
   ; $R3=len(needle)
   ; $R4=cnt
   ; $R5=tmp
   loop:
	 StrCpy $R5 $R2 $R3 $R4
	 StrCmp $R5 $R1 done
	 StrCmp $R5 "" done
	 IntOp $R4 $R4 + 1
	 Goto loop
 done:
   StrCpy $R1 $R2 "" $R4
   Pop $R5
   Pop $R4
   Pop $R3
   Pop $R2
   Exch $R1
 FunctionEnd
Function un.GetParameterValue
  Exch $R0  ; get the default parameter into R1
  Exch      ; exchange the top two
  Exch $R1  ; get the search parameter into $R0

  ;Preserve on the stack the registers we will use in this function
  Push $R2
  Push $R3
  Push $R4
  Push $R5

  Strlen $R2 $R1+2   ; store the length of the search string into R2

  Call un.GetParameters ;get the command line parameters
  Pop $R3            ; store the command line string in R3
  # search for quoted search string
  StrCpy $R5 '"'     ; later on we want to search for a open quote
  Push $R3           ; push the 'search in' string onto the stack
  Push '"/$R1='      ; push the 'search for'
  Call un.StrStr
  Pop $R4
  StrCpy $R4 $R4 "" 1 # skip quote
  StrCmp $R4 "" 0 next
  # search for non-quoted search string
  StrCpy $R5 ' '     ; later on we want to search for a space
  Push $R3           ; push the command line back on the stack for searching
  Push '/$R1='       ; search for the non-quoted search string
  Call un.StrStr
  Pop $R4
next:
  StrCmp $R4 "" done       ; if we didn't find anything then we are done
  # copy the value after /$R1=
  StrCpy $R0 $R4 "" $R2  ; copy commandline text beyond parameter into $R0
  # search for the next parameter so we can trim this extra text off
  Push $R0
  Push $R5
  Call un.StrStr         ; search for the next parameter
  Pop $R4
  StrCmp $R4 "" done
  StrLen $R4 $R4
  StrCpy $R0 $R0 -$R4 ; using the length of the string beyond the value,
					  ;copy only the value into $R0
done:
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0 ; put the value in $R0 at the top of the stack
FunctionEnd
