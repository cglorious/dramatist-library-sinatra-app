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
      #ActiveModel::Dirty; _changed? on params
      if params[:name] == "" || params[:genre] == "" || params[:synopsis] == ""
        #add error message
        redirect to '/plays/new'
      else
        @play = Play.create(name: params[:name], genre: params[:genre], synopsis: params[:synopsis], playwright_id: current_user.id)
        redirect to "/plays/#{@play.id}"
      end
    else
      redirect to '/login'
    end
  end

  get '/plays/:id' do
    if logged_in?
      @play = Play.find(params[:id])
      erb :'plays/show'
    else
      redirect to '/login'
    end
  end

  get '/plays/:id/edit' do
    if logged_in?
    @play = Play.find(params[:id])
      if @play && @play.playwright == current_user
        erb :'plays/edit'
      else
        redirect to '/plays'
      end
    else
      redirect to '/login'
    end
  end

  patch '/plays/:id' do
    @play = Play.find(params[:id])
    if logged_in?
      if params[:name] == "" || params[:genre] == "" || params[:synopsis] == ""
        redirect to "/plays/#{params[:id]}/edit"
      #alternate way to check if params are changed
      elsif params[:name] == @play.name && params[:genre] == @play.genre && params[:synopsis] == @play.genre
        redirect to '/plays'
      else
        @play.update(name: params[:name], genre: params[:genre], synopsis: params[:synopsis])
        @play.save
        redirect to "/plays/#{@play.id}"
      end
    else
      redirect to '/login'
    end
  end

  delete '/plays/:id' do
    if logged_in?
      @play = Play.find(params[:id])
      if @play && @play.playwright == current_user
        @play.delete
      end
      redirect to '/plays'
    else
      redirect to '/login'
    end
  end


end
