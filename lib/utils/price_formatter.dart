class PriceFormatter {
  static String formatta(double? price) {
    if(price == null) return '-';
    return '$price €';
  }
}