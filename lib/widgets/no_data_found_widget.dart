import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcel_app/bloc/font/font_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({Key? key, required this.additionalText}) : super(key: key);

  final String additionalText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FontBloc, FontState>(builder: (contextFont, stateFont) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.noDataFound,
              style: TextStyle(fontSize: 25 * stateFont.resize),
            ),
            const SizedBox(height: 10),
            Text(additionalText,
                style: TextStyle(fontSize: 14 * stateFont.resize),
                maxLines: 2,
                textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            const Icon(
              Icons.file_copy,
              size: 60,
            )
          ],
        ),
      );
    });
  }
}
