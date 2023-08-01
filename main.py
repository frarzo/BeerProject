import serial

ser = serial.Serial('COM3')
print(ser.name)
for el in ser:
    print(el)
    