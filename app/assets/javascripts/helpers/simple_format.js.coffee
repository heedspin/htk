Handlebars.registerHelper 'simpleFormat', (text) ->
  if !text
    return null
  carriage_returns = /\r\n?/g
  paragraphs = /\n\n+/g
  newline = /([^\n]\n)(?=[^\n])/g

  text = text.replace(carriage_returns, "\n") # \r\n and \r -> \n
  text = text.replace(paragraphs, "</p>\n\n<p>") # 2+ newline  -> paragraph
  text = text.replace(newline, "$1<br/>") # 1 newline   -> br
  text = "<p>" + text + "</p>";

  return new Handlebars.SafeString text