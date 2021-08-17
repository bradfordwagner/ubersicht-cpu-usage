command: "top -u -l 1"
refreshFrequency: '1s'

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  total-color = #c0c2c5
  user-color = rgba(#81A1C1, 1)
  system-color = rgba(#4C566A, 1)
  idle-color =  #b7bbc3

  // Position this where you want
  top 7px
  right 160px

  // Statistics text settings
  color var(--pecan-fg-pecanclock)
  font-family var(--pecan-font)
  font-size var(--pecan-font-size)
  background var(--pecan-bg-pecanclock)
  padding 2px 2px 4px
  border-radius 5px

  .cpu-user
    display: flex
    flex-direction: row
    padding: 0px 5px

  .container
    width: 275px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: widget-align
    text-transform uppercase
    font-weight bold

  .stats-container
    width 100%
    border-collapse collapse

  div
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  .stat
    padding: 0 15px 0 0
  .label
    padding: 0 15px 0 0
    font-weight bold

  .bar-container
    display: flex
    flex-wrap: nowrap
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#ccc, .5)

  .bar
    height: bar-height
    float: widget-align
    transition: width .2s ease-in-out

  .bar:first-child
    if widget-align == left
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .bar:last-child
    if widget-align == right
      border-radius: bar-height 0 0 bar-height
    else
      border-radius: 0 bar-height bar-height 0

  .total
    color: total-color
  .user
    color: user-color
  .sys
    color: system-color
  .bar-idle
    background: idle-color
  .bar-sys
    background: system-color
  .bar-user
    background: user-color
"""


render: -> """
  <div class="container">
    <div class="cpu-user">
      <table class="stats-container">
        <tr>
          <div class="label">cpu</div><div class="stat"><span class="total"></span></div>
          <div class="label">user</div><div class="stat"><span class="user"></span></div>
          <div class="label">sys</div><div class="stat"><span class="sys"></span></div>
        </tr>
      </table>
    </div>
    <div class="bar-container">
      <div class="bar bar-user"></div>
      <div class="bar bar-sys"></div>
      <div class="bar bar-idle"></div>
    </div>
  </div>
"""

update: (output, domEl) ->
  updateStat = (sel, usage) ->
    percent = usage + "%"
    $(domEl).find(".#{sel}").text usage
    $(domEl).find(".bar-#{sel}").css "width", percent

  lines = output.split "\n"

  userRegex = /(\d+\.\d+)%\suser/
  user = userRegex.exec(lines[3])[1]

  systemRegex = /(\d+\.\d+)%\ssys/
  sys = systemRegex.exec(lines[3])[1]

  idleRegex = /(\d+\.\d+)%\sidle/
  idle = idleRegex.exec(lines[3])[1]

  total = parseFloat(user) + parseFloat(sys)
  total = total.toFixed(2) # only 2 decimal places

  updateStat 'user', user
  updateStat 'sys', sys
  updateStat 'idle', idle
  updateStat 'total', total
