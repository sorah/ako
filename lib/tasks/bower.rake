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
        bower_components/pickadate/lib/compressed/picker.time.js
        bower_components/typeahead.js/dist/typeahead.bundle.min.js
      ).each do |src|
        puts "#{src} -> #{dest}"
        begin
          FileUtils.cp src, dest
        rescue ArgumentError => e
          raise unless e.message.start_with?("same file: ")
        end
      end
    end
  end
end
