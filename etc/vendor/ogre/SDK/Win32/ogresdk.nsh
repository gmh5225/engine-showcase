; Script generated by the HM NIS Edit Script Wizard.

!include WriteEnvStr.nsh

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "OGRE SDK"
!define PRODUCT_VERSION "1.6.1"
!define PRODUCT_PUBLISHER "The OGRE Team"
!define PRODUCT_WEB_SITE "http://www.ogre3d.org"
!ifdef MINGW
  !ifdef STLPORT
    !define WIKI_LINK "http://www.ogre3d.org/wiki/index.php/CodeBlocks_MingW_STLPort"
  !else
    !define WIKI_LINK "http://www.ogre3d.org/wiki/index.php/Codeblocks_and_MinGW"
  !endif
!else
  !define WIKI_LINK "http://www.ogre3d.org/wiki/index.php/Installing_An_SDK"
!endif

!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"

SetCompressor lzma

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Welcome page
!define MUI_WELCOMEPAGE_TITLE_3LINES
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_CHECKBOX
!insertmacro MUI_PAGE_LICENSE "..\..\COPYING"
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "OGRE SDK"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\docs\ReadMe.html"
!define MUI_FINISHPAGE_TITLE_3LINES
!define MUI_FINISHPAGE_LINK "learn more about setting up the SDK"
!define MUI_FINISHPAGE_LINK_LOCATION "${WIKI_LINK}"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION} for ${TARGET_COMPILER_DESCRIPTION}"
OutFile "OgreSDKSetup${PRODUCT_VERSION}_${TARGET_COMPILER}.exe"
InstallDir "c:\OgreSDK"
ShowInstDetails show
ShowUnInstDetails show

Section -Headers

  ; Required header files
  ; Core
  SetOutPath "$INSTDIR\include"
  SetOverwrite try
  File "..\..\OgreMain\include\*.h"
  File "..\..\ReferenceApplication\Common\include\*.h"
  SetOutPath "$INSTDIR\include\WIN32"
  SetOverwrite try
  File "..\..\OgreMain\include\WIN32\*.h"
  ; Dependencies - only ODE and CEGui
  SetOutPath "$INSTDIR\include\CEGUI"
  SetOverwrite try
  File /r /x .svn "..\..\Dependencies\include\CEGUI\*.*"
  SetOutPath "$INSTDIR\include\ode"
  SetOverwrite try
  File /r /x .svn "..\..\Dependencies\include\ode\*.*"
  SetOutPath "$INSTDIR\include\OIS"
  SetOverwrite try
  File /r /x .svn "..\..\Dependencies\include\OIS\*.*"

  ; Optional headers (for linking direct to plugins)
  SetOutPath "$INSTDIR\include\opt"
  SetOverwrite try
  File "..\..\Plugins\OctreeSceneManager\include\*.h"
  File "..\..\Plugins\BspSceneManager\include\*.h"
  File "..\..\Plugins\ParticleFX\include\*.h"
  File "..\..\Plugins\PCZSceneManager\include\*.h"
  File "..\..\Plugins\OctreeZone\include\*.h"

SectionEnd

Section -Libs
  ; Library files
  SetOutPath "$INSTDIR\lib"
  SetOverwrite try
  !ifdef MINGW
    ; Debug libs
    File "..\..\Dependencies\lib\Debug\libode_d.a"
    ; Release libs
    File "..\..\Dependencies\lib\Release\libode.a"
  !else ; MSVC
    ; Debug libs
    File "..\..\lib\OgreMain_d.lib"
    ; ode.lib is only one available, no separately named debug version
    File "..\..\Dependencies\lib\Release\ode.lib"
    File "..\..\Dependencies\lib\Debug\CEGUIBase_d.lib"
    File "..\..\Dependencies\lib\Debug\OIS_d.lib"
    File "..\..\lib\OgreGUIRenderer_d.lib"
    ; Release libs
    File "..\..\lib\OgreMain.lib"
    File "..\..\Dependencies\lib\Release\CEGUIBase.lib"
    File "..\..\Dependencies\lib\Release\OIS.lib"
    File "..\..\lib\OgreGUIRenderer.lib"
  !endif


  ; Optional library files (for linking direct to plugins)
  SetOutPath "$INSTDIR\lib\opt"
  SetOverwrite try
  !ifndef MINGW ; MSVC
    File "..\..\lib\Plugin_OctreeSceneManager.lib"
    File "..\..\lib\Plugin_OctreeSceneManager_d.lib"
    File "..\..\lib\Plugin_BspSceneManager.lib"
    File "..\..\lib\Plugin_BspSceneManager_d.lib"
    File "..\..\lib\Plugin_ParticleFX.lib"
    File "..\..\lib\Plugin_ParticleFX_d.lib"
	File "..\..\lib\Plugin_PCZSceneManager.lib"
	File "..\..\lib\Plugin_PCZSceneManager_d.lib"
	File "..\..\lib\Plugin_OctreeZone.lib"
	File "..\..\lib\Plugin_OctreeZone_d.lib"
  !endif

SectionEnd

Section -Binaries

  ; Binaries - debug
  SetOutPath "$INSTDIR\bin\debug"
  SetOverwrite ifnewer
  !ifdef MINGW
    File "..\..\Samples\Common\bin\Debug\mingwm10.dll"
    File "..\..\Samples\Common\bin\Debug\CEGUITinyXMLParser_d.dll"
  !endif
  File "..\..\Samples\Common\bin\Debug\cg.dll"
  File "..\..\Samples\Common\bin\Debug\OIS_d.dll"

  File "..\..\Samples\Common\bin\Debug\OgreMain_d.dll"
  File "..\..\Samples\Common\bin\Debug\CEGUIBase_d.dll"
  !ifndef MINGW ; MSVC
    File "..\..\Samples\Common\bin\Debug\CEGUIExpatParser_d.dll"
  !endif
  File "..\..\Samples\Common\bin\Debug\CEGUIFalagardWRBase_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_BSPSceneManager_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_CgProgramManager_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_OctreeSceneManager_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_ParticleFX_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_PCZSceneManager_d.dll"
  File "..\..\Samples\Common\bin\Debug\Plugin_OctreeZone_d.dll"
  File "..\..\Samples\Common\bin\Debug\RenderSystem_Direct3D9_d.dll"
  File "..\..\Samples\Common\bin\Debug\RenderSystem_GL_d.dll"
  File "..\..\Samples\Common\bin\Debug\OgreGUIRenderer_d.dll"

  File ".\samples\resources.cfg"
  File "..\..\Samples\Common\bin\Debug\plugins.cfg"
  File "..\..\Samples\Common\bin\Debug\media.cfg"
  File "..\..\Samples\Common\bin\quake3settings.cfg"
  ; Binaries - release
  SetOutPath "$INSTDIR\bin\release"
  SetOverwrite ifnewer
  !ifdef MINGW
    File "..\..\Samples\Common\bin\Release\mingwm10.dll"
    File "..\..\Samples\Common\bin\Release\CEGUITinyXMLParser.dll"
  !endif
  File "..\..\Samples\Common\bin\Release\cg.dll"
  File "..\..\Samples\Common\bin\Release\OIS.dll"

  File "..\..\Samples\Common\bin\Release\OgreMain.dll"
  File "..\..\Samples\Common\bin\Release\CEGUIBase.dll"
  !ifndef MINGW ; MSVC
    File "..\..\Samples\Common\bin\Release\CEGUIExpatParser.dll"
  !endif
  File "..\..\Samples\Common\bin\Release\CEGUIFalagardWRBase.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_BSPSceneManager.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_CgProgramManager.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_OctreeSceneManager.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_ParticleFX.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_PCZSceneManager.dll"
  File "..\..\Samples\Common\bin\Release\Plugin_OctreeZone.dll"
  File "..\..\Samples\Common\bin\Release\RenderSystem_Direct3D9.dll"
  File "..\..\Samples\Common\bin\Release\RenderSystem_GL.dll"
  File "..\..\Samples\Common\bin\Release\OgreGUIRenderer.dll"

  File ".\samples\resources.cfg"
  File "..\..\Samples\Common\bin\Release\plugins.cfg"
  File "..\..\Samples\Common\bin\Release\media.cfg"
  File "..\..\Samples\Common\bin\quake3settings.cfg"

SectionEnd

Section -Media
  SetOutPath "$INSTDIR\media"
  SetOverwrite ifnewer

  File /r /x .svn "..\..\Samples\Media\*.*"

SectionEnd

Section -Docs
  ; Documentation
  SetOutPath "$INSTDIR\docs"
  SetOverwrite try
  File ".\docs\ReadMe.html"
  File "..\..\Docs\ChangeLog.html"
  File "..\..\Docs\style.css"
  File "..\..\Docs\ogre-logo.gif"
  File "..\..\Docs\ogre-logo-wetfloor.gif"
  SetOutPath "$INSTDIR\docs\licenses"
  File "..\..\Docs\licenses\*.*"


  SetOutPath "$INSTDIR\docs\manual\images"
  SetOverwrite try
  File "..\..\Docs\manual\images\*.*"
  SetOutPath "$INSTDIR\docs\manual"
  File "..\..\Docs\manual\*.*"

  SetOutPath "$INSTDIR\docs\api"
  SetOverwrite try
  File "..\..\Docs\api\html\OgreAPIReference.*"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd


Section -AdditionalIcons
  SetOutPath $INSTDIR
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  WriteIniStr "$INSTDIR\OgreWebSite.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  WriteIniStr "$INSTDIR\Setup_Help.url" "InternetShortcut" "URL" "${WIKI_LINK}"
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\README.lnk" "$INSTDIR\docs\ReadMe.html"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\OGRE Manual.lnk" "$INSTDIR\docs\manual\index.html"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\OGRE API Reference.lnk" "$INSTDIR\docs\api\OgreAPIReference.chm"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\OGRE Website.lnk" "$INSTDIR\OgreWebSite.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Setup Help.lnk" "$INSTDIR\Setup_Help.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  
  ; Register OGRE_HOME
  Push "OGRE_HOME"
  Push $INSTDIR
  Call WriteEnvStr

SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  RMDir /r "$INSTDIR\bin"
  RMDir /r "$INSTDIR\docs"
  RMDir /r "$INSTDIR\include"
  RMDir /r "$INSTDIR\lib"
  RMDir /r "$INSTDIR\media"
  RMDir /r "$INSTDIR\samples"
  Delete "$INSTDIR\OgreWebSite.url"
  Delete "$INSTDIR\Setup_Help.url"
  Delete "$INSTDIR\uninst.exe"

  ; this only works if directory is empty
  RMDir "$INSTDIR"
  
  RMDir /r "$SMPROGRAMS\$ICONS_GROUP"
  
  Push "OGRE_HOME"
  Call un.DeleteEnvStr

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd
