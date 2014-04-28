require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper'
require 'pry'
require 'json'
require 'sinatra/partial'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :publiczny, Text
    property :created_at, DateTime
    has n, :comments
    belongs_to :category
end

class Comment
    include DataMapper::Resource
    property :id, Serial
    property :user, String
    property :body, Text
    belongs_to :post # post_id integer
    property :created_at, DateTime
end

class Category
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    has n, :posts
end

DataMapper.finalize
Post.auto_upgrade!
Comment.auto_upgrade!
Category.auto_upgrade!


if Category.count == 0
  Category.create( :title=>"Wszystkie")
end


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



#--------------------------------------------------------------
                             #POSTY
#tworzenie posta
get '/posts/new' do
  @cats = Category.all
  haml :'posts/new'
end

post '/posts/create' do
 Post.create(:title => params[:tytul], :body => params[:tresc], :category_id => params[:category_id] )

 redirect "/posts"
end

#pojedynczy post
get '/posts/:id' do
  @post = Post.get params[:id]
  @comments = @post.comments
  haml :'posts/show'
end

#wszystkie posty
get '/posts' do
  # @cats = Category.all
  @posts = Post.all
  haml :'posts/post'
end

# uczyn posta publicznym
post '/posts/:id/public' do
 @post = Post.get(params[:id])
 @post.update(:publiczny => "tak")
 content_type :json
 { :id => @post.id, :publiczny => @post.publiczny}.to_json

end


# uczyn posta niepublicznym
post '/posts/:id/notpublic' do
 @post = Post.get(params[:id])
 @post.update(:publiczny => "nie")
 content_type :json
 { :id => @post.id, :publiczny => @post.publiczny }.to_json
 # redirect "/lista_postow_publiczna"
end

# posty tylko publiczne
get '/posts/public' do
  @posts = Post.all(:publiczny => "tak")
  haml :'posts/show_public'
end


# akcje
get '/posts/:id/edit' do
  @post = Post.get(params[:id])
  haml :'posts/edit'
end

post '/posts/:id/update' do
  @post = Post.get params[:id]
  @post.update(params[:posty])
  redirect "/posts"
end

get '/posts/:id/destroy' do
  @post = Post.get(params[:id])
  @post.destroy
  content_type :json
  {:id => @post.id }.to_json
  # binding.pry
  # redirect "/lista_postow"
end

                          #COMMENTS

post '/comment/create' do
  @post = Post.get params[:post_id]
  @c = Comment.create(:user=>params[:user], :body=>params[:komentarz], :post_id => params[:post_id])
  content_type 'text/html', :charset => 'utf-8'
  haml :'comments/show', :layout => false
end

                        #CATEGORIES

get '/categories' do
  @cats = Category.all
  haml :'categories/category'
end

post '/categories/create' do
  @c = Category.create(:title=>params[:nazwa])
  content_type 'text/html', :charset => 'utf-8'
  haml :'categories/list', :layout => false
  redirect '/categories'
end

# pojedyncza kategoria
get '/categories/:id/show' do
  @cat = Category.get params[:id]
  @posts = @cat.posts
  haml :'categories/show'
end

# post '/post/:id/category_update' do
#   @post = Post.get params[:post_id]
#   @category = Category.get params[:id]
#   @post.update( @post.category << @category)
#   @post.save
# end