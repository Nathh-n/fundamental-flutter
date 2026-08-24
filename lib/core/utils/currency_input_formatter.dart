import 'package:flutter/services.dart';
import 'currency_formatter.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll('.', '');
    final number = int.tryParse(digitsOnly);

    if (number == null) {
      return oldValue;
    }

    final formatted = formatCurrencyNumber(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
