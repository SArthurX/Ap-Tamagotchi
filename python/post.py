
import requests
import json

api_token='YOUR_API_KEY'

def fetch_pm25_data():
    url = f"https://data.moenv.gov.tw/api/v2/aqx_p_136?api_key={api_token}"   # 請將 YOUR_API_KEY 替換為您的實際 API 金鑰
    headers = {
        'accept': '*/*'
    }

    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        for item in data['records']:
            if item['itemengname'] == 'PM2.5':
                print(f"縣市: {item['county']}, 區域: {item['sitename']}, PM2.5 濃度: {item['concentration']} μg/m3")
    else:        
        print(f"錯誤: 無法獲取數據 (HTTP狀態碼: {response.status_code})")

if __name__ == "__main__":
    fetch_pm25_data()
