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
    redirect to :'/'
  else
    redirect to :'/'
  end
end

#display specific users
get '/users/:id/?' do
  erb :'users/show'
end
