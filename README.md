# Taskbar Overseer
Adds a configurable delay before showing your auto hidden taskbar.

## Motivation
I have an OLED monitor and I run with an auto hidden taskbar to help prevent screen burn-in. When interacting with UI elements near the bottom of an app, I've found the behavior where the taskbar shows itself instantly to be quite annoying.

## Features
- Supports Windows 11 (possibly others, haven't tested)
- Supports StartAllBack [[link](https://www.startallback.com/)]
- Configurable height, minimum 1 pixel for hover detection
- Transparent only mode
- Toggle between transparent mode and any color overlay you want with a configurable hotkey

## Examples
### Default Mode
Transparent only
```
#Requires AutoHotkey v2.0
#Include <ahk-taskbaroverseer\taskbarOverseer>

TaskbarOverseer()
```
### Green Overlay
```
TaskbarOverseer(0)
```
### Red Overlay
```
TaskbarOverseer(0,"FF0000")
```
### Togglable Color Mode
Toggle between transparent and red color mode with Ctrl + t
```
TaskbarOverseer(1, "FF0000", "^t")
```
### StartAllBack Mode
Uses the alternate taskbar detection method
```
TaskbarOverseer(, , , 2)
```
## More Options
These values are configurable at the top of the class
```
  HOVER_DELAY := 500 ;the amount of time in milliseconds before the taskbar will unhide
  HEIGHT := 7 ;the height of the taskbar overlay, recommended values: 1-10ish, personal preference / resolution dependant
  MOUSE_INTERVAL := 100 ;the interval in milliseconds where we capture current mouse position, you can probably leave this alone
  RECREATE_DELAY := 750 ;the amount of time in milliseconds after the taskbar autohides before we recreate the taskbar overseer
```