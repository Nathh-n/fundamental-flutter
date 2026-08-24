import 'package:intl/intl.dart';

final NumberFormat _currencyFormatter = NumberFormat.decimalPattern('id_ID');

String formatCurrencyNumber(int value) {
  return _currencyFormatter.format(value);
}

String formatRupiah(int value) {
  return 'Rp ${formatCurrencyNumber(value)}';
}
