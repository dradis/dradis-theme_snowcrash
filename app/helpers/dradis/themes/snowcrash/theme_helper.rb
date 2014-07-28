module Dradis
  module Themes
    module Snowcrash
      module ThemeHelper
        def css_class_for_node(node)
          classes = []
          classes << 'hasSubmenu' if node.children.any?
          classes << 'active' if node == @node
          classes << 'in' if @node && @node.parent_id == node.id
          classes.join(' ')
        end

        def css_class_for_sub_nodes(node)
          controller_name == 'nodes' && @node && (@node.parent_id == node.id || @node.id == node.id) ? 'in' : ''
        end

        def flash_messages
          flash.collect do |name, msg|
            flash_css = 'alert'
            flash_css << {
                alert: ' alert-error',
                 info: ' alert-info',
               notice: ' alert-success',
              warning: ''
            }.fetch(name.to_sym, " unknown_flash_#{name}")

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

        def short_filename(long_filename)
          # hyphens are word-wrapped by the browser
          return long_filename if long_filename =~ /\-/

          return truncate(long_filename, length: 12)
        end
      end
    end
  end
end