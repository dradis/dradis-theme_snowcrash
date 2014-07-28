# jQuery.treeModal
#
# This plugin handles the node-selection modal tree (used for the Move node)
# operatio. See ./app/views/nodes/modals/

do ($ = jQuery, window, document) ->

  pluginName = "treeModal"
  defaults =
    selection: 0

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @$el = $(@element)
      @$tree = @$el.find('.tree-modal-box')

      @$el.find('.btn-primary').addClass('disabled')

      current_node_container = '#node_' + @$el.data('node-id')
      @$tree.find('a').each (i, element)=>
        $element = $(element)
        if $element.parents(current_node_container).length
          # when the element is a direct children of the current node, forbid
          # the move operation
          $element.attr('href', 'javascript:void(0)')
          $element.addClass('invalid-selection')
        else
          # if the element is not a direct children, allow
          $element.on 'click', @selectNode

    selectNode: (e)=>
      $target = $(e.currentTarget)
      if !$target.hasClass('toggle')
        e.preventDefault();

        @selection = $(e.target.parentNode).data('node-id')
        @$el.find('.active-selection').removeClass('active-selection')
        $target.addClass('active-selection')
        @$el.find('#node_parent_id').val(@selection)
        @$el.find('#current-selection').text($target.text())

        @$el.find('.btn-primary').removeClass('disabled')

  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
