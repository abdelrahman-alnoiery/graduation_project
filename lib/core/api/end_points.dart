class EndPoints {
  static const String baseUrl = "https://your-api.com/api/";

  // Auth
  static const String signIn = "auth/login";
  static const String signUp = "auth/register";
  static const String otp = "auth/otp";
  static const String verify = "auth/verify";

  // Products
  static const String products = "products";
  static const String productDetails = "products/details";
  static const String categories = "categories";

  // Cart
  static const String cart = ""; // ⚠️ هيتملى لما الـ Backend يبعت الـ API

  // Favorites
  static const String favorites = "favorites";

  // AI
  static const String aiFixing = "ai/fixing";
  static const String chatbot = "chatbot";

  static const String forgotPassword = "";
  static const String resetPassword = "";
  static const String signOut = "";

  // ⚠️ هيتملى لما الـ Backend يبعت الـ API
  // static const String products_of_category = "";
  static const String bestPrice = "";
  static const String brands = "";
  static const String trends = "";

  static const String profile = ""; // ⚠️ هيتملى لما الـ Backend يبعت الـ API
  static const String changePassword =
      ""; // ⚠️ هيتملى لما الـ Backend يبعت الـ API
}
