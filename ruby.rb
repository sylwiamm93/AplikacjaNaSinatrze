require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :created_at, DateTime
end
DataMapper.finalize
Post.auto_upgrade!

#set :layout_engine => :erb, :layout => :index
# akcja, route /
get '/' do
  haml :index
#  'Hello world!'
end

#akcja pod route, /o-mnie
get '/o-mnie' do
  'Jestem Sylwia!!'
  haml :index
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
  haml :view
end


