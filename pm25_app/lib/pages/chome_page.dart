import 'dart:math';
import 'package:flutter/material.dart';
import '../core/experience_provider.dart';
import 'package:provider/provider.dart';

class ChomePage extends StatefulWidget {
  @override
  _ChomePageState createState() => _ChomePageState();
}

class _ChomePageState extends State<ChomePage>
    with SingleTickerProviderStateMixin {
  String randomImage = '';
  double left = 90.0; // 預設圖片的X軸位置
  double top = 450.0; // 預設圖片的Y軸位置
  AnimationController? _controller; // 控制跳躍動畫
  Animation<double>? _jumpAnimation;
  late Random _random; // 用於隨機方向的變量

  @override
  void initState() {
    super.initState();
    _random = Random();
    _loadRandomImage();

    // 初始化動畫控制器
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // 定義跳躍動畫
    _jumpAnimation = Tween<double>(begin: 0, end: -30).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.reverse();
        }
      });

    // 啟動動畫
    _controller!.forward();

    // 開始讓小雞自動走動
    _startWalking();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // 載入隨機圖片
  void _loadRandomImage() async {
    List<String> images = [
      'assets/chome/1.png',
      'assets/chome/2.png',
      'assets/chome/3.png',
      'assets/chome/4.png',
      'assets/chome/5.png',
      'assets/chome/6.png',
      'assets/chome/7.png',
      'assets/chome/8.png',
    ];
    setState(() {
      randomImage = images[_random.nextInt(images.length)];
    });
  }

  // 自動讓小雞行走
  void _startWalking() async {
    while (mounted) {
      await Future.delayed(Duration(seconds: 1)); // 每隔一秒更新方向

      setState(() {
        // 隨機選擇移動方向
        double dx = (_random.nextDouble() - 0.5) * 100; // X軸隨機移動範圍
        double dy = (_random.nextDouble() - 0.5) * 100; // Y軸隨機移動範圍

        // 確保小雞不會移出螢幕邊界
        left = (left + dx).clamp(0.0, MediaQuery.of(context).size.width - 200);
        top = (top + dy).clamp(0.0, MediaQuery.of(context).size.height - 200);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final experience =
        Provider.of<ExperienceProvider>(context).experience; // 獲取經驗值

    return Scaffold(
      body: Stack(
        children: [
          // 背景圖片
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/chicken_home.png',
              fit: BoxFit.contain, // 保持圖片比例
            ),
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
          randomImage.isNotEmpty
              ? AnimatedPositioned(
                  duration: Duration(seconds: 1), // 設置動畫持續時間
                  left: left,
                  top: top + (_jumpAnimation?.value ?? 0), // 加上跳躍動畫的位移
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        left += details.delta.dx; // 更新X軸位置
                        top += details.delta.dy; // 更新Y軸位置
                      });
                    },
                    child: Image.asset(randomImage, width: 200, height: 200),
                  ),
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }
}
