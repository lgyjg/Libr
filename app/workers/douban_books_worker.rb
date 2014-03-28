class DoubanBooksWorker

  include Sidekiq::Worker

  def perform(name)
    count = 30
    total = 0
    start = 0
    while (start == 0) || (total-start > count)
      result = RestClient.get "http://api.douban.com/v2/book/user/#{name}/collections?start=#{start}&count=#{count}"
      json = JSON.parse(result)
      storeBooks(json)
      total = json['total']
      start += count
    end
  end


  def storeBooks(json)
    collections = json['collections']
    collections.each { |collection|
      book = collection['book']
      Book.create_book_by_isbn book unless Book.find_by_isbn book['isbn13']
    }
  end

end