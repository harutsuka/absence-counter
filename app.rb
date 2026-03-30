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

DAY_JP = {
  "Monday" => "月曜日",
  "Tuesday" => "火曜日",
  "Wednesday" => "水曜日",
  "Thursday" => "木曜日",
  "Friday" => "金曜日",
  "Saturday" => "土曜日",
}

get '/' do
  if session[:user_id]
    if params[:day]
      @subject = Subject.where("day LIKE ? ", "%#{params[:day]}%").where(user_id: session[:user_id]).order(:id)
    else
      @subject = Subject.where(user_id: session[:user_id]).order(:id)
    end
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
    password: params[:password]
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
    absent_count: 0,
    day: params[:day]
  )
  if subject.persisted?
    redirect '/'
  else
    redirect '/register'
  end
end

post '/record_absence/:id' do
  subject = Subject.find(params[:id])
  subject.update(absent_count: subject.absent_count+1)
  redirect '/'
end

get '/settings' do
  @absent_ratio = User.find(session[:user_id]).absent_ratio
  erb :settings
end

post '/settings' do
  user = User.find(session[:user_id])
  user.update(absent_ratio: params[:absent_ratio])
  redirect '/settings'
end

post '/edit/:id' do
  subject = Subject.find(params[:id])
  subject.update(
    name: params[:subject_name],
    class_count: params[:class_count],
    absent_count: params[:absent_count],
    day: params[:day]
  )
  redirect '/'
end
get '/delete/:id' do
  subject = Subject.find(params[:id])
  subject.destroy
  redirect '/'
end
