require 'openssl'
require 'base64'

def encrypt(data)
	cipher = OpenSSL::Cipher.new('AES-192-CBC')
	cipher.encrypt
	$key = cipher.random_key
	File.open("key.pem","w").write($key)
	$iv = cipher.random_iv
	File.open("iv.pem","w").write($iv)
	enc = cipher.update(data) + cipher.final
	enc = Base64.encode64(enc)
	$file = "../Encrypt/"+ $file
	puts $file
	File.open($file,"w").write(enc)
end

def decrypted(data)
	decipher = OpenSSL::Cipher.new('AES-192-CBC')
	decipher.decrypt
	decipher.padding = 0
 	decipher.key = File.open("key.pem","r").read
	decipher.iv = File.open("iv.pem","r").read
	dec = decipher.update(data) + decipher.final
	$file.slice! ".enc"
	File.open($file,"w").write(dec)
end


	def login(name,pass)
		uname = File.open("uname.pem","r").read
		password = File.open("pass.pem","r").read
		if uname == name && pass == password
				puts "1. Lock"
				puts "2. Unlock"
				act = gets.chomp!.to_i
			if(act == 1)
				puts "Give the name of the file to be encrypted"
				$file = gets.chomp!
				data = File.open($file,"r").read
				$file = $file + ".enc"
				encrypt(data)
			else
				$file = Dir["*.enc"].join("")
				#puts $file.class
			data = File.open($file,"r").read
			d = Base64.decode64(data)
			decrypted(d)
			#puts data
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
	print "Password: "
	pass = gets.chomp!
	c1 = OpenSSL::Digest::SHA1.new
	enc1 = c1.digest(pass)
	enc1 = Base64.encode64(enc1)
	login(enc,enc1)
else
	puts "Entering Program for First time......"
	print "Enter Username to Store: "
	username = gets.chomp!
	c = OpenSSL::Digest::SHA1.new
	enc = c.digest(username)
	enc = Base64.encode64(enc)
	print "Enter password: "
	pass = gets.chomp!
	c = OpenSSL::Digest::SHA1.new
	penc = c.digest(pass)
	penc = Base64.encode64(penc)
	cipher = OpenSSL::Cipher.new('AES-192-CBC')
	cipher.encrypt
	File.open("uname.pem","w").write(enc)
	File.open("pass.pem","w").write(penc)
	puts "Username Added..... Program Exiting..."
end

