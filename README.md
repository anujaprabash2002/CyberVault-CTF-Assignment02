# CyberVault CTF — Assignment 02

## IE3132 — Penetration Testing
### CTF Play Box Implementation — Working Box Demonstration

CyberVault CTF is a six-stage Capture The Flag (CTF) Play Box based on a cybersecurity incident investigation scenario. Participants investigate a simulated incident and solve progressive challenges using cybersecurity tools and techniques.

---

## 1. Project Overview

CyberVault CTF contains six stages covering different cybersecurity domains.

| Stage | Title | Domain | Difficulty |
|---|---|---|---|
| Stage 1 | The Leaked Post | OSINT / Reconnaissance | Easy |
| Stage 2 | Hidden in Plain Sight | Steganography | Easy |
| Stage 3 | The Encrypted Memo | Cryptography | Moderate |
| Stage 4 | Evidence Under Investigation | Digital Forensics | Moderate |
| Stage 5 | Trace the Intrusion | Network Security | Moderate–Hard |
| Stage 6 | The Compromised Server | Linux / System Security | Hard |

### Flag format

The flag format used by the challenges is:

```text
CVCTF{unique_flag_value}
```

The actual flag value is different for each stage.

---

## 2. Implemented Prototype and Technology

The working prototype uses:

- **CTF platform:** CTFd
- **Platform host:** Ubuntu Linux virtual machine
- **CTFd services:** Docker containers for the web proxy, CTFd application, database and cache
- **Stages 1–5:** File-based challenges hosted through CTFd
- **Stage 6:** Separate Ubuntu Server virtual machine
- **Virtualization:** Oracle VirtualBox
- **Stage 6 remote access:** OpenSSH over TCP port 22
- **Stage 6 network:** NAT and Host-Only adapters

The larger production-scale Docker deployment described in Assignment 01 is a proposed future deployment approach. The submitted prototype uses CTFd on Ubuntu and a separate VirtualBox Ubuntu Server for Stage 6.

---

## 3. Repository Contents

- `Challenge_Files/` — challenge resources for Stages 1–5.
- `Source_Code/Prabash/` — Member 1 platform health-check and Stage 6 reset scripts.
- `CTF_Box/` — location for the exported VM images and/or deployment files included in the final submission package.
- `Evidence/` — location for configuration screenshots, test logs and contribution evidence.
- `Video/` — location for the final demonstration video when prepared.

The exported VM image(s), required configuration files and this README must be included in the final CTF Box package so the assessor can deploy the environment.

---

## 4. Requirements

The prototype requires:

- Oracle VirtualBox
- The configured CTFd Ubuntu virtual machine
- The configured `CyberVault-Stage6-Server` virtual machine
- Docker running inside the CTFd Ubuntu VM
- A web browser
- An SSH client for Stage 6
- The challenge tools required for the relevant stages

The Stage 6 VM configuration used in the prototype is:

| Resource | Configuration |
|---|---|
| Operating system | Ubuntu Server |
| CPU | 2 vCPU |
| RAM | 4 GB |
| Storage | 25 GB |
| Network adapters | NAT + Host-Only |
| Remote access | SSH / TCP 22 |
| Host name | `cybervault-stage6` |
| Challenge account | `investigator` |

---

## 5. Setup and Run Instructions

### 5.1 Start the CTFd platform

1. Import the supplied CTFd Ubuntu VM into VirtualBox if it is not already registered.
2. Start the VM.
3. Open a terminal inside the Ubuntu VM.
4. Check the CTFd containers:

   ```bash
   docker ps
   ```

   The working setup used containers for the Nginx web proxy, CTFd application, MariaDB database and Redis cache.

5. Check the local web response:

   ```bash
   curl -I http://localhost
   ```

6. Open a browser **inside the CTFd Ubuntu VM** and visit:

   ```text
   http://localhost
   ```

7. Sign in with the authorized CTFd participant account and open the Challenges page.

The address `http://localhost` refers to the CTFd VM itself; it is not the Stage 6 server address.

### 5.2 Start the Stage 6 server

1. Start `CyberVault-Stage6-Server` in VirtualBox.
2. Log in with the authorized `investigator` account.
3. Check the current network addresses:

   ```bash
   ip a
   ```

4. Check that SSH is running:

   ```bash
   sudo systemctl status ssh --no-pager
   ```

5. From the authorized participant environment, connect using the current Host-Only address:

   ```bash
   ssh investigator@<CURRENT-STAGE6-IP>
   ```

Replace `<CURRENT-STAGE6-IP>` with the current Host-Only IP shown by `ip a`. The address may change if the Host-Only network uses DHCP.

---

## 6. Challenge Progression

Stage 1 is an independent introductory challenge. The remaining progression uses challenge dependencies so later stages are unlocked after the required preceding challenge is completed.

```text
Stage 1 — The Leaked Post (independent)

Stage 2 — Hidden in Plain Sight
        ↓
Stage 3 — The Encrypted Memo
        ↓
Stage 4 — Evidence Under Investigation
        ↓
Stage 5 — Trace the Intrusion
        ↓
Stage 6 — The Compromised Server
```

Participants should follow each intended solution path and submit each discovered flag through CTFd.

---

## 7. Challenge Tools

Use only the tools needed for the current stage.

| Stage | Example tools | Purpose |
|---|---|---|
| Stage 1 | Browser, OSINT tools, ExifTool | Investigate public-style clues and image metadata |
| Stage 2 | Zsteg, ExifTool, Binwalk | Inspect media and identify hidden data |
| Stage 3 | Python, CyberChef | Decode and decrypt the memo using the supplied clues |
| Stage 4 | ExifTool, `strings`, Binwalk | Inspect the suspicious evidence file and embedded data |
| Stage 5 | Wireshark, Tcpdump | Inspect the PCAP and investigate network traffic |
| Stage 6 | SSH, `ps`, `journalctl`, `find`, `grep` | Investigate the simulated Linux incident and locate evidence |

---

## 8. Flag Submission and Scoring

Participants submit discovered flags through CTFd. CTFd checks submitted values against the configured challenge flags and updates the solve status, score and challenge progression when a correct flag is submitted.

The prototype's configured stage scores are:

| Stage | Points |
|---|---:|
| Stage 1 | 100 |
| Stage 2 | 100 |
| Stage 3 | 200 |
| Stage 4 | 250 |
| Stage 5 | 300 |
| Stage 6 | 400 |
| **Total** | **1,350** |

The recorded end-to-end challenge testing reached 1,350 points after all six stages were solved.

---

## 9. Network Configuration and Isolation

The CTFd platform and Stage 6 server are separate virtual machines. Stage 6 uses NAT and a Host-Only adapter; SSH is provided on TCP port 22 for controlled access from the authorized participant environment.

Check the active IP address before each Stage 6 session because the Host-Only address can change. Do not expose the challenge environment or its management services to public or third-party systems. Use the CTF only in the authorized lab environment.

---

## 10. Member 1 Scripts

Member 1's scripts are stored in `Source_Code/Prabash/`.

### 10.1 Platform health check

File: `Source_Code/Prabash/platform_health_check.sh`

Run this script inside the CTFd Ubuntu VM:

```bash
bash platform_health_check.sh
```

Run it from the directory containing the script. It checks:

- Whether the Docker service is active
- Whether CTFd containers are running
- Whether the local CTFd web service responds on `http://localhost`

These checks were run in the working CTFd VM and returned `PASS` for Docker, the CTFd containers and the local web service.

### 10.2 Stage 6 reset script

File: `Source_Code/Prabash/cybervault-stage6-reset.sh`

On the Stage 6 VM, the installed script is located at:

```text
/usr/local/sbin/cybervault-stage6-reset.sh
```

Run it with root privileges:

```bash
sudo /usr/local/sbin/cybervault-stage6-reset.sh
```

The script checks for its protected backup and challenge directory, restores the challenge flag file from the backup with the specified ownership and permissions, restarts `cv-update.service`, and reports whether the service is active.

### 10.3 Stage 6 reset test evidence

The Stage 6 recovery test performed these checks:

1. A protected copy of `final_flag.txt` was stored at `/root/cybervault-stage6-backup/final_flag.txt` with restricted permissions.
2. The original challenge file was temporarily moved out of its target location.
3. The reset script was run.
4. The script reported `Stage 6 Reset: PASS` and the target file was present again.
5. The backup and restored file had matching SHA-256 hashes.
6. After `systemctl daemon-reload`, `cv-update.service` was confirmed active.

**Scope of this reset script:** it restores the Stage 6 challenge flag file and restarts the challenge service. It does not revert arbitrary changes to the entire operating system or reset the CTFd platform.

---

## 11. Reset and Recovery Instructions

### 11.1 Stage 6 challenge-file recovery

1. Start the Stage 6 Ubuntu Server.
2. Confirm that the protected backup exists:

   ```bash
   sudo ls -l /root/cybervault-stage6-backup/final_flag.txt
   ```

3. Run the reset script:

   ```bash
   sudo /usr/local/sbin/cybervault-stage6-reset.sh
   ```

4. Confirm that the service is active:

   ```bash
   sudo systemctl is-active cv-update.service
   ```

5. If needed, verify that the restored challenge file matches the backup without printing the flag value:

   ```bash
   sudo sha256sum /root/cybervault-stage6-backup/final_flag.txt /var/lib/cybervault/.incident/response/final_flag.txt
   ```

The two SHA-256 values should match. Do not print or expose the flag value when collecting evidence.

### 11.2 CTFd VM recovery

A VirtualBox baseline snapshot named `CyberVault-CTFd-Clean-State` was created for the CTFd Ubuntu VM. CTFd VM snapshot restoration has **not yet been documented as a completed recovery test** in this README. Before relying on it for the final demonstration, verify that the VM can be restored and that Docker, the web interface, challenges, flag validation and scoring work afterward.

---

## 12. Testing and Validation Checklist

Before recording the final demonstration, verify and record the result of each applicable check:

- [x] Docker service is active in the CTFd VM.
- [x] CTFd containers are running.
- [x] CTFd responds at `http://localhost` inside its Ubuntu VM.
- [x] All six configured challenges have been solved in the prototype, reaching 1,350 points.
- [x] Stage 6 SSH service/connectivity was used during challenge testing.
- [x] Stage 6 reset script restores the challenge file and reports success.
- [x] Backup and restored Stage 6 flag file have matching SHA-256 hashes.
- [ ] CTFd baseline snapshot restoration has been tested end-to-end.
- [ ] Security and unintended-shortcut checks have been completed and recorded.

Only mark outstanding items as complete after performing and recording those tests. Keep the relevant terminal output, screenshots and configuration evidence in `Evidence/` for the final package.

---

## 13. Individual Contribution Evidence

Contribution evidence can include:

- Source code and scripts
- Configuration files
- Test logs and screenshots
- Git commit history
- Each member's demonstration segment

Each member should explain their own assigned component in their own words and demonstrate the actual working environment. The repository's commit history can help identify changes made to files.

---

## 14. Repository Structure

```text
CyberVault-CTF-Assignment02/
├── Challenge_Files/
│   ├── Stage1/
│   ├── Stage2/
│   ├── Stage3/
│   ├── Stage4/
│   └── Stage5/
├── CTF_Box/
├── Evidence/
├── Source_Code/
│   └── Prabash/
│       ├── platform_health_check.sh
│       └── cybervault-stage6-reset.sh
├── Video/
└── README.md
```

The actual final submission package must also include the exported VM image(s) or other deployment files, source code, README and contribution/test evidence. Empty folders may not appear in Git until they contain a tracked file.

---

## 15. Safety and External Resources

CyberVault CTF is an intentionally created, authorized cybersecurity laboratory. Do not use the challenge systems, files, credentials or techniques against institutional, public, third-party or other unauthorized systems.

External tools, frameworks, images, datasets and resources used by the project must be acknowledged in the demonstration and submission materials. Tools used by the prototype include CTFd, Oracle VirtualBox, Ubuntu, Docker, OpenSSH, Wireshark, ExifTool, Zsteg, Binwalk, Python and CyberChef, where applicable to the stages.

---

## 16. Assignment Information

- **Module:** IE3132 — Penetration Testing
- **Course:** Cyber Security — Year 3, Semester 1
- **Project:** CyberVault CTF
- **Assignment:** Assignment 02 — CTF Play Box Implementation — Working Box Demonstration
- **Submission:** MP4 demonstration video (maximum 20 minutes), CTF Play Box files, source code, README and individual contribution evidence

No separate written report is required for Assignment 02 according to the assignment brief.
