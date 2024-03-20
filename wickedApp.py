
import subprocess
import time

# Define the shell script file name
shell_script = "./your_script.sh"  # Replace with your actual shell script file name

# Define the range of parameters
min_frequency = 76800000
max_frequency = 921600000

# Define the number of iterations
num_iterations = 30

# Iterate over the range of parameters
for i in range(0, num_iterations, 1):
    freqscript_command = 'sudo /home/carpab00/Desktop/Parallel-AES-Algorithm-using-CUDA/freq_scalator.sh '

    if i%2==0:
        freqscript_command += str(min_frequency)
    else:
        freqscript_command += str(max_frequency)

    

    # Execute the shell script with the current frequency as a parameter
    command_result = subprocess.run(freqscript_command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
    
    if command_result.returncode != 0:
        
        print("Error executing the command. Exit code: {}".format(command_result.returncode))
        print("Error output:")
        print(command_result.stderr)
    
    # Delay for 100 microseconds
    time.sleep(0.0001) 
