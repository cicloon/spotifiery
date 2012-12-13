module Spotifiery

  module Searchable    
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Track
    autoload :Album
    autoload :Artist
       
  end


end