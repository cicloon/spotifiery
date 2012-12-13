
require 'active_support/core_ext/hash/indifferent_access'


module Spotifiery

  module SearchResult

    class Base
      
      def initialize response

        response_hash = HashWithIndifferentAccess.new response        
        
        @info = response_hash[:info]
        response_results = response_hash[ ActiveSupport::Inflector.pluralize(@info[:type]) ]
        response_class = ActiveSupport::Inflector.constantize( "Spotifiery::Searchable::" + ActiveSupport::Inflector.titleize(@info[:type]))
        @results = response_results.map{|result_hash| response_class.new(result_hash) }
      end

      def results
        @results
      end


      def method_missing(method, *args, &block)                
        if defined?(@info) && @info.has_key?(method)
          @info[method]
        elsif defined?(@info) && method.eql?( ActiveSupport::Inflector.pluralize(@info[:type]).to_sym )
          @results
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        @info.has_key?(method) || method.eql?(ActiveSupport::Inflector.pluralize(@info[:type]).to_sym)
      end
                        
    end

  end

end 