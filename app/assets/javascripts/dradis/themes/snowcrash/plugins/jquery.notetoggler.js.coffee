# jQuery.noteToggler
#
# This plugin is used in the Nodes#show view to toggle the main content area
# between the Note and Evidence content for the different items associated with
# this note. It does this by binding to the .view-toggle links and displaying
# or hiding the corresponding content from the data('target') attribute.

do ($ = jQuery, window, document) ->

  pluginName = "noteToggler"
  defaults =
    property: "value"

  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @$el = $(@element)
      @$el.on 'click', '.view-toggle', @viewToggle

    viewToggle: (e)=>
      e.preventDefault()
      $link = $(e.currentTarget)
      $target = $($link.data('target'))
      $listItem = $link.closest('.list-item')
      if $target and $target.not('.in')
        $active_content = @$el.find('.toggler-note-content.in')
        $active_content.removeClass 'in'
        $($active_content.data('link-id')).removeClass 'active'

        $target.addClass 'in'
        $target.data 'link-id', '#' + $listItem.attr('id')
        $listItem.addClass 'active'



  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
