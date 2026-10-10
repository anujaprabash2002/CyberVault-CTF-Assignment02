
# CyberVault CTF — Integration Test Matrix

**Project:** CyberVault CTF Play Box  
**Module:** IE3132 Penetration Testing  
**Member:** Devindi K.G.Y — IT24100526  
**Assigned Component:** Integration, Testing & Documentation  
**Repository:** CyberVault-CTF-Assignment02

---

## 1. Purpose

This document records the integration tests, observed results, available evidence, defects, and remaining risks for the CyberVault CTF Play Box.

The purpose is to verify that the CTFd platform, six challenge stages, scoring, Stage 6 server, and recovery procedures work as intended.

Previously collected evidence and newly performed tests are identified separately. A test is marked PASS only when its result has been verified.

## 2. Integration Test Results

| Test ID | Test Description | Expected Result | Actual Result | Status |
|---|---|---|---|---|
| INT-01 | Check Docker containers | All four CTFd containers are running | The four containers were shown running in the Docker status evidence. | PASS — existing evidence |
| INT-02 | Check CTFd HTTP service | CTFd returns a successful HTTP response | HTTP 200 OK was observed. | PASS — existing evidence |
| INT-03 | Run platform health check | Docker, CTFd containers, and web service checks pass | The platform health check previously reported PASS for all three checks. | PASS — existing evidence |
| INT-04 | Verify challenge solves | All six challenges accept valid flags | The CTFd solve records show all six challenges completed. | PASS — existing evidence |
| INT-05 | Verify challenge progression | Challenges become available according to the intended progression | Stage 3 unlocked after the earlier challenges were completed. All six challenge solve records are present. Full dependency testing remains to be completed. | PASS — observed; full dependency test pending |
| INT-06 | Verify total score | The six challenge scores total 1,350 points | The scoreboard displayed 1,350 points. | PASS — existing evidence |
| INT-07 | Verify Stage 6 SSH connectivity | An authorized user can connect to the Stage 6 server | SSH login succeeded from Windows PowerShell using the `investigator` account and the Stage 6 host-only IP. | PASS — tested |
| INT-08 | Verify Stage 6 service status | `cv-update.service` is active and running | The service status displayed `active (running)`. | PASS — tested |
| INT-09 | Verify Stage 6 reset script | The script restores the flag file and restarts the service | The reset script previously reported PASS and the service remained active. | PASS — existing evidence |
| INT-10 | Verify Stage 6 flag restoration | The restored flag file matches the protected backup | The backup comparison reported PASS. The flag value is not included in this document. | PASS — existing evidence |
| INT-11 | Verify CTFd recovery | The documented recovery procedure restores the expected challenge state | A complete CTFd recovery test has not yet been performed. | PENDING |
| INT-12 | Test unintended challenge shortcuts | Locked challenges cannot be solved through unintended paths | Full shortcut and dependency-bypass testing has not yet been completed. | PENDING |
| INT-13 | Verify exported VM import | Both exported VMs import and start successfully in a test environment | A separate import test has not yet been completed. | PENDING |
| INT-14 | Verify design consistency | Challenge files, flags, scoring, and dependencies match the approved design | The Member 2 and Member 3 submissions still require comparison with the currently implemented challenges and approved design. | PENDING |
| INT-15 | Verify network isolation | The intended network restrictions and required service access work correctly | VM network settings have been reviewed, but connectivity and port restrictions still require verification. | PENDING |
| INT-16 | Verify final source and documentation | README, scripts, challenge files, and evidence are consistent | A final repository-wide review has not yet been completed. | PENDING |

## 3. Evidence Register

The following evidence files are available or planned for the project.

| Evidence ID | Evidence Filename | Description |
|---|---|---|
| EV-01 | `Devindi_Docker_Status.png` | Docker container status |
| EV-02 | `Devindi_CTFd_HTTP_Status.png` | CTFd HTTP response |
| EV-03 | `Devindi_Challenge1_Progression.png` | Stage 1 challenge evidence |
| EV-04 | `Devindi_Challenge2_Progression.png` | Stage 2 challenge evidence |
| EV-05 | `Devindi_Challenge3_Progression.png` | Stage 3 challenge evidence |
| EV-06 | `Devindi_Challenge4_Progression.png` | Stage 4 challenge evidence |
| EV-07 | `Devindi_Challenge5_Progression.png` | Stage 5 challenge evidence |
| EV-08 | `Devindi_Challenge6_Progression.png` | Stage 6 challenge evidence |
| EV-09 | `Devindi_Scoreboard.png` | Scoreboard showing 1,350 points |
| EV-10 | `Devindi_Stage6_SSH_Connection.png` | Successful SSH login from Windows PowerShell |
| EV-11 | `Devindi_Stage6_Service_Status.png` | `cv-update.service` status |
| EV-12 | `06_Platform_Health_Check_PASS.png` | Existing platform health-check result |
| EV-13 | `11_Stage6_Reset_Test_PASS.png` | Existing Stage 6 reset test result |
| EV-14 | `12_Stage6_Flag_Restore_Verification.png` | Existing flag backup comparison result |

**Evidence note:** EV-10 and EV-11 should be saved in `Evidence/Devindi/`. The existing Prabash evidence files may be stored in the main `Evidence/` folder. Update this register if any filenames or locations differ. Do not list a planned screenshot as available until it has actually been saved.

## 4. Challenge Scoring Verification

The currently implemented challenge scores are recorded below.

| Stage | Challenge | Category | Points |
|---|---|---|---:|
| 1 | The Leaked Post | OSINT / Reconnaissance | 100 |
| 2 | Hidden in Plain Sight | Steganography | 100 |
| 3 | The Encrypted Memo | Cryptography | 200 |
| 4 | Evidence Under Investigation | Digital Forensics | 250 |
| 5 | Trace the Intrusion | Network Security | 300 |
| 6 | The Compromised Server | Linux / System Security | 400 |
| | **Total** | | **1,350** |

The CTFd scoreboard and solve records show a total of 1,350 points across the six completed challenges.

## 5. Defects, Fixes, and Risks

| Risk ID | Defect or Risk | Action or Mitigation | Current Status |
|---|---|---|---|
| R-01 | CTFd recovery has not been verified | Review the documented recovery procedure and test it on a safe test copy with a backup available. | PENDING |
| R-02 | Exported VM imports have not been verified | Import the exported CTFd and Stage 6 VM files into a separate test setup and check that they start. | PENDING |
| R-03 | Challenge submissions may differ from the current implementation | Compare Member 2 and Member 3 challenge files, flags, points, and dependencies with the approved design before merging any changes. | PENDING |
| R-04 | Unintended challenge-solving paths may exist | Test direct access and dependency restrictions using an appropriate test account. | PENDING |
| R-05 | Network isolation has not been fully validated | Verify allowed and restricted connectivity and document the results. | PENDING |
| R-06 | VM snapshot-based recovery previously failed during testing | A script-based Stage 6 reset procedure was implemented and tested as an alternative. | SCRIPT TEST PASS — existing evidence |

Do not describe a risk as fixed unless the corrective action has been performed and verified. Record any newly discovered defects, their impact, the fix applied, and the retest result.

## 6. Reset and Recovery Verification

### Stage 6 recovery

The Stage 6 reset script is located at:

`/usr/local/sbin/cybervault-stage6-reset.sh`

The script was tested to restore the protected flag file and restart `cv-update.service`. The backup comparison and service status checks passed in the recorded test.

### CTFd recovery

CTFd recovery is a separate test. The successful Stage 6 reset does not prove that the CTFd challenge state can be recovered.

CTFd recovery remains PENDING until the documented procedure is safely tested and the expected platform, challenge, and scoring state is verified.

## 7. Integration Test Conclusion

The available evidence confirms that the CTFd containers and web service were running, all six challenges were solved, the scoreboard reached 1,350 points, and the Stage 6 SSH connection and service status were successfully checked.

The Stage 6 reset and flag restoration procedures also passed in previously collected tests.

However, the complete CTFd recovery procedure, unintended shortcut checks, exported VM import tests, network isolation validation, and final consistency review remain pending. The project should not be declared fully validated until these remaining tests have been performed and their results recorded.

**Prepared for:** CyberVault CTF Play Box — Integration, Testing & Documentation  
**Responsible Member:** Devindi K.G.Y — IT24100526
