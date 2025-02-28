# import requests
# from requests_html import HTMLSession
from bs4 import BeautifulSoup
from selenium import webdriver


# URL = "https://sonnenaufgang.online/sun/darmstadt"
#
# response = requests.get(URL)
#
# soup = BeautifulSoup(response.text,'html.parser')
#
# sunrise_data = soup.find('span',{'data-name': 'sunrise'})
#
# print(sunrise_data)

# https://www.youtube.com/channel/UCIE23hIy9QMns0VG8hDtUiw/videos

baseURL = 'https://www.youtube.com'
URL     = 'https://www.youtube.com/channel/UCIE23hIy9QMns0VG8hDtUiw/videos'
print(f"Scrapen von: {URL}")

session1   = HTMLSession()
page1      = session1.get(URL)

page1.html.render(sleep=5)

soup1      = BeautifulSoup(page1.html.html, 'html.parser')
results    = soup1.find_all(id='video-title')

title      = str(results[0].encode_contents())
hRefUrl    = str(results[0]['href']);

print(f"title   : {title}")
print(f"hRefUrl : {hRefUrl}")


# print('Video: + str(title) + wird abgerufen')
# videoURL baseURL hRefUrl
# print('video: videoURL)
# session2 HTMLSession()
# page2 session2.get(videoURL)
# page2.html.render(sleep=5)
# file open('video.html', 'w', encoding='utf8')
# file.write(page2.html.html)
# file.close()
# soup2 BeautifulSoup (page2.html.html, 'html.parser')
# results2 soup2.find_all(class_='view-count')
# if len(results2) > 0:
# print(results2)
# else:
# print('Element not found')