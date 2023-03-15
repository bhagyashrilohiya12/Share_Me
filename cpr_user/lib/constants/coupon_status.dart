class CouponStatus {
  static const int virgin = 0;
  static const int used = 0;
  static const int expired = 0;
  static const int reviewed = 0;

  static String getName(int code) {
    if (code == CouponStatus.virgin) {
      return "Virgin";
    } else if (code == CouponStatus.used) {
      return "Used";
    } else if (code == CouponStatus.expired) {
      return "Expired";
    } else if (code == CouponStatus.reviewed) {
      return "Reviewed";
    } else {
      return "";
    }
  }
}
