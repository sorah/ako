module ApplicationHelper
  def add_fields_link(title, form, association, options = {})
    newobj = form.object.send(association).klass.new
    index = Time.now.to_i
    fields = form.fields_for(association, newobj, child_index: index) do |f|
      render("#{association.to_s.singularize}_fields", f: f)
    end

    link_to \
      title, '#',
      class: "add_fields_link #{options.delete(:class)}",
      data: { index: index, html: fields.gsub(/[\r\n]/, ''), }.merge(options)
  end
end
