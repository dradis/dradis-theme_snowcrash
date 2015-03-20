jQuery ->
  jQuery.ajaxSetup beforeSend: (xhr) ->
    xhr.setRequestHeader 'Accept', 'text/javascript'
    token = $('meta[name=\'csrf-token\']').attr('content')
    xhr.setRequestHeader 'X-CSRF-Token', token
    return
  $('tbody td.value input').on('blur', ->
    $(this).removeClass 'editing'
    return
  ).on('change', ->
    names = $(this).attr('name').split('_settings_')
    plugin_name = names[0]
    setting_name = names[1]
    post_path = $(this).parents('form').attr('action')
    full_post_path = post_path + '/' + plugin_name
    setting = {}
    setting[setting_name] = $(this).val()
    ajax_opts =
      context: $(this)
      data: setting: setting
      dataType: 'json'
      type: 'post'
      complete: ->
        $(this).removeClass 'saving'
        return
      error: (xhr, status, error) ->
        $(this).addClass 'failed'
        return
      success: (data, status, xhr) ->
        $(this).addClass 'saved'
        setting_status = if data['setting_is_default'] then 'default' else 'user set'
        $(this).parents('td').siblings('td.status').text setting_status
        return
    $.extend true, ajax_opts,
      data: '_method': 'put'
      url: full_post_path
    $(this).addClass 'saving'
    $.ajax ajax_opts
    return
  ).on 'keydown', (e) ->
    $(this).addClass('editing').removeClass 'saved', 'failed'
    return
