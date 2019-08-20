require 'dm-core'
require 'dm-migrations'
require 'sinatra'

class Comment
    include DataMapper::Resource
    property :name, String
    property :timestamp, Date
    property :content, String
    property :firstname, String
    property :lastname, String
    property :id, Serial
end

#show all comments
get '/comments' do
    halt(401, 'Not Authorized') unless session[:admin]
    @comments = Comment.all
    erb :comments
end

#create new comment
get '/comments/new' do
    halt(401, 'Not Authorized') unless session[:admin]
    erb :new_comment
end

#create new comment
post '/comments' do
    halt(401, 'Not Authorized') unless session[:admin]
    @comment = Comment.new(
        :name=>params[:name],
        :timestamp=>Time.now,
        :content=>params[:content],
        :firstname=>session[:firstname],
        :lastname=>session[:lastname]
    )
    @comment.save
    redirect "/comments/#{@comment.id}"
end

#show comment
get '/comments/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    @comment = Comment.get(params[:id])
    erb :show_comment
end

#delete comment
delete '/comments/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    Comment.get(params[:id]).destroy
    redirect '/comments'
end

#edit comment
get '/comments/:id/edit' do
    halt(401, 'Not Authorized') unless session[:admin]
    @comment = Comment.get(params[:id])
    erb :edit_comment
end

#edit comment
put '/comments/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    @comment = Comment.get(params[:id]).update(
        :name=>params[:name],
        :timestamp=>Time.now,
        :content=>params[:content],
        :firstname=>session[:firstname],
        :lastname=>session[:lastname]
    )
    redirect "/comments/#{params[:id]}"
end