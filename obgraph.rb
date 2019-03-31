#!/usr/bin/env ruby
require 'json'
require 'ap'
require './beedata'

require 'active_support'
require 'active_support/core_ext'

u = 'yebyenw'
g = 'ob-mirror'

url = "https://www.beeminder.com/api/v1/users/#{u}/goals/#{g}/datapoints.json"

data = IO.read('./ob-mirror.json')
result = JSON.parse(data)

# {"errors":{"auth_token":"bad_token","message":"No such auth_token found. (Did you mix up auth_token and access_token?)"}}
# if the auth message above is received back, the process should abort:
if result.present? && result.class == Hash
  e = result['errors']
  e_h = e&.keys
  if e_h.present? && e_h.include?('message')
    Kernel.abort(e['message'])
  end
# if the parse is successful, the result is an array:
elsif result.present? && result.class == Array
  beedata([result[0],result[1],result[2]])
else
  Kernel.abort('data read by JSON could not be parsed into a hash or array')
end
