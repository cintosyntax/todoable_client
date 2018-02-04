# Todoable Client ![alt text](https://travis-ci.org/cintosyntax/todoable_client.svg?branch=master "Build Status")

A basic API wrapper client to access Todoable service

# Usage

Initialize a client and perform the call

```ruby
client = Todoable::Client.new('username', 'password')
client.get_lists
# =>
# {
#     :status_code=>200,
#     :success=>true,
#     :data=> {
#         "lists"=> [
#             {
#                 "name"=>"milk",
#                 "src"=>"http://todoable.teachable.tech/api/lists/bd57072f-dc8c-44bf-9017-95da8fb6939b",
#                 "id"=>"bd57072f-dc8c-44bf-9017-95da8fb6939b"
#             },
#             {
#                 "name"=>"cheese",
#                 "src"=>"http://todoable.teachable.tech/api/lists/6b854468-2e18-4646-aaa0-4b6738811be9",
#                 "id"=>"6b854468-2e18-4646-aaa0-4b6738811be9"
#             }
#         ]
#     }
# }
```

# Handling Invalid Credentials

If authentication fails because of invalid credentials it raises a `Todoable::Errors::InvalidCredentials`.