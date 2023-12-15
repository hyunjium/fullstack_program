import pickle
import pandas as pd
from openpyxl import Workbook


#pickle list로 가져와서 dataframe으로 변환
with open("KFC-영통씨네마점.pickle","rb") as fr:
    from_pickle_list = pickle.load(fr)
reviews = pd.DataFrame(from_pickle_list)

#order 중 NaN과 '' 행 삭제, index reset
reviews = reviews[reviews['order'].notna()]
for row_num in range(len(reviews)):
    if reviews.loc[row_num]['order'][0] == '':
        reviews = reviews.drop(row_num)
reviews = reviews.reset_index(drop=True)        

#set에 메뉴들 넣기
menuz = set()
del_space_menuz = set()
len_del_space_menuz = 0
for review in reviews['order']:
    for menu in review:
        del_space = menu.replace(" ","")
        del_space_menuz.add(del_space)
        if len_del_space_menuz != len(del_space_menuz):
            menuz.add(menu)
        len_del_space_menuz = len(del_space_menuz)

#set의 메뉴들을 key로 가지고 있는 'None' dict 만들기
taste_dict = {}
for each_menu in menuz:
    taste_dict[each_menu] = ''

key = list(taste_dict)

#space없는 taste_dict 만들기
nos_taste_dict = {}
for each_menu2 in menuz:
    nos_each_menu2 = each_menu2.replace(" ","")
    nos_taste_dict[nos_each_menu2] = ''

#메뉴별 '맛' 별점 추가
taste_df = pd.DataFrame(data={}, columns=taste_dict.keys())
for i in range(len(reviews)):
    order_dict_taste = taste_dict.copy()
    for order in reviews.loc[i]['order']:
        del_space_order = order.replace(" ","")
        if del_space_order in nos_taste_dict:
            index = list(nos_taste_dict).index(del_space_order)
    
            order_dict_taste[key[index]] = reviews.loc[i]['taste']
        
    taste_df = pd.concat([taste_df, pd.DataFrame([order_dict_taste])], ignore_index=True)

#엑셀로 출력 menu_name	store_name	avr_star review_num
wb = Workbook()
ws = wb.active

for row in range(len(taste_dict)):
    menu_name = key[row]
    store_name = "KFC-영통씨네마점"
    review_num = 0
    add_star = 0
    for values in taste_df[menu_name]:
        if values != "":
            review_num+=1
            add_star+=values
    avr_star = add_star/review_num
    ws.append({'A':menu_name, 'B':store_name, 'C':avr_star, 'D':review_num})

wb.save(filename="KFC-영통씨네마점.xlsx")

# #엑셀로 출력
# writer = pd.ExcelWriter("text.xlsx")
# taste_df.to_excel(writer, sheet_name="맛")
# writer.close()