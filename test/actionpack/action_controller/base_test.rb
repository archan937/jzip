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
            prepare_directories(true)
            get :index
            assert_equal_outcome
          end
          
          def test_uncompressed_javascript_compilation
            prepare_directories
            get :index
            assert_equal_outcome
          end
          
        private
        
          def prepare_directories(minify = false)
            test_dir = File.join(File.dirname(__FILE__), "..", "..")
            
            Jzip::Engine.options[:minify]   = minify
            Jzip::Engine.options[:root_dir] = File.expand_path(File.join(test_dir, "rails_root", compression))
            
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "assets", "jzip"       , "."), :force => true
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "public", "javascripts", "."), :force => true
            FileUtils.rm_r File.join(Jzip::Engine.options[:root_dir], "tmp"                       ), :force => true

            FileUtils.cp_r File.join(test_dir, "javascripts", "assets", "jzip", "."), File.join(Jzip::Engine.options[:root_dir], "assets", "jzip"       )
            FileUtils.cp_r File.join(test_dir, "javascripts", "before"        , "."), File.join(Jzip::Engine.options[:root_dir], "public", "javascripts")
          end
          
          def compression
            [("un" unless Jzip::Engine.options[:minify]), "compressed"].compact.join ""
          end
          
          def assert_equal_outcome
            true
          end
          
        end

      end
    end
  end
end
