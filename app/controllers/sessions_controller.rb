get '/sessions/new' do
  erb :'sessions/new'
end

post '/sessions' do
  @user = User.authenticate(params[:email], params[:password])
  if @user
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'sessions/new'
  end
end

delete '/sessions' do
  session[:user_id] = nil
  redirect '/'
end
