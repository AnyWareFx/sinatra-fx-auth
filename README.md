# Sinatra::FxAuth

Sinatra::FxAuth is a RESTful Authentication and Role-based Authorization extension for Sinatra.
No sessions or cookies required.


## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-fx-auth'


And then execute:

    $ bundle


Or install it yourself as:

    $ gem install sinatra-fx-auth


## Usage
``` ruby
require 'sinatra/base'
require 'sinatra/fx-auth'

class MyApp < Sinatra::Base
  register Sinatra::FxAuth

  # Accessible by all
  get '/products' do
    # ...
  end

  # Requires an authenticated :admin
  put '/products/:id', :auth => :admin do
    # ...
  end

  # Requires an authenticated :admin or the :user with the given :id
  get '/customers/:id/cart', :auth => [:admin, :user] do
    # ...
  end
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request