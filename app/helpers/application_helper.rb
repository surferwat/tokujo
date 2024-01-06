require "./lib/tailwind_form_builder.rb"

module ApplicationHelper
  # Defaults
  ActionView::Base.default_form_builder = TailwindFormBuilder



  # Helper method to generate form fields
  def form_fields(form,fields)
    fields.map do |field|
      render_string_label = capture do
        form.label field[1] if field[1].present?
      end

      render_string_desc = capture do 
        "<p class=\"text-slate-500\">#{field[0] == "select" ? field[6] : field[5] }</p>".html_safe
      end


      case field[0]
      when "text"
        render_string_input = capture do
          options = { placeholder: field[3] }
          options[:value] = field[4] if field[4].present?
          form.text_field field[2], options
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-3\">
            <div class=\"space-y-2\">
              #{render_string_label}
              #{render_string_desc}
            </div>
            <div>
              #{render_string_input}
            </div>
          </div>
        </div>"
      when "password"
        render_string_input = capture do
          form.password_field field[2], placeholder: field[3]
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-3\">
            <div class=\"space-y-2\">
              #{render_string_label}
              #{render_string_desc}
            </div>
            <div>
              #{render_string_input}
            </div>
          </div>
        </div>"
      when "select"
        render_string_input = capture do
          options = {}
          options[:include_blank] = "Please make selection" if field[5].blank?
          form.select field[2], options_for_select(field[4], selected: field[5]), options
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-3\">
            <div class=\"space-y-2\">
              #{render_string_label}
              #{render_string_desc}
            </div>
            <div>
              #{render_string_input}
            </div>
          </div>
        </div>"
      when "file"
        render_string_input = capture do
          form.file_field field[2]
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-3\">
            <div class=\"space-y-2\">
              #{render_string_label}
              #{render_string_desc}
            </div>
            <div>
              #{render_string_input}
            </div>
          </div>
        </div>"
      when "date"
        render_string_input = capture do
          options = { placeholder: field[3] }
          options[:value] = field[4] if field[4].present?
          form.date_field field[2], options
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-2\">
            #{render_string_label}
            #{render_string_desc}
            #{render_string_input}
          </div>
        </div>"
      when "number"
        render_string_input = capture do
          options = { placeholder: field[3] }
          options[:value] = field[4] if field[4].present?
          form.number_field field[2], options
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-2\">
            #{render_string_label}
            #{render_string_desc}
            #{render_string_input}
          </div>
        </div>"
      when "hidden"
        render_string_input = capture do
          form.hidden_field field[2]
        end

        "<div class=\"pb-2\">
          <div class=\"space-y-2\">
            #{render_string_input}
          </div>
        </div>"
      else 
        raise "Unsupported field type: #{field[0]}"
      end
    end.join.html_safe
  end



  # Helper to generate action panel buttons
  def action_panel_buttons(actions)
    return if actions.blank?

    actions.map do |action|
      if !action[0].blank? || !action[1].blank?
        render_string = capture do
          render partial: 'shared/button_solid_wfull', locals: { text: action[0], href: action[1] }
        end
  
        "<li class=\"py-4 flex\">#{render_string}</li>"
      end
    end.join.html_safe
  end



  # Helper to generate table rows
  def detail_dl_rows(attributes)
    attributes.map do |attribute|
      render_string_key = capture do 
        attribute[0]
      end
      render_string_value = capture do 
        attribute[1].to_s
      end
      "<dl class=\"divide-y divide-gray-200\">
        <div class=\"py-1 sm:grid sm:grid-cols-2\">
          <dt class=\"text-sm font-medium text-gray-500\">#{render_string_key}</dt>
          <dd class=\"mt-1 text-sm text-gray-900 sm:mt-0\">#{render_string_value}</dd>
        </div>
      </dl>"
    end.join.html_safe
  end



  # NOTE: Placing the link tag inside of the td tag maintains valid html table 
  # construction but seems like a bit of a hack.
  def td_for_row(route_path_helper_method, texts)
    return if texts.blank?

    texts.map do |text|
      "<td class=\"px-3 text-sm text-gray-500\"><a href=\"#{route_path_helper_method}\">#{text}</a></td>"
    end.join.html_safe
  end 



  def table_headers(texts)
    return if texts.blank?

    count = 0
    texts.map do |text|
      if count == 0
        "<th scope=\"col\" class=\"py-3.5 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-3 \">#{text}</th>"
      elsif count == texts.size
        "<th scope=\"col\" class=\"py-3.5 text-left text-sm font-semibold text-gray-900\">#{text}</th>"
      else
        "<th scope=\"col\" class=\"py-3.5 text-left text-sm font-semibold text-gray-900\">#{text}</th>"
      end
    end.join.html_safe
  end
end