class PriceFormatter {
  static String formatta(int? price) {
    if(price == null) return '-';
    return '$price €';
  }
}