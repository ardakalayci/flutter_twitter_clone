
class Validator {
  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) {
        return true;
      }
    }
    return false;
  }

  String validateEmail(String s) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(s)) {
      return 'Mail adresinizi giriniz';
    } else {
      return null;
    }
  }

  String validateName(String s) {
    if (_isNumeric(s)) {
      return 'İsim yanlış';
    }
    if (s.isEmpty) {
      return 'İsmini unutma';
    }
    return null;
  }

  String validatePassword(String s) {
    if (s.isEmpty) {
      return 'Şifre';
    }
    return null;
  }

}
