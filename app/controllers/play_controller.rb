class PlayController < ApplicationController

  get '/plays/new' do
    erb :'plays/new'
  end

  post '/plays' do
    if logged_in?
      @play = current_user.plays.build(name: params[:name], genre: params[:genre], synopsis: params[:synopsis])
      if @play.save
        redirect to "/plays/#{@play.id}"
      else
        erb :'plays/new'
      end
    else
      redirect to '/login'
    end
  end

  get '/plays/index' do
    erb :'plays/index'
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
        redirect to '/index'
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
      redirect to '/index'
    else
      redirect to '/login'
    end
  end

end
