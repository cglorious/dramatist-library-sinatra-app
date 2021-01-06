class PlaywrightController < ApplicationController

  get '/login' do
    if !logged_in?
      erb :'playwrights/login'
    else
      redirect to '/plays'
    end
  end

  post '/login' do
    playwright = Playwright.find_by(email: params[:email])
    if playwright && playwright.authenticate(params[:password])
      session[:user_id] = playwright.id
      if params[:bio] = nil || ""
        redirect to '/bio'
      else
        redirect to '/plays'
      end
    else
      redirect to '/signup'
    end
  end

  get '/bio' do
    erb :'playwrights/bio'
  end

  post '/bio' do
    current_user.update(bio: params[:bio])
    current_user.save
    redirect to '/plays'
  end

  get '/signup' do
    if !logged_in?
      erb :'playwrights/signup'
    else
      redirect to '/plays'
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

  get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/logout'
    else
      redirect to '/'
    end
  end

end
