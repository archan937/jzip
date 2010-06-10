require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "test_helper.rb"))

require "action_controller"

module Jzip
  module Test
    module Actionpack
      module ActionController
        
        class ApplicationController < ::ActionController::Base
          def index; render :text => "Testing!"; end
          def rescue_action(e); raise e; end
        end

        class BaseTest < ::ActionController::TestCase
          self.controller_class = ApplicationController

          setup do
            include Setup
          end
          
          def test_compressed_javascript_compilation
            test_compilation true
          end
          
          def test_uncompressed_javascript_compilation
            test_compilation false
          end
          
        private
        
          def test_compilation(minify)
            prepare_directories(minify)
            get :index
            assert_equal output_equals_comparison?, true
          end
        
          def prepare_directories(minify)
            Jzip::Engine.options[:minify]   = minify
            Jzip::Engine.options[:root_dir] = File.expand_path(File.join(test_dir, "rails_root", compression))
            
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "assets", "jzip"       , "."), :force => true
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "public", "javascripts", "."), :force => true
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "tmp"                       ), :force => true

            FileUtils.cp_r File.join(test_dir, "javascripts", "assets", "jzip", "."), File.join(Jzip::Engine.options[:root_dir], "assets", "jzip"       )
            FileUtils.cp_r File.join(test_dir, "javascripts", "before"        , "."), File.join(Jzip::Engine.options[:root_dir], "public", "javascripts")
          end
          
          def output_equals_comparison?
            Dir.glob(File.join(comparison_dir, "**", "*.js")).all? do |javascript|
              relative_path = Pathname.new(File.expand_path(javascript)).relative_path_from(Pathname.new(File.expand_path(comparison_dir)))
              File.read(javascript) == File.read(File.join(Jzip::Engine.options[:root_dir], relative_path)) rescue false
            end
          end
        
          def test_dir
            File.join(File.dirname(__FILE__), "..", "..")
          end

          def comparison_dir
            File.join(test_dir, "javascripts", "after", compression)
          end
          
          def compression
            [("un" unless Jzip::Engine.options[:minify]), "compressed"].compact.join ""
          end
          
        end

      end
    end
  end
end
