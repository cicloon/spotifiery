# Spotifiery

Spotifiery is a simple wrapper for the Spotify web API.

## Installation

Add this line to your application's Gemfile:

    gem 'spotifiery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spotifiery

## Usage

Using it is very simple:

There are three "searchable items":

- Track
- Album
- Artist

To search for a track you can do:

Spotifiery::Searchable::Track.find(:q => 'Stairway to Heaven')

Which will return a SearchResult containing tracks called "Stairway to Heaven".

It accepts the same params as the spotify API so if you want to look for the page 2 of search results you should do:

Spotifiery::Searchable::Track.find(:q => 'Stairway to Heaven', :page => 2)

A find will return a SearchResult object which contains metadata about the query performed like "num_results", "limit", "offset", "page"... and of course the result set, which can be accessed via the results method (if you've searched for tracks you can use the tracks method too, the same applies to albums or artists).

A Searchable contains all the metadata about itself and allows navigation through the API, p.e.: you can ask a track about its artits or about its album. 


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
