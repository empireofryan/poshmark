class QueriesController < ApplicationController
  def index
    @queries = Query.all
  end

  def new
    @query = Query.new
  end

  def create
    new_query = params.require(:query).permit(:id, :search)
    query = Query.create!(new_query)
    @query = params[:query][:search].gsub(" ", "+")
    @query_id = params[:query][:id]
  #  @search = @query.search
    # %x[rake hydra:run search="#{@search}"]
    hydra = Typhoeus::Hydra.new :max_concurrency => 5
    url = "https://poshmark.com/search?availability=sold_out&department=Women&max_id=5&query=" + @query
    responses = []

  #  urls.each do |url|
      req = Typhoeus::Request.new url
      req.on_complete do |resp|
        if resp.success?
          responses << resp.body
        #  puts responses
           puts 'responses size'
          puts responses.size
          puts 'responses to_s'
          a = responses.to_s
          puts a.class
          puts 'da shiz werks'
          doc = Nokogiri::HTML(resp.body)
      #    puts dapage
          a = doc.css('.tile')
    #      puts yoyo
          c = a.count.to_i
          puts c
          c = c - 1
          z = (0..c).to_a
          puts 'after c before z'
          p z
          puts z.class
        #   (0..47).to_a.each do |foo|
            z.to_a.each do |foo|

            puts foo
          #  byebug
             brand = doc.css('.tile')[foo]["data-post-brand"] if doc.css('.tile')
             puts brand
             price = a[foo]['data-post-price'] if a[foo]['data-post-price']
             price[0] = '' if price
             puts price
             size = a[foo]['data-post-size'] if a[foo]['data-post-size']
             b = doc.css('.covershot-con')
             href = b[foo]['href']
             title = b[foo]['title']
            #  img = b[i]('img').attr('src')
            #  c = doc.at_css('.covershot')
             img = doc.css('.covershot')[foo].attr('src')
            # img = doc.css('.covershot-con')[i]('img')
            # imgalt = b[i]('img')['alt']
            # originalprice = doc.css[i]('.original')
          #   @item = Item.find_or_create_by(title: title, brand: brand, url: href, price: price, image: img, size: size)
             puts 'title:'
             puts title
             puts 'brand:'
             puts brand
             puts 'url:'
             puts href
             puts 'image'
             puts img
             puts 'price:'
             puts price
             puts 'size:'
             puts size
             puts 'search:'
             puts @query
          #   byebug
            #  puts 'originalprice'
            #  puts originalprice
        begin



             @item = Item.find_or_create_by(title: title, url: href, brand: brand, price: price, size: size, image: img, search: @query, query_id: Query.last.id)
          #   @item.save!
        rescue ActiveRecord::RecordInvalid => invalid
         puts invalid.record.errors
         end
             puts 'Item created!'
             puts " "
           end
        else
          responses << "#{url} failed with #{resp.code}"
          puts responses
          puts 'error ryan robinson!'
        end
      end

      hydra.queue req
    #end

  hydra.run # let the magic begin!

#  byebug
    redirect_to queries_path
  end

  def show
    id = params[:id]
    @query = Query.find(id)
  end
end
