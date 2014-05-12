require 'rubygems'
require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/db.sqlite")

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
end


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
    property :title, String, :required=> true
    has n, :posts
end

DataMapper.finalize
DataMapper.auto_upgrade!

