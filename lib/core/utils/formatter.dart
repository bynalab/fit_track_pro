import 'package:intl/intl.dart';

String numberFormat(dynamic amount) {
  amount ??= 0;
  final formatter = NumberFormat('#,###.##');
  return formatter.format(amount);
}
