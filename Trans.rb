#!//Users/Ram/.rvm/rubies/ruby-2.1.1/bin/ruby
file = File.open("/Users/Ram/Documents/Ruby/Translateit/trans/X-english.srt")
a = Array.new
def convert_toepoc(timestring)
  count=0
  epoc=0
  timestring.gsub(',',':').split(':').each do |tmd|
    epoc += tmd.to_i * (10^count)
    count = count +1
  end
  return epoc
end
file.each do |line|
 if line.gsub(/\r\n/,'').match(/^\d+$/)
   count=line.to_i
 end
 if line.match(/[0-9]{2}:./)
  aa = convert_toepoc(line.split('-->')[0])
  end
end 
