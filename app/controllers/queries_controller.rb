class QueriesController < ApplicationController
  def index
    @queries = Query.all
  end

  def new
    @query = Query.new
  end

  def create
    new_query = params.require(:query).permit(:id, :search)
    query = Query.create(new_query)
    @query = params[:query][:search].gsub(" ", "%20")

  #  @search = @query.search
    # %x[rake hydra:run search="#{@search}"]
    hydra = Typhoeus::Hydra.new :max_concurrency => 5
    url = "https://poshmark.com/search?availability=sold_out&category=Shoes&department=Women&max_id=5&query=" + @query
    responses = []

  #  urls.each do |url|
      req = Typhoeus::Request.new url
      req.on_complete do |resp|
        if resp.success?
          responses << resp.body
          # puts responses
          puts 'responses size'
          puts responses.size
          puts 'responses to_s'
          a = responses.to_s
          puts a.class
          puts 'da shiz werks'
          dapage = Nokogiri::HTML(a)
          puts dapage
          yoyo = dapage.css('.tile')
          c = yoyo.count.to_i
          #puts c
        else
          responses << "#{url} failed with #{resp.code}"
          puts 'error ryan robinson!'
        end
      end

      hydra.queue req
    #end

  hydra.run # let the magic begin!

  byebug
    redirect_to items_path
  end

  def show
    id = params[:id]
    @query = Query.find(id)
  end
end
