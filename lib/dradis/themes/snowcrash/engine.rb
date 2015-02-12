module Dradis
  module Themes
    module Snowcrash
      class Engine < ::Rails::Engine
        isolate_namespace Dradis::Themes::Snowcrash

        include ::Dradis::Plugins::Base
        provides :theme

        initializer 'snowcrash.asset_precompile_paths' do |app|
          app.config.assets.precompile += ["snowcrash/manifests/*"]

          # In Rails 4 we can't have fonts in ./vendor/assets/ without this line
          app.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

          # In Rails 4 we can't have images in ./vendor/assets/images/
          app.config.assets.precompile += %w{ jquery.textile.loading.gif jquery.textile.fullscreen.png }

          # for some reason the font-awesome-rails gem doesn't do this automatically
          app.config.assets.precompile += %w( font-awesome-ie7.min.css )
        end

#     NAME = "Burp Scanner output (.xml) file upload"
    # EXPECTS = "Burp Scanner XML output. Go to the Scanner tab > right-click item > generate report"


        # Configuring the gem
        # class Configuration < Core::Configurator
        #   configure :namespace => 'burp'
        #   setting :category, :default => 'Burp Scanner output'
        #   setting :author, :default => 'Burp Scanner plugin'
        # end
      end
    end
  end
end
