# -*- coding: utf-8 -*-
# require 'gmail'
require 'bundler'
Bundler.require
require 'yaml'

config = YAML.load_file("config.yml")
username = config["username"]
password = config["password"]

# uidでuniqに識別可能？
#   uidをファイル保存して、
gmail = Gmail.new(username, password)
@gmail = gmail
slp_mails = gmail.inbox.emails(to: "slp@messiaen.eng.kagawa-u.ac.jp")
p slp_mails_size: slp_mails.size

p slp_mails.first
p slp_mails.last.uid
@slp_mails = slp_mails

def read(mail)
  mail.body.to_s.encode("utf-8", mail.charset)  unless mail.multipart?
end


module Reader
  def read(mail)
    mail.body.to_s.encode("utf-8", mail.charset)
  end
  module_function :read
end
