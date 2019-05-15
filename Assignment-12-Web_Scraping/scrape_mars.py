# import dependencies
from flask import Flask, render_template
from bs4 import BeautifulSoup as bs
from splinter import Browser
import requests
import pandas as pd

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/scrape")
def scrape():
    # https://splinter.readthedocs.io/en/latest/drivers/chrome.html
    get_ipython().system('which chromedriver')


    # # NASA Mars News

    executable_path = {'executable_path': '/usr/local/bin/chromedriver'}
    browser = Browser('chrome', **executable_path, headless=False)

    url = 'https://mars.nasa.gov/news/'
    browser.visit(url)

    html = requests.get(url)
    soup = bs(html.text, 'lxml')

    title_results = soup.find_all('div', class_="content_title")
    paragraph_results = soup.find_all('div', class_="rollover_description_inner")

    news_title = soup.find('div', class_="content_title").text.strip()
    news_p = soup.find('div', class_="rollover_description_inner").text.strip()


    # # JPL Mars Space Images

    executable_path = {'executable_path': '/usr/local/bin/chromedriver'}
    browser = Browser('chrome', **executable_path, headless=False)

    url = 'https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars'
    browser.visit(url)

    html = browser.html
    soup = bs(html, 'html.parser')

    result = soup.find('div', class_="default floating_text_area ms-layer")

    featured_image = result.footer.a['data-fancybox-href']
    featured_image_url = f'http://www.jpl.nasa.gov{featured_image}'


    # # Mars Weather

    url = 'https://twitter.com/marswxreport?lang=en'
    browser.visit(url)

    html = browser.html
    soup = bs(html, 'html.parser')

    current_weather = soup.find('p', class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text").text


    # # Mars Facts

    url = 'https://space-facts.com/mars/'
    table = pd.read_html(url)
    df = table[0]
    df.columns = ['Profile', 'Value']
    df.to_html('table.html',index=False, justify='center')


    # # Mars Hemisphere

    executable_path = {'executable_path': '/usr/local/bin/chromedriver'}
    browser = Browser('chrome', **executable_path, headless=False)

    url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(url)

    hemisphere_image_urls = []

    links = browser.find_by_css("h3")

    for i in range(len(links)):
        hemisphere = {}
        browser.find_by_css("h3")[i].click()
        sample = browser.find_link_by_text('Sample').first
        hemisphere['img_url'] = sample['href']
        hemisphere['title'] = browser.find_by_css("h2.title").text
        hemisphere_image_urls.append(hemisphere)
        browser.back()

    return render_template('index.html', news_p = news_p, news_title = news_title, featured_image_url = featured_image_url, current_weather = current_weather)



