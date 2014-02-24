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

# akcja, route /
get '/' do
  'Hello world!'
end

#akcja pod route, /o-mnie
get '/o-mnie' do
  'Jestem Sylwia!!'
end

get '/hello/:name' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params[:name] is 'foo' or 'bar'
  "Hello #{params[:name]}!"
end

get '/formularz' do
	erb :formularz
end

get '/petla' do
	erb :petla
end


get '/lista_postow' do
	lista = { :imie => "Sylwia", :age => "20" }
	haml :lista_postow, :locals => { :hash => lista }		
end

get '/posty' do
	erb :posty
end

get '/posty/nowy' do
	erb :nowy_post
end

post '/posty/utworz' do

	erb :nowy_post
end


post '/oblicz' do
a = params[:liczba1].to_i
b = params[:liczba2].to_i
(a*b).to_s
end