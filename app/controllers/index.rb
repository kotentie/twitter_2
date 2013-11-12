get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  session[:token] = @access_token.token
  session[:secret] = @access_token.secret
  # at this point in the code is where you'll need to create your user account and store the access token
  erb :index


end

post '/users/new' do

User.create(username: params[:username], oauth_secret: session[:secret], oauth_token: session[:token])


 @user = Twitter::Client.new(
  :oauth_token => session[:token],
  :oauth_token_secret => session[:secret])

@user.update(params[:tweet_text])
redirect to('/tweet')

end


get '/tweet' do

erb :tweet

end