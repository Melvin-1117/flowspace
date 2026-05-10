/// Shared AppBar factory for FlowSpace.
///
/// All main screens should use [buildFlowSpaceAppBar] instead of constructing
/// their own [AppBar]. The leading menu icon, background, title style, and
/// elevation are all canonical here.
library;

import 'package:flutter/material.dart';

// ── Design tokens ─────────────────────────────────────────────────────────────
const Color kAppBarBackground = Color(0xFF000000);
const double kAppBarTitleSize = 20.0;
const FontWeight kAppBarTitleWeight = FontWeight.w700;
const Color kAppBarTitleColor = Color(0xFFF0F0F0);
const Color kAppBarIconColor = Color(0xFF7C3AED); // purple accent

/// Builds the canonical [AppBar] for FlowSpace screens.
///
/// Parameters:
/// - [scaffoldKey] — used to open the side drawer via the menu icon.
/// - [title] — displayed title text (defaults to `'FlowSpace'`).
/// - [actions] — optional list of trailing action widgets.
/// - [useTransparentBackground] — set `true` only on the home/focus screen.
PreferredSizeWidget buildFlowSpaceAppBar({
  required GlobalKey<ScaffoldState> scaffoldKey,
  String title = 'FlowSpace',
  List<Widget>? actions,
  bool useTransparentBackground = false,
}) {
  return AppBar(
    backgroundColor:
        useTransparentBackground ? Colors.transparent : kAppBarBackground,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: _MenuButton(scaffoldKey: scaffoldKey),
    title: Text(
      title,
      style: const TextStyle(
        color: kAppBarTitleColor,
        fontWeight: kAppBarTitleWeight,
        fontSize: kAppBarTitleSize,
      ),
    ),
    actions: actions,
  );
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: kAppBarIconColor),
      onPressed: () => scaffoldKey.currentState?.openDrawer(),
      tooltip: 'Menu',
    );
  }
}
