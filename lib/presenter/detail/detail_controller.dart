import 'package:flutter/material.dart';

import '../../common/custom_app_localizations.dart';
import '../../domain/entity/user.dart';
import 'detail_model.dart';
import 'detail_screen.dart';

class DetailController extends StatelessWidget {
  const DetailController({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final i18n = CustomAppLocalizations.of(context)!;

    return DetailScreen(
      model: DetailModel.build(
        title: i18n.translate('detail.title'),
        user: user,
      ),
    );
  }
}
