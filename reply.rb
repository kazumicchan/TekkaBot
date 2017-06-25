require 'net/https'
require 'pp'
require 'Kconv'
require 'json'

class Access
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
		
        response = https.get("/api/v1/sns/status/info?last_msg_max=#{@msg_max}&last_reply_max=#{@reply_max-2}", 'Cookie' => @cookie)
		message= response.body
		@hash2= JSON.parse(message)
		@msg_max=@hash2["result"]["msg_max"]
		@membfs=@hash2["result"]["reply_msgs"].length
		puts @membfs
		for i in 0..@membfs-1
		name=@hash2["result"]["reply_msgs"][i]["nickname"]
		text=@hash2["result"]["reply_msgs"][i]["text"]
		userid=@hash2["result"]["reply_msgs"][i]["userid"]
		to_msgno=@hash2["result"]["reply_msgs"][i]["msgno"]
					Yotuba.think(name,text,userid,to_msgno)
		end
	end


	def leading(num)
		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = https.get("/api/v1/sns/status/info?last_msg_max=#{@msg_max}&last_reply_max=#{@reply_max-2}", 'Cookie' => @cookie)
		message= response.body
		@hash2= JSON.parse(message)
		@memb=@hash2["result"]["reply_msgs"].length
		null =@hash2["result"]["reply_msgs"].nil?
		if null != true
			msgno=@hash2["result"]["reply_msgs"][@memb-1]["msgno"]

			if msgno != $msgno2

				for i in @membfs..@memb-1
		name=@hash2["result"]["reply_msgs"][i]["nickname"]
		text=@hash2["result"]["reply_msgs"][i]["text"]
		userid=@hash2["result"]["reply_msgs"][i]["userid"]
		to_msgno=@hash2["result"]["reply_msgs"][i]["msgno"]
					Yotuba.think(name,text,userid,to_msgno)				end
			$msgno2 = msgno
			@membfs=@memb
			end
		end
	end
	def self.talk(postdata,to_msgno)
		mail     = 'kazu'
		password = '38d9dc'

		https = Net::HTTP.new('tekka.pw', 443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = https.start{|https|
		    https.post('/api/v1/auth/login/client', "login_id=#{mail}&login_pwd=#{password}")
		}
		@cookie = response['Set-Cookie'].split(',').join(';')


		response = https.post('/api/v1/profile/edit', "nickname=よつばちゃん&bio=botやで", 'Cookie' => @cookie)
puts to_msgno
		response = https.post('/api/v1/sns/msg/add', "type=1&teamid=tesso&channelid=chitchat&tag=&text=#{postdata}&replyto=#{to_msgno}&replyto_ver=1&product=", 'Cookie' => @cookie)
puts message= response.body
		response = https.post("/api/v1/profile/edit", "nickname=\u3088\u3064\u3070\u306e\u3075\u305f\u3070&bio=\u9032\u6357\u30c0\u30e1\u3067\u3059@kazunyaha", 'Cookie' => @cookie)

	end



end

class Yotuba
	def self.think(name,text,userid,to_msgno)
		case userid
			when "tekka" then
				File.open('tekka.txt', 'r:utf-8') do |f|
				  f.each_line do |line|
				    if line.include?(text)
						mes=line.split("=")
				      Access.talk(mes[1],to_msgno)
 					end
				  end
				end			
			else
				File.open('other.txt', 'r:utf-8') do |f|
				  f.each_line do |line|
				    if line.include?(text)
						mes=line.split("=")
				      Access.talk(mes[1],to_msgno)
 					end
				  end
				end		
			end
		case name
			when "よつばのふたば" then
				if text.include?("テスト")==true then
					Access.talk("受け取りました～",to_msgno)
				end
		end
	end
end


access = Access.new
access.login

num =0
$msgno2=0

while true
access.leading(num)
sleep (15)
end