namespace :hydra do
  task :run => [ :environment ] do
    hydra = Typhoeus::Hydra.new :max_concurrency => 5
    urls = %w(https://poshmark.com/search?availability=sold_out&category=Shoes&department=Women&max_id=5&query="" )
    responses = []

    urls.each do |url|
      req = Typhoeus::Request.new url
      req.on_complete do |resp|
        if resp.success?
          responses << resp.body
          puts responses
        else
          responses << "#{url} failed with #{resp.code}"
        end
      end

      hydra.queue req
    end

  hydra.run # let the magic begin!
  end
end
