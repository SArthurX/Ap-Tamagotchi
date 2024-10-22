import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import '../core/experience_provider.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _playFarmMusic(); // 進入頁面時播放農場音樂
  }

  @override
  void dispose() {
    _stopFarmMusic(); // 離開頁面時停止農場音樂
    super.dispose();
  }

  void _playFarmMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.play(AssetSource('audio/farm_music.mp3'), volume: 0.5);
    _audioPlayer!.setReleaseMode(ReleaseMode.loop); // 設置循環播放
  }

  // 停止農場音樂
  void _stopFarmMusic() async {
    await _audioPlayer?.stop();
  }

  @override
  Widget build(BuildContext context) {
        final experience =
        Provider.of<ExperienceProvider>(context).experience; 
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖片
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/store.png',
              fit: BoxFit.contain, // 保持圖片比例
            ),
          ),
          Positioned(
            top: 55,
            right: 60,
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
          // 前景內容（放在背景圖片之上）s
        ],
      ),
    );
  }
}
