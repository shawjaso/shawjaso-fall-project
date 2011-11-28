require 'sinatra'
require 'mogli'
require 'haml'

enable :sessions
set :raise_errors, true
set :show_exceptions, true

FACEBOOK_SCOPE = ''


unless ENV["FACEBOOK_APP_ID"] && ENV["FACEBOOK_SECRET"]
  abort("Missing ENV variables: Please set FACEBOOK_APP_ID and FACEBOOK_SECRET with your app credentials.")
end


before do
  if settings.environment == :production && request.scheme != 'https'
    redirect "https://#{request.env['HTTP_HOST']}"
  end
end


helpers do
  def url(path)
    base = "#{request.scheme}://#{request.env['HTTP_HOST']}"
    base + path
  end

  def authenticator
    @authenticator ||= Mogli::Authenticator.new(ENV["FACEBOOK_APP_ID"], ENV["FACEBOOK_SECRET"], url("/auth/facebook/callback"))
  end

end


error(Mogli::Client::HTTPException) do
  session[:at] = nil
  redirect "/auth/facebook"
end


get '/' do
  redirect "/auth/facebook" unless session[:at]
  @client = Mogli::Client.new(session[:at])

  @client.default_params[:limit] = 15

  @app = Mogli::Application.find(ENV["FACEBOOK_APP_ID"], @client)
  @user = Mogli::User.find("me", @client)
  # TODO Add user to db

  @friends_hash = Hash.new
  @friends_query = @client.fql_query("SELECT uid, name FROM user WHERE uid in (SELECT uid2 FROM friend WHERE uid1 = me())")
  @friends_query.each do |result|
    @friends_hash[result["uid"]] = result["name"]
  end

  # TODO: Add code to sort hash
  #@friends_hash.sort {|uid,name| uid[1]<=>name[1]}
  haml :select_friends 
end


post '/' do
  redirect "/"
end


get '/close' do
  "<body onload='window.close();'/>"
end


get '/auth/facebook' do
  session[:at] = nil
  redirect authenticator.authorize_url(:scope => FACEBOOK_SCOPE, :display => 'page')
end


get '/auth/facebook/callback' do
  client = Mogli::Client.create_from_code_and_authenticator(params[:code], authenticator)
  session[:at] = client.access_token
  redirect '/'
end


post '/set_urls' do
  friends = params["friend"]
  # TODO Get owner
  if friends.nil? or friends.count == 0
    redirect '/'
  end
  # TODO Write friends to db
end

