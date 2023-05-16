import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '';
import '../generated/l10n.dart';

class LanguageViewModel with ChangeNotifier {
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

  static LanguageViewModel of(BuildContext context) {
    return Provider.of<LanguageViewModel>(context, listen: false);
  }
}