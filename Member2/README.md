# CyberVault CTF - Member 2 Challenges (Stages 1-3)

## Challenge Files
- stage1_leaked_post.jpg + stage1_post.txt → Stage 1 (OSINT)
- stage2_team_photo.png → Stage 2 (Steganography)
- stage3_memo.txt → Stage 3 (Cryptography)

## How to Solve

### Stage 1 - The Leaked Post (OSINT)
```bash
exiftool stage1_leaked_post.jpg
```
Flag is in the Comment field of the EXIF metadata.

### Stage 2 - Hidden in Plain Sight (Steganography)
```bash
python3 -c "from stegano import lsb; print(lsb.reveal('stage2_team_photo.png'))"
```
Passphrase hint: username found in Stage 1.

### Stage 3 - The Encrypted Memo (Cryptography)
Use keyword from Stage 2 to XOR decrypt after Base64 decoding.
```bash
python3 solver.py
```

## Solver Script
Run solver.py to automatically solve all 3 stages:
```bash
python3 solver.py
```

## Reset/Recovery
All stages are file-based. Simply restore original files from backup.
