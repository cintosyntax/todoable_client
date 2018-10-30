# Todoable Client [![Build Status](https://travis-ci.org/edwinthinks/todoable_client.svg?branch=master)](https://travis-ci.org/edwinthinks/todoable_client)

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

# Fetch single list record
client.get_list(id)

# Create list with name provided
client.create_list(name)

# Delete list specified by the id provided
client.delete_list(list_id)

# Create a item for a list specified by the id provided
client.create_list_item(list_id, name)

# Updates a item for a list to finished specified by the list id and item id
client.finish_list_item(list_id, item_id)

# Delete a item for a list specified by the list id and item id
client.delete_list_item(list_id, item_id)
```

# Handling Invalid Credentials

If authentication fails because of invalid credentials it raises a `Todoable::Errors::InvalidCredentials`.
