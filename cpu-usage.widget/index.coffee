command: "top -u -l 1"
refreshFrequency: '1s'

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 7px
  right 160px

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#000, .5)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 600px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: widget-align
    font-size 10px
    text-transform uppercase
    font-weight bold

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 14px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  .label
    font-size 8px
    text-transform uppercase
    font-weight bold

  .bar-container
    width: 100%
    height: bar-height
    border-radius: bar-height
    float: widget-align
    clear: both
    background: rgba(#ccc, .5)
    position: absolute
    margin-bottom: 5px

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

  .bar-inactive
    background: rgba(#ccc, .5)

  .bar-sys
    background: rgba(#b5d93f, 1)

  .bar-user
    background: rgba(#df5077, 1)
"""


render: -> """
  <div class="container">
    <div class="widget-title">CPU</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="label">user</td><td class="stat"><span class="user"></span></td>
        <td class="label">sys</td><td class="stat"><span class="sys"></span></td>
        <td class="label">idle</td><td class="stat"><span class="idle"></span></td>
      </tr>
    </table>
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

  updateStat 'user', user
  updateStat 'sys', sys
  updateStat 'idle', idle
