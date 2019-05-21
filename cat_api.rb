#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'net/http'

url = URI("http://api.thecatapi.com/v1/images/search?format=json&mime_types=jpg")
http = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Get.new(url)
request["Content-Type"] = 'application/json'
request["x-api-key"] = 'ff121aa9-36fe-436e-ae44-cecce4a2fac6'
response = http.request(request).body
json = JSON.parse( response[1...-1])
url = URI(json["url"].gsub("https", "http"))
http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Get.new(url)

File.open("#{Time.now.strftime('%s')}_cat.jpeg", "w") do |file|
  r = http.request(request)
  if r.code == "301"
    r = Net::HTTP.get_response(URI.parse(r.header['location']))
  end
  file.write r.read_body
  file.close
end

