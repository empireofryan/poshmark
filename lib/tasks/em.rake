namespace :em do
  task :em => [ :environment ] do
  require "em-synchrony"
  require "em-synchrony/em-http"
  require 'nokogiri'

  EM.synchrony do
      concurrency = 2
      urls = ['http://nytimes.com', 'http://cnn.com']

      # iterator will execute async blocks until completion, .each, .inject also work!
      results = EM::Synchrony::Iterator.new(urls, concurrency).map do |url, iter|


          # fire async requests, on completion advance the iterator
          http = EventMachine::HttpRequest.new(url).aget :query => {'keyname' => 'value'}
          http.callback { iter.return(http) }
          http.errback { iter.return(http) }
      end

      p results # all completed requests
      EventMachine.stop
    end
  end
end
