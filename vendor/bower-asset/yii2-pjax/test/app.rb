require 'sinatra'
require 'json'

set :public_folder, File.dirname(settings.root)
enable :static

helpers do
  def pjax?
    env['HTTP_X_PJAX'] && !params[:layout]
  end

  def title(str)
    if pjax?
      "<title>#{str}</title>"
    else
      @title = str
      nil
    end
  end
end

after do
  if pjax?
    response.headers['X-PJAX-URL'] ||= request.url
    response.headers['X-PJAX-Version'] = 'v1'
  end
end


get '/' do
  erb :qunit
end

get '/env.html' do
  erb :env, :layout => !pjax?
end

post '/env.html' do
  erb :env, :layout => !pjax?
end

put '/env.html' do
  erb :env, :layout => !pjax?
end

delete '/env.html' do
  erb :env, :layout => !pjax?
end

get '/redirect.html' do
  if params[:anchor]
    path = "/hello.html##{params[:anchor]}"
    if pjax?
      response.headers['X-PJAX-URL'] = uri(path)
      status 200
    else
      redirect path
    end
  else
    redirect "/hello.html"
  end
end

get '/timeout.html' do
  if pjax?
    sleep 1
    erb :timeout, :layout => false
  else
    erb :timeout
  end
end

post '/timeout.html' do
  if pjax?
    sleep 1
    erb :timeout, :layout => false
  else
    status 500
    erb :boom
  end
end

get '/boom.html' do
  status 500
  erb :boom, :layout => !pjax?
end

get '/boom_sans_pjax.html' do
  status 500
  erb :boom_sans_pjax, :layout => false
end

get '/:page.html' do
  erb :"#{params[:page]}", :layout => !pjax?
end

get '/some-&-path/hello.html' do
  erb :hello, :layout => !pjax?
end
