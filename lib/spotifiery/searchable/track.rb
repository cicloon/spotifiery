module Spotifiery

  module Searchable

    class Track 
      include Base
      LOOKUPS = ['artist' , 'album']
      QUERY_EXTRA_DEFAULT = nil                        
    end

  end

end 