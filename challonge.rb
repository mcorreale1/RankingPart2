require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'fileutils'
require 'json'


class Getter
  attr_reader :api
  attr_reader :uname

  def initialize
    file = File.open("api.txt")
    raw = file.read
    file.close
    #0 is brian, 1 is me
    @api = raw.delete("\n")
    @uname = "mcore"
    raw = JSON.parse(get_tourny)
    data = Array.new(raw.size)
    raw.each_with_index do |t, i|
      puts t

    end

    #raw.each_with_index do |t,i|


   #   data[t] = Hash(*t)       
   # end
   #puts data

    

  end
  def make_url(request, params) 
    cmd = "https://api.challonge.com/v1/#{request}?api_key=#{@api}#{params}"
    return cmd
  end
  def get_tourny
    request = "tournaments.json"
    params = "&state=ended&created_after=2016-09-09"
    cmd = make_url(request, params)
    ret = call_api(cmd)
    return ret
  end
  def call_api(call)
    #puts call
    req = Net::HTTP.get(URI.parse(call))
    return req
  end
end

get = Getter.new



