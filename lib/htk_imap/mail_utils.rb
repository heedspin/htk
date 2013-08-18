module HtkImap::MailUtils
	def strip_attachments(body)
		body.parts.delete_if { |p| !p.multipart? && part_not_text?(p) }
		body.parts.select(&:multipart?).each { |p| p.parts.delete_if { |ip| part_not_text?(ip) } }
		body
	end

	def part_not_text?(p)
		!(p.content_type.include?('text/plain') || p.content_type.include?('text/html'))
	end
end