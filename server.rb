require 'sinatra'
require 'json'
require 'yaml'
require 'sinatra/activerecord'
require "./config/environment"
require './models/quote'

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Why you snooping, fam?\n"
  end

  def authorized?
    @config = YAML.load_file("./config/protected.yaml")
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [@config["username"], @config["password"]]
  end
end

get '/protected' do 
    protected!
    erb :admin
end

# Returns a random quote from the DB.
get '/quote' do
    content_type :json
    {:quote => KhaledQuote.order("RANDOM()").first.quote}.to_json
end 

# Adds a quote to the DB.
post '/quote' do 
    @quote = KhaledQuote.new(params[:model])
    if @quote.save
        redirect '/protected'
    else 
        "There was an error."
    end
end

# TODO: Searches for a random quote containing the word in the endpoint. Returns "Business is not booming." otherwise.
get '/:quote' do 
    params[:quote]
end

get '/' do 
    'Server is up and running.'
end
