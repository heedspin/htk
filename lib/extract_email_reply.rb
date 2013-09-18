#!/bin/env ruby
# encoding: utf-8
module ExtractEmailReply
	# http://stackoverflow.com/questions/278788/parse-email-content-from-quoted-reply
	REGEX_ARR = [
			Regexp.new("^\\*?(From|发件人)(:|：).+\n+\\*?(Sent|发送时间)(:|：)", Regexp::IGNORECASE),
		  Regexp.new("^.*On[^\n]*\n?[^\n]*wrote:$", Regexp::IGNORECASE),
		  Regexp.new("-+original\s+message-+\s*$", Regexp::IGNORECASE)
		]
	def extract_email_reply(text)
		text_length = text.length
		#calculates the matching regex closest to top of page
		index = REGEX_ARR.inject(text_length) do |min, regex|
		    [(text.index(regex) || text_length), min].min
		end

		text[0, index].strip
	end

end