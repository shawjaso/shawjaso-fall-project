require 'sinatra'
require 'mogli'
require 'haml'
require_relative 'db'

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

  @db_user = Owner.find_by_fb_id(@user.id)
  if @db_user.nil? == true
    @db_user = Owner.new
    @db_user.name = @user.name
    @db_user.fb_id = @user.id
    @db_user.save
  end

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
  @owner_id = params["owner_id"]
  friends = params["friend"]
  if friends.nil? or friends.count == 0
    redirect '/'
  end
  @friend_array = Array.new
  friends.each do |f|
    friend_result = Friend.where("fb_id = ? AND owner_id = ?", f, @owner_id)
    friend = Friend.new
    if friend_result.nil? == true or friend_result.count == 0
      friend.fb_id = f
      friend.owner_id = @owner_id
      friend.save
    else 
      friend = friend_result[0]
    end
    @friend_array << friend.id
  end

  haml :set_urls
end


post '/completed' do
    owner_id = params["owner_id"]
    friend_ids = params["friend_id"]
    auth_url = params["auth_url"]
    unauth_url = params["unauth_url"]

    @link = Link.new
    @link.owner_id = owner_id
    @link.auth_url = auth_url
    @link.unauth_url = unauth_url
    @link.save

    friend_ids.each do |friend_id|
      permission = Permission.new
      permission.link_id = @link.id
      permission.friend_id = friend_id
      permission.save
    end

    haml :completed
end


get '/fwlink/:link_id' do
  redirect "/auth/facebook" unless session[:at]
  @client = Mogli::Client.new(session[:at])

  @client.default_params[:limit] = 15

  @app = Mogli::Application.find(ENV["FACEBOOK_APP_ID"], @client)
  @user = Mogli::User.find("me", @client)

  link_id = params[:link_id]
  link = Link.find(link_id)
  friend = Friend.find_by_fb_id(@user.id) 
  if friend.nil?
    owner = Owner.find_by_fb_id(@user.id)
    if owner.nil?
      redirect link.unauth_url
    else
      redirect link.auth_url
    end
  end

  permissions = Permissions.where("link_id = ? AND friend_id = ?", link_id, friend.id)
  if permissions.nil? or permissions.count != 1
    redirect link.unauth_url
  else
    redirect link.auth_url
  end
end

