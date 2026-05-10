/// Canonical animation tokens for FlowSpace.
///
/// All durations and curves in the app should reference these constants instead
/// of being hard-coded inline. This makes future motion-design tweaks a
/// single-file change and ensures every screen feels consistent.
library;

import 'package:flutter/material.dart';

// ──────────────────────────────────────────────────────────────────────────────
// Micro-interactions  (hover, press, focus, tab-pill toggle)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kMicroDuration = Duration(milliseconds: 150);
const Curve kMicroCurve = Curves.easeOut;

// ──────────────────────────────────────────────────────────────────────────────
// Component mount  (modals appearing, cards switching, content fading in)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kMountDuration = Duration(milliseconds: 250);
const Curve kMountCurve = Curves.easeOut;

// ──────────────────────────────────────────────────────────────────────────────
// Component unmount  (reverse of mount — slightly faster to feel snappy)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kUnmountDuration = Duration(milliseconds: 200);
const Curve kUnmountCurve = Curves.easeIn;

// ──────────────────────────────────────────────────────────────────────────────
// Page-level staggered entry  (cards cascading in on screen open)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kPageEntryDuration = Duration(milliseconds: 300);
const Curve kPageEntryCurve = Curves.easeInOut;

/// Delay increment between successive staggered items.
const Duration kPageStaggerStep = Duration(milliseconds: 80);

// ──────────────────────────────────────────────────────────────────────────────
// Data visualisation / chart reveals
// ──────────────────────────────────────────────────────────────────────────────
const Duration kChartDuration = Duration(milliseconds: 800);
const Curve kChartCurve = Curves.easeOutCubic;

// ──────────────────────────────────────────────────────────────────────────────
// Loading skeleton shimmer
// ──────────────────────────────────────────────────────────────────────────────
const Duration kShimmerDuration = Duration(milliseconds: 1400);
const Curve kShimmerCurve = Curves.easeInOut;

// ──────────────────────────────────────────────────────────────────────────────
// Continuous pulse  (active indicator dots — looping scale + fade)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kPulseDuration = Duration(milliseconds: 600);
const Curve kPulseCurve = Curves.easeInOut;

// ──────────────────────────────────────────────────────────────────────────────
// Scroll-to animations  (programmatic scrollTo / ensureVisible)
// ──────────────────────────────────────────────────────────────────────────────
const Duration kScrollToDuration = Duration(milliseconds: 300);
const Curve kScrollToCurve = Curves.easeOut;

// ──────────────────────────────────────────────────────────────────────────────
// Reduced-motion helper
// ──────────────────────────────────────────────────────────────────────────────

/// Returns [d] unchanged unless the OS accessibility flag
/// `disableAnimations` is set, in which case [Duration.zero] is returned.
/// Use this wrapper for any animation that is purely decorative.
Duration effectiveDuration(BuildContext context, Duration d) {
  if (MediaQuery.of(context).disableAnimations) return Duration.zero;
  return d;
}
