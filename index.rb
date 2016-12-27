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
	afile = File.new("text.txt.enc","w")
	afile.syswrite(enc)	
	afile.close
end

def decrypt(data)
	decipher = OpenSSL::Cipher.new('AES-192-CBC')
	decipher.decrypt
	decipher.key = File.open("key.pem","r").read
	decipher.iv = File.open("iv.pem","r").read
	dec = decipher.update(data)+ decipher.final
	File.open("text.txt","w").write(dec)
end


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
	decrypt(data)
end