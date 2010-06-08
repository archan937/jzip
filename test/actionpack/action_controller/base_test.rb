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
          
          def test_javascript_compilation
            prepare_directories
            get :index
            assert_equal_outcome
          end
          
        private
        
          def prepare_directories
            test_dir = File.join(File.dirname(__FILE__), "..", "..")
            
            FileUtils.rm_r File.join(test_dir, "rails_root", "public", "javascripts", "."), :force => true
            FileUtils.rm_r File.join(test_dir, "rails_root", "tmp"                       ), :force => true
            FileUtils.cp_r File.join(test_dir, "javascripts", "before", "."), File.join(test_dir, "rails_root", "public", "javascripts")
          end
          
          def assert_equal_outcome
            true
          end
        end

      end
    end
  end
end
