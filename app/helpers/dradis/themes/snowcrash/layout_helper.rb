module Dradis
  module Themes
    module Snowcrash
      module LayoutHelper

        def brand_link
          link_to "Dradis Framework", root_path, class: 'brand'
        end

        def nav_links
          {
               chat: 'https://webchat.freenode.net/?channels=dradis',
             forums: 'http://discuss.dradisframework.org',
            support: 'http://guides.dradisframework.org',
             ticket: 'http://github.com/dradis/dradisframework/issues',
          }
        end

        def page_title
          Dradis::Core::Version::string
        end

        def version
          Dradis::Core::Version::string
        end
      end
    end
  end
end