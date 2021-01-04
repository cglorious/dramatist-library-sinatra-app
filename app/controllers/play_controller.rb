class PlayController < ApplicationController

  get '/plays' do
    @plays = Play.all
    erb :'plays/plays'
  end

  get '/plays/new' do
    erb :'plays/new'
  end

  post '/plays' do
    if logged_in?
      if params[:name] == "" || params[:genre] == "" || params[:synopsis] == ""
        #add error message
        redirect to '/plays/new'
      else
        #binding.pry
        #creating a Play
        @play = Play.create(name: params[:name], genre: params[:genre], synopsis: params[:synopsis], playwright_id: current_user.id)
        redirect to "/plays/#{@play.id}"
      end
    else
      redirect to '/login'
    end
  end

  get '/plays/:id' do
    if logged_in?
      @play = Play.find_by_id(params[:id])
      erb :'plays/show'
    else
      redirect to '/login'
    end
  end

  


end
