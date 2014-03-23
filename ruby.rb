require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :publiczny, Text
    property :created_at, DateTime
    has n, :comments
end

class Comment
    include DataMapper::Resource
    property :id, Serial
    property :user, String
    property :body, Text
    belongs_to :post # post_id integer
    property :created_at, DateTime
end


DataMapper.finalize
Post.auto_upgrade!
Comment.auto_upgrade!

#set :layout_engine => :erb, :layout => :index
# akcja, route /
get '/' do
  haml :index
#  'Hello world!'
end

#akcja pod route, /o-mnie
get '/o-mnie' do
  'Jestem Sylwia!!'
  haml :omnie
end

get '/hello/:name' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params[:name] is 'foo' or 'bar'
  "Hello #{params[:name]}!"
end

get '/formularz' do
	haml :formularz
end

post '/oblicz' do
a = params[:liczba1].to_i
b = params[:liczba2].to_i
(a*b).to_s
end

get '/petla' do
	erb :petla
end
#---


get '/nowy_post' do
  haml :nowy_post
end

post '/dodaj' do
 post = Post.create(:title=>params[:tytul], :body=>params[:tresc])
 redirect "/lista_postow"
end

get '/lista_postow_publiczna' do 
  @posts = Post.all(:publiczny => "tak")
  haml :lista_postow_publiczna
end

post '/:id/lista_postow_update' do 
 @post = Post.get(params[:id])
 @post.update(:publiczny => "tak")
 redirect "/lista_postow_publiczna"
end

get '/lista_postow' do 
  @posts = Post.all
  haml :lista_postow
end

get '/:id/edit' do
  @post = Post.get(params[:id])
  haml :edit
end

post '/:id/update' do
  @post = Post.get params[:id]
  @post.update(params[:posty]) 
  redirect "/lista_postow"
end

post '/:id/delete' do
  @post = Post.get(params[:id])
  @post.destroy
  redirect "/lista_postow"
end

get '/:id/view' do
  @post = Post.get params[:id]
  @comments = @post.comments
  haml :view
end

post '/comment/create' do
  @post = Post.get params[:post_id]
   Comment.create(:user=>params[:user], :body=>params[:komentarz], :post_id => params[:post_id])

  #c = Comment.new
  #c.user = params[:user]
  #c.body = params[:body]
  # c.post_id =
  #c.post = @post
  #c.save
  redirect "/#{@post.id}/view"

  # @post.comments << c
end

