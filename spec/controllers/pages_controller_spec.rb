require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController do
  describe "get SHOW" do
    it "should render the index if no id is specified" do
      get :show, :id => nil
      response.should render_template('index')
    end
    
    it "should render the about template" do
      get :show, :id => 'about'
      response.should render_template('about')
    end
    
    it "should render the contact template" do
      get :show, :id => 'contact'
      response.should render_template('contact')
    end
  end
end
