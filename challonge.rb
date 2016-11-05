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
    @uname = "briantse6"
  end
  def make_dir(name)
    if(!Dir.exist?(name)) 
      Dir.mkdir(name)
    end
  end
  def get_file(name)
    if(File.exist?(name))
      return File.open(name)
    else 
      return File.new(name)
    end
  end

  def call_api(request, params) 
    call = "https://api.challonge.com/v1/#{request}?api_key=#{@api}#{params}"
    return Net::HTTP.get(URI.parse(call))
  end
  def pull_tourny
    request = "tournaments.json"
    params = "&state=ended&created_after=2016-09-01"
    ret = call_api(request, params)
    data = Array.new
    JSON.parse(ret).each_with_index do |t, i| data[i] = t["tournament"] end
    make_dir("data")
    make_dir("data/tournaments")
    path = "data/tournaments/"
    data.each do |t|
      path = "data/tournaments/#{t["url"]}/"
      make_dir(path)
    end
    data.each do |t|
      path = FileUtils.pwd+"/data/tournaments/#{t["url"]}/"
      if(!File::exist?(path+"info.txt"))
        File.open(FileUtils.pwd+path+"info.txt", "w" ) do |f|
          f.write(t)
        end
      end
    end
  end
  
  def pull_info
    FileUtils.cd("data/tournaments/")
    Dir.foreach(Dir::pwd).to_a[2..-1].each { |dir|
      FileUtils.cd(Dir::pwd + "/" + dir)
      parts = JSON.parse(call_api("tournaments/#{dir}/participants.json", ""));
      puts parts.size
      exit
      FileUtils.cd("../")
    }
    FileUtils.cd("../../")
  end
end
get = Getter.new
get::pull_tourny
get::pull_info
