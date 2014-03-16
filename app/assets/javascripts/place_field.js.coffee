initializer = ->
  $('.place_field').each ->
    self = $(this)

    place_name_area = self.find('.place_name_field')
    place_fixed_area = self.find('.place_id_field')

    place_name_field = place_name_area.find('input')
    place_id_name = self.data('place-id-name')

    show_place_candidates = ->
      name = place_name_field.val()
      candidates = self.find('.place_name_candidates')

      if name.length == 0 || name.match(/^\s+$/)
        candidates.hide()
        return

      $.post '/places/candidates_for_expense', {name: name}, (html) ->
        candidates.html html
        candidates.find('li').click ->
          id = $(this).data('id')
          place_fixed_area.text($(this).text()).append(
            $("<input>").attr('name': place_id_name, 'type': 'hidden', 'value': id)
          ).show()
          place_name_area.hide()
          place_name_field.val('')
        candidates.show()

    place_name_field_timeout = null
    place_name_field.keyup ->
      clearTimeout(place_name_field_timeout) if place_name_field_timeout
      place_name_field_timeout = setTimeout(show_place_candidates, 250)

    place_name_field.focus -> self.find('.place_name_candidates').show()

    place_fixed_area.click ->
      $(this).find('input').remove()
      $(this).hide()
      place_name_area.show().find('input').focus()
jQuery ($) ->
  $(document).bind('page:change', -> initializer())
  initializer()
