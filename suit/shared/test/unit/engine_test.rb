require File.expand_path("../../test_helper.rb", __FILE__)

class EngineTest < ActiveSupport::TestCase

  context "Jzip::Engine" do
    should "be defined" do
      assert defined?(Jzip::Engine)
    end
  end

end