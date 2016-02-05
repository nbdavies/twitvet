

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
  redirect '/sessions/new' if !current_user
  @report = current_user.reports.find_or_create_by(name: params[:name])
  response = @report.parse_twitter if !@report.start_date

  if response == Twitter::Error::NotFound
    @errors = ["We couldn't find that user."]
  elsif response == Twitter::Error::Unauthorized
    @errors = ["You're not authorized with our Twitter API key. That is probably our bad."]
  elsif response == Twitter::Error::RateLimited
    @errors = ["Too many requests to the Twitter API! Come back in 15 minutes."]
  end


  redirect "/reports/#{@report.id}"
end
#display specific reports
get '/reports/:id/?' do
  redirect '/sessions/new' if !current_user
  @report = Report.find_by(id: params[:id])

  erb :'reports/show'
end
#display page with edit reports
#get '/reports/:id/edit/?' do

#return a form for editing reports
#put '/reports/:id/?' do

#delete specific reports
#delete '/reports/:id/?' do
