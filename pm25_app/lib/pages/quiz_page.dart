import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/experience_provider.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final String difficulty;
  final AudioPlayer? audioPlayer;

  QuizPage({required this.difficulty, required this.audioPlayer});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void dispose() {
    _stopMusic();
    super.dispose();
  }

  // 停止音樂播放
  void _stopMusic() async {
    await widget.audioPlayer?.stop();
  }

  List<QuizCard> _quizCards = [];
  int _currentIndex = 0;
  int _score = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadQuizCards();
  }

  // 增加題目

  void _loadQuizCards() {
    if (widget.difficulty == '簡單') {
      _quizCards = [
        QuizCard(
          question: '空氣品質指標 Air Quality index 包含哪些指標？',
          options: ['臭氧(O₃)', '細懸浮微粒(PM2.5)', '懸浮微粒(PM10)', '以上皆是'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '空污污染事件 Air pollution episode 高於幾天引起空氣品質惡化時，稱為空污事件?',
          options: ['高於一天以上', '一小時以下', '1-12小時', '12-24小時'],
          answerIndex: 0,
        ),
        QuizCard(
          question: '酸雨 Acid rain 的定義為雨水 pH 值小於多少，稱之酸雨？',
          options: ['7.0', '6.0', '5.0', '6.5'],
          answerIndex: 2,
        ),
        QuizCard(
          question: '台灣有多少空氣品質預報區 Air Quality forecasting area？',
          options: ['5個', '7個', '9個', '10個'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '有毒氣體 Toxic gas 有哪些？',
          options: ['氯化物', '氯氣 (Cl₂)', '氨氣', '以上皆是'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '台灣主要產生揚塵之河川哪些為非？',
          options: ['大安溪', '大甲溪', '烏溪', '花蓮溪'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '一天當中什麼時候臭氧濃度最高？',
          options: ['早上', '中午', '下午', '晚上'],
          answerIndex: 1,
        ),
        QuizCard(
          question: '細懸浮微粒(PM2.5) 在一天當中什麼時候最高？',
          options: ['中午前', '中午後', '清晨', '凌晨'],
          answerIndex: 1,
        ),
        QuizCard(
          question: '在112年前環境部空污感測器在台灣約已布建多少？',
          options: ['10,000', '15,000', '20,000', '5,000'],
          answerIndex: 0,
        ),
        QuizCard(
          question: '環境部空污感測器提供每幾分鐘 1 筆之感測數據？',
          options: ['1分鐘', '5分鐘', '10分鐘', '30分鐘'],
          answerIndex: 0,
        ),
        QuizCard(
          question: '台灣夏半年常見天氣系統何者為是？',
          options: ['熱帶性低氣壓', '颱風', '太平洋高壓(籠罩)', '以上皆是'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '台灣冬半年常見天氣系統中何者為非？',
          options: ['東北季風', '高壓出海', '高壓西移', '高壓迴流'],
          answerIndex: 2,
        ),
        QuizCard(
          question: '一氧化碳(CO)的檢測方法何者為是？',
          options: ['紅外線法', '紫外光吸收法', '化學發光法', '紫外光螢光法'],
          answerIndex: 0,
        ),
        QuizCard(
          question: '臭氧(O₃)的檢測方法何者為是？',
          options: ['紅外線法', '紫外光吸收法', '化學發光法', '紫外光螢光法'],
          answerIndex: 1,
        ),
        QuizCard(
          question: '氮氧化物(NOₓ)的檢測方法何者為是？',
          options: ['紅外線法', '紫外光吸收法', '化學發光法', '紫外光螢光法'],
          answerIndex: 2,
        ),
        QuizCard(
          question: '二氧化硫(SO₂)的檢測方法何者為是？',
          options: ['紅外線法', '紫外光吸收法', '化學發光法', '紫外光螢光法'],
          answerIndex: 3,
        ),
        // 你可以繼續增加更多簡單題目...
      ];
    } else if (widget.difficulty == '中等') {
      _quizCards = [
        QuizCard(
          question: '台灣空品監測站有哪些？',
          options: ['普通空氣品質監測站', '半自動監測站', '國家公園空氣品質監測站', '以上皆是'],
          answerIndex: 3,
        ),
        QuizCard(
          question: '國家公園空品監測站會避開哪裡的空氣品質？',
          options: ['道路或停車場', '自然景觀', '生態保育區', '園區入口'],
          answerIndex: 0,
        ),
        QuizCard(
          question: '空氣品質潛勢預報 Forecasting air quality potential 是什麼？',
          options: [
            '假設每日污染源排放之變化，則利用氣象因素之改變來預測未來空氣品質狀況稱為空氣品質潛勢預報',
            '假設每日污染源排放之變化大於天氣之變化，則利用氣象因素之改變來預測未來空氣品質狀況稱為空氣品質潛勢預報',
            '假設每日污染源排放之變化等於天氣之變化，則利用氣象因素之改變來預測未來空氣品質狀況稱為空氣品質潛勢預報',
            '以上皆是'
          ],
          answerIndex: 0,
        ),
        QuizCard(
          question: '空氣污染物中的自然界的釋出不包含什麼？',
          options: ['沙塵暴', '火山活動', '海鹽飛沫', '工業污染'],
          answerIndex: 3,
        ),
      ];
    } else if (widget.difficulty == '困難') {
      _quizCards = [
        QuizCard(
          question: 'coming soon!',
          options: ['A', 'B', 'C', 'D'],
          answerIndex: 0,
        ),
      ];
    }

    _quizCards.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final experience =
        Provider.of<ExperienceProvider>(context).experience; // 獲取經驗值

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/quiz.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
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
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.white.withOpacity(0.7),
              child: Text(
                _quizCards.isNotEmpty ? _quizCards[_currentIndex].question : '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // 選項按鈕1
          _buildOptionButton(70, 290, 0),
          // 選項按鈕2
          _buildOptionButton(70, 400, 1),
          // 選項按鈕3
          _buildOptionButton(70, 515, 2),
          // 選項按鈕4
          _buildOptionButton(70, 635, 3),
          // 分數顯示
          Positioned(
            top: 750,
            left: 20,
            child: Text(
              '連續正確 x$_score',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // 選項按鈕構建函數
  Widget _buildOptionButton(double left, double top, int optionIndex) {
    return Positioned(
      left: left,
      top: top,
      width: 270,
      height: 50,
      child: GestureDetector(
        onTap: () {
          _checkAnswer(optionIndex, _quizCards[_currentIndex].answerIndex);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _quizCards.isNotEmpty
                ? _quizCards[_currentIndex].options[optionIndex]
                : '',
            style: TextStyle(fontSize: 30, color: Colors.blueGrey),
          ),
        ),
      ),
    );
  }

  void _checkAnswer(int selectedIndex, int correctIndex) async {
    if (selectedIndex == correctIndex) {
      int points = _calculatePoints();
      Provider.of<ExperienceProvider>(context, listen: false)
          .increaseExperience(points);
      setState(() {
        _score += 1;
      });
      await _playSound('correct.mp3');
    } else {
      setState(() {
        _score = 0;
      });
      await _playSound('wrong.mp3');
    }

    // 移動到下一個題目
    if (_currentIndex < _quizCards.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已完成所有題目！')),
      );
    }
  }

  int _calculatePoints() {
    if (widget.difficulty == '簡單') {
      return 10; // 簡單難度每題加 10 分
    } else if (widget.difficulty == '中等') {
      return 20; // 中等難度每題加 20 分
    } else {
      return 0;
    }
  }

  // 播放提示音
  Future<void> _playSound(String fileName) async {
    await _audioPlayer.play(AssetSource(fileName));
  }
}

class QuizCard {
  final String question;
  final List<String> options;
  final int answerIndex;

  QuizCard({
    required this.question,
    required this.options,
    required this.answerIndex,
  });
}
