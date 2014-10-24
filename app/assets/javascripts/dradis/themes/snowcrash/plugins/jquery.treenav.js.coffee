# jQuery.treeNav
#
# This plugin handles the showing/hiding beviour of the nodes in the tree
# along with the 'Add node' and 'add subnode' forms.

do ($ = jQuery, window, document) ->

  pluginName = "treeNav"
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
      # @$el.on 'click', '.add-subnode', @toggleForm
      @$el.on 'click', 'a.toggle', @toggleChildren

      # @$el.find('li').hover @showToggleForm, @hideToggleForm

      path  = window.location.pathname
      if(path.indexOf("/nodes") != -1)
        nodeId = path.substring(path.lastIndexOf('/') + 1)
        @openNode parseInt(nodeId)

    # showToggleForm: (e) =>
    #   e.stopPropagation();
    #   target = $(e.currentTarget)
    #   target.parents('li:first').find(' > .add-subnode:visible').hide()
    #   target.find('.add-subnode').first().show()
    #   target.find('input').focus()
    #
    # hideToggleForm: (e)=>
    #   e.stopPropagation();
    #   target = $(e.currentTarget)
    #   target.find('.add-subnode').first().hide()
    #   # target.parents('li:first').find(' > .add-subnode:hidden').show()


    openNode: (nodeId) =>
      node = @$el.find("li[data-node-id=#{nodeId}]")
      siblings = node.parent('ul.children')
      if siblings.length
        siblings.show().addClass('opened')
      parent = siblings.parent()
      parentNodeId = parent.data('node-id')
      parent.children('a.toggle').find('i').addClass('icon-caret-down').removeClass('icon-caret-right')

      @openNode(parentNodeId) if parentNodeId

    # toggleForm: (e)=>
    #   e.preventDefault()
    #   target = $(e.currentTarget)
    #   subnodeWrapper = target.siblings('.add-subnode-wrapper').first()
    #   subnodeWrapper.slideToggle(200).find('input').focus()
    #   @$el.find('.add-subnode-wrapper').not(subnodeWrapper).slideUp('fast')

    loadChildren: (target) =>
      if !target.siblings('.children').first().has('li.node').length
        $.get(target.attr 'href')
        .fail ->
          target.siblings('.children').find('li.loading').hide()
          target.siblings('.children').find('li.error').show()

    toggleChildren: (e) =>
      e.preventDefault()
      e.stopPropagation()
      target = $(e.currentTarget)
      children = target.siblings('.children').first()

      if children.hasClass('opened')
        children.slideUp(200)
      else
        that = this
        children.slideDown(200, -> that.loadChildren(target))

      children.toggleClass('opened')

      target.find('i')
      .toggleClass('icon-caret-right')
      .toggleClass('icon-caret-down')


  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
