

class Validators {
  static final _nameRegExp = RegExp(r'^[A-Za-z\s]+$');
  static final _usernameRegExp = RegExp(r'^[A-Za-z][A-Za-z0-9_]*$');
  static final _emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  static String? validateName(String name) {
    if (name.isEmpty) {
      return 'Name cannot be empty.';
    }
    if (!_nameRegExp.hasMatch(name)) {
      return 'Only letters and spaces allowed.';
    }
    return null;
  }

  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username cannot be empty.';
    }
    if (!_usernameRegExp.hasMatch(username)) {
      return 'Start with a letter, then letters/numbers/underscores.';
    }
    return null;
  }
  
  static bool isValidDate(String date) {
    try {
      
      final parts = date.split('/');
      if (parts.length != 3) return false;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final currentYear = DateTime.now().year;
      
      if (month < 1 || month > 12) return false;
      if (currentYear - year > 150 || currentYear - year < 5) return false;
      
      final daysInMonth = [
        31,
        28 + (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 1 : 0),
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
      ];
      if (day < 1 || day > daysInMonth[month - 1]) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  static String formatDOB(String value){
    String formatted = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (formatted.length > 2 && !formatted.contains('/')) {
      formatted = formatted.substring(0, 2) + '/' + formatted.substring(2);
    }
    if (formatted.length > 5 && formatted.indexOf('/', 3) == -1) {
      formatted = formatted.substring(0, 5) + '/' + formatted.substring(5);
    }
    if (formatted.length > 10) {
      formatted = formatted.substring(0, 10); 
    }
    return formatted;
  }

  static String? validateDOB(String dob) {
    if (dob.isEmpty) return null; 
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dob)) {
      return 'Use DD/MM/YYYY.';
    }
    else if (!isValidDate(dob) && RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(dob)) {
      return "Invalid Date";
    }
    return null;
  }

  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty.';
    }
    if (!_emailRegExp.hasMatch(email)) {
      return 'Enter a valid email.';
    }
    return null;
  }

  static String? validateAbout(String about) {
    if (about.length > 150) {
      return 'Too long. Max 150 characters.';
    }
    return null;
  }
}
