#!/usr/bin/env ruby
require 'json'
require 'yaml'
def get_token(uaa_admin, uaa_pass, url)
    puts uaa_admin
    puts uaa_pass
    puts "#{url}/oauth/token"
    full_token = `curl "#{url}/oauth/token" -i -XPOST -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: application/json" -d "client_id=#{uaa_admin}&client_secret=#{uaa_pass}&grant_type=client_credentials&token_format=opaque&response_type=token"`
    #`curl "#{url}/oauth/token" -i -u 'login:loginsecret' -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: application/json' -d 'client_id=#{uaa_admin}&client_secret=#{uaa_pass}&grant_type=authorization_code&response_type=token&code=rIGVNz8XxN&token_format=opaque&redirect_uri=http%3A%2F%2Flocalhost%2Fredirect%2Fcf'`
    #`curl -v -XPOST -H"Application/json" -u "cf:" --data "username=#{uaa_admin}&password=#{uaa_pass}&client_id=cf&grant_type=password&response_type=token" #{url}`
    puts full_token
    #new_token = JSON.parse(full_token)
    token = full_token['access_token']
    puts token
    return token
end

#curl `"http://#{url}" -i -u 'login:loginsecret' -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: application/json' -d 'client_id=#{uaa_admin}&client_secret=#{uaa_pass}&grant_type=authorization_code&response_type=token&code=rIGVNz8XxN&token_format=opaque&redirect_uri=http%3A%2F%2Flocalhost%2Fredirect%2Fcf'`

# curl "https://uaa.sys.prod.pdc.digital.csaa-insurance.aaa.com/oauth/token" -i -u 'login:loginsecret' -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: application/json' -d 'client_id=admin&client_secret=AN_4Q0i6Xh7-WF88FiGwk5nP5tQgFPRB&grant_type=authorization_code&response_type=token&code=rIGVNz8XxN&token_format=opaque&redirect_uri=http%3A%2F%2Flocalhost%2Fredirect%2Fcf

#curl "#{url}/oauth/token" -i -X POST -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: application/json' -d 'client_id=#{uaa_admin}&client_secret=#{uaa_pass}&grant_type=client_credentials&token_format=opaque&response_type=token'
