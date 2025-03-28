---

<div align="center">
🚨🚁 THIS IS PROVIDED AS IS WITHOUT ANY WARRANTY OR GUARANTEE 🚁🚨

🚨🚁 THE AUTHOR IS NOT LIABLE FOR ANY DAMAGES OR LOSSES. 🚁🚨
</div>

---

<div id="user-content-toc" align="center">
  <img src="media/msfs2024-career-maintenance.png" alt="MSFS 2024 Career Maintenance" width="80" align="center">
    <ul style="list-style: none;">
    <summary>
      <h1 align="center"><b>msfs2024-career-maintenance</b></h1>
    </summary>
  </ul>
</div>

`msfs2024-career-maintenance` is my best attempt to ease the monotony of performing recurring maintenance on a company's fleet of aircraft in MSFS 2024 Career Mode.

---

## Prerequisites

This only works with MSFS 2024 (for obvious reasons). Also, [https://autohotkey.com/](https://autohotkey.com/) v2.0+ is required and must be installed and functional on your machine.

## How to use it?

Most likely you will want flexibility and the ability to run it without editing the script itself; see [Command Examples](#command-examples) below. But if you have only one company with a mostly static number of aircraft in your fleet and/or you don't mind updating the script you can edit the `numOfAircraft` default setting under the `----- CONFIGURATION -----` section. This way you can start the script simply by double-clicking/opening it rather than initiating from a terminal.

### Basic video walkthrough

https://github.com/user-attachments/assets/8164e216-e3cc-462e-9335-0f4ad0bdc5b4

🚀🪂🛸🚀🤩💖✨

### Command Examples

#### Run with Defaults for N number of Aircraft in your Fleet

Where in this example you have 42 aircraft:

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42"`

#### Run for a Particular Range within your Fleet

Using `-startFrom` and/or `-endAt` you can control the range of aircraft to be maintained:

##### Skips the first 3 aircraft

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-startFrom", "4"` 

##### Skips the last 10 aircraft

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-endAt", "31"`

The same as simply doing:

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "32"`

##### Only specific range in between, skips the first 4 and the last 5 aircraft

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-startFrom", "5", "-endAt", "36"`

#### Wash your planes (default keeps them dirty)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-washThePlane", "y"` 

or 

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-washThePlane", "true"`

#### Perform the "Delegated maintenance" (defaults to false, saves some money)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-delegatedMaintenance", "y"`

#### Run without maintaining each category that's in a "To maintain" state

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-needsMaintenance", "n"`

or

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-needsMaintenance", "false"`

#### Perform Extended Maintenance (defaults to false)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-extendedMaintenance", "y"`

#### Toggle Crew "On" for an entire fleet (of 55 aircraft, in this example)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "55", "-crewToggle", "On"`

#### Toggle Crew "Off" for a specific range (+- ~2 aircraft, not perfect)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "55", "-crewToggle", "Off", "-startFrom", "5", "-endAt", "15"`

#### Sell aircraft (defaults to false)

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-sellAircraft", "y"`

#### Sell aircraft (defaults to false) via a specific range

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "42", "-sellAircraft", "y", "-startFrom", "5", "-endAt", "15"`

### Step-by-step

#### Download the script (using _one_ of the methods below)

- Download the script from Flightsim.to: [https://flightsim.to/file/88521/msfs2024-career-maintenance](https://flightsim.to/file/88521/msfs2024-career-maintenance)
- Download the source code from [Releases](https://github.com/TryTryAgain/msfs2024-career-maintenance/releases/)
- Click into the [https://github.com/TryTryAgain/msfs2024-career-maintenance/blob/main/msfs2024-career-maintenance.ahk](https://github.com/TryTryAgain/msfs2024-career-maintenance/blob/main/msfs2024-career-maintenance.ahk) and click "Download raw file" to download only the script file alone.
- Download the entire project as a zip: Code -> Download ZIP -> Extract
- Clone the entire project with git/ssh in this example (HTTPS also available): `git clone git@github.com:TryTryAgain/msfs2024-career-maintenance.git`

#### Prepare the game window

- Navigate into the company you'd like to maintain.
- Find your total number of aircraft for that company.
- Navigate back to the "Fleet" window.

#### Open a PowerShell terminal window

I run mine from within vscode pwsh terminal most of the time or Windows Terminal pwsh (PowerShell 7+) and it's also working from Windows PowerShell (PowerShell 5).

Once you have a powershell terminal window open...

1) Navigate `cd` into the directory where the `msfs2024-career-maintenance.ahk` script lives.
2) Enter the following command, for example, if you have 5 aircraft in your company:

`Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "5"`

#### Tab back over to the game window

Once you enter the Start-Process command above the script is now running (you can see via the AHK taskbar icon), although the script will not start doing anything really until the FlightSimulator2024.exe window is active. So after starting the script by issuing the command you need to then toggle back over to the game window where you've left your company Fleet.

Activate the game window by clicking somewhere along the top and then let go and don't touch anything until it's complete. Or if you need to intervene because of any issue (see [Known Issues/Limitations](#known-issueslimitations)).

## How does it work?

🤞📜📢🙌🥁🖳👏

The `msfs2024-career-maintenance.ahk` script is of course an AutoHotKey (AHK) script. It works by automating keyboard key presses and mouse clicks. Because everything needed to perform maintenance is just that, this is a great solution, although it has [its limitations (and potential bugs)](#known-issueslimitations)...

Defaults within the `----- CONFIGURATION -----` section have been set but can be changed, see [Command Examples](#command-examples) above and configuration details below.

- The "Update check up" is always required so no configuration item is exposed to set to false.
- Defaults to `numOfAircraft := 5` if `"-numOfAircraft", "n"` is not provided in the -ArgumentList.
- Default for "Delegated maintenance"/`delegatedMaintenance := false`. This is set to false by default, it is known to unnecessarily drain your money.
- Default for washing the plane `washThePlane := false`. This is set to false, but you can have it also wash your planes by supplying `"-washThePlane", "y"` or `"-washThePlane", "true"`.
- Default for Categories that are in a "To maintain"/orange state, `needsMaintenance := true`. This is set to true by default, if something needs maintenance you don't want to fly without fixing or it may end up costing you much more. If you're a risk taker or have some other use case you can set this to false with `needsMaintenance := n` or `needsMaintenance := false`.

## Known Issues/Limitations

🚧🛑🧱🛠️⚙️🤖😬

Also keep an eye on this project's [Issues](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues) section for other known issues and limitations as well as planned features and feature requests. Also, please report any issues and add your own feature requests, I'd love to hear from you.

### Issues

~~Currently, there is an issue where the initialization of the script, once the Microsoft Flight Simulator window becomes active and the script starts running for the initial plane maintenance it may occasionally go into the "Buy Aircraft" section instead of into the first plane's manage plane section.~~  ... this should now hopefully be solved once and for all with the [BUG - Occasionally it incorrectly selects "Buy aircraft" instead of the first aircraft in the fleet](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/2) resolution. 🤞 Please add comments to the issue if you continue to experience this bug or have any other suggestions.

If Maintenance is needed on the General section (because it doesn't have both a Details and Repair option) the script will currently loop infinitely; you will have to click to intervene and quickly click to repair yourself while the script is running or quit the script all together and go back to that particular plane manually to resolve it yourself before running the script again. See [BUG - Infinite loop when the "General" section is in a state of "To maintain"](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/3)

### Limitations

Currently, there's no way to do what I'd call "deep maintenance inspection analysis" or extended maintenance... it is something I will look to add. What I mean by this is for those cases when even running all update checks and delegated maintenance tasks the mechanic continues to show a now hazier maintenance color but there is nothing left with "To maintain" from the main screen for that plane. In this case you would typically go into each section's Details and check for individual items that are lower than a certain threshold (like less than half) and then only repair those. That's what I will look to do with an additional function for "deepMaintenanceInspectionAnalysis" that will attempt to do just that. See [FEATURE REQUEST - Add the ability to perform extended maintenance](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/5).

Currently, this script only works from within an individual company (ie: it must be run for each company you have individually). Eventually, I think it would be nice to make the script able to be run "for all companies" and that would also add the feature to check the company stats and automatically grab the number of aircraft for each company as well...something that's currently a manual task and needs to be supplied with the `Start-Process -FilePath "msfs2024-career-maintenance.ahk" -ArgumentList "-numOfAircraft", "5"` method of running/starting the script. Eventually the script can always be ready, without a terminal, and instead initiated via some keyboard shortcut. See [FEATURE REQUEST - Run for all companies](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/4).

This has only been tested by me (please report issues). I've only tested it on 1920x1080 resolution (and certain things are positional and pixel based...like where to search for colors on the screen). Also, as I add more specifics regarding advanced/extended maintenance or plane management English will always be primary only, all languages will not automatically be supported, as it will require searching for words (although I will share how it was accomplished and will consider what would be needed to support multiple languages) and will look to add other languages if there is interest. Please comment on [this issue](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/1) or open a new one to get support for your language added.

Under "Accessibility"->"User interface and font" game settings, only the "Default" "Main Color" color scheme is supported. Likewise, see [this issue](https://github.com/TryTryAgain/msfs2024-career-maintenance/issues/13) where it was reported you must disable HDR before running the script otherwise it will sell your aircraft.
