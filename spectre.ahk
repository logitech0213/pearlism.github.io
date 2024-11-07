#NoEnv
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High

Gui, +AlwaysOnTop
Width := 350
Gui, +LastFound
WinSet, Transparent, 255
Gui, Color, 000000
Gui, Margin, 0, 0

Gui, Font, s10 cFF00FF Bold
Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background000000 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG%
Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200 gGuiMove vCaption", Spectre Divide 419

Gui, Font, s8
Gui, Add, CheckBox, % "x7 y+10 w" (Width-14) "r1 +0x4000 vEnableCheckbox", Enable (f2)

Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1 +0x4000", Target Location
Gui, Add, Button, % "x7 y+5 w" (Width-200) "r1 +0x4000 gHeadshotsButton", Head
Gui, Add, Button, % "x+2+m w" (Width-200) "r1 +0x4000 gChestButton", Chest


Gui, Add, Text, % "x7 y+10 w" (Width-20) "r1 +0x4000", Smoothing (Default is 0.6)
Gui, Add, Text, % "x7 y+15 w" (Width-14) "r1 +0x4000 vSmoothingValue", %smoothing%
Gui, Add, Button, % "x7 y+5 w" (Width-200) "r1 +0x4000 gDecreaseSmoothing", -
Gui, Add, Button, % "x+2+m w" (Width-200) "r1 +0x4000 gIncreaseSmoothing", +

Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1 +0x4000 gClose", X
Gui, Add, Text, % "x7 y+15 w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y550"

EMCol := 0xFF33FF
ColVn := 50
ZeroX := A_ScreenWidth / 2
ZeroY := A_ScreenHeight / 2.07
CFovX := 65
CFovY := 65
ScanL := ZeroX - CFovX
ScanT := ZeroY - CFovY
ScanR := ZeroX + CFovX
ScanB := ZeroY + CFovY
SearchArea := 50

smoothing := 0.6

Loop
{
    GuiControlGet, EnableState,, EnableCheckbox
    if (EnableState) {
        targetFound := False
        if GetKeyState("RButton", "P") or GetKeyState("XButton2", "P") {
            PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea, targetY - SearchArea, targetX + SearchArea, targetY + SearchArea, EMCol, ColVn, Fast RGB
            if (!ErrorLevel) {
                targetX := AimPixelX+3
                targetY := AimPixelY-11
                targetFound := True
            } else {
                PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX+3
                    targetY := AimPixelY-11
                    targetFound := True
                }
            }
            if (targetFound) {
                AimX := targetX - ZeroX
                AimY := targetY - ZeroY
                DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
            }
        }
    }
    Sleep, 10
}


Paused := False
f2::
    GuiControlGet, EnableState,, EnableCheckbox
    GuiControl,, EnableCheckbox, % !EnableState
    toggle := EnableState
Return

HeadshotsButton:
    ZeroY := A_ScreenHeight / 2.10
    GuiControl,, ZeroYLabel, %ZeroY%
    Return

ChestButton:
    ZeroY := A_ScreenHeight / 2.27
    GuiControl,, ZeroYLabel, %ZeroY%
    Return

IncreaseSmoothing:
    smoothing += 0.05
    if (smoothing > 2)
        smoothing := 2
    GuiControl,, SmoothingValue, %smoothing%
    Return

DecreaseSmoothing:
    smoothing -= 0.05
    if (smoothing < 0.0)
        smoothing := 0.0
    GuiControl,, SmoothingValue, %smoothing%
    Return

GuiMove:
    PostMessage, 0xA1, 2
    return

Close:
ExitApp
f9::Reload
