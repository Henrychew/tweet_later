


get '/' do
  @current_user = current_user


  erb :index
end

get '/create' do
  erb :create
end

post '/create' do

  User.create(params[:user])
  redirect to "/"
end


get '/login' do

  erb :login
end

post '/status/:job_id' do
  # return the status of a job to an AJAX call
  if job_is_complete(params[:job_id])
    return "true"
  else
    return "false"
  end
end



post '/login' do
  user = User.find_by(username: params[:user][:username])

  if user.authenticate?(params[:user][:password])
    session[:user_id] = user.id
  end

  if user.access_token?
    connect_twitter
  end

  redirect to "/"
end


post '/new' do



  if params[:option] && params[:option] == "delay5minute"
    puts "[LOG] We going to delay 5 minutes "
    job_id = User.find(session[:user_id]).tweet_delay_5minute(params[:tweet_textarea])
  else
    job_id = User.find(session[:user_id]).tweet(params[:tweet_textarea])
  end


end

get '/logout' do

  session.clear
  redirect to "/"
end


get '/auth/twitter/callback' do

  # probably you will need to create a user in the database too...
  @current_user = current_user
  @current_user.oauth_token = env['omniauth.auth']['credentials']['token']
  @current_user.oauth_secret = env['omniauth.auth']['credentials']['secret']
  @current_user.save

  # this is the main endpoint to your application
  redirect to('/')
end

get '/auth/failure' do
  # omniauth redirects to /auth/failure when it encounters a problem
  # so you can implement this as you please
  puts "[ERROR] fail to authenticate #{params}"
end


