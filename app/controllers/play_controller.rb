class PlayController < ApplicationController

  get '/plays' do
    @plays = Play.all
    erb :'plays/plays'
  end

  get '/plays/new' do
    erb :'plays/new'
  end

  post '/plays' do
    "You made a new play."
  end

end
