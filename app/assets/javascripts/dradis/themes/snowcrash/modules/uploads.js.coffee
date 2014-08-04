@SmartPoller =
  jobId: 0
  parsing: false

  # init: ->
  #   @$form = $('form')
  #   @after = $('#poller').data('after')
  #   @node = $('#poller').data('node')
  #   @url = $('#poller').data('url')

  updateConsole: ->
    return unless SmartPoller.parsing

    after = 0
    url = $('#new_upload').data('status-url')

    if $('.log').length
      after = $('#console p:last-child').data('id')

    $.get(
      url
      {item_id: SmartPoller.jobId, after: after},
      null,
      'script'
    )


jQuery ->
  if $('body.upload').length
    # Enable Ajax file uploads via 3rd party plugin
    $bar = $('.bar');
    $percent = $('.percent');
    $status = $('#status');
    $('form').ajaxForm({
      resetForm: true
      dataType: 'script'
      beforeSend: ->
          $status.empty();
          percentVal = '0%';
          $bar.width(percentVal)
          $percent.html(percentVal);
      uploadProgress: (event, position, total, percentComplete)->
          percentVal = percentComplete + '%';
          $bar.width(percentVal)
          $percent.html(percentVal);
      success: ->
          percentVal = '100%';
          $bar.width(percentVal)
          $percent.html(percentVal);
    });

    $(':file').change ->
      SmartPoller.jobId = SmartPoller.jobId + 1
      $('#console').empty()
      $('#filename').text(this.value)
      $('#spinner').show()
      $('#result').data('id',  SmartPoller.jobId)
      $('#result').show()
      $('#item_id').val(SmartPoller.jobId)

      # Can't use this, because Rails UJS doesn't kick in (missing CSRF)
      $(this).closest('form').submit()
      # $(this).closest('form').trigger('submit.rails');
