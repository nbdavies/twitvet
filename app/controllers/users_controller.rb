#return a HTML form for creating new users
get '/users/new/?' do
  erb :'users/new'
end

#create new users
post '/users/?' do
  erb :'users/create'
end

#display specific users
get '/users/:id/?' do
  erb :'users/show'
end

#display page with edit users
get '/users/:id/edit/?' do
  erb :'users/edit'
end

#return a form for editing users
put '/users/:id/?' do
  erb :'users/update'
end
