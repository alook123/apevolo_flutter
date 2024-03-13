// ignore_for_file: avoid_print

class Logger {
  // Sample of abstract logging function
  static Future<void> write(String message, {bool isError = false}) async {
    await Future.microtask(() => print(
        'DateTime: [${DateTime.now()}];isError: [$isError]; message:$message. '));
  }
}
