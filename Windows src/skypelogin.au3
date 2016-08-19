#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.2
 Author:         Sunquyman

 Script Function:
   Decrypts authlogins with user-provided master key, and logs into each Skype account

#ce ----------------------------------------------------------------------------



#include <constants.au3>
#include <MsgBoxConstants.au3>


Local $masterkey = InputBox("MultiSkype", "Please enter the master key...")

; Run decryption .jar
Local $iPID = Run(@ComSpec & " /c " & "java -jar jar\MultiSkypeAuthDecryption.jar " & $masterkey, "", @SW_HIDE, $STDOUT_CHILD)
Local $output
; While loop waits until output is captured
While 1
   $output = StdoutRead($iPID)
   If $output <> "" Then
	  ExitLoop
   EndIf
WEnd

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

   ; Check if first instance of Skype or not to determine how to open
   If $i == 0 Then
	  OpenPrimarySkype(4000,1000)
   Else
	  OpenSecondarySkype(4000,1000)
   EndIf

   ; If not last instance of Skype, sleep for 10 seconds
   If $i <> $accounts[0] - 1 Then
	  ; MsgBox($MB_SYSTEMMODAL, "", "Sleeping... for 10 seconds")
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
   While $var < 6
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