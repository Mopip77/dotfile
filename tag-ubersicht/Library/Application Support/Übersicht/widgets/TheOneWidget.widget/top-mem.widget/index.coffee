command: "ps axo \"rss,pid,ucomm\" | sort -nr | tail +1 | head -n3 | awk '{printf \"%8.0f MB,%s,%s\\n\", $1/1024, $3, $2}'"

refreshFrequency: 5000

style: """
  top: 607px
  left: 10px
  color: #fff
  font-family: Helvetica Neue

  table
    border-collapse: collapse
    table-layout: fixed

    &:before
      content: 'mem'
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

  .wrapper
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

  .pid
    position: absolute
    top: 2px
    right: 2px
    font-size: 10px
    font-weight: normal

"""


render: ->
  """
  <table>
    <tr>
      <td class='col1'></td>
      <td class='col2'></td>
      <td class='col3'></td>
    </tr>
  </table>
"""

update: (output, domEl) ->
  processes = output.split('\n')
  table     = $(domEl).find('table')

  renderProcess = (cpu, name, id) ->
    "<div class='wrapper'>" +
      "#{cpu}<p>#{name}</p>" +
      "<div class='pid'>#{id}</div>" +
    "</div>"

  for process, i in processes
    args = process.split(',')
    table.find(".col#{i+1}").html renderProcess(args...)

