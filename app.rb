require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'pry'

enable :sessions

set :root, File.expand_path(__dir__) # app.rb のあるディレクトリをrootに指定
set :views, File.join(settings.root, 'views')

set :bind, '0.0.0.0'
set :port, 4567

get '/' do
  if session[:user_id]
    @subject = Subject.where(user_id: session[:user_id]).order(:id)
    @user = User.find(session[:user_id])
    erb :index
  else
    redirect '/login'
  end
end

get '/signup' do
  erb :sign_up
end
get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(email: params[:email])
  
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect '/'
  else
    erb :login
  end
end

post '/signup' do
  user = User.create(
    email: params[:email],
    password: params[:password],
    absent_ratio: params[:absent_ratio]
  )
  if user.persisted?
    session[:user_id] = user.id
    redirect '/'
  else
    redirect '/signup'
  end
end

get '/logout' do
  session.clear
  redirect '/login'
end

get '/subject-register' do
  erb :register
end
post '/subject-register' do
  subject = Subject.create(
    name: params[:subject_name],
    class_count: params[:class_count],
    user_id: session[:user_id],
    absent_count: 0
  )
  if subject.persisted?
    redirect '/'
  else
    redirect '/register'
  end
end

get '/settings' do
  erb :settings
end

post '/record_absence/:id' do
  subject = Subject.find(params[:id])
  subject.update(absent_count: subject.absent_count+1)
  redirect '/'
end

post '/settings' do
  user = User.find(session[:user_id])
  user.update(absent_ratio: params[:absent_ratio])
  redirect '/settings'
end