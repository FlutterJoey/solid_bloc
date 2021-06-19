class CounterService {
  int _count = 0;

  void increment({int amount = 1}) {
    _count += amount;
  }

  void reduce({int amount = 1}) {
    _count -= amount;
  }

  /// method that will guarantee that _count will not change immediately on execution
  Future<void> incrementAsync({int amount = 1}) async {
    await Future.delayed(Duration(seconds: 1));
    _count += amount;
  }

  /// method that will guarantee that _count will not change immediately on execution
  Future<void> reduceAsync({int amount = 1}) async {
    _count -= amount;
  }

  int get count => _count;
}
