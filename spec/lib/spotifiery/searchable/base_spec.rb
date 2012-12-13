require_relative '../../../spec_helper'

describe Spotifiery::Searchable::Base do

  describe "default attributes and methods" do

    it "should define base api search url" do
      Spotifiery::Searchable::Base::BASE_SEARCH_URL.should eql("http://ws.spotify.com/search/1/")
    end

    it "should define base api lookup url" do
      Spotifiery::Searchable::Base::BASE_LOOKUP_URL.should eql("http://ws.spotify.com/lookup/1/.json")
    end

  end

  describe "modules including it" do

    before do
      # Not sure if this is an aberration... 
      class SearchableTestClass 
        include Spotifiery::Searchable::Base
      end      
    end

    it "should define the find static method" do
      SearchableTestClass.should respond_to(:find)
    end

    it "should raise exception if find called" do        
      lambda { SearchableTestClass.find(:q => "something") }.should raise_error
    end

    it "should include httparty methods" do        
      SearchableTestClass.should include(HTTParty)      
    end

  end


end