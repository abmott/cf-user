#!/usr/bin/env ruby

require 'json'

wrkdir = Dir.pwd
params_file = File.read("#{wrkdir}/params.json")
params = JSON.parse(params_file)

env = "sandbox"

puts params["#{env}"]['target']
puts params["#{env}"]['environment']
puts params["#{env}"]['pcf_login_url']
puts params["#{env}"]['pcf_api_url']
puts params["#{env}"]['send_email_from']
puts params["#{env}"]['send_email_domain']
puts params["#{env}"]['send_email_user']
puts params["#{env}"]['send_email_api_key']

target = [ params["#{env}"]['target'], params["#{env}"]['environment'], params["#{env}"]['pcf_login_url'], params["#{env}"]['pcf_api_url'], params["#{env}"]['send_email_from'], params["#{env}"]['send_email_domain'], params["#{env}"]['send_email_user'], params["#{env}"]['send_email_api_key'] ]

print target
