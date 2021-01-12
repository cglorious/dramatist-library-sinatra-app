class PlayController < ApplicationController

  get '/home' do
    #within the Playwright
    @plays = Play.all
    erb :'plays/home'
  end

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

      #if params[:name] == "" || params[:genre] == "" || params[:synopsis] == ""
      #  redirect to '/plays/new'
      #else
      #  @play = Play.create(name: params[:name], genre: params[:genre], synopsis: params[:synopsis], playwright_id: current_user.id)
      #  redirect to "/plays/#{@play.id}"
      #end
    else
      redirect to '/login'
    end
  end

  get '/plays/show/all' do
    #plays/index
    erb :'plays/show/all'
  end

  get '/plays/:id' do
    if logged_in?
      @play = Play.find(params[:id])
      erb :'plays/show/show'
    else
      redirect to '/login'
    end
  end

  get '/plays/more/:id' do
    #nested routing, playwrights/:id/plays
    @play = Play.find(params[:id])
    @playwright = Playwright.find(@play.playwright_id)
    erb :'plays/show/more'
  end

  get '/plays/:id/edit' do
    if logged_in?
    @play = Play.find(params[:id])
      if @play && @play.playwright == current_user
        erb :'plays/edit'
      else
        redirect to '/home'
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
      redirect to '/home'
    else
      redirect to '/login'
    end
  end


end
