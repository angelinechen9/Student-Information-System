require 'sinatra'
require_relative 'student.rb'
require_relative 'comment.rb'

configure :development do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/assignment2.db")
end

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
end

configure do
    DataMapper.finalize
    DataMapper.auto_upgrade!
    enable :sessions
end

get '/' do
    if (session[:admin])
        erb :index
    else
        redirect '/login'
    end
end

get '/video' do
    erb :video
end

get '/login' do
    erb :login, :layout=>false
end

post '/login' do
    session[:admin] = true
    session[:firstname] = params[:firstname]
    session[:lastname] = params[:lastname]
    redirect '/'
end

get '/logout' do
    session.clear
    redirect '/login'
end