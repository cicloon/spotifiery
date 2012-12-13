describe 'Spotifiery::SearchResult::Base' do

  describe "on initialize from a mock" do

    before (:each) do
      @spotify_json = {
        :info =>  {:num_results => 110, :limit => 100, :offset => 200, :query => "foo", :type => "album", :page => 3}, 
        :albums => []
      }
      @spotifiery_search_result = Spotifiery::SearchResult::Base.new(@spotify_json)
    end

    it "should accept a valid spotify json string" do
      @spotifiery_search_result.should_not be_nil
    end

    it "should respond to spotify search results" do     
      @spotifiery_search_result.should respond_to(:num_results, :limit, :offset, :query, :type, :page)
    end

    it "should have album as type" do
      @spotifiery_search_result.type.should eql 'album'
    end

  end

  describe "on initialize from a real spotify response" do

    before (:each) do
      VCR.insert_cassette 'with_or_without_you', :record => :new_episodes
      spotify_response = HTTParty.get("http://ws.spotify.com/search/1/track.json", :query => {:q => "With or Without You", :page => '1'})      
      parsed_response = JSON.parse(spotify_response.body, :symbolize_names => true)
      @spotifiery_search_result = Spotifiery::SearchResult::Base.new parsed_response
    end

    after do
      VCR.eject_cassette
    end    

    it "should have track as type" do
      @spotifiery_search_result.type.should eql 'track'
    end

    it "should respond to tracks and results" do
      @spotifiery_search_result.should respond_to(:tracks, :results)
    end

    it "each item in results should be a track" do            
      @spotifiery_search_result.tracks.first.should be_a_kind_of(Spotifiery::Searchable::Track)
      @spotifiery_search_result.tracks.last.should be_a_kind_of(Spotifiery::Searchable::Track)
    end

  end
  
end