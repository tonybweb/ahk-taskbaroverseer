class Builder {
  options := {
    canOversee:         (*) => true,
    color:              "00FF00",
    height:             5,
    hotkey:             false,
    hoverDelay:         400,
    mode:               TaskbarOverseer.MODE_WIN_11,
    mouseInterval:      100,
    recreateDelay:      100,
    transparent:        0,
  }

  canOverseeCallback(callback) {
    this.options.canOversee := callback
    return this
  }

  color(value) {
    this.options.color := value
    return this
  }

  /**
   * recommended values: 1-10ish, personal preference / resolution dependant
   * @param {Integer} value - the height of the taskbar overlay
   * @returns {Builder}
   */
  height(value) {
    this.options.height := value
    return this
  }

  hotkey(value) {
    this.options.hotkey := value
    return this
  }

  /**
   * @param {Integer} value - the amount of time in milliseconds before the taskbar will unhide
   * @returns {Builder}
   */
  hoverDelay(value) {
    this.options.hoverDelay := value
    return this
  }

  /**
   * capture current mouse position every x interval in milliseconds
   * the default is probably fine in most use cases (10 captures a second)
   * @param {Integer} value - default 100, lower values = slighty more responsive at the cost of more processing
   * @returns {Builder}
   */
  mouseInterval(value) {
    this.options.mouseInterval := value
    return this
  }

  transparent() {
    this.options.transparent := 1
    return this
  }

  /**
   * the amount of time in milliseconds after the taskbar
   * autohides before we recreate the taskbar overseer
   * @param {Integer} value - default 100
   * @returns {Builder}
   */
  recreateDelay(value) {
    this.options.recreateDelay := value
    return this
  }

  startAllBack() {
    this.options.mode := TaskbarOverseer.MODE_STARTALLBACK
    return this
  }

  run() {
    return TaskbarOverseer(this.options)
  }
}