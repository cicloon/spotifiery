require_relative '../../../spec_helper'

describe Spotifiery::Searchable::Artist do

  describe "default attributes and methods" do

    it "should have a base uri to search artists" do
      Spotifiery::Searchable::Track.base_uri.should eql("http://ws.spotify.com/search/1")
    end

    it "should define base query extra option" do
      Spotifiery::Searchable::Artist::QUERY_EXTRA_DEFAULT.should eql "albumdetail"
    end    

  end

  describe "looking for artists" do

    before (:each) do
      VCR.insert_cassette 'artist_find', :record => :new_episodes
      @result = Spotifiery::Searchable::Artist.find(:q => "Foo Fighters" )
    end

    after do
      VCR.eject_cassette
    end

    it "it should return a SearchResult::Base object" do      
      @result.should be_a_kind_of(Spotifiery::SearchResult::Base)
    end

    it "should return Artists as results" do
      @result.results.first.should be_a_kind_of(Spotifiery::Searchable::Artist)
    end

  end

  describe "a concrete track by uri" do
    before (:each) do
      VCR.insert_cassette 'track_lookup_by_uri', :record => :new_episodes
      @spotifiery_artist = Spotifiery::Searchable::Artist.new("spotify:artist:4YrKBkKSVeqDamzBPWVnSJ") 
    end

    after do
      VCR.eject_cassette
    end

    it "should respond to base attributes" do
      @spotifiery_artist.should respond_to(:name, :href)
    end

    it "should have 'Basement Jaxx' as name" do
      @spotifiery_artist.name.should eql 'Basement Jaxx'
    end

    it "should respond to albums" do
      @spotifiery_artist.should respond_to :albums
    end

    it "should have an array of Albums as albums" do
      @spotifiery_artist.albums.first.should be_a_kind_of Spotifiery::Searchable::Album
      @spotifiery_artist.albums.last.should be_a_kind_of Spotifiery::Searchable::Album
    end

  end


end