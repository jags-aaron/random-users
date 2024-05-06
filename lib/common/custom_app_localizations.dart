import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CustomAppLocalizations {
  CustomAppLocalizations({this.locale});

  final Locale? locale;
  final Map<String, dynamic> translations = <String, dynamic>{};
  late Map<String, String> _localizedStrings;

  static CustomAppLocalizations? of(BuildContext context) {
    return Localizations.of<CustomAppLocalizations>(context, CustomAppLocalizations);
  }

  static const LocalizationsDelegate<CustomAppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    final String jsonString =
        await rootBundle.loadString('i18n/${locale!.languageCode}.json');
    final Map<String, dynamic> jsonMap =
        json.decode(jsonString) as Map<String, dynamic>;

    _destructureObject(object: jsonMap);

    _localizedStrings = translations.map((String key, dynamic value) {
      return MapEntry<String, String>(key, value.toString());
    });

    return true;
  }

  void _destructureObject({
    required Map<String, dynamic> object,
    String suffix = '',
  }) {
    object.forEach((String key, dynamic value) {
      if (value is String) {
        translations.addAll(<String, dynamic>{'$suffix$key': value});
      } else {
        _destructureObject(
          object: value as Map<String, dynamic>,
          suffix: '$suffix$key.',
        );
      }
    });
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<CustomAppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return <String>['es'].contains(locale.languageCode);
  }

  @override
  Future<CustomAppLocalizations> load(Locale locale) async {
    final CustomAppLocalizations localizations = CustomAppLocalizations(locale: locale,);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
