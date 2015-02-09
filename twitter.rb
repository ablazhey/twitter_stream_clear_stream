require 'tweetstream'
require 'colorize'
require 'levenshtein'
require 'pry'
require 'benchmark'

  def include_to_array?(array, src)
  response = false
       array.each do |a|
        count = Levenshtein.distance(a, src)
        r = (1 - (count.to_f/[a.length, src.length].max.to_f))*100
#    binding.pry
        if r >= 80.0
         response = true
         break
        end     
    end 
    response
  end



TweetStream.configure do |config|
  config.consumer_key       = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  config.consumer_secret    = 'xxxxxxxxxxxxxxxxxxxxxxxx'
  config.oauth_token        = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  config.oauth_token_secret = 'xxxxxxxxxxxxxxxxxxxxxxxxx'
  config.auth_method        = :oauth
end


old_text = []

TweetStream::Client.new.track('Дебальцево', 'ATO', 'Донецк') do |status|
 # binding.pry
#  binding.pry
  unless include_to_array?(old_text, status.text)
    puts "#{status.created_at.strftime("%d-%m-%y %H:%M:%S")}  ".red unless status.text.include? 'RT'
    puts "#{status.text}\n\n\n".green unless status.text.include? 'RT'
    old_text << status.text unless status.text.include? 'RT'
  end
  #puts "\n\n#####################################################################\n"
end
