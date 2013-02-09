# -*- encoding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/reloader'
require 'rack-flash'
require './model/news'
require './model/conflict_checker'
require 'erb'

class App < Sinatra::Base
  enable :method_override, :sessions
  use Rack::Flash

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html

    def edit?
      /^\/edit\/.*/ =~ request.path
    end
  end

  configure :development do
    register Sinatra::Reloader
  end

  before do
    session[:id] ||= SecureRandom.uuid
  end

  get '/' do
    @news = News.reverse_order(:created)
    @message = flash[:message]
    erb :index
  end

  delete '/' do
    News[params[:id]].delete
    flash[:message] = "Has been deleted !"
    redirect '/'
  end

  get '/add' do
    @news = News.new
    @errors = @news.errors
    erb :form
  end

  post '/add' do
    news = News.new(
      kind: params[:kind],
      title: params[:title],
      link: params[:link],
      created: Time.now,
      )

    if news.valid?
      news.save
      flash[:message] = "Was added !"
      redirect '/'
    else
      @errors = news.errors
      @news = news
      erb :form
    end
  end

  get '/edit/:id' do
    @news = News[params[:id]]
    @errors = @news.errors
    erb :form
  end

  put '/edit/:id' do
    news = News[params[:id]]
    news.kind = params[:kind]
    news.title = params[:title]
    news.link = params[:link]

    if news.valid?
      news.save
      flash[:message] = "Has been updated !"
      redirect '/'
    else
      @news = news
      @errors = news.errors
      erb :form
    end
  end

  # ログの保存と同時編集の確認
  post '/check' do
    halt "Access denied." unless request.xhr?

    cc = ConflictChecker.new
    content_type "text/plain"
    return cc.conflict?(params[:id], session[:id]) ? 'conflict' : 'safe'
  end
end
