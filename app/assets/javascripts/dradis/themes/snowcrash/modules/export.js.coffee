jQuery ->
  if $('body.export').length
    $('input[name=template]').on 'click', ->
    #   action = $('input[name=action]:checked').attr('value')
    #   new_href = 'javascript:alert("Please choose a plugin in Step 1")'
    #
    #   if action
    #     new_href = action + '?template=' + $(this).attr('value')
    #
    #   $('#export-button').attr('href', new_href)
    #
      # Update Export button
      $('#export-button').attr('disabled', null)

    # Show the first tab
    $('#plugin-chooser li:first a').tab('show')
