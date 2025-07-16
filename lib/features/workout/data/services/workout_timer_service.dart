import 'dart:async';

typedef TickCallback = void Function(int seconds);

class WorkoutTimerService {
  Timer? _timer;
  int _elapsed = 0;
  late TickCallback _onTick;

  void start(TickCallback onTick) {
    _onTick = onTick;
    _elapsed = 0;
    _startTimer();
  }

  void resume() {
    _startTimer();
  }

  void pause() {
    _timer?.cancel();
  }

  void stop() {
    _timer?.cancel();
    _elapsed = 0;
  }

  int get elapsed => _elapsed;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsed++;
      _onTick(_elapsed);
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
