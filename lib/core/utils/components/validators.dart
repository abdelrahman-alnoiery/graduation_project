class Validators {
  // ── Email ─────────────────────────────────────────
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  // ── Password ──────────────────────────────────────
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one uppercase letter";
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }
    return null;
  }

  // ── Confirm Password ──────────────────────────────
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm password is required";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }

  // ── Name ──────────────────────────────────────────
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    if (value.length < 3) {
      return "Name must be at least 3 characters";
    }
    return null;
  }

  // ── Phone ─────────────────────────────────────────
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final phoneRegex = RegExp(r'^(010|011|012|015)[0-9]{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Please enter a valid Egyptian phone number";
    }
    return null;
  }

  // ── OTP ───────────────────────────────────────────
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP is required";
    }
    if (value.length != 6) {
      return "OTP must be 6 digits";
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "OTP must contain numbers only";
    }
    return null;
  }

  // ── Not Empty ─────────────────────────────────────
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }
}
