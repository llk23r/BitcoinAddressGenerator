require 'ecdsa'
require 'securerandom'
require 'digest'
require 'rubygems'
require 'rqrcode'

#Method to calculate SHA256
def SHA256(hex)	
	temp = ""
	`echo -n #{hex} \
	   | xxd -r -p > temp`
	`hexdump -C temp`
	$hash256 = Digest::SHA256.hexdigest File.read "temp"
	return $hash256
end

#Method to calculate base58 encoding
def base58encode(checksum)
	`chmod +x base58.sh`
	return `./base58.sh #{checksum}`
end 

#Generate a Private Key
group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
priv_key  = '%x' % private_key

#Address Prefix : 80 is for mainnet
address_prefix_1 = "80"

#WIF or Compressed?
compressed = false
puts "1. WIF 2. Compressed"
type = gets.chomp
if(type == '2') 
	compression_flag = "01"	
	compressed = true
end		

#Private Key with Address Version
priv_key_with_version = address_prefix_1.concat(priv_key)

#Append the compression flag if compressed format
priv_key_with_compression_flag = compressed ? priv_key_with_version.concat(compression_flag) : priv_key_with_version

#SHA256 the Key twice
double_hash = SHA256(SHA256(priv_key_with_compression_flag))

#Store the first 4 bytes as a checksum
checksum = $hash256[0..7]

#Include the checksum at the end of the private Key
priv_key_with_checksum = double_hash.concat(checksum)

#Encode the private key in base58
base58_priv_key = base58encode(priv_key_with_checksum)

#Display the private key
puts "\nPRIVATE KEY\t\t : #{base58_priv_key}"

# Generate a Public Key for the Private Key
public_key = group.generator.multiply_by_scalar(private_key)

#Get the x and y coordinates of the curve. A public key is a point on the curve.
pub_key_x = '%x' % public_key.x
pub_key_y = '%x' % public_key.y

#Concatenate the x and y coordinates 
pub_key = pub_key_x.concat(pub_key_y)

#Append 0x04 at the beginning 
pub_key = "04".concat(pub_key)

#SHA256 the key
pub_key_hash = SHA256(pub_key)

#Strip down the length using RipeMD-160
ripe_md160 = Digest::RMD160.hexdigest(pub_key_hash)

#Define version number - 0x00 indicates Mainnet
version_number = "00"

#Append version number to the ripeMD-160 hash 
public_key_with_version = version_number.concat(ripe_md160)

#Double SHA256 the key
hash_after_ripe = SHA256(SHA256(public_key_with_version))

#store first 4 bytes as checksum
pub_checksum = hash_after_ripe[0..7]

#Get the 25 byte binary bitcoin address
binary_btc_add = public_key_with_version.concat(pub_checksum)

#base58 encode the address
final_encode = base58encode(binary_btc_add)

#Display the Wallet Address
puts "\nWallet Address\t\t : #{final_encode}"

qrcode = RQRCode::QRCode.new("#{final_encode}")

#Store the address as a png
png = qrcode.as_png(
    resize_gte_to: false,
    resize_exactly_to: false,
    fill: 'white',
    color: 'black',
    size: 240,
    border_modules: 4,
    module_px_size: 6,
    file: nil
    )

#Store the png file in the current folder
IO.write("Wallet-qrcode.png", png.to_s)
`google-chrome https://blockchain.info/address/#{final_encode}`
`xdg-open Wallet-qrcode.png`
	
