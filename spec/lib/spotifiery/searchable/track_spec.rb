require_relative '../../../spec_helper'

describe Spotifiery::Searchable::Track do

  describe "default attributes and methods" do

    it "should have a base uri to search tracks" do
      Spotifiery::Searchable::Track.base_uri.should eql("http://ws.spotify.com/search/1")
    end

    it "should not define base query extra option" do
      Spotifiery::Searchable::Track::QUERY_EXTRA_DEFAULT.should be_nil
    end

  end

  describe "looking for tracks" do

    before (:each) do
      VCR.insert_cassette 'track_find', :record => :new_episodes
      @result = Spotifiery::Searchable::Track.find(:q => "Foo Fighters" )
    end

    after do
      VCR.eject_cassette
    end

    it "it should return a SearchResult::Base object" do      
      @result.should be_a_kind_of(Spotifiery::SearchResult::Base)
    end

    it "should return a Tracks as results" do
      @result.results.first.should be_a_kind_of(Spotifiery::Searchable::Track)
    end

  end

  describe "a concrete track by uri" do
    before (:each) do
      VCR.insert_cassette 'track_lookup_by_uri', :record => :new_episodes
      @spotifiery_track = Spotifiery::Searchable::Track.new("spotify:track:07q6QTQXyPRCf7GbLakRPr") 
    end

    after do
      VCR.eject_cassette
    end

    it "should respond to base attributes" do
      @spotifiery_track.should respond_to(:name, :popularity, :length, :href, :track_number)
    end

    it "should have 'Everlong' as name" do
      @spotifiery_track.name.should eql 'Everlong'
    end

    it "should have 3 as track-number" do
      @spotifiery_track.track_number.should eql 3
    end

    it "should have a length of 250.259" do
      @spotifiery_track.length.should eql 250.259      
    end
   
    it "should respond to artist" do
      @spotifiery_track.should respond_to :artists
    end

    it "should respond to album" do 
      @spotifiery_track.should respond_to :album
    end

    it "should have an array of Artist as astist" do
      @spotifiery_track.artists.first.should be_a_kind_of Spotifiery::Searchable::Artist
      @spotifiery_track.artists.last.should be_a_kind_of Spotifiery::Searchable::Artist
    end

    it "should have an Album as album" do
      @spotifiery_track.album.should be_a_kind_of Spotifiery::Searchable::Album
    end

    it "should have Foo Fighters as artist name" do
      @spotifiery_track.artists.first.name.should eql "Foo Fighters"
    end

    it "should have Greatest Hits as album name" do
      @spotifiery_track.album.name.should eql "Greatest Hits"
    end

  end


end