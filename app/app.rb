require 'bundler/setup'
require 'sinatra'
require 'aozora_checker'

get '/' do
  @title = "文字チェッカーR #{AozoraChecker::VERSION}"
  haml :index
end

post '/check' do
  @title = "文字チェッカーR #{AozoraChecker::VERSION}"
  @options = params["option"]
  options = @options.merge({"utf8"=>"on"})
  checker = AozoraChecker.new(options)
  checked = checker.do_check(params["text"])
  @result = checked.map{|ch| ch.to_html}.join("")
  haml :result
end
