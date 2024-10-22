import 'package:flutter/foundation.dart';

class ExperienceProvider with ChangeNotifier {
  int _experience = 0; // 初始經驗值
  bool _showExperience = true; // 控制是否顯示經驗值

  int get experience => _experience; // 獲取當前經驗值
  bool get showExperience => _showExperience; // 獲取是否顯示經驗值

  // 增加經驗值
  void increaseExperience(int amount) {
    _experience += amount;
    notifyListeners(); // 通知所有監聽者狀態已更新
  }

  // 減少經驗值
  void decreaseExperience(int amount) {
    if (_experience - amount >= 0) {
      _experience -= amount;
    } else {
      _experience = 0; // 防止經驗值變成負數
    }
    notifyListeners(); // 通知所有監聽者狀態已更新
  }

  // 切換顯示經驗值狀態
  void toggleShowExperience() {
    _showExperience = !_showExperience;
    notifyListeners(); // 通知所有監聽者狀態已更新
  }
}
