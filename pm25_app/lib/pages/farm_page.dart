import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FarmPage extends StatefulWidget {
  @override
  _FarmPageState createState() => _FarmPageState();
}

class _FarmPageState extends State<FarmPage> {
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

  // 播放農場音樂
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
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖片
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/farm.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 前景內容
        ],
      ),
    );
  }
}
