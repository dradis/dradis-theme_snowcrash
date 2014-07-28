module Dradis
  module Themes
    module Snowcrash
      module ThemeHelper
        def flash_messages
          flash.collect do |name, msg|
            flash_css = 'alert'
            flash_css << {
                alert: ' alert-error',
                 info: ' alert-info',
               notice: ' alert-success',
              warning: ''
              }[name]

            content_tag :div, :class => flash_css do
              [
                link_to('x', '#', class: 'close', data: {dismiss: 'alert'}),
                msg
              ].join("\n").html_safe
            end
          end.join("\n").html_safe
        end

        def markup(text)
          return unless text.present?

          output = text.dup
          Hash[ *text.scan(/#\[(.+?)\]#[\r|\n](.*?)(?=#\[|\z)/m).flatten.collect{ |str| str.strip } ].keys.each do |field|
            output.gsub!(/#\[#{Regexp.escape(field)}\]#[\r|\n]/, "h4. #{field}\n\n")
          end

          auto_link(RedCloth.new(output, [:filter_html, :no_span_caps]).to_html, sanitize: false ).html_safe
        end

      end
    end
  end
end