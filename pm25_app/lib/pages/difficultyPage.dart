import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'quiz_page.dart';
import 'package:provider/provider.dart';
import '../core/experience_provider.dart';

class DifficultyPage extends StatefulWidget {
  @override
  _DifficultyPageState createState() => _DifficultyPageState();
}

class _DifficultyPageState extends State<DifficultyPage> {
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _playChallengeMusic();
  }

  @override
  void dispose() {
    _stopMusic(); // 當頁面結束時停止播放音樂
    super.dispose();
  }

  // 播放闖關區音樂
  void _playChallengeMusic() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!
        .play(AssetSource('audio/challenge_music.mp3'), volume: 0.5);
    _audioPlayer!.setReleaseMode(ReleaseMode.loop); // 設置循環播放
  }

  // 停止音樂播放
  void _stopMusic() async {
    await _audioPlayer?.stop();
  }

  @override
  Widget build(BuildContext context) {
    final experience =
        Provider.of<ExperienceProvider>(context).experience; // 獲取經驗值
    return Scaffold(
      body: Stack(
        children: [
          // 背景圖片
          Image.asset('assets/difficulty.png',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover // 保持圖片比例
              ),
          Positioned(
            top: 68,
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

          // 初級按鈕
          Positioned(
            left: 50,
            top: 285,
            width: 280,
            height: 60,
            child: GestureDetector(
              onTap: () {
                _navigateToQuizPage(context, '簡單');
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // 中級按鈕
          Positioned(
            left: 50,
            top: 455,
            width: 280,
            height: 60,
            child: GestureDetector(
              onTap: () {
                _navigateToQuizPage(context, '中等');
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // 高級按鈕
          Positioned(
            left: 50,
            top: 625,
            width: 280,
            height: 60,
            child: GestureDetector(
              onTap: () {
                _navigateToQuizPage(context, '困難');
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 導航到 QuizPage，但保持音樂播放
  void _navigateToQuizPage(BuildContext context, String difficulty) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizPage(difficulty: difficulty, audioPlayer: _audioPlayer),
      ),
    );
  }
}
