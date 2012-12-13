module Spotifiery

  module Searchable

    class Artist
      include Base                        
      LOOKUPS = ['album']
      QUERY_EXTRA_DEFAULT = 'albumdetail'
    end

  end

end 