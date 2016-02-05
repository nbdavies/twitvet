#return a HTML form for creating new users
get '/users/new/?' do
  @user = User.new
  erb :'users/new'
end

#create new users
post '/users/?' do
  @user = User.new(params[:user])
  @errors = @user.errors.full_messages
  if @user.save
    session[:user_id] = @user.id
    redirect to '/'
  else
    erb :'users/new'
  end
end

#display specific users
get '/users/:id/?' do
  @user = User.find(params[:id])
  redirect to "/" unless @user.id == session[:user_id]
  erb :'users/show'
end
