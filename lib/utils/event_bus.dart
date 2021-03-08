import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static EventBus _eventBus;

  static EventBus getInstance() {
    if (_eventBus == null) {
      _eventBus = new EventBus();
    }

    return _eventBus;
  }
}

// 改变首页的搜索关键词
class ChangeSearchWord {
  String keyword;

  ChangeSearchWord(this.keyword);
}
