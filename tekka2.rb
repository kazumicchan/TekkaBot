require 'net/https'
require 'pp'
require 'Kconv'
require 'json'



class Yotuba

	def login
		mail     = ''
		password = ''

		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = https.start{|https|
		    https.post('/api/v1/auth/login/client', "login_id=#{mail}&login_pwd=#{password}")
		}
		@cookie = response['Set-Cookie'].split(',').join(';')
		puts "Login OK"
		response = https.get("/api/v1/sns/status/all", 'Cookie' => @cookie)
		message= response.body
		hash2= JSON.parse(message)
		@msg_max=hash2["result"]["msg_max"]
		@reply_max=hash2["result"]["reply_max"]	
	end

	def talk
		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		prof = https.get("/api/v1/profile/item?userid=kazu", 'Cookie' => @cookie)

		response = https.post('/api/v1/profile/edit', "nickname=よつばちゃん&bio=botやで", 'Cookie' => @cookie)
		response = https.post('/api/v1/sns/msg/add', "type=1&teamid=tesso&channelid=chitchat&tag=&text=#{$postdata}&product=", 'Cookie' => @cookie)
		response = https.post("/api/v1/profile/edit", "nickname=\u3088\u3064\u3070\u306e\u3075\u305f\u3070&bio=\u9032\u6357\u30c0\u30e1\u3067\u3059@kazunyaha", 'Cookie' => @cookie)
		

	end

	def think(choices)
		case choices
		when 1 then
		when 2 then
		choices2=Random.new.rand(100).to_s
puts choices2

				File.open('nyan.txt', 'r:utf-8') do |f|
				  f.each_line do |line|
				    if line.include?(choices2)
						mes=line.split("=")
				      $postdata=mes[1]
 					end
				  end
				end	
		when 3 then

		end
	end

end

yotuba =Yotuba.new
yotuba.login
while true

	cho=rand(3)
	yotuba.think(cho)
	yotuba.talk
	sleep(cho*80)

end

