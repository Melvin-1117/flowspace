import 'package:flutter/material.dart';

Future<String?> showPriorityPopover(
  BuildContext context,
  String currentPriority,
) {
  return showMenu<String>(
    context: context,
    position: const RelativeRect.fromLTRB(100, 300, 40, 0),
    items: const [
      PopupMenuItem(value: 'high', child: Text('High')),
      PopupMenuItem(value: 'med', child: Text('Med')),
      PopupMenuItem(value: 'low', child: Text('Low')),
    ],
  );
}
