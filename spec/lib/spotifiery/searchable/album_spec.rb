require_relative '../../../spec_helper'

describe Spotifiery::Searchable::Album do

  describe "default attributes and methods" do

    it "should have a base uri to search albums" do
      Spotifiery::Searchable::Album.base_uri.should eql("http://ws.spotify.com/search/1")
    end

    it "should define base query extra option" do
      Spotifiery::Searchable::Album::QUERY_EXTRA_DEFAULT.should eql "trackdetail"
    end

  end

  describe "looking for albums" do

    before (:each) do
      VCR.insert_cassette 'album_find', :record => :new_episodes
      @result = Spotifiery::Searchable::Album.find(:q => "Greatest Hits" )
    end

    after do
      VCR.eject_cassette
    end

    it "it should return a SearchResult::Base object" do      
      @result.should be_a_kind_of(Spotifiery::SearchResult::Base)
    end

    it "should return Albums as results" do
      @result.results.first.should be_a_kind_of(Spotifiery::Searchable::Album)
    end

  end

  describe "a concrete artist by uri" do
    before (:each) do
      VCR.insert_cassette 'album_lookup_by_uri', :record => :new_episodes
      @spotifiery_album = Spotifiery::Searchable::Album.new("spotify:album:6G9fHYDCoyEErUkHrFYfs4") 
    end

    after do
      VCR.eject_cassette
    end

    it "should respond to base attributes" do
      @spotifiery_album.should respond_to(:name, :released, :href)
    end

    it "should have 'Remedy' as name" do
      @spotifiery_album.name.should eql 'Remedy'
    end

    it "should have 1999 as track-number" do
      @spotifiery_album.released.should eql 1999
    end

    
    it "should respond to artist" do
      @spotifiery_album.should respond_to :artists
    end

    it "should respond to tracks" do 
      @spotifiery_album.should respond_to :tracks
    end

    it "should have an Artist as astist" do
      @spotifiery_album.artists.first.should be_a_kind_of Spotifiery::Searchable::Artist
      @spotifiery_album.artists.last.should be_a_kind_of Spotifiery::Searchable::Artist      
    end

    it "should have an array of Tracks as tracks" do
      @spotifiery_album.tracks.first.should be_a_kind_of Spotifiery::Searchable::Track
      @spotifiery_album.tracks.last.should be_a_kind_of Spotifiery::Searchable::Track
    end

    it "should have Basement Jaxx as artist name" do
      @spotifiery_album.artists.first.name.should eql "Basement Jaxx"
    end

  end


end