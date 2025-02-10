# msfs2024-career-maintenance

<center>🚨🚁 THIS IS PROVIDED AS IS WITHOUT ANY WARRANTY OR GUARANTEE 🚁🚨

🚨🚁 THE AUTHOR IS NOT LIABLE FOR ANY DAMAGES OR LOSSES. 🚁🚨</center>

`msfs2024-career-maintenance` is my best attempt to ease the monotony of performing recurring maintenance on a company's fleet of aircraft in MSFS 2024 Career Mode.

## Prerequisites

This only works with MSFS 2024 (for obvious reasons). Also, [https://autohotkey.com/](https://autohotkey.com/) v2.0+ is required and must be installed and functional on your machine.

## How to use it?

<video src="https://github.com/TryTryAgain/msfs2024-career-maintenance/raw/refs/heads/main/media/example.mp4" controls></video>

🚀🪂🛸🚀🤩💖✨

### Download the script (using _one_ of the three methods below)

- Click into the [https://github.com/TryTryAgain/msfs2024-career-maintenance/blob/main/msfs2024-career-maintenance.ahk](https://github.com/TryTryAgain/msfs2024-career-maintenance/blob/main/msfs2024-career-maintenance.ahk) and click "Download raw file" to download only the script file alone.
- Download the entire project as a zip: Code -> Download ZIP -> Extract
- Clone the entire project with git/ssh in this example (HTTPS also available): `git clone git@github.com:TryTryAgain/msfs2024-career-maintenance.git`

### Prepare the game window

- Navigate into the company you'd like to maintain.
- Find your total number of aircraft for that company.
- Navigate back to the "Fleet" window.

### Open a PowerShell terminal window

I run mine from within vscode pwsh terminal most of the time or Windows Terminal pwsh (PowerShell 7+) and it's also working from Windows PowerShell (PowerShell 5).

Once you have a powershell terminal window open...

1) Navigate `cd` into the directory where the `msfs2024-career-maintenance.ahk` script lives.
2) Enter the following command, for example, if you have 5 aircraft in your company:

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "5"`

### Tab back over to the game window

Once you enter the Start-Process command above the script is now running (you can see via the AHK taskbar icon), although the script will not start doing anything really until the FlightSimulator2024.exe window is active. So after starting the script by issuing the command you need to then toggle back over to the game window where you've left your company Fleet.

Activate the game window by clicking somewhere along the top and then let go and don't touch anything until it's complete. Or if you need to intervene because of any issue (see [Known Issues/Limitations](#known-issueslimitations)).

## How does it work?

🤞📜📢🙌🥁🖳👏

The `msfs2024-career-maintenance.ahk` script is of course an AutoHotKey (AHK) script. It works by automating keyboard key presses and mouse clicks. Because everything needed to perform maintenance is just that, this is a great solution, although it has [its limitations (and potential bugs)](#known-issueslimitations)...

## Known Issues/Limitations

🚧🛑🧱🛠️⚙️🤖😬

Also keep an eye on this project's [Issues](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues) section for known issues and limitations and please add your own and request features, I'd love to hear from you.

### Issues

Currently, there is an issue where the initialization of the script, once the Microsoft Flight Simulator window becomes active and the script starts running for the initial plane maintenance it may occasionally go into the "Buy Aircraft" section instead of into the first plane's manage plane section.

If Maintenance is needed on the General section (because it doesn't have both a Details and Repair option) the script will currently loop infinitely; you will have to click to intervene and quickly click to repair yourself while the script is running or quit the script all together and go back to that particular plane manually to resolve it yourself before running the script again.

### Limitations

Currently, there's no way to do what I'd call "deep maintenance inspection analysis"... it is something I will look to add. What I mean by this is for those cases when even running all update check and delegated maintenance tasks the mechanic continues to show a now hazier maintenance color but there is nothing left with maintenance needed from the main screen for that plane. In this case you would typically go into each section's Details and check for individual items that are lower than a certain threshold (like less than half) and then only repair those. That's what I will look to do with an additional function for "deepMaintenanceInspectionAnalysis" that will attempt to do just that.

Currently, this script only works from within an individual company (ie: it must be run for each company you have individually). Eventually, I think it would be nice to make the script able to be run "for all companies" and that would also add the feature to check the company stats and automatically grab the number of aircraft for each company as well...something that's currently a manual task and needs to be supplied with the `Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "5"` method of running/starting the script. Eventually the script can always be ready, without a terminal, and instead initiated via some keyboard shortcut.
