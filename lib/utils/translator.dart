import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Translator {
  Translator._();

  static AppLocalizations instance(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}
