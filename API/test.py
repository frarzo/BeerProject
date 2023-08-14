import requests

r = requests.post(
    "http://localhost:80/API/api.php", data={"email": "franz9700@gmail.com", "psw": "abcd1234"},
)

print(r.text)
