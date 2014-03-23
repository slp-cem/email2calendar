# -*- coding: utf-8 -*-
%w(yaml base64 kconv).each do |lib|
  require lib
end

require 'bundler'
Bundler.require

config = YAML.load_file("config.yml")
username = config["username"]
password = config["password"]
#----
filter = { to: "slp@messiaen.eng.kagawa-u.ac.jp", from: "-amazon"}
@reg = /^■\s*予定.*/m

module Gmail
  class Message
    def read
      unless multipart?
        body.to_s.toutf8
      else
        text_part.decoded
      end
    end
    def subject
      super.toutf8
    end
  end
end

# uidでuniqに識別可能？
#   uidをファイル保存して、
gmail = Gmail.new(username, password)
@gmail = gmail

# slp_mails = gmail.inbox.emails(filter).lazy.select{ |m| m.subject.toutf8.include? "活動" }.select { |m| m.read.include? "予定" }
slp_mails = gmail.inbox.emails(filter).lazy.select{ |m| m.subject.include? "活動" }.select { |m| m.read.include? "予定" }

p slp_mails_size: slp_mails.size

@slp_mails = slp_mails
@plans = @slp_mails.take(5).to_a.map { |e| e.read.scan(@reg) }



