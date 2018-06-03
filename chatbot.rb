# coding: utf-8
# basic sinatra chat code from 'https://github.com/sinatra/sinatra/blob/master/examples/chat.rb'
require 'sinatra'
require 'watson'
require './env' if File.exists?('env.rb')
set :server, 'thin'
connections = []
client = Watson::Conversation.new

Watson::Conversation.configure(
  username: ENV["username"],
  password: ENV["password"],
  workspace_id: ENV["workspace_id"],
  url:      'https://gateway.watsonplatform.net/conversation/api',
)

get '/' do
  halt erb(:login) unless params[:user]
  erb :chat, :locals => { :user => params[:user]}
end

get '/stream', :provides => 'text/event-stream' do
  stream :keep_open do |out|
    connections << out
    out.callback { connections.delete(out) }
  end
end

post '/' do
  response = client.send_message(params[:msg])
  puts response
  connections.each { |out| out << "data: watson: #{response[:body][0]}\n\n" }
  204 # response without entity body
end

__END__

@@ layout
<html>
  <head>
    <title>Super Simple Chatbot with Sinatra</title>
    <meta charset="utf-8" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
  </head>
  <body><%= yield %></body>
</html>

@@ login
<form action='/'>
  <label for='user'>User Name:</label>
  <input name='user' value='' />
  <input type='submit' value="GO!" />
</form>

@@ chat
<pre id='chat'></pre>
<form>
  <input id='msg' placeholder='type message here...' />
</form>

<script>
  // reading
  var es = new EventSource('/stream');
  es.onmessage = function(e) { $('#chat').append(e.data + "\n") };

  // writing
  $("form").on('submit',function(e) {
    $("#chat").append("<%= user %>: " + $("#msg").val()+"\n")

    $.post('/', {user: "<%= user %>" , msg:  $('#msg').val()});
    $('#msg').val(''); $('#msg').focus();
    e.preventDefault();
  });
</script>

