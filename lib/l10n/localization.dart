import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Localization {
  static AppLocalizations? _l;
  AppLocalizations get loc => Localization._l!;

  static void init(BuildContext context) => _l = AppLocalizations.of(context)!;
}
