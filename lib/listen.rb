require 'sinatra'
require "sinatra/reloader"
require 'pry'
require 'json'
require 'client'
require 'comment_formatter'
require 'message_parser'

class GithubTrello < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    erb "<h1>It works!</h1>" +
        "<div>But you should add the url: '#{base_url}/payload' to your git repo web hooks to integrate it with your Trello board.</div>"
  end

  post '/payload' do
    if params[:payload]
      push = JSON.parse(params[:payload])

      short_code = MessageParser.trello_short_code(push['head_commit']['message'])
      @card = Trello::Card.find(short_code) if short_code

      if short_code && @card
        author = push['head_commit']['author']['name']
        message = push['head_commit']['message']
        compare_url = push['compare']
        comment = CommentFormatter.new.formatted_comment(author, message, compare_url)
        @card.add_comment(comment)
      end
    end
  end

  private

  def base_url
    @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
  end
end
