require 'sinatra'
# require 'sinatra/reloader'
require 'dm-sqlite-adapter'
require 'data_mapper'
require 'pry'
require 'json'
require 'sinatra/partial'
require 'bundler'
Bundler.require
require './model'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class SinatraWardenExample < Sinatra::Base
  use Rack::Session::Cookie, secret: "nothingissecretontheinternet"
  use Rack::Flash, accessorize: [:error, :success]

  use Warden::Manager do |config|
  config.serialize_into_session{|user| user.id }
  config.serialize_from_session{|id| User.get(id) }
  config.scope_defaults :default,
    strategies: [:password],
    action: 'auth/unauthenticated'
  config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
      env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
      def valid?
        params['user']['username'] && params['user']['password']
      end

      def authenticate!
        user = User.first(username: params['user']['username'])

        if user.nil?
          fail!("The username you entered does not exist.")
          flash.error = ""
        elsif user.authenticate(params['user']['password'])
          flash.success = "Successfully Logged In"
          success!(user)
        else
          fail!("Could not log in")
        end
      end
  end
end



if Category.count == 0
  Category.create( :title=>"Wszystkie")
end


#set :layout_engine => :erb, :layout => :index
# akcja, route /
# get '/' do
#   haml :index
# #  'Hello world!'
# end

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
<<<<<<< HEAD
 Post.create(:title=>params[:tytul], :body=>params[:tresc], :category_id=>params[:category_id])
=======
 Post.create(:title => params[:tytul], :body => params[:tresc], :category_id => params[:category_id] )

>>>>>>> 0b86ae2f21b6c92c09f830c5c0048457c0889929
 redirect "/posts"
end

#pojedynczy post
get '/posts/:id' do
  @post = Post.get params[:id]
  # binding.pry
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
<<<<<<< HEAD
get '/' do 
=======
get '/posts/public' do
>>>>>>> 0b86ae2f21b6c92c09f830c5c0048457c0889929
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

# ------LOGOWANIE

get '/auth/login' do 
  haml :login
end
