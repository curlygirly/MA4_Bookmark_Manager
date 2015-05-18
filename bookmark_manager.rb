require 'sinatra/base'


class BookmarkManager < Sinatra::Base
set :views, Proc.new { File.join(root,"views") }

  get '/' do
    'Hello BookmarkManager!'
    @links = Link.all
  erb :index
  end

  post '/links' do
    url = params['url']
    title = params['title']
    tags = params['tags'].split(' ').map do |tag|
  # this will either find this tag or create
  # it if it doesn't exist already
  Tag.first_or_create(text: tag)
end
Link.create(url: url, title: title, tags: tags)

    redirect to('/')
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

# we're telling datamapper to use a postgres database on localhost. The name will be "bookmark_manager_test" or "bookmark_manager_development" depending on the environment
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/links' # this needs to be done after datamapper is initialised
require './lib/tag'

# After declaring your models, you should finalise them
DataMapper.finalize

# However, the database tables don't exist yet. Let's tell datamapper to create them
DataMapper.auto_upgrade!

