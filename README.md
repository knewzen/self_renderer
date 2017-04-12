# SelfRenderer

Rails model & object rendering outside the context of web requests.

## Use Cases

* Serialize model in background job to send over ActionCable
* etc....

## Quick Start

```sh
gem install self_renderer
```

```ruby
require "self_renderer"

class User < ApplicationRecord
  include SelfRenderer
end
```

```ruby
# render html strings
User.find(1).render_to_html(template: "users/show.html.erb")
User.find(2).render_to_html(partial: "users/_item.html.erb")

# render json strings
User.find(3).render_to_json(template: "users/show.json.jbuilder")
User.find(4).render_to_json(partial: "users/_item.json.jbuilder")

# render ruby hashes
User.find(5).render_to_hash(template: "users/show.json.jbuilder")
User.find(6).render_to_hash(partial: "users/show.json.jbuilder")
```