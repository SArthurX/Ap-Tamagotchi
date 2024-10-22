import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../core/experience_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const API_KEY = 'YOUR_API_KEY';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _city = '';
  String _airQuality = '未知';
  String _chickenImage = 'assets/chface/200.png'; // 初始圖片
  int _aqi = 0;
  double _imageTop = 250;
  double _imageLeft = 110;

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndAirQuality();
  }

  // 雞圖片跳兩下的動畫
  void _startChickenJumpAnimation() async {
    for (int i = 0; i < 2; i++) {
      setState(() {
        _imageTop -= 30; // 向上跳
      });
      await Future.delayed(Duration(milliseconds: 200));
      setState(() {
        _imageTop += 30; // 回到原來位置
      });
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  // 获取当前位置和空气质量数据
  void _getCurrentLocationAndAirQuality() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('位置服務不可用');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('權限被拒絕');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('位置权限被永久拒绝');
    }

    Position position = await Geolocator.getCurrentPosition();
    print(position);
    _city = '臺中市';
    _fetchAirQuality(_city);
  }

  void _fetchAirQuality(String city) async {
    String apiUrl =
        'https://data.moenv.gov.tw/api/v2/aqx_p_432?format=json&limit=1000&api_key=${API_KEY}&sort=ImportDate%20desc&filters=County,EQ,$city';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        var records = data['records'];

        if (records != null && records.length > 0) {
          var record = records[3];

          setState(() {
            _aqi = int.tryParse(record['aqi']) ?? 0;
            _updateAirQuality();
          });
        } else {
          print('無法載入空品數據');
        }
      } else {
        print('Failed to load air quality data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateChickenImage() {
    // 如果 AQI 小於 10，對應 "死亡" 狀態 (0.png)
    if (_aqi < 10) {
      _chickenImage = 'assets/chface/0.png';
    } else {
      // 反向映射，將 AQI 越大對應到越好的圖片（200 是最好，10 是次差）
      int roundedAqi = (200 - ((_aqi / 10).round() * 10));

      // 確保圖片數值在 10 到 200 之間
      if (roundedAqi < 10) {
        roundedAqi = 10; // 次差狀態
      } else if (roundedAqi > 200) {
        roundedAqi = 200; // 最佳狀態
      }

      _chickenImage = 'assets/chface/$roundedAqi.png'; // 動態設置圖片路徑
    }
    setState(() {});
    _startChickenJumpAnimation(); // 確保更新圖片後再開始跳躍
  }

  void _updateAirQuality() {
    if (_aqi <= 50) {
      _airQuality = '良好';
    } else if (_aqi <= 100) {
      _airQuality = '中等';
    } else if (_aqi <= 150) {
      _airQuality = '對敏感人群不健康';
    } else {
      _airQuality = '不健康';
    }

    _updateChickenImage(); // 更新雞的圖片
  }

  Color _getAirQualityColor() {
    if (_airQuality == '良好') {
      return Colors.green; // 良好狀態顯示綠色
    } else if (_airQuality == '中等') {
      return Colors.yellow; // 中等顯示黃色
    } else if (_airQuality == '對敏感人群不健康') {
      return Colors.orange; // 對敏感人群不健康顯示橙色
    } else {
      return Colors.red; // 不健康顯示紅色
    }
  }

  @override
  Widget build(BuildContext context) {
    final experience =
        Provider.of<ExperienceProvider>(context).experience; // 獲取經驗值

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // 背景圖片
          Image.asset(
            'assets/home.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // 可調整位置的文字
          Positioned(
            top: 712,
            left: 150,
            child: Text(
              '$_city',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Positioned(
            top: 820,
            left: 180,
            child: Text(
              '$_aqi',
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Positioned(
            top: 578,
            left: 280,
            child: Text(
              '$_airQuality',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _getAirQualityColor(), // 動態改變顏色
              ),
            ),
          ),
          Positioned(
            top: 53,
            right: 40,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '\$ $experience', // 顯示經驗值
                style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // 可拖動的圖片
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            top: _imageTop,
            left: _imageLeft,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _imageTop += details.delta.dy;
                  _imageLeft += details.delta.dx;
                });
              },
              child: Image.asset(
                _chickenImage, // 動態加載的雞圖片
                width: 200,
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
