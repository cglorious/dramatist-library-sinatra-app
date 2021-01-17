class PlaywrightController < ApplicationController

  get '/admin/index' do
    @plays = Play.all
    erb :'playwrights/admin/index'
  end

  get '/login' do
    if !logged_in?
      erb :'playwrights/login'
    else
      redirect to '/admin/index'
    end
  end

  post '/login' do
    playwright = Playwright.find_by(email: params[:email])
    if playwright && playwright.authenticate(params[:password])
      session[:user_id] = playwright.id
      if current_user.bio
        redirect to '/admin/index'
      else
        redirect to '/bio'
      end
    else
      redirect to '/signup'
    end
  end

  get '/bio' do
    @playwright = Playwright.find(current_user.id)
    erb :'playwrights/bio'
  end

  post '/bio' do
    current_user.update(bio: params[:bio])
    redirect to '/admin/index'
  end

  get '/signup' do
    if !logged_in?
      erb :'playwrights/signup'
    else
      redirect to '/admin/index'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @playwright = Playwright.create(name: params[:name], email: params[:email], password: params[:password])
      session[:user_id] = @playwright.id
      redirect to '/bio'
    end
  end

  get '/admin/settings' do
    @playwright = Playwright.find(current_user.id)
    erb :'playwrights/admin/settings'
  end

  patch '/settings' do
    @playwright = Playwright.find(current_user.id)
    if logged_in?
      @playwright.update(name: params[:name], email: params[:email], bio: params[:bio])
      @playwright.save
      redirect to '/admin/index'
    else
      erb :'playwrights/login'
    end
  end

  get '/playwrights/index' do
    erb :'playwrights/index'
  end

  get '/playwrights/:id' do
    @playwright = Playwright.find(params[:id])
    erb :'/playwrights/show'
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/logout'
    else
      redirect to '/'
    end
  end

end
