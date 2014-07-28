# jQuery.templateEditor
#
# This plugin extracts the data-content value from the source link and puts it
# in the textarea of the editor.

do ($ = jQuery, window, document) ->

  pluginName = "templateEditor"
  defaults =
    property: "value"

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @$el = $(@element)
      @$el.on 'click', '.editor-toggle', @populateEditor

    populateEditor: (e)->
      $source= $(e.currentTarget)
      $target = $($source.data('target'))

      # Adjust title, URL and submit button text of the editor
      form_url = $source.data('url')
      if ((form_url.indexOf("notes/") != -1) | (form_url.indexOf("evidence/") != -1) | (form_url.indexOf("issues/") != -1))
        form_method = 'put'
      else
        form_method = 'post'

      $target.find('h3').text($source.data('title'))
      $target.find('form').attr('action', form_url)
      $target.find('form').attr('method', form_method)
      $target.find("[name='commit']").val($source.data('button'))
      $target.find(".cancel-link").unbind('click').on 'click', ->
        # hide the ditor no matter what
        $('#notes_editor, #issues_editor').removeClass('in')
        # if we've got a data-cancel in the source, use it
        if $source.data('cancel')
          $("#{$source.data('cancel')} a").click()

      # Reset any possible errors
      $target.find(".alert").remove()
      $target.find(".help-inline").remove()
      $target.find(".control-group.error").removeClass('error')

      # This isn't ideal as it's non-standard for notes/issues
      if $source.data('issue-id')
        $target.find('#evidence_issue_id').val($source.data('issue-id'))

      # Populate the editor
      $editor = $target.find('textarea')
      $editor.val($source.data('content'))

      # Populate category for notes
      # This isn't ideal as it's non-standard for notes/issues
      if $source.data('category-id')
        cat_id = $source.data('category-id')
        $target.find("option[value='#{cat_id}']").attr('selected', true)

      # Go back to Write mode
      $target.find('.btn-write').click()
      $editor.focus()


  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
