#!/usr/bin/env ruby
def send_onlyaccount_email(emailaddr, env, pcf_login_url, pcf_api_url, send_email_from, send_email_domain, send_email_user, send_email_api_key, smtp_endpoint)
require 'net/smtp'
#emailaddr = "Adam.Mott@csaa.com"
#password = "this&^*(the&*(**pass))"

#get name form email address
namearray = emailaddr.split(/\@/)
namestring = namearray[0].to_s
name = namestring.gsub(".", " ")
#puts fullname

#check for short userrole value and give real value
case env
when "prod"
  login_url = "Prod - #{pcf_login_url}"
  api_url = "Prod - cf login -a #{pcf_api_url}"
when "backup"
  login_url = "GDC - URL_TO_BE"
  api_url = "GDC - cf login -a API_ENDPOINT_TO_BE"
when "sandbox"
  login_url = "Sandbox - #{pcf_login_url}"
  api_url = "Sandbox - cf login -a #{pcf_api_url}"
else
  login_url = ""
  api_url = ""
end



account_email = <<MESSAGE_END
From: #{send_email_from}
To: #{name} <#{emailaddr}>
MIME-Version: 1.0
Content-type: text/html
Subject: PCF Account

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dutf-8">
</head>
<body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-=
break: after-white-space; color: rgb(0, 0, 0); font-size: 14px; font-family:=
 Calibri, sans-serif;">
<div>
<div>#{name},</div>
<div><br>
</div>
<div>An account has been created for you. Your password will be in a seperate email to follow.</div>
<div>When you login you will not be assigned to any projects at this time.</div>
<div>An additional email will follow with more details once project spaces are defined.</div>
<div>Once defined you will see available spaces upon login.</div>
<div><br>
</div>
<div>username: #{emailaddr}</div>
<div><br>
</div>
<div>The URL to access the App Space is:</div>
<div>#{login_url}</div>
<div><br>
</div>
<div>To access by command line use:</div>
<div>#{api_url}</div>
<div><br>
</div>
<div>Thank you,</div>
<div><br>
</div>
<div>Dev-Ops Team</div>
</div>
</body>
</html>
MESSAGE_END

def emailnotify(emailaddr, email, send_email_from, send_email_domain, send_email_user, send_email_api_key, smtp_endpoint)
smtp = Net::SMTP.new "#{smtp_endpoint}", 465
smtp.enable_ssl
smtp.start("#{send_email_domain}", "#{send_email_user}", "#{send_email_api_key}", :login) do |smtp|
   smtp.send_message email, "#{send_email_from}", "#{emailaddr}"
end

end

emailnotify("#{emailaddr}", "#{account_email}", "#{send_email_from}", "#{send_email_domain}", "#{send_email_user}", "#{send_email_api_key}", "#{smtp_endpoint}")

end
