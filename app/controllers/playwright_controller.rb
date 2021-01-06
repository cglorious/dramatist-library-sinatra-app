class PlaywrightController < ApplicationController

  get '/login' do
    if !logged_in?
      erb :'playwrights/login'
    else
      redirect to '/home'
    end
  end

  post '/login' do
    playwright = Playwright.find_by(email: params[:email])
    if playwright && playwright.authenticate(params[:password])
      session[:user_id] = playwright.id
      if current_user.bio
        redirect to '/home'
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
    current_user.save
    redirect to '/home'
  end

  get '/signup' do
    if !logged_in?
      erb :'playwrights/signup'
    else
      redirect to '/home'
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

  get '/settings' do
    @playwright = Playwright.find(current_user.id)
    erb :'playwrights/settings'
  end

  patch '/settings' do
    @playwright = Playwright.find(current_user.id)
    if logged_in?
      @playwright.update(name: params[:name], email: params[:email], bio: params[:bio])
      @playwright.save
      redirect to '/home'
    else
      erb :'playwrights/login'
    end
  end

  get '/playwrights/show/all' do
    erb :'playwrights/show/all'
  end

  get '/playwrights/:id' do
    @playwright = Playwright.find(params[:id])
    erb :'/playwrights/show/show'
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
