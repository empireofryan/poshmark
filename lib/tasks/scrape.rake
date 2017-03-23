namespace :scrape do
  task :posh => [ :environment ] do
  desc '$$$ making paper $$$'
  require 'phantomjs'
  require 'watir'
  require 'nokogiri'
  require 'date'
  require 'time'
  require 'chronic'
  require 'active_support/all'
  require 'timeout'
  require 'rspec/retry'

  TIMEOUT = 300 # set some value in seconds, f.ex. 300
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = TIMEOUT # seconds – default is 60
  #browser = Watir::Browser.new :firefox, :http_client => client

  puts '!WWWWWeeu..   ..ueeWWWWW! '
  puts ' "$$(    R$$e$$R    )$$" '
  puts '  "$8oeeo. "*" .oeeo8$" '
  puts '  .$$#"""*$i i$*"""#$$. '
  puts '  9$" @@@ $$ $$F @@@ $N '
  puts '   9$  `` $$ $$L `` $$ '
  puts '  `$$uuuuo$$ $$uuuuu$$" '
  puts '  x$P**$$P*$"$P#$$$*R$L '
  puts "  x$$   $$k $$F :$P` '$$i "
  puts ' $$     #$  #  $$     #$k '
  puts 'd$"     "$L   x$F     "$$ '
  puts "$$      '$E   9$>      9$>"
  puts "$6       $F   ?$>      9$>"
  puts "$$      d$    '$&      8$"
  puts '"$k    x$$     !$k    :$$'
  puts ' #$b  u$$L      9$b.  $$"'
  puts ' "#$od$#$$u....u$P$Nu@$"'
  puts '  ..?$R)..?R$$$$*"  #$P'
  puts ' $$$$$$$$$$$$$$@WWWW$NWWW'
  puts ' `````""3$F""""#$F"""""""'
  puts "        @$.... '$B"
  puts '       d$$$$$$$$$$:'
  puts '       ````````````'

  t1 = Time.now
  puts 'time begun ' + t1.to_s

   #movies   #run movies scraper
   poshmark   #run medium scraper
  # awwwards #run awwwards scraper
  # deals_pt1
  #  economists
  #  posh
  #   twitter
  #   next_web
  #   google
  #   nytimes
  # imgur
  puts 'Scraper successfully executed.'
end

  def poshmark
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://poshmark.com/search?query=calvin+klein+boots&department=Women&ac=true'

    doc = Nokogiri::HTML(b.html)
    puts doc
    a = doc.css('.tile')
    b = doc.css('.postArticle-content a')
    c = a.count.to_i
    c = c - 1
    z = (0..c).to_a
    puts z
    binding.pry
     z.each do |i|
       link = b[i]['href']
       puts link
       url = link
       title = a[i.to_i].text
       puts title
       @medium = Medium.find_or_create_by(title: title, url: url)
       @medium.save
       puts 'Medium article created!'
       puts " "
     end
  end # end of medium

  def bla
    begin
      b = Watir::Browser.new(:phantomjs)
      z = (1..3).to_a
      z.each do |i|
        b.goto 'https://vimeo.com/channels/staffpicks/page:' + i.to_s
        doc = Nokogiri::HTML(b.html)
        a = doc.css('#gallery ol li')
      #  puts a
        a.each do |video|
          url_suffix = video.css('a')[0]['href']
          url = 'http://vimeo.com' + url_suffix
          puts url
          title = video.css('a')[0]['title']
          puts title
          picture = video.css('img')[0]['src']
          puts picture
          @vimeo = Vimeo.find_or_create_by(title: title, picture: picture, url: url)
          @vimeo.save
          puts 'Vimeo entry created!'
        end
      end
    rescue
      retry
    end
  end# end vimeo

  def movies
    b = Watir::Browser.new(:phantomjs, :http_client => client)
    b.goto 'https://www.rottentomatoes.com/top/'

    doc = Nokogiri::HTML(b.html)

    a = doc.css('.movie_list')[8]
    b = a.css('tr td a')
    c = a.css('tr td').first.attr('href')
    d = a.css('tr td').first.attr('value')
    e = a.css('tr td').first.attr(['href'])
    f = a.css('tr td').first.attr(['value'])
    z = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    z.each do |i|
      link = b[i]['href']
      puts link
      url = 'http://www.rottentomatoes.com' + link
      title = b[i].text
      puts title
      @movie = Movie.find_or_create_by(title: title, url: url)
      @movie.save
      puts 'Movie created!'
      puts " "
    end
    end
  end # end movies

  def medium
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://medium.com/browse/top'

    doc = Nokogiri::HTML(b.html)
    a = doc.css('.postArticle-content a h3')
    b = doc.css('.postArticle-content a')
    c = a.count.to_i
    c = c - 1
    z = (0..c).to_a
    puts z
     z.each do |i|
       link = b[i]['href']
       puts link
       url = link
       title = a[i.to_i].text
       puts title
       @medium = Medium.find_or_create_by(title: title, url: url)
       @medium.save
       puts 'Medium article created!'
       puts " "
     end
  end # end of medium



  def twitter
  begin
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://trends24.in/united-states/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.trend-card__list li')
    # puts a
    # b = doc.css('.trend-items .trend-item')
    # puts b
     a.each do |twitter|
       hashtag = twitter.text
       puts hashtag
       url = twitter.css('a')[0]['href']
      #  hashtag = video.css('a')[0]['title']
       puts url
      @twitter = Twitter.find_or_create_by(hashtag: hashtag, url: url)
      @twitter.save
      puts 'Twitter entry created!'
    end #end a.each
  rescue
    retry
  end
  end # end twitter

  def next_web
  begin
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://thenextweb.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.story-title')
     puts a
     a.each_with_index do |article, index|
       begin
         title = article.text
         puts title
         url = article.css('a')[0]['href']
         puts url
         @next_web = Thenextweb.find_or_create_by(title: title, url: url)
         @next_web.save
         puts 'Next Web entry created!'
       rescue
        'new web rescued'
       end
     end #end a.each
   rescue
     retry
   end
  end # end next_web

  def google
  begin
    b = Watir::Browser.new(:phantomjs)
    b.goto 'https://www.google.com/trends/hottrends'
    doc = Nokogiri::HTML(b.html)
      begin
    a = doc.css('.hottrends-trends-list-trend-container')
    # puts a
     a.each do |article|
       title = article.css('.hottrends-single-trend-title').text
       puts title
       a_url = article.css('.hottrends-single-trend-title-container a')[1]['href']
       url = 'http://www.google.com' + a_url
       puts url
       search = article.css('.hottrends-single-trend-info-line-number').text
       puts search
       @google = Google.find_or_create_by(title: title, url: url, search: search)
       @google.save
      puts 'Google trending entry created!'
      end
    rescue Net::ReadTimeout
      puts 'rescued '
    end#end a.each
  rescue
    retry
  end
  end # end google

  def nytimes
  begin
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://mobile.nytimes.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.sfgAsset-li')
  #   puts a
     a.each do |article|
       begin
         a_url = article.css('a')[0]['href']
        if a_url.start_with?('/2016')
          url = 'http://www.nytimes.com' + a_url
          puts url
        end
      title = article.css('.sfgAsset-hed').text.strip
      puts title
      if url
        @nytime = Nytime.find_or_create_by(title: title, url: url)
        @nytime.save
        puts 'Next Web entry created!'
      end
    rescue NoMethodError
     puts "no method error rescued"
    end
    end #end a.each
  rescue
    retry
  end
  end # end nytimes

  def imgur
  begin
    b = Watir::Browser.new(:phantomjs)
    b.goto 'http://imgur.com/'
    doc = Nokogiri::HTML(b.html)
    a = doc.css('.cards .post')
  #   puts a
     a.each do |article|
       begin
         a_url = article.css('a')[0]['href']
        #  puts a_url
         url = 'http://www.imgur.com' + a_url
      #   puts url
         image_a = article.css('img')[0]['src']
         image_a[0..1] = ""
         image = 'http://' + image_a
         puts image
       if url
          @imgur = Imgur.find_or_create_by(image: image, url: url)
          @imgur.save
          puts 'Next Web entry created!'
        end
      rescue NoMethodError
       puts "no method error rescued"
      end
    end #end a.each
  rescue
    retry
  end
  end # end imgur
#dont need an end
