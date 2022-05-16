# Linux GPG Encryption
: '
We have confidential data that needs to be transferred to a remote location, so we need to encrypt that data.We also need to decrypt data we received from a remote location in order to understand its content.
On storage server in Stratos Datacenter we have private and public keys stored /home/*_key.asc. Use those keys to perform the following actions.
Encrypt /home/encrypt_me.txt to /home/encrypted_me.asc.
Decrypt /home/decrypt_me.asc to /home/decrypted_me.txt. (Passphrase for decryption and encryption is kodekloud).
'


# Login on storage server
ssh natasha@ststor01
sudo -i

cd /home/
ll
	#encrypt_me.txt
	decrypt_me.asc
	private_key.asc
	public_key.asc
	
# Import gpg Private & Public key
gpg --import public_key.asc
gpg --import private_key.asc

# verify keys
gpg --list-keys
	# UID kodekloud@kodekloud.com
gpg --list-secret-keys
	# UID kodekloud@kodekloud.com

# encrypt the file txt in to asc
gpg --encrypt -r kodekloud@kodekloud.com --armor < encrypt_me.txt -o encrypted_me.asc

# decrypt the file asc in to txt  using passphrase 
gpg --decrypt decrypt_me.asc > decrypted_me.txt

# check the encrpyted & decrypted files  in  /home
ll
	# decrypted_me.txt
	encrypted_me.asc

# Validate the task
cat decrypted_me.txt
	# Welcome to xFusionCorp Industries. This is KodeKloud System Administration Lab

cat decrypt_me.asc
	# 'h'ҊOoD+)δ1RK*PH

cat encrypt_me.txt
	# My name is "My Name"

cat encrypted_me.asc
	# -----BEGIN PGP MESSAGE-----



CONGRATULATIONS!!!!
You have successfully completed the quiz. Results have been saved. Ref ID:62824bc3ca9fa3274e474a6d
