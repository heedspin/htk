module HtkImap::MailUtils
	def strip_attachments(body)
		body.parts.delete_if { |p| !p.multipart? && part_not_text?(p) }
		body.parts.select(&:multipart?).each { |p| p.parts.delete_if { |ip| part_not_text?(ip) } }
		body
	end

	def part_not_text?(p)
		!(p.content_type.include?('text/plain') || p.content_type.include?('text/html'))
	end

	def find_content_type(mail_body, content_type)
		if mail_body.multipart?
			mail_body.parts.each do |part|
				if found_text = find_content_type(part, content_type)
					return found_text
				end
			end
		elsif mail_body.respond_to?(:content_type)
			if mail_body.content_type.include?(content_type)
				return mail_body.decoded
			end
		else
			return mail_body.decoded
		end
	end
end