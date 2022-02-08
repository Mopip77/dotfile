command: "top -u -l 1"

refreshFrequency: 2000

style: """
  // Change bar height
  bar-height = 6px

  // Align contents left or right
  widget-align = left

  // Position this where you want
  top 338px
  left 10px

  // Statistics text settings
  color #fff
  font-family Helvetica Neue
  background rgba(#FFF, .1)
  padding 10px 10px 15px
  border-radius 5px

  .container
    width: 300px
    text-align: widget-align
    position: relative
    clear: both

  .widget-title
    text-align: widget-align

  .stats-container
    margin-bottom 5px
    border-collapse collapse

  td
    font-size: 14px
    font-weight: 300
    color: rgba(#fff, .9)
    text-shadow: 0 1px 0px rgba(#000, .7)
    text-align: widget-align

  .widget-title
    font-size 10px
    text-transform uppercase
    font-weight bold

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
    background: rgba(#fff, .5)
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
    background: rgba(#0bf, .5)

  .bar-sys
    background: rgba(#fc0, .5)

  .bar-user
    background: rgba(#c00, .5)
"""


render: -> """
  <div class="container">
    <div class="widget-title">CPU</div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="user"></span></td>
        <td class="stat"><span class="sys"></span></td>
        <td class="stat"><span class="idle"></span></td>
      </tr>
      <tr>
        <td class="label">user</td>
        <td class="label">sys</td>
        <td class="label">idle</td>
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
