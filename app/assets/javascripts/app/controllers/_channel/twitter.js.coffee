class App.ChannelTwitter extends App.Controller
  constructor: ->
    super

    # render page
    @render()

  render: ->
    @html App.view('channel/twitter')(
      head: 'some header'
    )
