#Requires AutoHotkey v2.1-a

/************************************************************************
 * @description TaskbarOverseer, adds a configurable delay before showing
 * your auto hidden taskbar
 *
 * @author tonybweb
 * @date 2025/04/25
 * @version 1.1.0
 ***********************************************************************/

class TaskbarOverseer
{
  #Include "subclasses\Builder.ahk"
  static canOverseeCallback(callback) => TaskbarOverseer.Builder().canOverseeCallback(callback)
  static color(value) => TaskbarOverseer.Builder().color(value)
  static height(value) => TaskbarOverseer.Builder().height(value)
  static hotkey(value) => TaskbarOverseer.Builder().hotkey(value)
  static hoverDelay(value) => TaskbarOverseer.Builder().hoverDelay(value)
  static mouseInterval(value) => TaskbarOverseer.Builder().mouseInterval(value)
  static transparent() => TaskbarOverseer.Builder().transparent()
  static recreateDelay(value) => TaskbarOverseer.Builder().recreateDelay(value)
  static startAllBack() => TaskbarOverseer.Builder().startAllBack()
  static run() => TaskbarOverseer.Builder().run()

  static MODE_WIN_11 := 1
  static MODE_STARTALLBACK := 2

  WS_DISABLED := 0x08000000, WS_EX_LAYERED := 0x00080000, WM_LBUTTONDOWN := 0x0201

  canDestroy := 1
  gui := ""
  options := {}

  __New(options) {
    CoordMode("Mouse", "Screen")
    this.options := options

    this.createGui()
    SetTimer(() => this.watcher(), this.options.mouseInterval)

    this.hotkeys()
  }

  createGui() {
    this.canDestroy := 1
		this.gui := Gui("-DPIScale -Caption +AlwaysOnTop +ToolWindow +E" (this.WS_EX_LAYERED | this.WS_DISABLED))
    SetGuiTransparency()
    this.gui.BackColor := this.options.color
    this.gui.MarginX := 0
    this.gui.MarginY := 0

    this.gui.Show(
      "NoActivate"
      " x" 0
      " y" A_ScreenHeight - this.options.height
      " w" A_ScreenWidth
      " h" this.options.height
    )

    guiClickedCallback := this.destroyGui.Bind(this)
    this.gui.OnMessage(this.WM_LBUTTONDOWN, guiClickedCallback)

    SetGuiTransparency() {
      DllCall("SetLayeredWindowAttributes","Uptr",this.gui.hwnd,"Uint",0,"char", this.options.transparent ? 1 : 255,"uint",2)
    }
  }

  destroyGui(GuiCtrlObj := {}, wParam := "", lParam := "", msg := "") {
    static callback := this.recreateWhenTaskbarHides.Bind(this)

    if (this.gui) {
      this.gui.Destroy()
      this.gui := ""

      SetTimer(callback, this.options.recreateDelay)
    }
    return 0
  }

  hotkeys() {
    if (this.options.hotkey) {
      Hotkey(this.options.hotkey, (*) => this.toggleTransparency())
    }
  }

  recreateWhenTaskbarHides() {
    if (this.options.canOversee()) {
      switch(this.options.mode) {
        case TaskbarOverseer.MODE_WIN_11:
          taskbarHidden := DetectWin11Taskbar()
        case TaskbarOverseer.MODE_STARTALLBACK:
          taskbarHidden := DetectStartAllBackTaskbar()
      }

      if (taskbarHidden) {
        SetTimer(, 0)
        SetTimer(() => this.createGui(), -this.options.recreateDelay)
      }
    }

    DetectWin11Taskbar() {
      taskbarHidden := 0
      if (WinExist("ahk_class Shell_TrayWnd")) {
        WinGetPos(, &taskbarY, , , "ahk_class Shell_TrayWnd")
        taskbarHidden := A_ScreenHeight - taskbarY <= this.options.height
      }

      return taskbarHidden
    }
    DetectStartAllBackTaskbar() {
      return ! WinExist("ahk_class Shell_TrayWnd")
    }
  }

  toggleTransparency() {
    this.options.transparent := ! this.options.transparent
    this.canDestroy := 0
    this.destroyGui()
  }

  watcher() {
    if (this.options.canOversee()) {
      try {
        MouseGetPos(, , &mouseOverAppHwnd)
      } catch as e {
        mouseOverAppHwnd := ""
      }

      if (this.canDestroy && this.gui != "" && mouseOverAppHwnd == (this.gui?.Hwnd? ?? "")) {
        this.canDestroy := 0
        guiHoveredCallback := this.destroyGui.Bind(this)
        SetTimer(guiHoveredCallback, -this.options.hoverDelay)
      }
    } else {
      this.destroyGui()
    }
  }
}
