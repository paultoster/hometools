import requests

key_token = ""
key_token = "3da03ac500a673837a0d6222c45ada4cb26dbb29"
query = "apple"
query = "Siemens"


headers = {
    'Content-Type': 'application/json'
}
requestResponse = requests.get(f"https://api.tiingo.com/tiingo/utilities/search?query={query}&token={key_token}", headers=headers)
print(requestResponse.json())




headers = {
    'Content-Type': 'application/json'
}


requestResponse = requests.get(f"https://api.tiingo.com/tiingo/daily/aapl/prices?startDate=2019-01-02&token={key_token}", headers=headers)
print(requestResponse.json())