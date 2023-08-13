import requests

r = requests.post(
    "http://localhost:80/api.php",
    json={"email": "franz9700@gmail.com", "psw": "abcd1234"},
)

print(r.text)
