# Taskbar Overseer
Adds a configurable delay before showing your auto hidden taskbar.

## Motivation
I have an OLED monitor and I run with an auto hidden taskbar to help prevent screen burn-in. When interacting with UI elements near the bottom of an app, I've found the behavior where the taskbar shows itself instantly to be quite annoying.

## Features
- Supports Windows 11 (possibly others, haven't tested)
- Supports StartAllBack [[link](https://www.startallback.com/)]
- Transparent only mode
- Toggle between transparent mode and any color overlay you want with a configurable hotkey
- Callback support for temporarily disabling the overlay under almost any circumstance

Note: Requires AutoHotkey v2.1 alpha. It's probably not difficult to make it work with standard v2 but ¯\\\_(ツ)_/¯

## Examples
### Default Mode
Green Overlay
```
#Include <ahk-taskbaroverseer\TaskbarOverseer>

TaskbarOverseer.run()
```
### Transparent Mode
```
TaskbarOverseer.transparent().run()
```
### Red Overlay
```
TaskbarOverseer.color("FF0000").run()
```
### Togglable Color Mode
Toggle between transparent and red color mode with Ctrl + t
```
TaskbarOverseer
  .transparent()
  .color("FF0000")
  .hotkey("^t")
  .run()
```
### StartAllBack Mode
Uses the alternate taskbar detection method
```
TaskbarOverseer.startAllBack().run()
```
### Callback Example
Taskbar Overseer overlays basically every app and sometimes this can be undesireable (video players, games, etc.). You can use the callback functionality to disable the overlay where appropiate.

In the below example every 2 seconds we check if the active app is`YourGame.exe` if so we return false which disables Taskbar Overseer. It'll automatically renable itself again when the callback function returns true again.
```
lookForGameEveryInterval(*) {
  static  canOverseer := true,
          interval := 2000,
          lastTick := 0

  if (A_TickCount - lastTick > interval) {
    lastTick := A_TickCount

    canOverseer := true
    if (WinActive("ahk_exe YourGame.exe")) {
      canOverseer := false
    }
  }

  return canOverseer
}

TaskbarOverseer
  .transparent()
  .canOverseeCallback(lookForGameEveryInterval)
  .run()
```
## Available Options
Available fluent options (see subclasses\Builder.ahk)
```
  .canOverseeCallback(callback)
  .color(value)
  .height(value)
  .hotkey(value)
  .hoverDelay(value)
  .mouseInterval(value)
  .transparent()
  .recreateDelay(value)
  .startAllBack()
```