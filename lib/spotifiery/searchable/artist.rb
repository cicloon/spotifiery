module Spotifiery

  module Searchable

    class Artist
      include Base                        
      LOOKUPS = ['album']
      QUERY_EXTRA_DEFAULT = 'albumdetail'

      def self.base_name
        'artist'
      end

    end

  end

end 