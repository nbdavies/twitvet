

#list of all reports - non-public, for testing only
get '/reports/?' do
  @reports = Report.all
  erb :'reports/index'
end
#return a HTML form for creating new reports
get '/reports/new/?' do
  redirect '/' if !current_user
  erb :'reports/new'
end
#create new reports
post '/reports/?' do
  @report = Report.new(name: params[:name])
  @report.parse_twitter
  redirect "/reports/#{@report.id}"
end
#display specific reports
get '/reports/:id/?' do
  redirect '/' if !current_user
  @report = Report.find_by(id: params[:id])
  erb :'reports/show'
end
#display page with edit reports
#get '/reports/:id/edit/?' do

#return a form for editing reports
#put '/reports/:id/?' do

#delete specific reports
#delete '/reports/:id/?' do
