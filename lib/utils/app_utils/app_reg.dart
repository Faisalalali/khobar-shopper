class AppReg {
  // characters, letters or numbers
  static RegExp englishWordsRegex = RegExp(r'^[a-zA-Z ]+$');
  static RegExp numbersRegex = RegExp(r'[0-9]+$');
  static RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static RegExp phoneNumber = RegExp(r'^[+]9665[0-9]{8}$');
  static RegExp allowedPhoneInputRegex = RegExp(r'^[+0-9]+$');
  static RegExp passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#\$&*~]).{10}$');
  static RegExp price = RegExp(r'[0-9.]+$');

  AppReg._();
}
