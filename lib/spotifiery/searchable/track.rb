module Spotifiery

  module Searchable

    class Track 
      include Base
      LOOKUPS = ['artist' , 'album']
      QUERY_EXTRA_DEFAULT = nil                        

      def self.base_name
        'track'
      end

    end

  end

end 