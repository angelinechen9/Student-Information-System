require 'dm-core'
require 'dm-migrations'
require 'sinatra'

class Student
    include DataMapper::Resource
    property :firstname, String
    property :lastname, String
    property :birthday, Date
    property :address, String
    property :id, Serial
end

#show all students
get '/students' do
    halt(401, 'Not Authorized') unless session[:admin]
    @students = Student.all
    erb :students
end

#create new student
get '/students/new' do
    halt(401, 'Not Authorized') unless session[:admin]
    erb :new_student
end

#create new student
post '/students' do
    halt(401, 'Not Authorized') unless session[:admin]
    @student = Student.new(
        :firstname=>params[:firstname],
        :lastname=>params[:lastname],
        :birthday=>params[:birthday],
        :address=>params[:address]
    )
    @student.save
    redirect "/students/#{@student.id}"
end

#show student
get '/students/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    @student = Student.get(params[:id])
    erb :show_student
end

#delete student
delete '/students/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    Student.get(params[:id]).destroy
    redirect '/students'
end

#edit student
get '/students/:id/edit' do
    halt(401, 'Not Authorized') unless session[:admin]
    @student = Student.get(params[:id])
    erb :edit_student
end

#edit student
put '/students/:id' do
    halt(401, 'Not Authorized') unless session[:admin]
    @student = Student.get(params[:id]).update(
        :firstname=>params[:firstname],
        :lastname=>params[:lastname],
        :birthday=>params[:birthday],
        :address=>params[:address]
    )
    redirect "/students/#{params[:id]}"
end