import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/farm_page.dart';
import 'pages/store_page.dart';
import 'pages/chome_page.dart';
import 'pages/difficultyPage.dart';

import 'core/experience_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExperienceProvider(),
      child: AirChickenApp(),
    ),
  );
}

class AirChickenApp extends StatefulWidget {
  @override
  _AirChickenAppState createState() => _AirChickenAppState();
}

class _AirChickenAppState extends State<AirChickenApp> {
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _playHomePageMusic();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  // 播放首頁的背景音樂
  void _playHomePageMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(AssetSource('audio/background.mp3'), volume: 0.5);
    _audioPlayer!.setReleaseMode(ReleaseMode.loop); // 設置循環播放
  }

  // 停止首頁的背景音樂
  void _stopHomePageMusic() async {
    await _audioPlayer?.stop();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '空氣清淨雞',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(
        playHomeMusic: _playHomePageMusic, // 傳遞播放音樂的功能到首頁
        stopHomeMusic: _stopHomePageMusic, // 傳遞停止音樂的功能到首頁
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final VoidCallback playHomeMusic;
  final VoidCallback stopHomeMusic;

  MainPage({required this.playHomeMusic, required this.stopHomeMusic});

  @override
  Widget build(BuildContext context) {
    final experience = Provider.of<ExperienceProvider>(context).experience;
    final showExperience =
        Provider.of<ExperienceProvider>(context).showExperience;

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          playHomeMusic(); // 確保返回到主畫面時重新播放音樂
          return true;
        },
        child: Stack(
          children: [
            // 背景圖片
            Image.asset(
              'assets/g_map.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 10,
              top: 20,
              width: 75,
              height: 75,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 點擊區域 - 空品地圖
            Positioned(
              left: 230,
              top: 20,
              width: 130,
              height: 75,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 點擊區域 - 闖關區
            Positioned(
              left: 150,
              top: 150,
              width: 200,
              height: 150,
              child: GestureDetector(
                onTap: () {
                  stopHomeMusic(); // 停止首頁音樂
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DifficultyPage()),
                  ).then((_) => playHomeMusic());
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 點擊區域 - 農場
            Positioned(
              left: 280,
              top: 600,
              width: 120,
              height: 120,
              child: GestureDetector(
                onTap: () {
                  stopHomeMusic();
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => FarmPage()))
                      .then((_) => playHomeMusic());
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 點擊區域 - 小雞之家
            Positioned(
              left: 120,
              top: 720,
              width: 120,
              height: 120,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChomePage()),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // 點擊區域 - 商店
            Positioned(
              left: 15,
              top: 330,
              width: 100,
              height: 120,
              child: GestureDetector(
                onTap: () {
                  stopHomeMusic();
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StorePage()))
                      .then((_) => playHomeMusic());
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
