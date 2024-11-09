#NoEnv
#Persistent
#NoTrayIcon
#SingleInstance IGNORE

if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

SetBatchLines -1
StringCaseSense, On
Gui, +OwnDialogs
Gui, Color, cF0F0F0

theBB := "4.0"
newBB := "Official version, update when available."

Gui, Add, Text, cADADAD x5 y5, Version: %theBB%
Gui, Add, Text, cRed x20 y20, Press F1 or the button below to confirm input
Gui, Add, CheckBox, cGreen vSFZD gToggleAlwaysOnTop x200 y5, Always On Top
Gui, Add, Text, c0080FF x15 y40 w500, Enter Content:
Gui, Add, Edit, vInputBox x4 y55 w240 h90
Gui, Add, Text, c0080FF x15 y155 w500, Message Mode:
Gui, Add, DropDownList, AltSubmit x75 y151 w100 vMessageMode Choose1, Team Mode|All Teams
Gui, Add, Button, x35 y190 gConfirm, Confirm Input
Gui, Show, w250 h250, R6S Input Tool v%theBB%

WinGet, theA,, A
return

ToggleAlwaysOnTop:
GuiControlGet, SFZD
If (SFZD = 1)
{
    WinSet AlwaysOnTop, On, ahk_id %TheA%
}
else
{
    WinSet AlwaysOnTop, Off, ahk_id %TheA%
}
return

$^F1::
gosub, ProcessInput
Gui, Submit, NoHide
GuiControlGet, MessageMode
if (MessageMode = 2) {
    Send {T Down}
    Send {T Up}
} else {
    Send {Y Down}
    Send {Y Up}
}
sleep, 10
SendInput {Q}{Q}:{9}{7}{0}{6}{1}{0}{7}{2}{2}
Send {Enter Down}
Send {Enter Up}
return

ProcessInput:
WinRestore, Rainbow Six
ControlFocus,, Rainbow Six
return

SpaceReplace:
if (newText = "") {
    Send {Enter Down}
    Send {Enter Up}
    Exit
} else if (newText = "'") {
    Send {Space Down}
    Send {Space Up}
} else {
    SendInput {%newText%}
}
return

Input64bit:
Gui, Submit, NoHide
StringReplace, theText, InputBox, `n, , ALL
GuiControl,, InputBox, %theText%
StringReplace, theText, theText, %A_SPACE%, ', ALL
gosub, ProcessInput
Gui, Submit, NoHide
GuiControlGet, MessageMode
if (MessageMode = 2) {
    Send {T Down}
    Send {T Up}
} else {
    Send {Y Down}
    Send {Y Up}
}
sleep, 10

Loop, Parse, theText
{
    newText := A_LoopField
    gosub, SpaceReplace
    sleep, 10
}
Send {Enter Down}
Send {Enter Up}
return

Confirm:
gosub, Input64bit
return

$F1::
gosub, Input64bit
return

OnExit:
ExitApp
return

GuiClose:
ExitApp
return