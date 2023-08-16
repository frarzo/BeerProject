import json, os

# I dati sono stati generati con mockaroo.com, ma ha tornato un valore stringa con la virgola al posto del numero float con punto, quindi converto


def serialize_json(folder, filename, data):
    if not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)
    with open(f"{folder}/{filename}", "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        f.close()
    print(f"Data serialized to path: {folder}/{filename}")


def read_json(path):
    if os.path.exists(path):
        with open(path, "r", encoding="utf8") as file:
            data = json.load(file)
        print(f"Data read from path: {path}")
        return data
    else:
        print(f"No data found at path: {path}")
        return {}


utenti = read_json(".//db stuff/utente.json")

for user in utenti:
    user['saldo']=float(user["saldo"].replace(",","."))
    print(user["saldo"])


serialize_json("./", "utente.json", utenti)
