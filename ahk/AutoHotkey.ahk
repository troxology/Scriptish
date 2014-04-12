/*
AutoHotkey.ahk

This is my default ahk script with my most common ahk macros
*/

; *** Config ***
#SingleInstance force

; *** Clipboard ***
$^+v::
ClipSaved := ClipboardAll ;save original clipboard contents
clipboard = %clipboard% ;remove formatting
Send ^v ;send the Ctrl+V command
;sleep 10
clipboard := ClipSaved ;restore the original clipboard contents
ClipSaved = ;clear the variable
Return

; *** Hotstrings ***
:*:]d::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, M/d/yyyy h:mm tt  ; It will look like 9/1/2005 3:53 PM
SendInput %CurrentDateTime%
return

; *** Capslock ***
; Highlighted Text to Upper Case
CapsLock & u::
clipboard =  ;
Send ^c
ClipWait
temp = %clipboard%
StringUpper clipboard, clipboard
Send ^v
return

; Highlighted Text to Lower Case
CapsLock & l::
clipboard =  ;
Send ^c
ClipWait
temp = %clipboard%
StringLower clipboard, clipboard
Send ^v
return

; Trim Highlighted Text
CapsLock & t::
clipboard =  ;
Send ^c
ClipWait
temp = %clipboard%
originalTrimSetting := %A_AutoTrim%
AutoTrim, On
clipboard = %clipboard%
Send ^v
AutoTrim, %originalTrimSetting%
return

; Banion User directory
CapsLock & b::
VarSetCapacity(User, 123)
Result := DllCall("Advapi32.dll\GetUserName", str, User)
Run, explore c:\Users\%User%
return

; Replace Text
CapsLock & h::
;Gui, Add, Text,, Please enter your name:
;Gui, Add, Edit, vName
;Gui, Show
return

;GuiEscape:
;GuiClose:
;Quitter:
;ExitApp