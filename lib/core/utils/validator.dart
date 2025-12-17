import 'package:get/utils.dart';

mixin Validators {
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    } else if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-=|]).{8,}$',
    ).hasMatch(value)) {
      return 'password_invalid'.tr;
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr;
    } else if (value != password) {
      return 'confirm_password_not_match'.tr;
    }
    return null;
  }

  String? validateEmail(value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr;
    }
    return RegExp(
          r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
        ).hasMatch(value)
        ? null
        : 'email_invalid'.tr;
  }

  bool isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(value);
  }

  bool isValidPassword(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    } else if (value.length < 8) {
      return false;
    }
    return true;
  }

  String? validateName(value) {
    if (value == null || value.isEmpty) {
      return 'name_required'.tr;
    } else if (value.length < 3) {
      return 'name_short'.tr;
    }
    return null;
  }

  String? validatePhoneNumber(value) {
    if (value == null || value.isEmpty) {
      return 'phone_required'.tr;
    } else if (value.length < 7 || value.length > 10) {
      return 'phone_invalid'.tr;
    }
    return null;
  }

  String? validatePhoneOrEmail(value) {
    if (value == null || value.isEmpty) {
      return 'phone_required'.tr;
    }

    // Check if it's an email
    if (value.contains('@')) {
      return RegExp(
            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
          ).hasMatch(value)
          ? null
          : 'email_invalid'.tr;
    }

    // Otherwise validate as phone
    if (value.length < 7 || value.length > 10) {
      return 'phone_invalid'.tr;
    }

    return null;
  }
}
