import 'package:currency_formatter/currency_formatter.dart';

class Currency {
  static CurrencyFormat vndSettings = CurrencyFormat(
    code: 'vnd',
    symbol: '₫',
    symbolSide: SymbolSide.left,
    thousandSeparator: '.',
    decimalSeparator: ',',
    symbolSeparator: ' ',
  );

  static String formatVND(double amount) {
    return CurrencyFormatter.format(amount, vndSettings);
  }

  static String formatIntVND(int amount) {
    return CurrencyFormatter.format(amount, vndSettings);
  }
}
