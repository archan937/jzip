require File.expand_path("../../../../test_helper.rb", __FILE__)

module Core
  module String
    class AnalyzationTest < ActiveSupport::TestCase

      test "jzip_require_statement?" do
        assert_equal true , "//= require \"defaults\"".jzip_require_statement?
        assert_equal false, "//  require \"defaults\"".jzip_require_statement?
        assert_equal false, "#   require \"defaults\"".jzip_require_statement?
      end

      test "required_jzip_source" do
        # assert something
      end

      test "overrule_jzip_minification?" do
        # assert something
      end

    end
  end
end