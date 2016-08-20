#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Sunquyman

 Script Function:
   Decrypts authlogins with user-provided master key, and logs into each Skype account

#ce ----------------------------------------------------------------------------



#include <constants.au3>
#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <GUIConstantsEx.au3>

; Declare settings
Global $isAutofilled
Global $isLoggingEnabled
Global $tabNum

Global $settingspath = "settings\settings.ini"

; Load settings from text
If FileExists($settingspath) Then
   $isAutofilled = StringToBool(IniRead($settingspath, "Settings", "isAutofilled", Default))
   $isLoggingEnabled = StringToBool(IniRead($settingspath, "Settings", "isLoggingEnabled", Default))
Else
   ; Otherwise, set to default
   $isAutofilled = true
   $isLoggingEnabled = false
EndIf

GUICreate("Initial Settings", 300, 200) ; Even top settings: 40, 80, 130
Local $autofillBox = GUICtrlCreateCheckbox("Skype Autofills Username Box?", 62, 40, 170, 20)
Local $loggingBox = GUICtrlCreateCheckbox("Enable Logging", 95, 75, 170, 20)
Local $executeButton = GUICtrlCreateButton("Execute MultiSkype!", 60, 120, 170, 35)

; Set GUI to settings
If $isAutofilled Then
   GUICtrlSetState($autofillBox, $GUI_CHECKED)
Else
   GUICtrlSetState($autofillBox, $GUI_UNCHECKED)
EndIf
If $isLoggingEnabled Then
   GUICtrlSetState($loggingBox, $GUI_CHECKED)
Else
   GUICtrlSetState($loggingBox, $GUI_UNCHECKED)
EndIf

; Show GUI
GUISetState(@SW_SHOW)

; Pause Execution until Button Pressed
While 1
   $idMsg = GUIGetMsg()
   If $idMsg = $executeButton Then
	  ExitLoop
   EndIf
WEnd

; Modify settings based on GUI
if GUICtrlRead($autofillBox) = $GUI_CHECKED Then
   $isAutofilled = True
Else
   $isAutofilled = False
EndIf
if GUICtrlRead($loggingBox) = $GUI_CHECKED Then
   $isLoggingEnabled = True
Else
   $isLoggingEnabled = False
EndIf

; Set tabNum by isAutofilled value
If $isAutofilled Then
  $tabNum = 6
Else
  $tabNum = 7
EndIf

; Save Settings to File
IniWrite($settingspath, "Settings", "isAutofilled", $isAutofilled)
IniWrite($settingspath, "Settings", "isLoggingEnabled", $isLoggingEnabled)

Local $masterkey = InputBox("MultiSkype", "Please enter the master key...")
SendAndLog("MASTER KEY: " & $masterkey)

; Run decryption .jar
Local $iPID = Run(@ComSpec & " /c " & "java -jar jar\MultiSkypeAuthDecryption.jar " & $masterkey, "", @SW_HIDE, $STDOUT_CHILD)
Local $output
; While loop waits until output is captured
While 1
   $output = StdoutRead($iPID)
   If $output <> "" Then
	  ExitLoop
   EndIf
   SendAndLog("Looping, waiting for output captured")
WEnd
SendAndLog("MASTER KEY VALIDATED? " & $output)


; Split string into accounts
Local $accounts = StringSplit($output, ";")

; Loop through accounts
For $i = 1 To $accounts[0] - 1
   ; Split accounts into data info
   Local $authLogins = StringSplit($accounts[$i], ",")
   ; Load authlogin info into variables
   Local $name = $authLogins[1]
   Local $username = $authLogins[2]
   Local $password = $authLogins[3]
   SendAndLog("NAME " & $name & " USERNAME: " & $username & " PASSWORD: " & $password)

   ; Check if first instance of Skype or not to determine how to open
   If $i == 0 Then
	  SendAndLog("Opening first Skype...")
	  OpenPrimarySkype(4000,1000)
	  SendAndLog("First Skype Opened!")
   Else
	  SendAndLog("Opening x Skype...")
	  OpenSecondarySkype(4000,1000)
	  SendAndLog("Skype x opened!")
   EndIf

   ; If not last instance of Skype, sleep for 10 seconds
   If $i <> $accounts[0] - 1 Then
	  ; MsgBox($MB_SYSTEMMODAL, "", "Sleeping... for 10 seconds")
	  SendAndLog("Sleeping for 10 seconds...")
	  Sleep(10000)
   EndIf
Next

MsgBox($MB_SYSTEMMODAL, "Success!", "Login successful!")

;-------------------
;Function defintions
;-------------------

Func OpenPrimarySkype($sleepDelay, $tabDelay)
   OpenSkype("skype.exe",$sleepDelay, $tabDelay)
EndFunc

Func OpenSecondarySkype($sleepDelay, $tabDelay)
   OpenSkype("skype.exe /secondary",$sleepDelay, $tabDelay)
EndFunc

Func OpenSkype($runString, $sleepDelay, $tabDelay)
   Run($runString)
   WinWaitActive("Skype")
   Sleep($sleepDelay)
   Local $var = 0
   While $var < $tabNum
	  Send("{TAB}")
	  Sleep($tabDelay)
	  $var += 1
   WEnd
   Send($username)
   Send("{TAB}")
   Send($password)
   Send("{TAB}")
   Send("{ENTER}")
EndFunc

; Borrowed logging function

Func SendAndLog($Data, $FileName = -1, $TimeStamp = True)
   If $isLoggingEnabled = true Then
    If $FileName == -1 Then $FileName = @ScriptDir & '\logs\mutliskypelog.txt'
    $hFile = FileOpen($FileName, 1)
    If $hFile <> -1 Then
        If $TimeStamp = True Then $Data = _Now() & ' - ' & $Data
        FileWriteLine($hFile, $Data)
        FileClose($hFile)
	 EndIf
   EndIf
EndFunc

Func StringToBool($str)
   Local $bool
   If $str = "True" Then
	  $bool = True
   Else
	  $bool = False
   EndIf
   Return $bool
EndFunc