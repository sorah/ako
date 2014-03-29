init = ($) ->
  $('.pickadate-target').each ->
    self = $(this)

    hidden_field = self.find('.hidden_field')
    date_input = self.find('.date-input').pickadate()
    hour_input = self.find('.hour-input')
    minute_input = self.find('.minute-input')

    date_picker = date_input.pickadate('picker')

    if !hidden_field.val()? || hidden_field.val() == ""
      initial_date = new Date()
      hidden_field.val initial_date.toISOString()
    else
      initial_date = new Date(hidden_field.val())

    date_picker.set('select', initial_date)

    hour_input.val(initial_date.getHours())
    minute_input.val(initial_date.getMinutes())

    get_time = =>
      {hour: hour_input.val(), mins: minute_input.val()}

    on_set = =>
      console.log('hi')
      date = date_picker.get('select').obj

      {hour, mins} = get_time()
      date.setHours(hour, mins)

      hidden_field.val date.toISOString()

    date_picker.on('set', on_set)
    hour_input.change(on_set)
    minute_input.change(on_set)

jQuery(($) ->
  $('document').on('page:change', -> init($))
  init($)
)
