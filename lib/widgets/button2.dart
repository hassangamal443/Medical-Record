import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:personal_medical_record/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class LocaleToggleButton2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        AppLocalizations.of(context)!.switch_Language,
        style: TextStyle(
          fontFamily: 'Oxanium',
          color: Colors.grey[300],
          fontSize: 15,
        ),
      ),
      onPressed: () {
        LocaleProvider localeProvider = Provider.of<LocaleProvider>(context, listen: false);
        if (localeProvider.locale.languageCode == 'en') {
          localeProvider.setLocale(Locale('ar'));
        } else {
          localeProvider.setLocale(Locale('en'));
        }
      },
    );
  }
}
