init = ($) ->
  $('form').delegate('a.add_fields_link', 'click', (e) ->
    e.preventDefault()
    self = $(this)

    regex = new RegExp(self.data('index'), 'g')
    html = self.data('html').replace(regex, new Date().getTime())
    if self.data('insert-before')
      console.log $(self.data('insert-before'))
      $(self.data('insert-before')).before(html)
    else
      self.before(html)
  )


jQuery(($) ->
  $('document').on('page:change', -> init($))
  init($)
)
