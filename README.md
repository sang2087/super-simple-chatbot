# Super Simple Chatbot with Sinatra, IBM conversation


## Installation

```
gem install sinatra
gem install thin
gem install watson
gem install watson-conversation
```

create `env.rb` file in the same folder as `chatbot.rb` and fill it out as follows

```
ENV['username'] = "YOUR IBM CONVERSATION USERNAME"
ENV['password'] = "YOUR IBM CONVERSATION PASSWORD"
ENV['workspace_id'] = "YOUR IBM CONVERSATION WORKSPACE_ID"
```

basic sinatra chat code from [https://github.com/sinatra/sinatra/blob/master/examples/chat.rb](https://github.com/sinatra/sinatra/blob/master/examples/chat.rb)
