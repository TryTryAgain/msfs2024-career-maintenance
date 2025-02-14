#Requires AutoHotkey v2.0
#SingleInstance Force

^c::ExitApp ; Press "Ctrl+C" at any time to exit the script

; Written by Michael Lawler aka FractalSystems/TryTryAgain
; Version 1.2.3

; ----- CONFIGURATION ----------; These variables can be changed to suit your needs or dynamically set by supplying the proper -ArgumentList argument+value.
numOfAircraft := 5              ; Defaults to 5 planes if '-numOfAircraft', 'n' is not provided in the -ArgumentList.
delegatedMaintenance := false   ; Default for Delegated maintenance. | This is set to false by default, it is known to unnecessarily drain your money.
washThePlane := false           ; Default for washing the plane. | This is set to false by default, keep it dirty, save some money or provide '-washThePlane', 'y' if you want it cleaned.
needsMaintenance := true        ; Default for "To maintain". | This is set to true by default, if something needs maintenance you don't want to fly without fixing or it may end up costing you much more.
updateCheckUp := true           ; Default for Update check up. | This is set to true by default, you can toggle it off if desired.
extendedMaintenance := false    ; Default for Deep/Extended Maintenance. | This is set to false by default, enable it with '-extendedMaintenance', 'true' if needed.
; ------------------------------;
; ------------------------------; The variables below shouldn't have to change but there if you need/want to.
keyDelay := 300                 ; Default delay (in milliseconds) between individual key presses.    | Going too fast can cause the game to miss inputs.
maintenanceDelay := 900         ; Default delay (in milliseconds) between individual key presses specific to performing maintenance. | Going too fast can cause the game to miss inputs.
cycleDelay := 800               ; Default delay (in milliseconds) between complete aircraft cycles.  | Going too fast can cause the game to miss inputs.
toMaintainColor := 0xF59C00     ; Default (orange "To maintain") color to search for. | Use the AHK Window Spy tool to find the color of the needs maintenance button.
outOfOrderColor := 0xFA3636     ; Default (red "Out of order") color to search for. | Use the AHK Window Spy tool to find the color of the out of order button.
clickNextColor := 0xFFDE03      ; Default (yellow "Next") color to search for. | Use the AHK Window Spy tool to find the color of the next button.
extendedMaintColor := 0xAC731D  ; Default (green "Extended Delegated Maintenance") color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
extendedMaintColor2 := 0xBB872A ; Default "Extended Delegated Maintenance" color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
extendedMaintColor3 := 0xC38525 ; Default "Extended Tech + Delegated Maintenance" color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
startFrom := 1                  ; Default start from the first plane.
endAt := numOfAircraft          ; Default end at the last plane.
; ------------------------------;
; Parse named arguments
loop A_Args.Length
{
    arg := A_Args[A_Index]
    
    if (arg = "-numOfAircraft" && A_Index < A_Args.Length)
        numOfAircraft := A_Args[A_Index + 1]
    
    if (arg = "-keyDelay" && A_Index < A_Args.Length)
        keyDelay := A_Args[A_Index + 1]

    if (arg = "-maintenanceDelay" && A_Index < A_Args.Length)
        maintenanceDelay := A_Args[A_Index + 1]

    if (arg = "-cycleDelay" && A_Index < A_Args.Length)
        cycleDelay := A_Args[A_Index + 1]
    
    if (arg = "-delegatedMaintenance" && A_Index < A_Args.Length)
        delegatedMaintenance := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-washThePlane" && A_Index < A_Args.Length)
        washThePlane := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-needsMaintenance" && A_Index < A_Args.Length)
        needsMaintenance := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-startFrom" && A_Index < A_Args.Length)
        startFrom := A_Args[A_Index + 1]
    
    if (arg = "-endAt" && A_Index < A_Args.Length)
        endAt := A_Args[A_Index + 1]
    
    if (arg = "-extendedMaintenance" && A_Index < A_Args.Length)
        extendedMaintenance := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
    
    if (arg = "-help" || arg = "-Help") {
        MsgBox "Usage:`n"
            . "To get this help message:`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-Help'`n"
            . "Examples:`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5'`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5', '-delegatedMaintenance', 'true', '-washThePlane', 'y'`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '5', '-needsMaintenance', 'false'`n"
            . "Start-Process -FilePath 'msfs2024-career-maintenance.ahk' -ArgumentList '-numOfAircraft', '10', '-keyDelay', '500', '-cycleDelay', '1000'`n"
            . "`n"
            . "Options:`n"
            . "-numOfAircraft [number] : Sets the number of aircraft to process.`n"
            . "-keyDelay [ms] : Sets the delay between key presses.`n"
            . "-maintenanceDelay [ms] : Sets the delay between key presses specific to performing maintenance.`n"
            . "-cycleDelay [ms] : Sets the delay between full cycles.`n"
            . "-delegatedMaintenance [true/false or y/n] : Enables or disables the Delegated Maintenance steps.`n"
            . "-washThePlane [true/false or y/n] : Enables or disables the Wash The Plane steps.`n"
            . "-needsMaintenance [true/false or y/n] : Enables or disables the Needs Maintenance step.`n"
            . "-updateCheckUp [true/false or y/n] : Enables or disables the Update Check Up step.`n"
            . "-extendedMaintenance [true/false or y/n] : Enables or disables the Deep/Extended Maintenance step.`n"
            . "-startFrom [number] : Sets the starting aircraft.`n"
            . "-endAt [number] : Sets the ending aircraft.`n"
        ExitApp
    }
}

; Start the timer
startTime := A_TickCount

; Initialize startFrom and endAt after parsing arguments
startFrom := startFrom ? startFrom : 1 ; Default value, if -startFrom is not provided
endAt := numOfAircraft ; Default value, if -endAt is not provided

for i, arg in A_Args {
    if (arg = "-endAt" && i < A_Args.Length) {
        endAt := A_Args[i + 1] ; Set endAt to the value after "-endAt"
    }
}

WinWaitActive "ahk_exe FlightSimulator2024.exe"
WinGetPos &WinX, &WinY, &WinWidth, &WinHeight, "ahk_exe FlightSimulator2024.exe"

ToolTip "FlightSimulator2024.exe is active. Starting repair sequence..."
Sleep 2000
ToolTip

; Prevent the automation from entering "Buy aircraft" instead of properly selecting the first aircraft in the fleet.
CoordMode "Mouse", "Screen"
MouseMove A_ScreenWidth // 2, 10
MouseClick "Left"
actions := ["{e}", "{q}"]
for action in actions {
    Send action
    Sleep 500
}
actions := ["{Down 4}", "{Right 1}", "{Left 2}"]
for action in actions {
    Sleep 500 ; small delay between movements
    Send action
}

firstLoop := true
for plane in Range(startFrom, endAt)
{
    if !firstLoop
        plane--
    
    SelectPlane(plane)
    PerformManage()
    
    if (updateCheckUp) {
        PerformUpdate()
    }
    
    if (delegatedMaintenance) {
        PerformDelegatedMaintenance()
    }

    if (washThePlane) {
        PerformWashThePlane()
    }

    if (needsMaintenance) {
        PerformNeedsMaintenance()
    }

    if (extendedMaintenance) {
        PerformDeepMaintenance()
        PerformDeepMaintenance() ; Run it again as more could have been uncovered
    }

    PerformExitPlaneMaintenance()
    
    firstLoop := false
}

; Calculate the elapsed time
elapsedTime := A_TickCount - startTime
hours := Floor(elapsedTime / 3600000)
minutes := Floor(Mod(elapsedTime, 3600000) / 60000)
seconds := Floor(Mod(elapsedTime, 60000) / 1000)
formattedTime := Format("{:02}:{:02}:{:02}", hours, minutes, seconds)

actualProcessed := endAt - startFrom + 1
MsgBox "The repair sequence for " . actualProcessed . " aircraft (from " . startFrom . " to " . endAt . ") out of " . numOfAircraft . " total aircraft in your company has completed.`nElapsed time: " . formattedTime
ExitApp

SelectPlane(plane) {
    for i in Range(1, plane) {
        Send "{Right}"
        Sleep 500
    }
}

PerformManage() {
    Manage(2, maintenanceDelay)
}

; Ensure the mouse is placed somewhere reliably on the screen
MouseMove A_ScreenWidth // 2, 10
MouseClick "Left"

PerformUpdate() {
    Update(2, maintenanceDelay)
}

Manage(times, delay) {
    for i in Range(1, times) {
        Send "{Space}"
        Sleep delay
    }
}

Update(times, delay) {
    for i in Range(1, times) {
        Send "{Space}"
        Sleep delay
        if (i = times) {
            Sleep delay ; Add an additional delay between the loops
        }
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
    while FindAndClickColor(outOfOrderColor, toMaintainColor, clickNextColor) {
        ; Perform actions based on the color found
        if (FoundColor = outOfOrderColor) {
            ; Handle out of order maintenance
            Send "{Down}"
            Sleep keyDelay
            Send "{Down}"
            Sleep keyDelay
            Send "{Space}"
            Sleep maintenanceDelay
            Send "{Space}"
            Sleep maintenanceDelay
        } else if (FoundColor = toMaintainColor) {
            ; Handle to maintain maintenance
            Send "{Down}"
            Sleep keyDelay
            Send "{Down}"
            Sleep keyDelay
            Send "{Space}"
            Sleep maintenanceDelay
            Send "{Space}"
            Sleep maintenanceDelay
        }
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

FindAndClickColor(colors*) {
    CoordMode "Pixel", "Screen"
    CoordMode "Mouse", "Screen"

    ; Configuration for search area (percentages)
    ; Only tested on 1920x1080 resolution
    ; Used to ignore any of the search colors that may be in the top or left of the screen
    searchLeftPercent := 0.35  ; Start from 35% of the width from the left edge of the window
    searchTopPercent := 0.3   ; Start from 30% of the height from the top edge of the window
    searchRightPercent := 1.0 ; End at 100% of the width (right edge)
    searchBottomPercent := 1.0 ; End at 100% of the height (bottom edge)

    ; Calculate the search area coordinates
    searchLeft := WinX + (WinWidth * searchLeftPercent)
    searchTop := WinY + (WinHeight * searchTopPercent)
    searchRight := WinX + (WinWidth * searchRightPercent)
    searchBottom := WinY + (WinHeight * searchBottomPercent)

    attempts := 10
    OutX := 0
    OutY := 0
    global FoundColor := ""

    Loop attempts {
        for color in colors {
            if PixelSearch(&OutX, &OutY, searchLeft, searchTop, searchRight, searchBottom, color, 10) {
                FoundColor := color
                break
            }
        }

        if (FoundColor) {
            if (FoundColor = clickNextColor) {
                PerformClickNext(OutX, OutY)
            } else if (FoundColor = outOfOrderColor) {
                ToolTip "Found 'Out of order' item at " OutX ", " OutY
                Sleep 500
                Click OutX, OutY
                Sleep 500
                Click OutX, OutY
                ToolTip "Clicking: " OutX ", " OutY
                Sleep 500
                ToolTip
            } else if (FoundColor = toMaintainColor) {
                ToolTip "Found 'To maintain' item at " OutX ", " OutY
                Sleep 500
                Click OutX, OutY
                Sleep 500
                Click OutX, OutY
                ToolTip "Clicking: " OutX ", " OutY
                Sleep 500
                ToolTip
            }

            return true
        }
    }

    if (colors.Length = 1 && colors[1] = clickNextColor) {
        ToolTip "No 'Next' button found."
        Sleep 500
        ToolTip
    } else {
        ToolTip "No additional maintenance required."
        Sleep 500
        ToolTip
    }

    return false
}

PerformClickNext(OutX, OutY) {
    ToolTip "Found 'Next' button at " OutX ", " OutY
    Sleep 800
    ToolTip "Claiming insurance: " OutX ", " OutY
    Send "{Down}"
    Sleep 500
    Send "{Space}"
    Sleep 500
    ToolTip
}

PerformDeepMaintenance() {
    Sleep 1000
    ; Configuration for deep maintenance search area (percentages)
    searchLeftPercent := 0.1  ; Start from 10% of the width from the left edge of the window
    searchTopPercent := 0.3   ; Start from 30% of the height from the top edge of the window
    searchRightPercent := 0.3 ; End at 30% of the width (right edge)
    searchBottomPercent := 0.8 ; End at 80% of the height (bottom edge)

    ; Calculate the search area coordinates
    searchLeft := WinX + (WinWidth * searchLeftPercent)
    searchTop := WinY + (WinHeight * searchTopPercent)
    searchRight := WinX + (WinWidth * searchRightPercent)
    searchBottom := WinY + (WinHeight * searchBottomPercent)

    attempts := 10
    OutX := 0
    OutY := 0
    global FoundColor := ""

    Loop attempts {
        for color in [toMaintainColor, extendedMaintColor, extendedMaintColor2, extendedMaintColor3] {
            if PixelSearch(&OutX, &OutY, searchLeft, searchTop, searchRight, searchBottom, color, 10) {
                FoundColor := color
                break
            }
        }

        if (FoundColor) {
            if (FoundColor = toMaintainColor) {
                ToolTip "Found 'To maintain' for 'Delegated maintenance' item at " OutX ", " OutY
                Sleep 500
                Click OutX, OutY
                Sleep 500
                Send "{Up}"
                Sleep 500
                Send "{Down}"
                Sleep 500
                Send "{Up}"
                Sleep 500
                Send "{Space}"
                Sleep 500
                Send "{Space}"
                Sleep 500
                ToolTip
            } else if (FoundColor = extendedMaintColor || FoundColor = extendedMaintColor2 || FoundColor = extendedMaintColor3) {
                ToolTip "Found 'Extended Maintenance' item at " OutX ", " OutY "`nDeep maintenance analysis steps need to be added..."
                Sleep 800
                ToolTip
            }
            Sleep 500

            return true
        }
    }

    ToolTip "No additional deep maintenance required."
    Sleep 500
    ToolTip

    return false
}