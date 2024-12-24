/************************************************************************
 * @description TaskbarOverseer, adds a configurable delay before showing
 * your auto hidden taskbar
 *
 * @author tonybweb
 * @date 2024/12/23
 * @version 1.0.0
 ***********************************************************************/

/**
 * TaskbarOverseer, adds a configurable delay before showing your auto hidden taskbar
 *
  * @param {Boolean} transparent - starts the taskbar overlay in transparent mode
  * @param {String} color - color for when not transparent
  * @param {String} hk - hotkey to use to toggle transparency
  * @param {String} mode - the method taskbar overseer will use for detecting the taskbar, 1 for Win11, 2 for StartAllBack
 */
class TaskbarOverseer
{
  HOVER_DELAY := 500 ;the amount of time in milliseconds before the taskbar will unhide
  HEIGHT := 7 ;the height of the taskbar overlay, valid values: 1-40
  MOUSE_INTERVAL := 100 ;the interval in milliseconds where we capture current mouse position, you can probably leave this alone
  RECREATE_DELAY := 750 ;the amount of time in milliseconds where we recreate the taskbar overseer once the taskbar autohides again

  MODE_WIN_11 := 1
  MODE_STARTALLBACK := 2

  canDestroy := 1
  color := ""
  mode := this.MODE_WIN_11
  transparent := 0

  __New(transparent := 1, color := "00FF00", hk := "", mode := this.MODE_WIN_11)
  {
    this.color := color
    this.transparent := transparent
    this.mode := mode

    CoordMode("Mouse", "Screen")

    this.createGui()
    SetTimer(() => this.watchMouse(), this.MOUSE_INTERVAL)

    if (hk) {
      this.hotkeys(hk)
    }
  }

  createGui()
  {
    this.canDestroy := 1
		this.gui := Gui("-DPIScale -Caption +E0x80000 +AlwaysOnTop +ToolWindow") ;E0x80000 layered window
    SetGuiTransparency()
    this.gui.BackColor := this.color
    this.gui.MarginX := 0
    this.gui.MarginY := 0

    this.gui.Show(
      "NoActivate"
      " x" 0
      " y" A_ScreenHeight - this.HEIGHT
      " w" A_ScreenWidth
      " h" this.HEIGHT
    )

    guiClickedCallback := this.destroyGui.Bind(this)
    this.gui.OnMessage(WM_LBUTTONDOWN, guiClickedCallback)

    SetGuiTransparency()
    {
      DllCall("SetLayeredWindowAttributes","Uptr",this.gui.hwnd,"Uint",0,"char",this.transparent ? 1 : 255,"uint",2)
    }
  }

  destroyGui(GuiCtrlObj := {}, wParam := "", lParam := "", msg := "") {
    if (this.gui) {
      this.gui.Destroy()
      this.gui := ""

      SetTimer(() => this.recreateWhenTaskbarHides(), this.RECREATE_DELAY)
    }
    return 0
  }

  hotkeys(hk)
  {
    Hotkey(hk, ToggleTransparency)

    ToggleTransparency(hk)
    {
      this.transparent := ! this.transparent
      this.canDestroy := 0
      this.destroyGui()
    }
  }

  recreateWhenTaskbarHides()
  {
    Switch(this.mode) {
      case this.MODE_WIN_11:
        taskbarHidden := DetectWin11Taskbar()
      case this.MODE_STARTALLBACK:
        taskbarHidden := DetectStartAllBackTaskbar()
    }

    if (taskbarHidden) {
      SetTimer(, 0)
      SetTimer(() => this.createGui(), -this.RECREATE_DELAY)
    }

    DetectWin11Taskbar()
    {
      taskbarHidden := 0
      if (WinExist("ahk_class Shell_TrayWnd")) {
        WinGetPos(, &taskbarY, , , "ahk_class Shell_TrayWnd")
        taskbarHidden := A_ScreenHeight - taskbarY <= this.HEIGHT
      }

      return taskbarHidden
    }

    DetectStartAllBackTaskbar()
    {
      return ! WinExist("ahk_class Shell_TrayWnd")
    }
  }

  watchMouse()
  {
    Try {
      MouseGetPos(, , &mouseOverAppHwnd)
    } catch as e {
      mouseOverAppHwnd := ""
    }

    if (this.canDestroy && mouseOverAppHwnd == this.gui?.Hwnd? ?? "") {
      this.canDestroy := 0
      guiHoveredCallback := this.destroyGui.Bind(this)
      SetTimer(guiHoveredCallback, -this.HOVER_DELAY)
    }
  }
}
