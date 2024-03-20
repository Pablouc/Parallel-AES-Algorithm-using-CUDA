import sys
import os 
import subprocess
import threading
import wickedApp

threads = []


def executeApps():
    AES_command = 'sudo ./AES novel.txt key.txt encrypt.txt decrypt.txt'
    wicked_command = 'sudo python3 wickedApp.py'
    matrixMult_command= 'sudo ./test'
    run_attack = subprocess.run(AES_command + '&' + matrixMult_command +'&'+ wicked_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    if run_attack.returncode != 0 :
        print(run_attack.stderr)

    validation_command = 'sudo diff novel.txt decrypt.txt'
    attack_validation = subprocess.run(validation_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    if attack_validation.stdout.strip():
        print(attack_validation.stdout)

for i in range(10):
    executeApps()
    # thread = threading.Thread(target=executeApps, args=())
   # threads.append(thread)
   # thread.start()


#for t in threads:
   # t.join()
