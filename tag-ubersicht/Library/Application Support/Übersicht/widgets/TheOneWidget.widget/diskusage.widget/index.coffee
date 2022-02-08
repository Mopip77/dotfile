command: "BLOCKSIZE=1000000 df -l"

refreshFrequency: 5000

# choose your main disk from df -l output
# disk on the first line = index 1
disk_index: 8

style: """
  // Change bar height
  bar-height = 6px
  // Align contents left or right
  widget-align = left
  // Opposite of align
  if (widget-align == left)
    widget-align-anti = right
  else
    widget-align-anti = left
  // Position this where you want
  top 263px
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
  .disk-name
    float: widget-align-anti
    font-weight bold
  .widget-name
    float: widget-align
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
  .bar-used
    background: rgba(#c00, .5)
  .bar-available
    background: rgba(#0bf, .0)
"""


render: -> """
  <div class="container">
    <div class="widget-title">
      <div class="widget-name">Disk</div>
      <div class="disk-name"></div>
    </div>
    <table class="stats-container" width="100%">
      <tr>
        <td class="stat"><span class="used"></span></td>
        <td class="stat"><span class="available"></span></td>
        <td class="stat"><span class="total"></span></td>
        <td class="stat"><span class="usage"></span></td>
      </tr>
      <tr>
        <td class="label">used</td>
        <td class="label">available</td>
        <td class="label">total</td>
        <td class="label">usage</td>
      </tr>
    </table>
    <div class="bar-container">
      <div class="bar bar-used"></div>
      <div class="bar bar-available"></div>
    </div>
  </div>
"""

update: (output, domEl) ->

  chooseColor = (percentage) ->
    if percentage > 90
      "rgba(204,0,0, .5)"
    else if percentage > 80
      "rgba(255,204,0, .5)"
    else
      "rgba(0,187,255, .5)"

  usageFormat = (mb) ->
    if mb > 1000
      gb = mb / 1000
      "#{parseFloat(gb.toFixed(2))}GB"
    else
      "#{parseFloat(mb.toFixed(2))}MB"

  updateStat = (sel, usedMbs, totalMbs) ->
    percent = (usedMbs / totalMbs * 100).toFixed(1)
    $(domEl).find(".#{sel}").text usageFormat(usedMbs)
    $(domEl).find(".bar-#{sel}").css "width", percent + "%"
    if sel == 'used'
      $(domEl).find(".bar-#{sel}").css "background-color", chooseColor(percent)
 
  updateCapacity = (cap) ->
    $(domEl).find(".usage").text cap

  lines = output.split "\n"
  mainDisk = lines[@disk_index].split(/\ +/)

  $(domEl).find(".disk-name").text mainDisk[0]

  diskName = mainDisk[0]
  totalMbs = mainDisk[1]
  usedMbs = mainDisk[2]
  availableMbs = mainDisk[3]
  capacityRatio = mainDisk[4]

  $(domEl).find(".total").text usageFormat(totalMbs)

  updateStat 'used', usedMbs, totalMbs
  updateStat 'available', availableMbs, totalMbs
  updateCapacity capacityRatio
