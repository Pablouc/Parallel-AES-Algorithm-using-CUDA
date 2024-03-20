from PIL import Image

# Load the byte array and dimensions from the file
with open("byteImage.txt", "r") as byte_file:
        width, height = map(int, byte_file.readline().split())
        byte_array = bytes.fromhex(byte_file.read())

# Convert the byte array back into an image
image = Image.frombytes("RGB", (width, height), byte_array)

# Save the image to a file
image.save("reconstructed_image.jpg")
