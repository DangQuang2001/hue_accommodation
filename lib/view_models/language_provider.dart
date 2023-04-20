import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '';
import '../generated/l10n.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale=const Locale('en', 'US');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    const AppLocalizationDelegate delegate = AppLocalizationDelegate();
    if (delegate.supportedLocales.contains(locale)) {
      print('khong co');
      return;
    }

    _locale = locale;
    notifyListeners();
  }

  static LanguageProvider of(BuildContext context) {
    return Provider.of<LanguageProvider>(context, listen: false);
  }
}