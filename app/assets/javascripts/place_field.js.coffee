initializer = ->
  $('.place_field').each ->
    self = $(this)

    place_name_area = self.find('.place_name_field')
    place_fixed_area = self.find('.place_id_field')

    place_name_field = place_name_area.find('input')

    place_name_attr = place_name_field.attr('name')
    place_id_name = self.data('place-id-name')

    place_fixed_area.click ->
      place_fixed_area.hide()
      place_name_area.show().find('input').focus()
      place_name_field.attr('name', place_name_attr)

    place_name_field_val_on_focus = null
    place_name_field.focus ->
      place_fixed_area.find('input').removeAttr('name')
      place_name_field_val_on_focus = place_name_field.val()
    place_name_field.blur ->
      # when unchanged
      if place_name_field.val() == place_name_field_val_on_focus
        place_fixed_area.find('input').attr('name', place_id_name)

      place_name_field_val_on_focus = null

    place_name_field.bind('typeahead:selected', (e, selected)->
      place_fixed_area.text(selected.name).append(
        $("<input>").attr(
          name: place_id_name,
          type: 'hidden',
          value: selected.id
        )
      ).show()

      place_name_area.hide()

      place_name_field_val_on_focus = null
      place_name_field.removeAttr('name')
      place_name_field.val('')
    )
    

    suggest = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      limit: 15,
      prefetch: {
        url: '/places/candidates_for_expense',
        filter: (list) -> list.places
      },
      remote: {
        url: '/places/candidates_for_expense?name=%QUERY',
        filter: (list) -> list.places
      }
    )

    suggest.initialize()

    place_name_field.typeahead(
      {
        minLength: 1,
        hint: true,
        highlight: true,
      },
      {
        name: 'places',
        source: suggest.ttAdapter(),#substringMatcher(states),#
        displayKey: 'name',
      }
    )
jQuery ($) ->
  $(document).bind('page:change', -> initializer())
  initializer()
