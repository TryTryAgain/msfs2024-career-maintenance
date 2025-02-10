#Requires AutoHotkey v2.0
#SingleInstance Force

; ----- CONFIGURATION -----
numOfAircraft := 10               ; Defaults to 5 planes if '-numOfAircraft', 'n' is not provided in the -ArgumentList.
keyDelay := 750                   ; Default delay (in milliseconds) between individual key presses.    | Going too fast can cause the game to miss inputs.
cycleDelay := 1100                ; Default delay (in milliseconds) between complete aircraft cycles.  | Going too fast can cause the game to miss inputs.
searchColor := 0xF59C00           ; Default (orange needs maintenance) color to search for.            | Use the Window Spy tool to find the color of the needs maintenance button.
delegatedMaintenance := false     ; Default delegated maintenance.      | This is set to false by default, it is known to unnecessarily drain your money.
washThePlane := false             ; Default wash the plane.             | This is set to false by default, keep it dirty, save some money or provide '-washThePlane', 'y' if you want it cleaned.
needsMaintenance := true          ; Default needs maintenance.          | This is set to true by default, if something needs maintenance you don't want to fly without fixing or it may end up costing you much more.

; Parse named arguments
loop A_Args.Length
{
    arg := A_Args[A_Index]
    
    if (arg = "-numOfAircraft" && A_Index < A_Args.Length)
        numOfAircraft := A_Args[A_Index + 1]
    
    if (arg = "-keyDelay" && A_Index < A_Args.Length)
        keyDelay := A_Args[A_Index + 1]

    if (arg = "-cycleDelay" && A_Index < A_Args.Length)
        cycleDelay := A_Args[A_Index + 1]
    
    if (arg = "-delegatedMaintenance" && A_Index < A_Args.Length)
        delegatedMaintenance := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-washThePlane" && A_Index < A_Args.Length)
        washThePlane := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-needsMaintenance" && A_Index < A_Args.Length)
        needsMaintenance := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-help" || arg = "-Help") {
        MsgBox "Usage:`n" 
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5'`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5', '-manageAndUpdate', 'true', '-washThePlane', 'y'`n"
            . "Examples:`n"
            . "  Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '10', '-keyDelay', '500', '-cycleDelay', '1200'`n"
            . "  Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5', '-manageAndUpdate', 'true', '-washThePlane', 'y'`n"
            . "`n"
            . "Options:`n"
            . "  -numOfAircraft [number] : Sets the number of aircraft to process.`n"
            . "  -keyDelay [ms] : Sets the delay between key presses.`n"
            . "  -cycleDelay [ms] : Sets the delay between full cycles.`n"
            . "  -delegatedMaintenance [true/false or y/n] : Enables or disables the Delegated Maintenance steps.`n"
            . "  -washThePlane [true/false or y/n] : Enables or disables the Wash The Plane steps.`n"
            . "  -needsMaintenance [true/false or y/n] : Enables or disables the Needs Maintenance step.`n"
        ExitApp
    }
}

WinWaitActive "ahk_exe FlightSimulator2024.exe"
WinGetPos &WinX, &WinY, &WinWidth, &WinHeight, "ahk_exe FlightSimulator2024.exe"

ToolTip "FlightSimulator2024.exe is active. Starting repair sequence..."
Sleep 2000
ToolTip

CoordMode "Mouse", "Screen"
loop 4 ; Change 4 to the number of times you want to move the mouse
{
    MouseMove A_ScreenWidth - 1, A_ScreenHeight - 1
    Sleep 100 ; Optional: Add a small delay between movements
}
Send "{Left 4}" ; Get to the first plane (instead of occasionally clicking Buy Aircraft)

firstLoop := true
for plane in Range(1, numOfAircraft)
{
    if !firstLoop
        plane--
    
    PerformManageAndUpdate(plane)
    
    if (delegatedMaintenance)
        PerformDelegatedMaintenance()
    
    if (washThePlane)
        PerformWashThePlane()
    
    if (needsMaintenance)
        PerformNeedsMaintenance()

    PerformExitPlaneMaintenance()
    
    firstLoop := false
}

MsgBox "The repair sequence for " . numOfAircraft . " aircraft is complete."
ExitApp

PerformManageAndUpdate(plane) {
    for i in Range(1, plane) {
        Send "{Right}"
        Sleep keyDelay
    }
    for i in Range(1, 4) {
        Send "{Space}"
        Sleep keyDelay
    }
}

PerformDelegatedMaintenance() {
    Sleep 1500
    Send "{Right}"
    Sleep keyDelay
    for i in Range(1, 2) {
        Send "{Space}"
        Sleep keyDelay
    }
}

PerformWashThePlane() {
    Sleep 1000
    Send "{Left}"
    Sleep keyDelay
    Send "{Down}"
    Sleep keyDelay
    for i in Range(1, 2) {
        Send "{Space}"
        Sleep keyDelay
    }
}

PerformNeedsMaintenance() {
    Sleep 1000
    while FindAndClickColor(searchColor) {
        Send "{Down}"
        Sleep keyDelay
        Send "{Down}"
        Sleep keyDelay
        Send "{Space}"
        Sleep keyDelay
        Send "{Space}"
        Sleep keyDelay
        Sleep 1000
    }
}

PerformExitPlaneMaintenance() {
    Send "{Esc}"
    Sleep cycleDelay
}

Range(start, finish) {
    arr := []
    Loop finish - start + 1
        arr.Push(start + A_Index - 1)
    return arr
}

FindAndClickColor(color) {
    CoordMode "Pixel", "Screen"
    CoordMode "Mouse", "Screen"

    searchLeft   := WinWidth * 0.6
    searchTop    := WinHeight * 0.3
    searchRight  := WinWidth
    searchBottom := WinHeight

    attempts := 10
    OutX := 0
    OutY := 0

    Loop attempts {
        if PixelSearch(&OutX, &OutY, searchLeft, searchTop, searchRight, searchBottom, color, 10)
        {
            ToolTip "Found that maintenance is needed: " OutX ", " OutY
            Sleep 500

            Click OutX, OutY
            Sleep 500
            Click OutX, OutY
            ToolTip "Clicking: " OutX ", " OutY
            Sleep 500
            ToolTip

            return true
        }
        Sleep 100
    }

    ToolTip "No additional maintenance required."
    Sleep 1000
    ToolTip

    return false
}
