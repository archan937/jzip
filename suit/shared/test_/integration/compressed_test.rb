require File.expand_path("../../support/dummy_app.rb", __FILE__)

DummyApp.setup "Compressed Javascript"

class CompressedTest < ActionController::IntegrationTest

  context "Jzip with compression" do
    teardown do
      DummyApp.restore_all true
    end

    should "behave as expected" do
      visit "/"
      # assert generated javascripts
      # assert generated tmp javascripts
    end
  end

end