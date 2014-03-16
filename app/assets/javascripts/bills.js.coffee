
initializer = ->
  expense_title_cache = {}
  get_title_of_expense = (id, callback) ->
    id = id.toString()
    return unless id.match(/^\d+$/)

    if expense_title_cache[id]
      title = expense_title_cache[id]
      console.log("cache hit: expenses/#{id} -> #{title}")
      return callback(expense_title_cache[id]) 

    $.getJSON "/expenses/#{id}.json", (response) ->
      if response.title
        console.log("response: expenses/#{id} -> #{response.title}")
        expense_title_cache[id] = response.title
        callback(response.title)

  $('.expense_field').each ->
    self = $(this)

    id_field = self.find('.expense_id_field')
    id_input = self.find('input')

    title_field = self.find('.expense_title_field')

    show_candidates = -> 42 # do nothing

    title_field.click ->
      title_field.hide()
      id_field.show()
      id_input.focus()

    (=>
      timeout = null
      id_field.keyup ->
        clearTimeout(timeout) if timeout
        timeout = setTimeout(show_candidates, 250)
    )()

    show_title = ->
      get_title_of_expense id_input.val(), (title) ->
        id_field.hide()
        title_field.text(title).show()

    id_input.blur -> show_title()

jQuery ($) ->
  $(document).bind('page:change', -> initializer())
  initializer()
