# IssueImporter
#
# This object handles making server requests to search for issues, presenting
# the results and adding them to the library.

@IssueImporter =
  query: ($form) ->
    $('.results').show()
    $('.results .loading:first').parent().show()
    $('.results .placeholder:first').parent().hide()

    $.post $('.import-box:first').data('url'), $form.serialize()

    $('.results .list-item').each (idx,item) ->
      if ($(item).children('.loading').length > 0)
        $(item).show()
      else if ($(item).children('.placeholder').length > 0)
        $(item).hide()
      else
        $(item).remove()

  submit: (path, issue_text) ->
    $.post path, {issue:{text: issue_text}}
    $('.results .loading').parent().show()

  addIssue: (content) ->
    $('.results .loading').parent().hide()
    $('#issues .issue-list').prepend($(content))

  addResults: (results) ->
    $('.results .loading').parent().hide()
    if results.length > 0
      $('.results .issue-list').append( $(results) )
    else
      $('.results .placeholder:first').parent().show()



class IssueTable
  constructor: ->
    $('#issue-table').on('click', '.js-taglink', @tagSelected)
    # We're hooking into Rails UJS data-confirm behavior to only fire the Ajax
    # if the user confirmed the deletion
    $('#issue-table').on('confirm:complete', '#delete-selected', @deleteSelected)

  deleteSelected: (element, answer) ->
    if answer
      $('#tbl-issues').find('input[type=checkbox]:checked.js-multicheck').each ->
        $.ajax
          type: 'DELETE'
          url: $(this).data('url')
          # TODO: handle response success true/false
        $(this).parent().parent().remove()
        # TODO: show placeholder if no issues left

    # prevent Rails UJS from doing anything else.
    false


jQuery ->
  if ($('#issues').length > 0)
    $('input.search-query').on 'blur', ->
      if $(this).val().length > 0
        $(this).closest('.control-group').removeClass('error')
      else
        $(this).closest('.control-group').addClass('error')


    $('.results').on 'click', 'a.add-issue', (e) ->
      e.preventDefault()
      IssueImporter.submit $(this).attr('href'), $(this).data('text')
      $(this).parents('.accordion-group').slideUp 300, ->
        $(this).remove()


    # Checkbox behavior: select all, show 'btn-group', etc.
    $('#select-all').click ->
      $('input[type=checkbox]').not(this).prop('checked', $(this).prop('checked'))


    $('input[type=checkbox].js-multicheck').click ->
      _select_all = $(this).prop('checked')

      if _select_all
        $('input[type=checkbox].js-multicheck').each ->
          _select_all = $(this).prop('checked')
          _select_all

      $('#select-all').prop('checked', _select_all)

    $('input[type=checkbox]').click ->
      if $('input[type=checkbox]:checked').length
        $('.btn-group').css('visibility', 'visible')
      else
        $('.btn-group').css('visibility', 'hidden')


    new IssueTable