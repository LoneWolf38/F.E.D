require 'openssl'
require 'base64'

def encrypt(data)
	cipher = OpenSSL::Cipher.new('AES-192-CBC')
	cipher.encrypt
	$key = 	File.open("key.pem","r").read
	$iv = File.open("iv.pem","r").read
	enc = cipher.update(data) + cipher.final
	enc = Base64.encode64(enc)
	afile = File.new("text.txt.enc","w")
	afile.syswrite(enc)	
	afile.close
end

def decrypted(data)
	decipher = OpenSSL::Cipher.new('AES-192-CBC')
	decipher.decrypt
	decipher.padding = 0
	decipher.key = File.open("key.pem","r").read
	decipher.iv = File.open("iv.pem","r").read
	dec = decipher.update(data)+ decipher.final
	File.open("text.txt","w").write(dec)
end


	def login(name)
		uname = File.open("uname.pem","r").read
		
		if uname == name
				puts "1. Lock"
				puts "2. Unlock"
				act = gets.chomp!.to_i
			if(act == 1)
				puts "Enter data to be encrypted"
				data = gets.chomp!
				encrypt(data)
			else
			data = File.open("text.txt.enc","r").read
			data = Base64.decode64(data)
			decrypted(data)
			end
		else 
			print "Wrong Entry"
		end
	end

if File::exists?("uname.pem")
	print "Username: "
	username = gets.chomp!
	c = OpenSSL::Digest::SHA1.new
	enc = c.digest(username)
	enc = Base64.encode64(enc)
	login(enc)
else
	puts "Entering Program for First time......"
	print "Enter Username to Store: "
	username = gets.chomp!
	c = OpenSSL::Digest::SHA1.new
	enc = c.digest(username)
	enc = Base64.encode64(enc)
	cipher = OpenSSL::Cipher.new('AES-192-CBC')
	cipher.encrypt
	File.open("uname.pem","w").write(enc)
	$key = cipher.random_key
	File.open("key.pem","w").write($key)
	$iv = cipher.random_iv
	File.open("iv.pem","w").write($iv)
	puts "Username Added..... Program Exiting..."
end

