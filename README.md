<center>Install necessary gems:</center>

`gem install ecdsa securerandom digest rubygems rqrcode`

<center>Run the Script</center>

`ruby wif_ecsda.rb`

<center>Files Description</center>

```
- wif_ecsda.rb : It generates a new Key-pair everytime it executes. Supports WIF and compression bit. Doesn't support BIP32 seed generation. It also shows a QR-Code of the address that can be scanned by any wallet application. It also opens blockchain.info to explore the corresponding address in Google Chrome _(Chrome has to be installed for this to work.)_   

- base58.sh : It passes the checksum-appended-key to btemp.sh

- btemp.sh : Generates a valid base58 encoding. 

- Wallet-qrcode.png : QR-Code of the address.	

```
<center>Tests</center>

```
- Able to successfully import the generated private key in Electrum Wallet. 
- Mobile application wallets are able to successfully scan the QR code. 
- Block Explorer validates the generated block address.
```
<center><h1>CAUTION!</h1></center>

<p>

This script generates addresses for the mainnet. Do not use it unless you know how to import a wallet from a private key. This is only for educational purpose and is not the most secure way to handle wallets. Please look into BIP32 implementation of wallets which are much more secure.
P.S Do not share the private key with anyone. 

</p>
