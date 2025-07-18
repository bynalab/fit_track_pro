import 'package:fit_track_pro/core/utils/formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('numberFormat', () {
    test('formats integer numbers correctly', () {
      expect(numberFormat(1000), '1,000');
      expect(numberFormat(1234567), '1,234,567');
    });

    test('formats decimal numbers correctly', () {
      expect(numberFormat(1234.56), '1,234.56');
      expect(numberFormat(1234567.89), '1,234,567.89');
    });

    test('formats null as 0', () {
      expect(numberFormat(null), '0');
    });
  });

  group('formatDuration', () {
    test('formats seconds less than a minute', () {
      expect(formatDuration(45), '00:45');
    });

    test('formats minutes and seconds correctly', () {
      expect(formatDuration(75), '01:15');
      expect(formatDuration(360), '06:00');
    });
  });

  group('formatElapsedTime', () {
    test('formats seconds only', () {
      expect(formatElapsedTime(10), '10 sec');
    });

    test('formats minutes and seconds', () {
      expect(formatElapsedTime(125), '2 min 05 sec');
    });

    test('formats hours, minutes, and seconds', () {
      expect(formatElapsedTime(3665), '1 hr 01 min 05 sec');
    });

    test('zero duration returns 0 sec', () {
      expect(formatElapsedTime(0), '0 sec');
    });
  });
}
