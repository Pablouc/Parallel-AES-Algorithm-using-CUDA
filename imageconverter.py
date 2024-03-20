from PIL import Image

# Load the image
image = Image.open("path/to/image.jpg")

# Convert the image to a byte array
byte_array = image.tobytes()

# Store the byte array in a file
with open("byteImage.txt", "wb") as byte_file:
        byte_file.write(byte_array)
