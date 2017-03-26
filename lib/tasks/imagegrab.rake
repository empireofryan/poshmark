namespace :image do
  task :grab => [ :environment ] do

    require 'rubygems'
    require 'nokogiri'
    require 'eventmachine'
    require 'em-synchrony'
    require 'em-synchrony/em-http'

    # if ARGV.length < 2
    #   puts 'grab url path'
    #   exit
    # end

    def images(page)
      document = Nokogiri.HTML(page)
      imgs = []
      document.css('img').each do |img|
        imgs << img.attributes['src']
      end
      return imgs
    end

    def write(filename, data)
      f = File.new(filename, 'wb')
      f.write(data)
      f.close
    end

    page_url = ['http://www.nytimes.com', 'http://www.cnn.com']
    path = '/Users/Ryan/Development/code/poshmark'

    EM.synchrony do
      page = EM::Synchrony.sync EventMachine::HttpRequest.new(page_url).get
      urls = images(page.response)
      uri = URI(page_url)
      concurrency = urls.length

      results = EM::Synchrony::Iterator.new(urls, concurrency).map do |url, iter|
        http = EventMachine::HttpRequest.new("#{uri.scheme}://#{uri.host}/#{url}").aget
        http.callback { iter.return(http) }
        http.errback { iter.return(http) }
      end

      results.each do |r|
        filename = path + r.req.uri.path.split('/')[-1]
        write(filename, r.response)
        puts filename
      end

      EventMachine.stop
    end
  end
end
