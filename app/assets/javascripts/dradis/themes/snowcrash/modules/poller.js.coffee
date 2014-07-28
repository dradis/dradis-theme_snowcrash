# TODO: detect if note is open in the editor when receiving a updateNote,
# deleteNote event
@SmartPoller =
  after: 0
  node: 0
  url: undefined

  init: ->
    @after = $('#poller').data('after')
    @node = $('#poller').data('node')
    @url = $('#poller').data('url')

  setAfter: (new_after)->
    @after = new_after

  poll: ->
    self = this
    setTimeout (-> self.request()), 10000
    # setTimeout @request.bind(@), 10000

  request: ->
    params =
      after: @after
      node_id: @node

    $.get(@url, params)

  addNote: (node_id, sidebar, content) ->
    if @node == node_id
      $('#notes').append(sidebar)
      $('#note-viewer').append(content)
      $('#notes .placeholder').hide()

  updateNote: (node_id, note_id, sidebar, content) ->
    if @node == node_id
      $('#note_' + note_id + '_link').replaceWith(sidebar)
      $content = $('#note_' + note_id + '_content')
      active = $content.hasClass('in')
      $content.replaceWith(content)
      if active
        $('#note_' + note_id + '_link a').click()

  deleteNote: (node_id, note_id) ->
    if @node == node_id
      $('#note_' + note_id + '_link').remove()
      $content = $('#note_' + note_id + '_content')
      if $content.hasClass('in')
        source= $content.find('.editor-toggle').data('content')
        $('#note-viewer').prepend('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><p><strong>Warning</strong>. This note has been deleted by another user. The cached content is shown below:</p><pre>'+source+'</pre></div>')
      $content.remove()

      if ($('#notes .list-item').size() == 1)
        $('#notes .placeholder').slideDown(300)

  addNode: (node_id, label) ->
    console.log('addNode')
    # if top-level
    # if parent is shown

  updateNode: (node_id, content) ->
    $("#node_#{node_id}").replaceWith(content)

    # This would find all trees in the page (sidenav and modal), but then we've
    # got the problem in the modal where the click events are not properly bound,
    # so you don't get the .invalid-selection class or the @selectNode handler.
    # $("[data-node-id=#{node_id}]").replaceWith(content)
    #
    # For the time being, just invalidate the modal Move Node view:
    $('#modal_move_node .tree-modal-box').html('<div class="alert alert-notice">Somebody else made a change. Please refresh the page to load an updated list of nodes.</div>')

    if @node == node_id
      $('#node_' + node_id).addClass('active')

  deleteNode: (node_id) ->
    if @node == node_id
      $('#node_' + node_id + ' a').attr('href', '#')

      $('#note-viewer').prepend('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><p><strong>Warning</strong>. This whole node has been deleted by another user. If you navigate away or refresh your browser content will be lost.</div>')
    else
      # Adjust parent style / remove caret
      $node = $('#node_' + node_id)
      $parent = $node.parents('li').first()
      sibling_count = $parent.find('ul li').length
      $node.remove()
      if sibling_count == 1
        $parent.removeClass('hasSubmenu')
        $parent.find('.toggle').replaceWith('<span class="toggle">&nbsp;</span>')

  addEvidence: (node_id, sidebar, content) ->
    if @node == node_id
      $('#issues').append(sidebar)
      $('#note-viewer').append(content)
      $('#issues .placeholder').hide()

  updateEvidence: (node_id, evidence_id, sidebar, content) ->
    if @node == node_id
      $('#evidence_' + evidence_id + '_link').replaceWith(sidebar)
      $content = $('#evidence_' + evidence_id + '_content')
      active = $content.hasClass('in')
      $content.replaceWith(content)
      if active
        $('#evidence_' + evidence_id + '_link a').click()

  deleteEvidence: (node_id, evidence_id) ->
    if @node == node_id
      $link = $('#evidence_' + evidence_id + '_link')
      issue_title = $link.text().trim()
      $link.remove()
      $content = $('#evidence_' + evidence_id + '_content')
      if $content.hasClass('in')
        source= $content.find('.editor-toggle').data('content')
        $('#note-viewer').prepend('<div class="alert alert-error"><button type="button" class="close" data-dismiss="alert">&times;</button><p><strong>Warning</strong>. The evidence for "' + issue_title + '" has been deleted by another user. The cached content is shown below:</p><pre>'+source+'</pre></div>')
      $content.remove()

      if ($('#issues .list-item').size() == 1)
        $('#issues .placeholder').slideDown(300)


jQuery ->
  if $('#poller').length > 0
    SmartPoller.init()
    SmartPoller.poll()