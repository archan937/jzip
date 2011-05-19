require File.expand_path("../../test_helper", __FILE__)

class ApplicationControllerTest < ActionController::TestCase

  context "Jzip" do
    should "call compile_javascript_files on a request" do
      Jzip::Engine.expects :compile_javascript_files
      get :index
      assert_response 200
    end
  end

end