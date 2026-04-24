import 'dart:async';

enum AppEvent { refresh,reloadHome,mapRefresh}


class NotificationCenter {
  static final StreamController<AppEvent> _controller =
  StreamController<AppEvent>.broadcast();

  static Stream<AppEvent> get stream => _controller.stream;

  static void post(AppEvent event) {
    _controller.add(event);
  }
}