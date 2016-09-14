require 'net/http'
require 'json'

uri = URI.parse 'https://gitlab.com/api/v3/ci/lint'

Dir.glob("#{File.dirname(__FILE__)}/**/*.yml").each do |file|
  response = Net::HTTP.post_form(uri, content: File.read(file))

  file = file.match(/((\w|\+|#)+)\.gitlab-ci/)[1]

  if JSON.parse(response.body)['status'] == 'valid'
    puts "\e[32mvalid\e[0m: #{file}" # Color 'valid' green
  else
    puts "invalid: #{file}"
    exit(1)
  end
end
