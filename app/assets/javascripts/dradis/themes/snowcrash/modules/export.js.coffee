jQuery ->
  if $('body.export').length
    # Show the first tab
    $('#plugin-chooser li:first a').tab('show')
