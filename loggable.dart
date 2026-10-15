

mixin Loggable {
  void log(String message) {
    print('[${DateTime.now().toString().substring(0, 16)}] $message');
  }
}