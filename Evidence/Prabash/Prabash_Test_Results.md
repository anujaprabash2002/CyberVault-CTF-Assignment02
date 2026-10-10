# CyberVault CTF – Member 1 Test Results

## 1. Project Information

- **Module:** IE3132 – Penetration Testing
- **Assignment:** Assignment 02 – CTF Play Box Implementation
- **Project:** CyberVault CTF
- **Member:** Prabash
- **Role:** Member 1 – CTF Platform and Architecture

## 2. Purpose

This document records the platform health checks, Stage 6 reset-script validation, recovery checks, and VM appliance export verification performed for the CyberVault CTF prototype.

It documents the tests performed for Member 1's component. It does not replace the end-to-end integration and testing evidence required for the entire group project.

## 3. Test Environment

### CTFd Platform

- **Operating System:** Ubuntu Linux
- **Platform:** CTFd
- **Container Runtime:** Docker
- **Web Access:** `http://localhost` inside the CTFd Ubuntu VM

### Stage 6 Environment

- **Virtual Machine:** `CyberVault-Stage6-Server`
- **Operating System:** Ubuntu Server
- **Challenge Service:** `cv-update.service`
- **Challenge Flag File:** `/var/lib/cybervault/.incident/response/final_flag.txt`
- **Reset Script:** `/usr/local/sbin/cybervault-stage6-reset.sh`

## 4. CTFd Platform Health Check

The `platform_health_check.sh` script was executed on the CTFd Ubuntu VM.

### Results

| Test ID | Test Description | Result |
|---|---|---|
| P01 | Check whether the Docker service is active | PASS |
| P02 | Detect running CTFd containers | PASS |
| P03 | Check the CTFd web response | PASS |

### Detected Containers

The following containers were detected during the health check:

- `ctfd-nginx-1`
- `ctfd-ctfd-1`
- `ctfd-db-1`
- `ctfd-cache-1`

The health-check script reported that the Docker service, CTFd containers, and CTFd web service were working during the test.

**Script:** `Source_Code/Prabash/platform_health_check.sh`

## 5. Stage 6 Backup Verification

A protected backup of the Stage 6 challenge flag file was created at:

`/root/cybervault-stage6-backup/final_flag.txt`

The backup file permissions were verified as root-only read/write permissions.

The following command was used:

```bash
sudo ls -l /root/cybervault-stage6-backup/final_flag.txt
```

The backup file was present and protected with permissions equivalent to `600`.

## 6. Reset Script Syntax Validation

The Stage 6 reset script was checked for Bash syntax errors.

Command:

```bash
sudo bash -n /usr/local/sbin/cybervault-stage6-reset.sh
```

**Observed Result:** `SCRIPT SYNTAX: PASS`

## 7. Stage 6 Reset and Recovery Test

The reset script was tested by temporarily moving the challenge flag file to a temporary location and then executing the reset script.

The script restores the challenge flag file from the protected backup and restarts the Stage 6 challenge service.

### Observed Results

| Test ID | Test Description | Result |
|---|---|---|
| R01 | Execute the reset script | PASS |
| R02 | Verify that the challenge flag file was restored | PASS |
| R03 | Check the challenge service after reset | PASS |
| R04 | Compare the backup and restored file SHA-256 hashes | PASS |
| R05 | Remove the temporary test copy | PASS |

The reset script reported:

```text
Stage 6 Reset: PASS
FLAG FILE RESTORE: PASS
```

After the reset, the `cv-update.service` service was checked and reported as active.

The SHA-256 values of the backup file and restored challenge flag file were identical, confirming that the restored file matched the backup.

The temporary test copy was removed after verification.

**Reset script:** `Source_Code/Prabash/cybervault-stage6-reset.sh`

## 8. Stage 6 Service Verification

The challenge service was checked using:

```bash
sudo systemctl is-active cv-update.service
```

**Observed Result:** `active`

This confirmed that the challenge service was active after the reset-script test.

## 9. VirtualBox Appliance Export Verification

The following VM appliance files were exported and verified locally.

| Appliance | File | Size in bytes |
|---|---|---:|
| CTFd platform VM | `CTF_Box/CyberVault-CTFd-Ubuntu.ova` | 7,043,421,184 |
| Stage 6 server VM | `CTF_Box/CyberVault-Stage6-Server.ova` | 6,670,507,008 |

Both OVA files were present in the local `CTF_Box` directory.

The `.gitignore` rules were checked to ensure that the large VirtualBox appliance files were excluded from Git tracking.

The OVA files are retained in the local submission package and are not intended to be pushed to the GitHub repository as ordinary source-code files.

## 10. Repository Verification

The Git repository was checked after pushing the source-code and documentation changes.

The repository status showed that the local branch and `origin/main` were synchronized and the working tree was clean.

The following Member 1 files were added to the repository:

- `Source_Code/Prabash/platform_health_check.sh`
- `Source_Code/Prabash/cybervault-stage6-reset.sh`

## 11. Tests Still Required Before Final Submission

The following items must be verified and documented before the final submission:

- [ ] Test the CTFd VM recovery procedure.
- [ ] Re-run and record the complete six-stage challenge progression.
- [ ] Verify that all flag submissions and expected scores work.
- [ ] Test challenge dependencies and attempts to access locked stages prematurely.
- [ ] Complete any remaining isolation and unintended-shortcut tests.
- [ ] Verify that the exported VM appliances can be imported and started in a suitable test environment.
- [ ] Capture and organize the final testing evidence.

These items should only be marked as complete after the corresponding tests have actually been performed.

## 12. Evidence Files

Supporting screenshots and configuration evidence should be stored in the `Evidence` directory.

Recommended evidence includes:

- Platform health-check output
- Stage 6 reset-script output
- Backup and restored file hash comparison
- Stage 6 service status
- VirtualBox appliance export verification
- Git repository status and commit history

## 13. Conclusion

The Member 1 platform health-check script completed successfully. The Stage 6 reset script passed syntax validation and was tested successfully for restoring the challenge flag file from a protected backup. The restored file matched the backup according to the SHA-256 comparison, and the challenge service was active after the reset.

The CTFd and Stage 6 VM appliances were exported and verified in the local submission directory.

Further platform recovery, complete end-to-end, isolation, and deployment checks must be completed and documented before the final group submission.