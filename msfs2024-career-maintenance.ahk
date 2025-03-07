#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2)
CoordMode("Pixel", "Screen")
#Include %A_ScriptDir%\FindText.ahk ; from: https://www.autohotkey.com/boards/viewtopic.php?t=116471

^c::ExitApp ; Press "Ctrl+C" at any time to exit the script

; Written by Michael Lawler aka FractalSystems/TryTryAgain
; Version 1.4.7

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
navDelay := 150                 ; Default delay (in milliseconds) between navigation key presses.    | Going too fast can cause the game to miss inputs.
maintenanceDelay := 900         ; Default delay (in milliseconds) between individual key presses specific to performing maintenance. | Going too fast can cause the game to miss inputs.
crewDelay := 500                ; Default delay (in milliseconds) between crew toggle key presses. | Going too fast can cause the game to miss inputs.
cycleDelay := 1000              ; Default delay (in milliseconds) between complete aircraft cycles.  | Going too fast can cause the game to miss inputs.
toMaintainColor := 0xF57900     ; Default (new dark orange "To maintain") color to search for. | Use the AHK Window Spy tool to find the color of the needs maintenance button.
outOfOrderColor := 0xFA3636     ; Default (red "Out of order") color to search for. | Use the AHK Window Spy tool to find the color of the out of order button.
clickNextColor := 0xFFDE03      ; Default (yellow "Next") color to search for. | Use the AHK Window Spy tool to find the color of the next button.
extendedMaintColor := 0xAC731D  ; Default (green "Extended Delegated Maintenance") color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
extendedMaintColor2 := 0xBB872A ; Default "Extended Delegated Maintenance" color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
extendedMaintColor3 := 0xC38525 ; Default "Extended Tech + Delegated Maintenance" color to search for. | Use the AHK Window Spy tool to find the color of the extended maintenance button.
startFrom := 1                  ; Default start from the first plane.
endAt := numOfAircraft          ; Default end at the last plane.
crewToggle := "no_run"          ; Default crew toggle, only runs when -crewToggle Argument and valid value supplied. | Use '-crewToggle', 'On' or 'Off' to turn Crew On or Off for your fleet.
sellAircraft := false          ; Default sell aircraft, set to true to sell aircraft. | Use '-sellAircraft', 'true' to sell aircraft.
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
    if (arg = "-crewToggle" && A_Index < A_Args.Length)
        crewToggle := A_Args[A_Index + 1]
    if (arg = "-sellAircraft" && A_Index < A_Args.Length)
        sellAircraft := (A_Args[A_Index + 1] = "true" || A_Args[A_Index + 1] = "y")
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
            . "-crewToggle [On/Off or on/off] : Turn Crew On or Off.`n"
            . "-sellAircraft [true/false or y/n] : Enables or disables the Sell Aircraft step.`n"
        ExitApp
    }
}

; Start the timer
startTime := A_TickCount

; Initialize startFrom and endAt after parsing arguments
startFrom := startFrom ? startFrom : 1 ; Default value, if -startFrom is not provided
endAt := numOfAircraft ; Default value, if -endAt is not provided
; Still not sure why this is needed, but it is.
for i, arg in A_Args { ; otherwise it was taking the default even if the argument was provided
    if (arg = "-endAt" && i < A_Args.Length) {
        endAt := A_Args[i + 1] ; Set endAt to the value after "-endAt"
    }
}

; Convert crewToggle to lowercase for case-insensitive comparison
crewToggle := StrLower(crewToggle)

; If crewToggle is being used, ensure last plane is processed by adding some buffer
if (crewToggle = "on" || crewToggle = "off") {
    endAt := endAt + 2
    navDelay := navDelay + 100
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

firstLoop := true
for plane in Range(startFrom, endAt)
{
    if (!firstLoop) {
        plane--
    }
    
    if (sellAircraft) {
        if (!firstLoop) {
            planeLoop := startFrom - 1
        } else {
            planeLoop := startFrom
        }
        Sleep 300
        SelectPlane(planeLoop)
    } else {
        Sleep 300
        SelectPlane(plane)
    }

    if (crewToggle = "on" || crewToggle = "off") {
        ; Capture the screen again for each plane
        FindText().ScreenShot(WinX, WinY, WinX + WinWidth - 1, WinY + WinHeight - 1)
        Sleep crewDelay
        PerformCrewToggle()
        MainStart()
    } else {
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

        if (sellAircraft) {
            PerformSellAircraft()
        }

        PerformExitPlaneMaintenance()
    }

    firstLoop := false
}

; Calculate the elapsed time
elapsedTime := A_TickCount - startTime
hours := Floor(elapsedTime / 3600000)
minutes := Floor(Mod(elapsedTime, 3600000) / 60000)
seconds := Floor(Mod(elapsedTime, 60000) / 1000)
formattedTime := Format("{:02}:{:02}:{:02}", hours, minutes, seconds)

actualProcessed := endAt - startFrom + 1
if (crewToggle = "on" || crewToggle = "off") {
    endAt := endAt - 2
    actualProcessed := actualProcessed - 2
    MsgBox "The repair sequence for " . actualProcessed . " +- ~2 aircraft (from " . startFrom . " to " . endAt . ") out of " . numOfAircraft . " total aircraft in your company has completed.`nElapsed time: " . formattedTime
} else {
    MsgBox "The repair sequence for " . actualProcessed . " aircraft (from " . startFrom . " to " . endAt . ") out of " . numOfAircraft . " total aircraft in your company has completed.`nElapsed time: " . formattedTime
}
ExitApp

MainStart() {
    Sleep navDelay
    actions := ["{e}", "{q}"]
    for action in actions {
        Send action
        Sleep 500
    }
    Sleep crewDelay
}

SelectPlane(plane) {
    for i in Range(1, plane) {
        Send "{Right}"
        Sleep navDelay
    }
}

PerformManage() {
    Manage(2, maintenanceDelay)
}

PerformUpdate() {
    Update(2, maintenanceDelay)
}

Manage(times, delay) {
    for i in Range(1, times) {
        Send "{Space}"
        Sleep delay + 200
    }
}

Update(times, delay) {
    for i in Range(1, times) {
        Send "{Space}"
        Sleep delay
        if (i >= 3) {
            Sleep delay * 2.5 ; Increase the delay by 2.5x after the third loop
        }
        if (i = times) {
            Sleep delay
        }
    }
}

PerformDelegatedMaintenance() {
    Sleep 1500
    Send "{Right}"
    Sleep navDelay
    for i in Range(1, 2) {
        Send "{Space}"
        Sleep keyDelay
    }
}

PerformWashThePlane() {
    Sleep 1000
    Send "{Left}"
    Sleep navDelay
    Send "{Down}"
    Sleep navDelay
    for i in Range(1, 2) {
        Send "{Space}"
        Sleep keyDelay
    }
}

PerformSellAircraft() {
    Sleep 1000
    for i in Range(1, 2) {
        Send "{Left}"
        Sleep navDelay
    }
    for i in Range(1, 2) {
        Send "{Down}"
        Sleep navDelay
    }
    Send "{Space}"
    Sleep keyDelay
    for i in Range(1, 2) {
        Send "{Down}"
        Sleep keyDelay
    }
    Send "{Space}"
    Sleep keyDelay
}

PerformNeedsMaintenance() {
    Sleep 500
    while FindAndClickColor(outOfOrderColor, toMaintainColor, clickNextColor) {
        ; Perform actions based on the color found
        if (FoundColor = outOfOrderColor) {
            ; Handle out of order maintenance
            Send "{Down}"
            Sleep navDelay
            Send "{Down}"
            Sleep navDelay
            Send "{Space}"
            Sleep maintenanceDelay
            Send "{Space}"
            Sleep maintenanceDelay
        } else if (FoundColor = toMaintainColor) {
            ; Handle to maintain maintenance
            Send "{Down}"
            Sleep navDelay
            Send "{Down}"
            Sleep navDelay
            Send "{Space}"
            Sleep maintenanceDelay
            Send "{Space}"
            Sleep maintenanceDelay
        }
        Sleep 500
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
                Click OutX, OutY
                Sleep navDelay
                Click OutX, OutY
                Sleep 500
                ToolTip
            } else if (FoundColor = toMaintainColor) {
                ToolTip "Found 'To maintain' item at " OutX ", " OutY
                Click OutX, OutY
                Sleep navDelay
                Click OutX, OutY
                Sleep 500
                ToolTip
            }

            return true
        }
    }

    return false
}

PerformClickNext(OutX, OutY) {
    ToolTip "Found 'Next' button at " OutX ", " OutY
    Sleep maintenanceDelay
    ToolTip "Claiming insurance: " OutX ", " OutY
    Send "{Down}"
    Sleep navDelay
    Send "{Space}"
    Sleep maintenanceDelay
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
                Sleep navDelay
                Click OutX, OutY
                Sleep navDelay
                Send "{Up}"
                Sleep navDelay
                Send "{Down}"
                Sleep navDelay
                Send "{Up}"
                Sleep navDelay
                Send "{Space}"
                Sleep maintenanceDelay
                Send "{Space}"
                Sleep maintenanceDelay
                ToolTip
            } else if (FoundColor = extendedMaintColor || FoundColor = extendedMaintColor2 || FoundColor = extendedMaintColor3) {
                ToolTip "Found 'Extended Maintenance' item at " OutX ", " OutY "`nDeep maintenance analysis steps need to be added..."
                Sleep maintenanceDelay
                ToolTip
            }
            Sleep 500

            return true
        }
    }

    return false
}

PerformCrewToggle() {
    ; If wanting to turn crew on we look for the "Off" text pattern
    if (crewToggle = "on") {
        textPatterns := [
            "|<>*167$23.zzttkz330SCAMQwlstdXt00DlYaTXDAz6SMyAwlwttnlnnU7bbUTDC", ; English=Off (unselected left)
            "|<>*160$23.zzttkz330SCAMQwlstdXt00Dl00TXDAz6SMyAwlwttnlnnU7bbUTDC", ; English=Off (unselected right)
            "|<>*133$25.00331s7bVz3XVnlVVksmksBzyQ7zzA3a661n33UtVVkMkkwQMMDwAA3w6600004", ; English=Off (selected)
            "|<>*157$68.0zwzzzzzzlzk3yTzzzzyQTwMTzzzzzzbjz77kz7szVtzzlss70M3k84FkSA8lWAMU16Q7X7Azz6QNlW1sk31w1byQMUSA0s60Nzb797XDzkb6TtlkFllrC9lX6QQ40w0k60M3V7X0TUS1U70sFss", ; French=Désactivé (unselected left)
            "|<>*155$68.zzszzzzzzzzkTyTzzzzzszw1zDzzzzzCDzADzzzzzznrznXsTXwDkwzzwwQ3UA1s428sD64Ml6AE0XCHlXaTzXCAsl4wM1Uy0nzCAFD60Q30AznXYnlbzsHXDwssAksvb4slXCC30S0M30A1kXlkDkD0k3UQ8wTzzzzzzzzzzzU", ; French=Désactivé (unselected right)
            "|<>**50$67.z03000000C0Ls3U0000770+S0000003W0571s7Uw3lk02VlyDtz3xyvXEdzbCtnzzIlcIsn30tXa+Ro+Ttw3pk75Cu7DwTbus3WXR3a01n5A1lFibXUQNWbCscrTVzbwzHzDI+zUTVyTsz7i7E", ; French=Désactivé (selected)
            "|<>**50$23.sCk00MU0zzztzzznzCEXyQM0AtsTtnkznbVUbD3zCS02Qw04tt", ; German=Ein (unselected left)
            "|<>*156$23.04Ty08zwTvzszzwlz6E06AM0ANsDsnkTlbUzXD1z6S02Aw04Nt", ; German=Ein (unselected right)
            "|<>*135$23.zvU1zr03U407003C0tjztnbzna7k7ADUCMT0Qky0tVzxn3zva7", ; German=Ein (selected)
            "|<>*151$20.zzlk7xg0T773zlswASA17X600zU0S00T01znUTws7z01zk2", ; Norwegian=På (unselected left)
            "|<>2F3E5D-323232$20.zzkk3tA0T303tlssASA17X000zU0S00D01zVUTsM7y01zk2", ; Norwegian=På (unselected right)
            "|<>*126$20.00CDs2HzUssw0C73nVnysQtzz0TzVzzUzy0ATU37s0zy0Dy", ; Norwegian=På (selected)
        ]
    ; If wanting to turn crew off we look for the "On" text pattern
    } else if (crewToggle = "off") {
        textPatterns := [
            "|<>**50$20.zw0A3U2CTzbnznAm4nAMAHD34nknAw6nD9snn0QwsDD8", ; English=On (unselected left)
            "|<>*160$20.sTzw1zyADz7Xwlwm0z4MDlD3wHkT4w7nD9snm0QwkDD8", ; English=On (unselected right)
            "|<>*122$22.3k00Tk03bU0QC1VkNjb1rCM7MNURVb1q6Q6MNstVXz667sMM0008", ; English=On (selected)
            "|<>*157$70.wzzzszzty80bVzznXzzDtU2C7zzDTzzzCDwsDkwzzzlwszn0y10WCA3XXzgnl02AtX6S0SX7CAsl6CNs1uAQznX4M1bXzc1nzCCHU6SDy03DwssCTtszsSAMnXUsvbXzXwE72D7U6C0CDlUQ8wT0ws0nzzzzzzzznzz8", ; French=Activé(E) (unselected left)
            "|<>*148$71.zzzzzzzszDzDtzzzlzznwE1DVzznXzzDtU2D3zzbjzzzb7yS3wCDzzsTCDwM7k84FlUQQTwnD408na4Ns1t6CQNlWAQnk3mAQznX4M1bU7Y0tzb79k3D7z00nzCC3bySDy3lX6QQ77QwTwDl0A8wS0Ms0sTX0sFsy1tk1XzzzzzzzznzzDzzzzzzzznzwM", ; French=Activé(E) (unselected right)
            "|<>**50$69.000000070k0kQ000s01sCzz7U07700C3ZzMo00sU000MjtAkDDlQQS3509a3xyvXbssc1AkzzpANzb5y3b7CsdrCQkjkQtk75Cvza5y2zi0scqTwkc0zxk756lU65073bCscyC8sc0kCznp2Vzb5zC1nwSsQ7sMzt0000U004300A", ; French=Activé(E) (selected)
            "|<>**50$30.7s0006M000AAzxzAAzzzBabb1NabaQNabaTnnbbDk3bbVk3bbwbtbaQbtW6QaMkb1U", ; German=Aus (unselected left)
            "|<>*155$31.yTzzzy7zzzz3zzzzUzzwTUSSQ3nDDANlXbaTslnn1w0ttkA0Awz2D6ANlDl0AF7skb0k", ; German=Aus (unselected right)
            "|<>*126$31.1U0001s0000w0000T003UTVVXwAkknaCQMNU7CAAw3z66Dnzn30tktnaCkCznis7DMyE", ; German=Aus (selected)
            "|<>*155$21.yTzzVzzwDzzUzzs777AwtlXWCAQFk3mQ0C3XlkQz777ssw", ; Norwegian=Av (unselected left)
            "|<>*151$20.yTzz3zzkzzw7zy1lnaSQlXWAMsX0D9U1kMwQ6TXX7sss", ; Norwegian=Av (unselected right)
            "|<>**50$21.3k00S003k00n777MssnbjCQRlnXiTyRnzlgTyDbVtgs774", ; Norwegian=Av (selected)
        ]
    }

    ; Get window position and dimensions.
    WinGetPos &WinX, &WinY, &WinWidth, &WinHeight, "ahk_exe FlightSimulator2024.exe"

    ; Capture the screen using FindText()
    FindText().ScreenShot(WinX, WinY, WinX + WinWidth - 1, WinY + WinHeight - 1)

    X := 0 ; Initialize output variables
    Y := 0

    ; Search for the text pattern
    for textPattern in textPatterns {
        if (ok := FindText(&X, &Y, WinX, WinY, WinX + WinWidth, WinY + WinHeight, 0, 0, textPattern)) {
            MouseMove X, Y
            Sleep navDelay
            MouseClick "Left"
            Sleep crewDelay
            MouseMove X, Y - 60
            Sleep navDelay
            MouseClick "Left"
            Sleep crewDelay
            Send "{Down}"
            Sleep crewDelay
            Send "{Down}"
            Sleep crewDelay
            Send "{Down}"
            Sleep crewDelay
            Send "{Space}"
            return ; Exit the function if a match is found
        }
    }
    Sleep cycleDelay
}
