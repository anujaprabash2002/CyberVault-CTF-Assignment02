import subprocess
import base64
from stegano import lsb

print("=" * 50)
print("CyberVault CTF - Member 2 Solver Script")
print("=" * 50)

# Stage 1 - OSINT - Extract EXIF metadata
print("\n[Stage 1] Extracting EXIF metadata from leaked post...")
result = subprocess.run(['exiftool', 'stage1_leaked_post.jpg'], capture_output=True, text=True)
for line in result.stdout.split('\n'):
    if 'Comment' in line:
        print("FLAG FOUND:", line.split(':')[1].strip())

# Stage 2 - Steganography - Extract hidden data
print("\n[Stage 2] Extracting hidden data from image...")
flag = lsb.reveal('stage2_team_photo.png')
print("FLAG FOUND:", flag)

# Stage 3 - Cryptography - Decode Base64 + XOR decrypt
print("\n[Stage 3] Decrypting encrypted memo...")
key = 'cyberkey'
with open('stage3_memo.txt', 'r') as f:
    encoded = f.read()
xor = base64.b64decode(encoded)
decrypted = ''.join([chr(xor[i] ^ ord(key[i % len(key)])) for i in range(len(xor))])
for line in decrypted.split('\n'):
    if 'Flag' in line:
        print("FLAG FOUND:", line.strip())

print("\n" + "=" * 50)
print("All Stage 1-3 flags recovered successfully")
print("=" * 50)
