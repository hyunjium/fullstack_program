from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
from bs4 import BeautifulSoup
import pickle

browser = webdriver.Chrome()
time.sleep(2)
browser.get("https://www.yogiyo.co.kr/mobile/#/")

#주소 경희대로 변경
search_box = browser.find_element(By.NAME,"address_input")
browser.find_element(By.NAME,"address_input").clear()
search_box.send_keys("경희대학교 국제캠퍼스")
search_box.send_keys(Keys.ENTER)
time.sleep(2)
school_add = browser.find_element(By.CSS_SELECTOR, "#search > div > form > ul > li:nth-child(3) > a")
school_add.click()
time.sleep(2)

#가게 검색
search = browser.find_element(By.CSS_SELECTOR, "#category > ul > li.hidden-xs.menu-search > a")
search.click()
search_word = browser.find_element(By.CSS_SELECTOR, "#category > ul > li.main-search > form > div > input")
search_word.send_keys("KFC-영통씨네마점")
search_word.send_keys(Keys.ENTER)
time.sleep(2)
click_mac = browser.find_element(By.CSS_SELECTOR, "#content > div > div:nth-child(5) > div > div > div > div")
click_mac.click()
time.sleep(2)

soup = BeautifulSoup(browser.page_source, "lxml")

#리뷰 카테고리 클릭
star_sec = browser.find_element(By.CSS_SELECTOR, "#content > div.restaurant-detail.row.ng-scope > div.col-sm-8 > ul > li:nth-child(2) > a")
star_sec.click()
time.sleep(2)

#더보기 클릭
look_more = browser.find_element(By.CSS_SELECTOR, "#review > li.list-group-item.btn-more > a")
while True:
    try:
        look_more.click()
        time.sleep(3)
    except:
        break

review = []

#리뷰 메뉴들 가져오기
review_menu = browser.find_elements(By.CSS_SELECTOR,'.order-items.default.ng-binding')
print("리뷰개수=",len(review_menu))
for each_menu in review_menu:
    menu_one_person=[]
    sp = each_menu.text.split(',')
    #/있을 경우 앞의 메뉴만, 없을 경우 전체 메뉴 list에 넣기
    for one_menu in sp:
        if '/' in one_menu:
            front_menu=one_menu[:one_menu.find('/')]
            menu_one_person.append(front_menu)
        else:
            menu_one_person.append(one_menu)
    #각 사람의 리뷰들 dict에 넣기
    review_dict = {}
    review_dict['order'] = menu_one_person
    review.append(review_dict)

#리뷰 맛 별점 dict에 넣기
review_star = browser.find_elements(By.CSS_SELECTOR,'.points.ng-binding')
review_num = 0
for taste_num in range(3,len(review_star),3):
    if '' == review_star[taste_num].text:
        review[review_num]['taste'] = 'None'
    else:
        review[review_num]['taste'] = int(review_star[taste_num].text)
    review_num+=1

#음식 사진 url 새로운 dict에 넣기
# url_images_list = []
# food_names = browser.find_elements(By.CSS_SELECTOR, "div[ng-bind-html='item.name|strip_html']")
# for each_food_name in food_names:
#     url_dict = {}
#     url_dict['food_name'] = each_food_name.text
#     url_images_list.append(url_dict)
# print(url_images_list)

# # for each_url in all_food_images:
#     re_url = each_url.get_attribute("style").split('"')
#     url_images_list.append(re_url[1])

# print(url_images_list)

#pickle로 review list 저장
with open("KFC-영통씨네마점.pickle","wb") as fw:
   pickle.dump(review, fw)