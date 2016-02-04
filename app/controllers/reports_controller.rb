#list of all reports
get '/reports/?' do
  erb :'reports/index'
end
#return a HTML form for creating new reports
get '/reports/new/?' do
  erb :'reports/new'
end
#create new reports
post '/reports/?' do
  erb :'reports/create'
end
#display specific reports
get '/reports/:id/?' do
  erb :'reports/show'
end
#display page with edit reports
get '/reports/:id/edit/?' do
  erb :'reports/edit'
end
#return a form for editing reports
put '/reports/:id/?' do
  erb :'reports/update'
end
#delete specific reports
delete '/reports/:id/?' do
  erb :'reports/destroy'
end