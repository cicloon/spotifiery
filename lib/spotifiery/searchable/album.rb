module Spotifiery

  module Searchable

    class Album
      include Base                        
      LOOKUPS = ['artist' , 'track']
      QUERY_EXTRA_DEFAULT = 'trackdetail'

      private

      # Spotify messed it up with albums and artists.
      # An Album lookup returns artist as artist-id: "spotify:artist:7jy3rLJdDQY21OgRLCZ9sD" and artist: "Foo Fighters"
      # An Album search returns artists as [{href: "spotify:artist:7jy3rLJdDQY21OgRLCZ9sD",name: "Foo Fighters"}]
      # This is fixed here
      def lookup_in_spotify      
        perform_lookup
        parsed_response = @lookup_response.parsed_response
        searchable_type = self.class.name.demodulize.downcase

        # Build the artist hash as it is on search results
        artist_hash = HashWithIndifferentAccess.new({ :name => parsed_response[searchable_type]['artist'], :href => parsed_response[searchable_type]['artist-id']})

        # Remove artist references from lookup response
        parsed_response[searchable_type].delete(:artist)
        parsed_response[searchable_type].delete('artist-id')

        # Set artists as it is on search results
        parsed_response[searchable_type]['artists'] = [artist_hash]        

        # Initialize attributes as always
        set_base_attributes_by_lookup parsed_response
      end


    end

  end

end 