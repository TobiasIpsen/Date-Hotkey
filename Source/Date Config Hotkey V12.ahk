;====================================================================

; Press a hotkey and get your chosen date configuration/format written
; Makes it easy to make folders for the current date etc.
; Written By Tobias Ipsen
; https://tobiasipsen.dk
; https://github.com/TobiasIpsen
; https://github.com/TobiasIpsen/Date-Hotkey

;====================================================================


RegExMatch(A_ScriptName, "^(.*?)\.", basename)    ; dont use splitpath to get basename because it cant handle DeltaRush.1.3.exe
WINTITLE := basename1 " " VERSION


#SingleInstance, force ; Determines whether a script is allowed to run again when it is already running. Force = Skips the dialog box and replaces the old instance automatically.
#NoENV ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts and increases performance).
#Persistent ; Keeps a script permanently running (that is, until the user closes it or ExitApp is encountered).
SetBatchLines -1    ; have the script run at maximum speed and never sleep



;============================================================
; 1. When this ahk program is compiled into an exe, fileinstall indicates which files should be embedded inside the exe.
; 2. When the program is run, fileinstall extracts the embedded file to the specified folder.
;============================================================

RegExMatch(A_ScriptName, "^(.*?)\.", basename)    ; dont use splitpath

if Not InStr(FileExist(A_AppData "\" basename1), "D")    ; create appdata folder if doesnt exist
    FileCreateDir , % A_AppData "\" basename1
    SetWorkingDir, % A_AppData "\" basename1
;============================================================

;============================================================
; Opens the Configure GUI (and closes it quickly again) to activate the hotkey
  ;============================================================
  Gosub, Configure
  Sleep, 1
  WinClose, Date Hotkey Configuration
;============================================================

/*
  ;============================================================
  ; Makes a folder called "Config" where the settings will be stores
  ;============================================================
  SetWorkingDir, %A_ScriptDir% ; Changes the script's current working directory.
  FileCreateDir, Config ; Creates a folder called Config
  SetWorkingDir, Config ; Changes the script's current working directory to the Config folder
  ;============================================================
*/

/*
  ChosenHotkey1:=%ChosenHotkey1%
  Hotkey, %ChosenHotkey1%, WriteDateFormatLabel1
  ChosenHotkey2:=%ChosenHotkey2%
  Hotkey, %ChosenHotkey2%, WriteDateFormatLabel2
  ChosenHotkey3:=%ChosenHotkey3%
  Hotkey, %ChosenHotkey3%, WriteDateFormatLabel3
*/

;============================================================
; Creates Hotkey settings if it doesn't exist
  ;============================================================
  IfNotExist, Hotkey Settings.ini
    {
      IniWrite, Ins, Hotkey Settings.ini, section, key1
      IniWrite, ^Ins, Hotkey Settings.ini, section, key2
      IniWrite, +Ins, Hotkey Settings.ini, section, key3
    }
;============================================================

;============================================================
; Update Hotkey On Off ;;;; Checks if a hotkey is on or off
  ;============================================================
  gosub, HotkeyOnOff1Update
  gosub, HotkeyOnOff2Update
  gosub, HotkeyOnOff3Update
;============================================================


;============================================================
; Reads/Gets the last mapped/choosen Hotkey, choosen Symbol and activates it. & Hotkey On Off Setting
  ;============================================================

  ; Hotkey 1
  IniRead, ChosenHotkey1, Hotkey Settings.ini, section, key1
  if ChosenHotkey1 != ERROR
  Hotkey, %ChosenHotkey1%, WriteDateFormatLabel1
  IniRead, HotkeyDropDown1, HotkeyDropDown Settings.ini, Section, HotkeyDropDown1
  IniRead, HotkeyOnOff1, HotkeyOnOff Settings.ini, section, HotkeyOnOff1

  ; Hotkey 2
  IniRead, ChosenHotkey2, Hotkey Settings.ini, section, key2
  if ChosenHotkey2 != ERROR
  Hotkey, %ChosenHotkey2%, WriteDateFormatLabel2
  IniRead, HotkeyDropDown2, HotkeyDropDown Settings.ini, Section, HotkeyDropDown1
  IniRead, HotkeyOnOff2, HotkeyOnOff Settings.ini, section, HotkeyOnOff2

  ; Hotkey 3
  IniRead, ChosenHotkey3, Hotkey Settings.ini, section, key3
  if ChosenHotkey3 != ERROR
  Hotkey, %ChosenHotkey3%, WriteDateFormatLabel3
  IniRead, HotkeyDropDown3, HotkeyDropDown Settings.ini, Section, HotkeyDropDown3
  IniRead, HotkeyOnOff3, HotkeyOnOff Settings.ini, section, HotkeyOnOff3
;============================================================


;============================================================
; Menu Setup ;;;Right Click On Taskbar/Tray Icon
  ;============================================================
  Menu, Tray, NoStandard
  Menu, Tray, Add, Configure, Configure
  Menu, Tray, Add, Change Hotkey, Change_HotkeyTray
  Menu, tray, Add, About..., About
  Menu, tray, Add, Exit, Exit
Return
;============================================================


;============================================================
; Tray Icon Setup ;Right Click on Icon Setup ;;;Exit & About
  ;============================================================
  Exit:
    ExitApp
  Return

  About:
  Gui, About: Destroy
  Gui, About: +ToolWindow +E0x40000
      Gui, About: Add, Link,, <a href="https://tobiasipsen.dk">Script Made by Tobias Ipsen</a>
      Gui, About: Add, Link,, <a href="https://github.com/TobiasIpsen">All My Script</a>
      Gui, About: Add, Link,, <a href="https://github.com/TobiasIpsen/Date-Hotkey">Guide/Download</a>
      Gui, About: Show, w200, About DateHotkey 0.0.4
  Return
;============================================================


;============================================================
; Change Hotkey Gui
;============================================================
Change_HotkeyTray:
Gui, ChangeHotkey: Destroy




;============================================================ 
; Build Change Hotkey GUI
;============================================================ 

;============================================================
; Change Hotkey 1
  ;============================================================
  Gui, ChangeHotkey: Add, Text, x10 y10, Hotkey On/Off:
  Gui, ChangeHotkey: Add, DropDownList, x+10 y7 vHotkeyOnOff1 gHotkeyOnOff1Update, On||Off

  Gui, ChangeHotkey: Add, Text, vHotkeyText1 x10 y+5, Choose new hotkey
  Gui, ChangeHotkey: Add, Button, x10 y+5 vChangeHotkeyNow1 gChangeHotkeyNow1, Change
  ;Gui, ChangeHotkey: Add, Hotkey, x10 y+5 vChosenHotkey1, %ChosenHotkey1%

  Gui, ChangeHotkey: Add, Text,ys x140 y33 vHotkeySymbol1, Symbol between the numbers
  Gui, ChangeHotkey: Add, DropDownList, x140 y50  vHotkeyDropDown1, -||.|_|/|{Blank}|{Space}
  Gui, ChangeHotkey: Add, Button, vSymbol_Help1 gSymbol_Help x265 y49, ?
  ;Symbol1:= "0-0|0.0|0_0|00|0 0|0/0"
;============================================================

;============================================================
; Change Hotkey 2
  ;============================================================
  Gui, ChangeHotkey: Add, Text, x10 y90, Hotkey On/Off:
  Gui, ChangeHotkey: Add, DropDownList, x+10 y87 vHotkeyOnOff2 gHotkeyOnOff2Update, On||Off

  Gui, ChangeHotkey: Add, Text, vHotkeyText2 x10 y+5, Choose new hotkey
  Gui, ChangeHotkey: Add, Button, x10 y+5 vChangeHotkeyNow2 gChangeHotkeyNow2, Change
  ;Gui, ChangeHotkey: Add, Hotkey, x10 y+5 vChosenHotkey1, %ChosenHotkey1%

  Gui, ChangeHotkey: Add, Text,ys x140 y113 vHotkeySymbol2, Symbol between the numbers
  Gui, ChangeHotkey: Add, DropDownList, x140 y130  vHotkeyDropDown2, -||.|_|/|{Blank}|{Space}
  Gui, ChangeHotkey: Add, Button, vSymbol_Help2 gSymbol_Help x265 y129, ?
  ;Symbol1:= "0-0|0.0|0_0|00|0 0|0/0"
;============================================================

;============================================================
; Change Hotkey 3
  ;============================================================
  Gui, ChangeHotkey: Add, Text, x10 y170, Hotkey On/Off:
  Gui, ChangeHotkey: Add, DropDownList, x+10 y166 vHotkeyOnOff3 gHotkeyOnOff3Update, On||Off

  Gui, ChangeHotkey: Add, Text, vHotkeyText3 x10 y+5, Choose new hotkey
  Gui, ChangeHotkey: Add, Button, x10 y+5 vChangeHotkeyNow3 gChangeHotkeyNow3, Change
  ;Gui, ChangeHotkey: Add, Hotkey, x10 y+5 vChosenHotkey1, %ChosenHotkey1%

  Gui, ChangeHotkey: Add, Text,ys x140 y193 vHotkeySymbol3, Symbol between the numbers
  Gui, ChangeHotkey: Add, DropDownList, x140 y210 vHotkeyDropDown3, -||.|_|/|{Blank}|{Space}
  Gui, ChangeHotkey: Add, Button, vSymbol_Help3 gSymbol_Help x265 y209, ?
  ;Symbol1:= "0-0|0.0|0_0|00|0 0|0/0"
;============================================================


;============================================================
; OK BUTTON & RESET BUTTON
  ;============================================================
  Gui, ChangeHotkey: Add, Button, x10 y250 gHotkeyButtonOK, OK
  Gui, ChangeHotkey: Add, Button, xs x+165 y250 gResetHotkeys, Reset Hotkeys
;============================================================


;============================================================
; Get The Last Saved DropDown Settings & Checkbox
  ;============================================================

  ; DropDown
  IniRead, HotkeyDropDown1, HotkeyDropDown Settings.ini, Section, HotkeyDropDown1
  GuiControl, ChangeHotkey: ChooseString, HotkeyDropDown1, %HotkeyDropDown1%

  IniRead, HotkeyDropDown2, HotkeyDropDown Settings.ini, Section, HotkeyDropDown2
  GuiControl, ChangeHotkey: ChooseString, HotkeyDropDown2, %HotkeyDropDown2%

  IniRead, HotkeyDropDown3, HotkeyDropDown Settings.ini, Section, HotkeyDropDown3
  GuiControl, ChangeHotkey: ChooseString, HotkeyDropDown3, %HotkeyDropDown3%


  ; Activate / Deactivate hotkey
  IniRead, HotkeyOnOff1, HotkeyOnOff Settings.ini, section, HotkeyOnOff1
  GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff1, %HotkeyOnOff1%

  IniRead, HotkeyOnOff2, HotkeyOnOff Settings.ini, section, HotkeyOnOff2
  GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff2, %HotkeyOnOff2%

  IniRead, HotkeyOnOff3, HotkeyOnOff Settings.ini, section, HotkeyOnOff3
  GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff3, %HotkeyOnOff3%
;============================================================


;============================================================
; Show The Change Hotkey GUI
  ;============================================================
  Gui, ChangeHotkey: Show,, Change Hotkey
  Gui, ChangeHotkey: +ToolWindow +E0x40000 ;+E0x40000 Is to keep the GUI in the taskbar. ToolWindows I to make the GUI header cleaner

  gosub, HotkeyOnOff1Update
  gosub, HotkeyOnOff2Update
  gosub, HotkeyOnOff3Update

  Return
;============================================================



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;============================================================
; Reset Hotkey Settings
  ;============================================================
  ResetHotkeys:
    FileDelete, Hotkey Settings.ini
    Reload
  Return
;============================================================

;============================================================
; Symbol Help Icon
  ;============================================================
  Symbol_Help:
    MsgBox, , Symbol Help, - = DAY-MONTH`n. = DAY.MONTH`n_ = DAY_MONTH`n/ = DAY/MONTH`n{Blank} = DAYMONTH`n{Space} = DAY MONTH
  Return
;============================================================

;============================================================
; OK Button Aciton For Changing The Hotkey
  ;============================================================
  HotkeyButtonOK:
    Gui, ChangeHotkey: Submit, NoHide
    If(ChosenHotkey1 == "")
    {
      MsgBox,, Error, Hotkey needs to be set
    }
    Else
    {
    ; Chosen Hotkey
    IniWrite, %ChosenHotkey1%, Hotkey Settings.ini, section, key1
    IniWrite, %ChosenHotkey2%, Hotkey Settings.ini, section, key2
    IniWrite, %ChosenHotkey3%, Hotkey Settings.ini, section, key3
    ; Hotkey Symbol DropDown Setting
    IniWrite, %HotkeyDropDown1%, HotkeyDropDown Settings.ini, section, HotkeyDropDown1
    IniWrite, %HotkeyDropDown2%, HotkeyDropDown Settings.ini, section, HotkeyDropDown2
    IniWrite, %HotkeyDropDown3%, HotkeyDropDown Settings.ini, section, HotkeyDropDown3
    ; Hotkey On Off Toggle
    IniWrite, %HotkeyOnOff1%, HotkeyOnOff Settings.ini, section, HotkeyOnOff1
    IniWrite, %HotkeyOnOff2%, HotkeyOnOff Settings.ini, section, HotkeyOnOff2
    IniWrite, %HotkeyOnOff3%, HotkeyOnOff Settings.ini, section, HotkeyOnOff3

    Sleep 250
    Gui, Destroy
    }
  Return
;============================================================

;============================================================
; This is Checking for if the DropDown Settings is On or Off. If it is Off, it grays out the settings.
  ;============================================================

  ;============================================================
  ; Hotkey On Off 1
    ;============================================================
    HotkeyOnOff1Update:
      Gui, ChangeHotkey: Submit, NoHide
      If(HotkeyOnOff1 == "On")
      {
        GuiControl, ChangeHotkey: Enable, HotkeyText1
        GuiControl, ChangeHotkey: Enable, ChangeHotkeyNow1
        GuiControl, ChangeHotkey: Enable, HotkeySymbol1
        GuiControl, ChangeHotkey: Enable, HotkeyDropDown1
        GuiControl, ChangeHotkey: Enable, Symbol_Help1
        Hotkey, %ChosenHotkey1%, On
    ;   MsgBox,, On
      }
      If(HotkeyOnOff1 == "Off")
      {
        If(ChosenHotkey1 == "")
        {
          Msgbox,, Error, Please Choose a Hotkey before turning off
          GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff1, On
        }
        Else
        {
        GuiControl, ChangeHotkey: Disable, HotkeyText1
        GuiControl, ChangeHotkey: Disable, ChangeHotkeyNow1
        GuiControl, ChangeHotkey: Disable, HotkeySymbol1
        GuiControl, ChangeHotkey: Disable, HotkeyDropDown1
        GuiControl, ChangeHotkey: Disable, Symbol_Help1
        Hotkey, %ChosenHotkey1%, Off
    ;   MsgBox,, Off
        }
      }
  Return

  ;============================================================
  ; Hotkey On Off 2
    ;============================================================
    HotkeyOnOff2Update:
      Gui, ChangeHotkey: Submit, NoHide
      If(HotkeyOnOff2 == "On")
      {
        GuiControl, ChangeHotkey: Enable, HotkeyText2
        GuiControl, ChangeHotkey: Enable, ChangeHotkeyNow2
        GuiControl, ChangeHotkey: Enable, HotkeySymbol2
        GuiControl, ChangeHotkey: Enable, HotkeyDropDown2
        GuiControl, ChangeHotkey: Enable, Symbol_Help2
        Hotkey, %ChosenHotkey2%, On
    ;   MsgBox,, On
      }
      If(HotkeyOnOff2 == "Off")
      {
        If(ChosenHotkey2 == "")
        {
          Msgbox,, Error, Please Choose a Hotkey before turning off
          GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff2, On
        }
        Else
        {
        GuiControl, ChangeHotkey: Disable, HotkeyText2
        GuiControl, ChangeHotkey: Disable, ChangeHotkeyNow2
        GuiControl, ChangeHotkey: Disable, HotkeySymbol2
        GuiControl, ChangeHotkey: Disable, HotkeyDropDown2
        GuiControl, ChangeHotkey: Disable, Symbol_Help2
        Hotkey, %ChosenHotkey2%, Off
    ;   MsgBox,, Off
        }
      }
  Return

  ;============================================================
  ; Hotkey On Off 3
    ;============================================================
    HotkeyOnOff3Update:
      Gui, ChangeHotkey: Submit, NoHide
      If(HotkeyOnOff3 == "On")
      {
        GuiControl, ChangeHotkey: Enable, HotkeyText3
        GuiControl, ChangeHotkey: Enable, ChangeHotkeyNow3
        GuiControl, ChangeHotkey: Enable, HotkeySymbol3
        GuiControl, ChangeHotkey: Enable, HotkeyDropDown3
        GuiControl, ChangeHotkey: Enable, Symbol_Help3
        Hotkey, %ChosenHotkey3%, On
    ;   MsgBox,, On
      }
      If(HotkeyOnOff3 == "Off")
      {
        If(ChosenHotkey3 == "")
        {
          Msgbox,, Error, Please Choose a Hotkey before turning off
          GuiControl, ChangeHotkey: ChooseString, HotkeyOnOff1, On
        }
        Else
        {
        GuiControl, ChangeHotkey: Disable, HotkeyText3
        GuiControl, ChangeHotkey: Disable, ChangeHotkeyNow3
        GuiControl, ChangeHotkey: Disable, HotkeySymbol3
        GuiControl, ChangeHotkey: Disable, HotkeyDropDown3
        GuiControl, ChangeHotkey: Disable, Symbol_Help3
        Hotkey, %ChosenHotkey3%, Off
    ;   MsgBox,, Off
        }
      }
  Return
;============================================================






;============================================================
; Build Change Hotkey GUI
  ;============================================================
  ChangeHotkeyNow1:
    IfWinExist, New Hotkey 1
      Gui, ChangeHotkeyNow1: Show,, New Hotkey 1
    Else
      Gui, ChangeHotkeyNow1: Add, Hotkey, x10 y+5 vChosenHotkey1, %ChosenHotkey1%
      Gui, ChangeHotkeyNow1: Add, Button, x10 y+5 gChangeHotkeyButtonOK1, Ok
      Gui, ChangeHotkeyNow1: Add, Button, x45 y31 gHotkeyButtonCancel1, Cancel
      Gui, ChangeHotkeyNow1: Show,, New Hotkey 1
      Gui, ChangeHotkeyNow1: +ToolWindow
    ;  Gui, ChangeHotkeyNow: -Caption
  Return

  ChangeHotkeyNow2:
    IfWinExist, New Hotkey 2
      Gui, ChangeHotkeyNow2: Show,, New Hotkey 2
    Else
      Gui, ChangeHotkeyNow2: Add, Hotkey, x10 y+5 vChosenHotkey2, %ChosenHotkey2%
      Gui, ChangeHotkeyNow2: Add, Button, x10 y+5 gChangeHotkeyButtonOK2, Ok
      Gui, ChangeHotkeyNow2: Add, Button, x45 y31 gHotkeyButtonCancel2, Cancel
      Gui, ChangeHotkeyNow2: Show,, New Hotkey 2
      Gui, ChangeHotkeyNow2: +ToolWindow
    ;  Gui, ChangeHotkeyNow: -Caption
  Return

  ChangeHotkeyNow3:
    IfWinExist, New Hotkey 3
      Gui, ChangeHotkeyNow3: Show,, New Hotkey 3
    Else
      Gui, ChangeHotkeyNow3: Add, Hotkey, x10 y+5 vChosenHotkey3, %ChosenHotkey3%
      Gui, ChangeHotkeyNow3: Add, Button, x10 y+5 gChangeHotkeyButtonOK3, Ok
      Gui, ChangeHotkeyNow3: Add, Button, x45 y31 gHotkeyButtonCancel3, Cancel
      Gui, ChangeHotkeyNow3: Show,, New Hotkey 3
      Gui, ChangeHotkeyNow3: +ToolWindow
    ;  Gui, ChangeHotkeyNow: -Caption
  Return
;============================================================

;============================================================
; OK & Cancel Button Functions
  ;============================================================
  HotkeyButtonCancel1:
      Gui, ChangeHotkeyNow1: Destroy
  Return

  HotkeyButtonCancel2:
      Gui, ChangeHotkeyNow2: Destroy
  Return

  HotkeyButtonCancel3:
      Gui, ChangeHotkeyNow3: Destroy
  Return

  ChangeHotkeyButtonOK1:
      GuiControlGet, New_Key1, ChangeHotkeyNow:, ChosenHotkey1
      If(New_Key1!=ChosenHotkey1)
      {
          Hotkey, %ChosenHotkey1%, WriteDateFormatLabel1, off
          ChosenHotkey1:=New_Key1
          Hotkey, %ChosenHotkey1%, WriteDateFormatLabel1, on
          IniWrite, %ChosenHotkey1%, Hotkey Settings.ini, section, key1
      }
      Gui, ChangeHotkeyNow: Destroy
  Return

  ChangeHotkeyButtonOK2:
      GuiControlGet, New_Key2, ChangeHotkeyNow:, ChosenHotkey2
      If(New_Key2!=ChosenHotkey2)
      {
          Hotkey, %ChosenHotkey2%, WriteDateFormatLabel2, off
          ChosenHotkey2:=New_Key2
          Hotkey, %ChosenHotkey2%, WriteDateFormatLabel2, on
          IniWrite, %ChosenHotkey2%, Hotkey Settings.ini, section, key2
      }
      Gui, ChangeHotkeyNow: Destroy
  Return

  ChangeHotkeyButtonOK3:
      GuiControlGet, New_Key3, ChangeHotkeyNow:, ChosenHotkey3
      If(New_Key3!=ChosenHotkey3)
      {
          Hotkey, %ChosenHotkey3%, WriteDateFormatLabel3, off
          ChosenHotkey3:=New_Key3
          Hotkey, %ChosenHotkey3%, WriteDateFormatLabel3, on
          IniWrite, %ChosenHotkey3%, Hotkey Settings.ini, section, key3
      }
      Gui, ChangeHotkeyNow: Destroy
  Return
;============================================================



;============================================================
; Build Configure GUI Layout
  ;============================================================
  Configure:
  Gui, Main: Destroy
  
  ;============================================================
  ; Day
    ;============================================================
    Gui, Main: Add, Text, x25 y+20, How should the day be displayed?
    Gui, Main: Add, DropDownList, x25 y+5 vDaySetup, d|dd||ddd|dddd
    Gui, Main: Add, Button, gDay_Help x150 y37, ?
  ;============================================================

  ;============================================================
  ; Month
    ;============================================================
    Gui, Main: Add, Text, x25 y+20, How should the Month be displayed?
    Gui, Main: Add, DropDownList, x25 y+5 vMonthSetup, M|MM||MMM|MMMM
    Gui, Main: Add, Button, gMonth_Help x150 y97, ?
  ;============================================================

  ;============================================================
  ; Year
    ;============================================================
    Gui, Main: Add, Text, x25 y+20, How should the Year be displayed?
    Gui, Main: Add, DropDownList, x25 y+5 vYearSetup, y|yy|yyyy||
    Gui, Main: Add, Button, gYear_Help x150 y157, ?
  ;============================================================

  ;============================================================
  ; Format
    ;============================================================
    Gui, Main: Add, Text, x25 y+20, How should the date be displayed?
    Gui, Main: Add, DropDownList, x25 y+5 vFormatSetup, yyyy-MM-dd||dd-MM-yyyy|MM-dd-yyyy
    Gui, Main: Add, Button, gFormat_Help x150 y217, ?
  ;============================================================

  ;============================================================
  ; Ok & Cancel Buttons
    ;============================================================
    Gui, Main: Add, Button, Section x25 y+20 gSubmitAll_Ok,&OK
    Gui, Main: Add, Button,ys gSubmitAll_Cancel,&Cancel
  ;============================================================


  ;============================================================
  ; FUNCTION. Get The Last Saved Configure Setting And Update ot
    ;============================================================
    IniRead, DaySetup, Date Settings.ini, Section, DaySetup
    GuiControl, Main: ChooseString, DaySetup, %DaySetup%

    IniRead, MonthSetup, Date Settings.ini, Section, MonthSetup
    GuiControl, Main: ChooseString, MonthSetup, %MonthSetup%

    IniRead, YearSetup, Date Settings.ini, Section, YearSetup
    GuiControl, Main: ChooseString, YearSetup, %YearSetup%

    IniRead, FormatSetup, Date Settings.ini, Section, FormatSetup
    GuiControl, Main: ChooseString, FormatSetup, %FormatSetup%

    Gui, Main: Submit, NoHide
  ;============================================================


  ; Show The Configure GUI
    ;============================================================
    ;  Gui, Main: +AlwaysOnTop
    Gui, Main: +ToolWindow +E0x40000 ;+E0x40000 Is to keep the GUI in the taskbar. ToolWindows I to make the GUI header cleaner
    Gui, Main: Show,, Date Hotkey Configuration
  Return
;============================================================
  


  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FUNCTIONS
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;============================================================
  ; Day Help Icon
    ;============================================================
    Day_Help:
    MsgBox, , Display Day Help, d = 1`ndd = 01`nddd = Mon`ndddd = Monday
    Return
  ;============================================================

  ;============================================================
  ; Month Help Icon
    ;============================================================
    Month_Help:
    MsgBox, , Display Month Help, M = 1`nMM = 01`nMMM = Jan`nMMMM = January
    Return
  ;============================================================

  ;============================================================
  ; Year Help Icon
    ;============================================================
    Year_Help:
    MsgBox, , Display Year Help, y = 1`nyy = 01`nyyyy = 2001
    Return
  ;============================================================

  ;============================================================
  ; Format Help Icon
    ;============================================================
    Format_Help:
    MsgBox, , Display Format Help, yyyy-MM-dd = 2001-01-30`ndd-MM-yyyy = 30-01-2001`nMM-dd-yyyy = 01-30-2002
    Return
  ;============================================================

  ;============================================================
  ; Ok Button & Cancel Button
    ;============================================================
    SubmitAll_OK:
      Gui, Main: Submit, NoHide
      IniWrite, %DaySetup%, Date Settings.ini, Section, DaySetup
      IniWrite, %MonthSetup%, Date Settings.ini, Section, MonthSetup
      IniWrite, %YearSetup%, Date Settings.ini, Section, YearSetup
      IniWrite, %FormatSetup%, Date Settings.ini, Section, FormatSetup
    
    MsgBox,, Settings Saved, Your Settings have been saved.`n`nThe app will close in 5 seconds., 5
      Gui, Main: Destroy
    Return

    SubmitAll_Cancel:
      Gui, Main: Destroy
    Return
;============================================================

;============================================================
; Write The Correct Format When Hotkey Is Pressed
  ;============================================================
  #IfWinActive, New Hotkey
  {
    Hotkey, %ChosenHotkey1%, Off
    Hotkey, %ChosenHotkey2%, Off
    Hotkey, %ChosenHotkey3%, Off
    Return
  }
  #IfWinNotActive, New Hotkey
  {
    Hotkey, %ChosenHotkey1%, On
    Hotkey, %ChosenHotkey2%, On
    Hotkey, %ChosenHotkey3%, On

  ;============================================================
  WriteDateFormatLabel1:
    ;============================================================
      If(FormatSetup == "yyyy-MM-dd")
      {
        Gui, Main: Submit, NoHide
        FormatTime, TimeString, , %YearSetup%%HotkeyDropDown1%%MonthSetup%%HotkeyDropDown1%%DaySetup%
        SendInput, %TimeString%
      Return
      }

      If(FormatSetup == "dd-MM-yyyy")
      {
        Gui, Main: Submit, NoHide
        FormatTime, TimeString, , %DaySetup%%HotkeyDropDown1%%MonthSetup%%HotkeyDropDown1%%YearSetup%
        SendInput, %TimeString%
      Return
      }

      If(FormatSetup == "MM-dd-yyyy")
      {
        Gui, Main: Submit, NoHide
        FormatTime, TimeString, , %MonthSetup%%HotkeyDropDown1%%DaySetup%%HotkeyDropDown1%%YearSetup%
        SendInput, %TimeString%
      Return
      }
    Return
    }
  ;============================================================

  ;============================================================
  WriteDateFormatLabel2:
    ;============================================================
    If(FormatSetup == "yyyy-MM-dd")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %YearSetup%%HotkeyDropDown2%%MonthSetup%%HotkeyDropDown2%%DaySetup%
      SendInput, %TimeString%
    Return
    }

    If(FormatSetup == "dd-MM-yyyy")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %DaySetup%%HotkeyDropDown2%%MonthSetup%%HotkeyDropDown2%%YearSetup%
      SendInput, %TimeString%
    Return
    }

    If(FormatSetup == "MM-dd-yyyy")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %MonthSetup%%HotkeyDropDown2%%DaySetup%%HotkeyDropDown2%%YearSetup%
      SendInput, %TimeString%
    Return
    }
  ;============================================================

  ;============================================================
  WriteDateFormatLabel3:
    ;============================================================
    If(FormatSetup == "yyyy-MM-dd")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %YearSetup%%HotkeyDropDown3%%MonthSetup%%HotkeyDropDown3%%DaySetup%
      SendInput, %TimeString%
    Return
    }

    If(FormatSetup == "dd-MM-yyyy")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %DaySetup%%HotkeyDropDown3%%MonthSetup%%HotkeyDropDown3%%YearSetup%
      SendInput, %TimeString%
    Return
    }

    If(FormatSetup == "MM-dd-yyyy")
    {
      Gui, Main: Submit, NoHide
      FormatTime, TimeString, , %MonthSetup%%HotkeyDropDown3%%DaySetup%%HotkeyDropDown3%%YearSetup%
      SendInput, %TimeString%
    Return
    }
  ;============================================================

;============================================================




/*
F4::
Gui, Main: Submit, NoHide
MsgBox, % FormatSetup
Return
*/