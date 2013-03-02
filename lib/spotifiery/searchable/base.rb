require 'active_support/core_ext/object'
require 'active_support/core_ext/string'

module Spotifiery

  module Searchable

    module Base

      extend ActiveSupport::Concern
      BASE_SEARCH_URL = "http://ws.spotify.com/search/1/"
      BASE_LOOKUP_URL = "http://ws.spotify.com/lookup/1/.json"

      
      included do                 
        include HTTParty        
        base_uri BASE_SEARCH_URL
        format :json        
      end

      module ClassMethods

        # Search for something (track, album or artist).
        # Accept the same params as spotify search API
        def find opts = {}        
          parsed_response = ask_spotify opts
          Spotifiery::SearchResult::Base.new parsed_response, self
        end

        private

        def ask_spotify opts = {}          
          opts = {:q => '', :page => '1'}.merge opts
          self.get("/#{base_name.demodulize.downcase}.json" , :query => opts.to_param ).parsed_response
        end
      end
      

      # Can be initialized from a spotify uri or from an search result hash.
      # This way Spotify is not asked when initialized from a search result when name, popularity, etc are called
      def initialize spotify_uri_or_hash
              
        if spotify_uri_or_hash.is_a? Hash          
          initialize_base_attributes_getters HashWithIndifferentAccess.new spotify_uri_or_hash
          @href = spotify_uri_or_hash['href']

        elsif spotify_uri_or_hash.is_a? String          
          
          @href = spotify_uri_or_hash
          
        else
          raise "Wrong initialize params"
        end
      end


      private

      def method_missing(method, *args, &block)
        
        # Looked in spotify before?
        if !defined?(@lookup_response)
          lookup_in_spotify
        end

        # Try to find the method in base_attributes
        if @base_attributes.has_key? method
          # Always try to parse for integers
          Integer(@base_attributes[method],10) rescue @base_attributes[method]
        # If not try to see if an instance variable is defined
        elsif instance_variable_defined?("@#{method}")
            instance_variable_get("@#{method}")
        else
          super
        end

      end

      def respond_to_missing?(method, include_private = false)
        if !defined? @lookup_response
          lookup_in_spotify
        end
        @base_attributes.has_key?(method) || instance_variable_defined?("@#{method}")
      end

      # Perform a lookup, taking all the metadata from Spotify.
      def lookup_in_spotify      
        perform_lookup
        parsed_response = HashWithIndifferentAccess.new @lookup_response.parsed_response              
        set_base_attributes_by_lookup parsed_response
      end

      def perform_lookup
        @lookup_response = HTTParty.get( Spotifiery::Searchable::Base::BASE_LOOKUP_URL, :query => {:uri => @href, :extras => self.class::QUERY_EXTRA_DEFAULT } )
      end

      # Define base attribute methods from an Spotify lookup
      def set_base_attributes_by_lookup attributes_hash
        searchable_type = self.class.base_name.demodulize.downcase      
        initialize_base_attributes_getters attributes_hash[ searchable_type ]
      end

      # Define methods from a hash
      def initialize_base_attributes_getters attributes_hash

        @base_attributes ||= {}

        attributes_hash.each do |key, value|   

          attribute = key.underscore.to_sym                    
          if !self.class::LOOKUPS.include? attribute.to_s.singularize

            @base_attributes[ attribute ] = value             
            define_base_method attribute if !defined? attribute

          else
            initialize_lookup attribute, value
          end 
        end
      end

      # Define methods that require new searchables
      def initialize_lookup attribute, value
        singular_attribute = attribute.to_s.singularize
        searchable_class = ("Spotifiery::Searchable::" + singular_attribute.titleize ).constantize

        searchable_instance = if value.is_a? Array          
          value.map {|val| searchable_class.new val }
        else
          searchable_class.new value
        end

        instance_variable_set("@#{attribute}", searchable_instance)
        define_searchable_method attribute        
      end

      def define_base_method method
        send(:define_singleton_method, method) do
          # Always try to parse for integers
          Integer(@base_attributes[attribute],10) rescue @base_attributes[attribute]
        end
      end

      def define_searchable_method method
        send(:define_singleton_method, method) do
          instance_variable_get("@#{method}")          
        end
      end


    end

    

  end


end