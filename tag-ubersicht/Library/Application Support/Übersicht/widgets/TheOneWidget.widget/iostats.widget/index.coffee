disk = 'disk0'
delay = '5'  #seconds

command: "iostat -dw #{delay} -c 2  #{disk} | awk 'FNR>3' | awk '{printf \"%s,%s,%s\",$1,$2,$3}'"

refreshFrequency: delay*1000

style: """
    top: 717px
    left: 10px
    color: #fff
    font-family: Helvetica Neue

    table
      border-collapse: collapse
      table-layout: fixed

      &:after
        content: 'iostats'
        position: absolute
        left: 0
        top: -14px
        font-size: 10px

    td
      font-size: 12px
      font-weight: 100
      width: 130px
      max-width: 130px
      overflow: hidden
      text-shadow: 0 0 1px rgba(#000, 0.5)

    .value
      padding: 4px 6px 4px 6px
      position: relative

    .col1
      background: rgba(#fff, 0.1)
      border-radius 5px

    .col2
      background: rgba(#fff, 0.05)
      border-radius 5px
 
    .col3
      background: rgba(#fff, 0.025)
      border-radius 5px

    p
      padding: 0
      margin: 0
      font-size: 11px
      font-weight: normal
      max-width: 100%
      color: #ddd
      text-overflow: ellipsis
      text-shadow: none
"""

render: -> """
  <table>
    <tr>
      <td class='col1'></td>
      <td class='col2'></td>
      <td class='col3'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  values = output.split(',')
  table     = $(domEl).find('table')




  renderValue = (value, index, label) ->
    "<div class='value'>" +
      "#{value}" +
      "<p class=label> #{label}</p>" +
    "</div>"

  for value, i in values
    if i == 0
      label = 'KB/t'
    else if i == 1
      label = 'tps'
    else if i == 2
      label = 'MB/s'

    table.find(".col#{i+1}").html renderValue(value,i,label)
