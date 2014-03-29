require 'fileutils'

namespace :bower do
  desc "call `bower install` then copy required files to vendor/javascripts"
  task install: :environment do
    Dir.chdir(Rails.root) do
      puts "$ bower install"
      system "bower", "install"

      dest = Rails.root.join('vendor', 'assets', 'javascripts').to_s
      %w(
        bower_components/pickadate/lib/compressed/picker.js
        bower_components/pickadate/lib/compressed/picker.date.js
        bower_components/typeahead.js/dist/typeahead.bundle.min.js
      ).each do |src|
        puts "#{src} -> #{dest}"
        FileUtils.cp src, dest
      end

      dest = Rails.root.join('vendor', 'assets', 'stylesheets').to_s
      %w(
        bower_components/pickadate/lib/compressed/themes/classic.css
        bower_components/pickadate/lib/compressed/themes/classic.date.css
      ).each do |src|
        puts "#{src} -> #{dest}"
        FileUtils.cp src, dest
      end
    end
  end
end
