  command: "/usr/bin/python3 ultralist.widget/main.py"

  refreshFrequency: 3000

  style: """
    left: 1em
    top: 0.5em
    font-family: Menlo
    font-size: 1em
  """

  render: (output) ->
    "<div>#{output}</div>"