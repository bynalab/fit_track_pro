import 'package:intl/intl.dart';

String numberFormat(dynamic amount) {
  amount ??= 0;
  final formatter = NumberFormat('#,###.##');
  return formatter.format(amount);
}

String formatDuration(int seconds) {
  final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
  final secs = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$secs';
}

String formatElapsedTime(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '$hours hr ${minutes.toString().padLeft(2, '0')} min ${remainingSeconds.toString().padLeft(2, '0')} sec';
  } else if (minutes > 0) {
    return '$minutes min ${remainingSeconds.toString().padLeft(2, '0')} sec';
  }

  return '$remainingSeconds sec';
}
