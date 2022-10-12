import 'dart:ui';
import 'package:flutter/cupertino.dart';

class MultiLanguages {
  final Locale locale;

  MultiLanguages({this.locale = const Locale.fromSubtags(languageCode: 'en')});

  static MultiLanguages? of(BuildContext context) {
    return Localizations.of<MultiLanguages>(context, MultiLanguages);
  }

  void keepLocalKey(String localKey) async {

  }


}