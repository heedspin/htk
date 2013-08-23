class EmailSerializer < ActiveModel::Serializer
	embed :ids, include: true
  attributes :id, :date, :subject, :html_body
  has_many :parties

  def html_body
  	text = object.html_body
  	if text.include?('</head>')
	  	text = text.slice(text.index('</head>')+7..-1)
	  end
	  text.sub!('</html>', '')
	  text.sub!('<body', '<div')
	  text.sub!('</body>', '</div>')
	  text
  end
end
