// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:flutter_boilerplate/app/ui/widgets/common/dialogs/flexible_dialog.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlexibleDialog(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
