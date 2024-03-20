from PIL import Image

# Load the image
image = Image.open("./image.jpg")

# Convert the image to a byte array
byte_array = image.tobytes()

# Get the dimensions of the image
width, height = image.size

# Store the byte array and dimensions in a file
with open("byteImage.txt", "w") as byte_file:
    byte_file.write(f"{width} {height}\n")
    byte_file.write(byte_array.hex())

