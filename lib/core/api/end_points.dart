class EndPoints {
  // ── Base URLs ─────────────────────────────────────
  static const String baseUrl =
      "https://cargo-project-production.up.railway.app/api";
  static const String aiBaseUrl = "https://abdoelhadray-cardamage.hf.space";

  // ── AI Endpoints ──────────────────────────────────
  static const String aiPredict = "/api/predict";
  static const String aiClasses = "/api/classes";
  static const String aiHealth = "/api/health";

  // ── باقي الـ endpoints ────────────────────────────
  static const String signUp = "/auth/register";
  static const String signIn = "/auth/login";

  // ── User ──────────────────────────────────────────
  static const String getMe = "/user";
  static const String updateMe = "/user";

  // ── Products ──────────────────────────────────────
  static const String productSearch = "/product/search"; // ✅ جديد
  static const String sellerProductSearch = "/product/seller/search"; // ✅ جديد

  static const String products = "/product";
  static const String productDetails = "/product";
  static const String sellerProducts = "/product/seller";

  // ── Orders ────────────────────────────────────────
  static const String createOrder = "/order";
  static const String myOrders = "/order/my";
  static const String allOrders = "/order";

  // ── Reviews ───────────────────────────────────────
  static const String reviews = "/review";
  static const String productReviews = "/review/product";

  // ── Recommendations ───────────────────────────────
  static const String contentRecommend = "/recommend/content";
  static const String trendingRecommend = "/recommend/trending";
  static const String userRecommend = "/recommend/user";

  // ── Car Damage Detection ──────────────────────────
  static const String detectDamage = "/detect-damage";

  static const String otp = "";
  static const String verify = "";
  static const String categories = "";
  static const String cart = "";
  static const String favorites = "";
  static const String chatbot = "";
  static const String bestPrice = "";
  static const String brands = "";
  static const String trends = "";
  static const String profile = "";
  static const String changePassword = "";
  static const String signOut = "";
  static const String forgotPassword = "";
  static const String resetPassword = "";
}
