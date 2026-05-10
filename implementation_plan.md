# Animation Polish & Navigation Bar Standardisation

Full audit of every hardcoded animation value and per-page navbar divergence, plus a proposed canonical token set to unify the design language.

---

## 1 — ANIMATION AUDIT

### 1.1 Micro-Interactions (hover, press, focus)

| File | Widget | Current Value | Easing |
|---|---|---|---|
| [task_card.dart](file:///c:/Users/anton/flowspace/lib/features/tasks/widgets/task_card.dart#L43-L44) | `AnimatedContainer` (selection highlight) | **200ms** | implicit (linear) |
| [session_type_toggle.dart](file:///c:/Users/anton/flowspace/lib/features/pomodoro/widgets/session_type_toggle.dart#L27-L28) | `AnimatedContainer` (tab pill) | **180ms** | implicit (linear) |
| [timer_controls.dart](file:///c:/Users/anton/flowspace/lib/features/pomodoro/widgets/timer_controls.dart#L112-L114) | `AnimatedScale` (button press) | **100ms** | implicit (linear) |
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L303-L305) | `AnimatedScale` (button press) | **100ms** | implicit (linear) |
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L189-L190) | `AnimatedContainer` (state toggle) | **200ms** | implicit (linear) |

### 1.2 Component Mount / Content Transitions

| File | Widget | Current Value | Easing |
|---|---|---|---|
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L16-L20) | `AnimatedSwitcher` mount | **400ms** | `easeOutCubic` |
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L18) | `AnimatedSwitcher` unmount | **300ms** | `easeInCubic` |
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L254-L255) | `AnimatedSize` (pause text) | **300ms** | implicit (linear) |
| [subject_mastery_card.dart](file:///c:/Users/anton/flowspace/lib/features/planner/widgets/subject_mastery_card.dart#L150) | `.animate().scale()` (badge) | **400ms** | implicit |

### 1.3 Page-Level Staggered Entry (flutter_animate)

| File | Widget | Fade Duration | Slide Duration | Easing | Stagger |
|---|---|---|---|---|---|
| [analytics_screen.dart](file:///c:/Users/anton/flowspace/lib/features/analytics/analytics_screen.dart#L22-L23) | 6 cards | **420ms** | **420ms** | `easeOutCubic` | 0/100/200/300/400/400ms |
| [pulse_screen.dart](file:///c:/Users/anton/flowspace/lib/features/pulse/pulse_screen.dart#L154-L211) | 4 sections + 2 titles | default (uses `.fadeIn()`) | default | — | 0/100/200/300/400ms |
| [planner_screen.dart](file:///c:/Users/anton/flowspace/lib/features/planner/planner_screen.dart#L119-L242) | health ring, milestone, subjects, focus blocks | default | default | — | 0/100/200+i*80/500ms |
| [task_board_screen.dart](file:///c:/Users/anton/flowspace/lib/features/tasks/task_board_screen.dart#L215-L221) | progress dot | **450ms** | — | — | — |

### 1.4 Data Visualisation / Chart Animations

| File | Widget | Current Value | Easing |
|---|---|---|---|
| [stat_progress_bar.dart](file:///c:/Users/anton/flowspace/lib/features/analytics/widgets/stat_progress_bar.dart#L3-L4) | `TweenAnimationBuilder` | **600ms** | `easeOutCubic` |
| [subject_mastery_card.dart](file:///c:/Users/anton/flowspace/lib/features/planner/widgets/subject_mastery_card.dart#L117-L120) | `TweenAnimationBuilder` (progress bar) | **600ms** | `easeOutCubic` |
| [allocation_donut_chart.dart](file:///c:/Users/anton/flowspace/lib/features/analytics/widgets/allocation_donut_chart.dart#L75-L78) | `TweenAnimationBuilder` (pie reveal) | **900ms** | `easeOutCubic` |
| [weekly_velocity_chart.dart](file:///c:/Users/anton/flowspace/lib/features/analytics/widgets/weekly_velocity_chart.dart#L46-L48) | `AnimationController` (bar chart) | **950ms** | `easeOutCubic` (per-bar `Interval`) |

### 1.5 Continuous / Looping Animations

| File | Widget | Current Value | Easing |
|---|---|---|---|
| [active_focus_session_card.dart](file:///c:/Users/anton/flowspace/lib/features/dashboard/widgets/active_focus_session_card.dart#L88-L103) | Pulse dot (scale+fade loop) | **600ms** | `easeInOut` |
| [planner_screen.dart](file:///c:/Users/anton/flowspace/lib/features/planner/planner_screen.dart#L681-L686) | Skeleton shimmer | **900ms** | implicit |
| [event_stream_terminal.dart](file:///c:/Users/anton/flowspace/lib/features/pulse/widgets/event_stream_terminal.dart#L31-L32) | Cursor blink | **500ms** | (timer toggle) |

### 1.6 Scroll Animations

| File | Widget | Current Value | Easing |
|---|---|---|---|
| [planner_screen.dart](file:///c:/Users/anton/flowspace/lib/features/planner/planner_screen.dart#L377-L378) | `Scrollable.ensureVisible` | **350ms** | `easeOutCubic` |
| [event_stream_terminal.dart](file:///c:/Users/anton/flowspace/lib/features/pulse/widgets/event_stream_terminal.dart#L156-L158) | `_controller.animateTo` | **250ms** | `easeOut` |

### 1.7 Timer Ring (special case)

| File | Widget | Current Value | Notes |
|---|---|---|---|
| [timer_ring.dart](file:///c:/Users/anton/flowspace/lib/features/pomodoro/widgets/timer_ring.dart#L25-L26) | `AnimationController` | **1 000ms** | Drives continuous ring repaint; not a UI transition |

---

## 2 — NAVIGATION BAR AUDIT

### 2.1 BottomNavigationBar Instances

The bottom navigation bar is **duplicated in 5 separate files** with diverging styles:

| File | `currentIndex` | `backgroundColor` | `selectedItemColor` | `unselectedItemColor` | `selectedLabelStyle` | `unselectedLabelStyle` | Active icons? | Label casing |
|---|---|---|---|---|---|---|---|---|
| [home_page.dart:106](file:///c:/Users/anton/flowspace/lib/home_page.dart#L101-L147) | 0 | `0xFF0C0910` | `0xFF8B5CF6` | `Colors.grey[600]` | — | — | ✓ (some) | UPPER |
| [task_board_screen.dart:523](file:///c:/Users/anton/flowspace/lib/features/tasks/task_board_screen.dart#L522-L557) | 1 | `0xFF000000` | `0xFF7C3AED` | `0xFF555555` | — | — | Partial | Mixed |
| [pomodoro_screen.dart:73](file:///c:/Users/anton/flowspace/lib/features/pomodoro/pomodoro_screen.dart#L73-L120) | 2 | `0xFF09090B` | `0xFF7C3AED` | `0xFF7A7A83` | `10/w700/ls:1` | `10/w600/ls:1` | ✓ | UPPER |
| [planner_screen.dart:250](file:///c:/Users/anton/flowspace/lib/features/planner/planner_screen.dart#L250-L287) | 3 | `0xFF09090B` | `0xFF7C3AED` | `0xFF7A7A83` | — | — | ✓ | UPPER |
| [pulse_screen.dart:229](file:///c:/Users/anton/flowspace/lib/features/pulse/pulse_screen.dart#L229-L266) | 4 | `pulseCard` | `pulsePrimary` | `0xFF7A7A83` | — | — | ✓ | UPPER |
| [pulse_dashboard_screen.dart:113](file:///c:/Users/anton/flowspace/lib/features/settings/pulse_dashboard_screen.dart#L113-L160) | 4 | `0xFF0D0D0D` | `_primary` | `0xFF7A7A83` | `10/w700/ls:1` | `10/w600/ls:1` | ✓ | UPPER |

> [!WARNING]
> **Key divergences**:
> - `selectedItemColor`: `0xFF8B5CF6` (home) vs `0xFF7C3AED` (everywhere else)
> - `unselectedItemColor`: `Colors.grey[600]` (home) vs `0xFF555555` (tasks) vs `0xFF7A7A83` (pomo/planner/pulse)
> - `backgroundColor`: 4 different values (`0xFF0C0910`, `0xFF000000`, `0xFF09090B`, `0xFF0D0D0D`, `pulseCard`)
> - `selectedLabelStyle` / `unselectedLabelStyle`: only set in 2 of 6 instances
> - Item `label` casing: mixed case `'Focus'`/`'Tasks'`/`'Pomo'` in task_board vs `'FOCUS'`/`'TASKS'`/`'POMO'` everywhere else
> - Item `activeIcon`: inconsistently provided (home has most, tasks has partial, others vary)

### 2.2 AppBar Instances

Each screen builds its own `AppBar` with different styles:

| File | `backgroundColor` | `elevation` | Leading icon color | Title style | Actions |
|---|---|---|---|---|---|
| [home_page.dart](file:///c:/Users/anton/flowspace/lib/home_page.dart#L26-L58) | `transparent` | `0` | `Colors.white` | `w:bold, 20, white` | notification + avatar |
| [task_board_screen.dart](file:///c:/Users/anton/flowspace/lib/features/tasks/task_board_screen.dart#L66-L131) | `0xFF000000` | `0` | default (theme) | — (no title) | notification badge + avatar |
| [pomodoro_screen.dart](file:///c:/Users/anton/flowspace/lib/features/pomodoro/pomodoro_screen.dart#L211-L242) | **custom Row** (not AppBar) | — | `0xFF7C3AED` | `w700, 20, 0xFFF0F0F0` | person circle |
| [planner_screen.dart](file:///c:/Users/anton/flowspace/lib/features/planner/planner_screen.dart#L53-L89) | `0xFF000000` | default | `Colors.white` | `w:bold, 20, white` | search + avatar |
| [pulse_screen.dart](file:///c:/Users/anton/flowspace/lib/features/pulse/pulse_screen.dart#L80-L131) | `pulseBackground` | `0` | `pulsePrimary` | GoogleFonts.inter, w700 | avatar (dynamic) |
| [analytics_screen.dart](file:///c:/Users/anton/flowspace/lib/features/analytics/analytics_screen.dart#L69-L93) | `0xFF000000` | `0` | `_purple` | `w700, 28, _textPrimary` | avatar |
| [pulse_dashboard_screen.dart](file:///c:/Users/anton/flowspace/lib/features/settings/pulse_dashboard_screen.dart#L31-L54) | `_bg` (0xFF000000) | `0` | `_primary` | GoogleFonts.spaceGrotesk, w700 | avatar |
| [task_detail_screen.dart](file:///c:/Users/anton/flowspace/lib/features/tasks/task_detail_screen.dart#L36-L43) | `0xFF000000` | default | `Colors.white` | `'Task Detail'` | — |

> [!WARNING]
> **Key divergences**:
> - Pomodoro uses a custom `_buildTopBar()` Row instead of `AppBar` widget
> - Analytics title is 28px, home/planner are 20px, pulse dashboard is Google Fonts SpaceGrotesk
> - Leading icon color: white vs purple vs default — no consistency
> - Home uses transparent background; all others use opaque black (with 3 slightly different hex values)

### 2.3 Drawer

The `AppDrawer` widget is shared consistently via `const AppDrawer()`. ✓
However, `PulseScreen` uses its own `_PulseDrawer` instead.

---

## 3 — PROPOSED TOKEN MAP

### 3.1 Animation Tokens

```dart
/// lib/core/constants/animation_tokens.dart

// ──── Micro-interactions (hover, press, focus, toggle) ────
const Duration kMicroDuration      = Duration(milliseconds: 150);
const Curve    kMicroCurve         = Curves.easeOut;

// ──── Component mount (modals, cards appearing, content switches) ────
const Duration kMountDuration      = Duration(milliseconds: 250);
const Curve    kMountCurve         = Curves.easeOut;

// ──── Component unmount ────
const Duration kUnmountDuration    = Duration(milliseconds: 200);
const Curve    kUnmountCurve       = Curves.easeIn;

// ──── Page-level staggered entries ────
const Duration kPageEntryDuration  = Duration(milliseconds: 300);
const Curve    kPageEntryCurve     = Curves.easeInOut;
const Duration kPageStaggerStep    = Duration(milliseconds: 80);

// ──── Data visualisation / chart reveals ────
const Duration kChartDuration      = Duration(milliseconds: 800);
const Curve    kChartCurve         = Curves.easeOutCubic;

// ──── Loading shimmer / skeleton ────
const Duration kShimmerDuration    = Duration(milliseconds: 1400);
const Curve    kShimmerCurve       = Curves.easeInOut;

// ──── Continuous pulse (active indicator dots) ────
const Duration kPulseDuration      = Duration(milliseconds: 600);
const Curve    kPulseCurve         = Curves.easeInOut;

// ──── Scroll-to animations ────
const Duration kScrollToDuration   = Duration(milliseconds: 300);
const Curve    kScrollToCurve      = Curves.easeOut;
```

### 3.2 Before → After Token Mapping

| File | Widget | Before | After |
|---|---|---|---|
| `task_card.dart` | AnimatedContainer | 200ms / linear | `kMicroDuration` / `kMicroCurve` |
| `session_type_toggle.dart` | AnimatedContainer | 180ms / linear | `kMicroDuration` / `kMicroCurve` |
| `timer_controls.dart` | AnimatedScale | 100ms / linear | `kMicroDuration` / `kMicroCurve` |
| `active_focus_session_card.dart` | AnimatedScale (press) | 100ms / linear | `kMicroDuration` / `kMicroCurve` |
| `active_focus_session_card.dart` | AnimatedContainer (state) | 200ms / linear | `kMicroDuration` / `kMicroCurve` |
| `active_focus_session_card.dart` | AnimatedSwitcher (mount) | 400ms / easeOutCubic | `kMountDuration` / `kMountCurve` |
| `active_focus_session_card.dart` | AnimatedSwitcher (unmount) | 300ms / easeInCubic | `kUnmountDuration` / `kUnmountCurve` |
| `active_focus_session_card.dart` | AnimatedSize | 300ms / linear | `kMountDuration` / `kMountCurve` |
| `subject_mastery_card.dart` | `.animate().scale()` badge | 400ms / implicit | `kMountDuration` / `kMountCurve` |
| `analytics_screen.dart` | 6× `.fadeIn` + `.slideY` | 420ms / easeOutCubic | `kPageEntryDuration` / `kPageEntryCurve` |
| `pulse_screen.dart` | 4× `.fadeIn` + `.slideY` | default / — | `kPageEntryDuration` / `kPageEntryCurve` |
| `planner_screen.dart` | staggered `.fadeIn` + `.slideY` | default + 200+i*80 | `kPageEntryDuration` / `kPageEntryCurve` / `kPageStaggerStep` |
| `task_board_screen.dart` | `.animate().scale()` dot | 450ms / — | `kMountDuration` / `kMountCurve` |
| `stat_progress_bar.dart` | TweenAnimationBuilder | 600ms / easeOutCubic | `kChartDuration` / `kChartCurve` |
| `subject_mastery_card.dart` | TweenAnimationBuilder (bar) | 600ms / easeOutCubic | `kChartDuration` / `kChartCurve` |
| `allocation_donut_chart.dart` | TweenAnimationBuilder (pie) | 900ms / easeOutCubic | `kChartDuration` / `kChartCurve` |
| `weekly_velocity_chart.dart` | AnimationController (bars) | 950ms / easeOutCubic | `kChartDuration` / `kChartCurve` |
| `planner_screen.dart` | Skeleton shimmer | 900ms / implicit | `kShimmerDuration` / `kShimmerCurve` |
| `active_focus_session_card.dart` | Pulse dot | 600ms / easeInOut | `kPulseDuration` / `kPulseCurve` |
| `planner_screen.dart` | `Scrollable.ensureVisible` | 350ms / easeOutCubic | `kScrollToDuration` / `kScrollToCurve` |
| `event_stream_terminal.dart` | `_controller.animateTo` | 250ms / easeOut | `kScrollToDuration` / `kScrollToCurve` |

### 3.3 Reduced-Motion Fallback Strategy

A new utility widget or extension will wrap `flutter_animate` calls:

```dart
/// If the user prefers reduced motion, durations collapse to Duration.zero
/// and all curves become Curves.linear (instant snap).
Duration effectiveDuration(BuildContext context, Duration d) {
  return MediaQuery.of(context).disableAnimations ? Duration.zero : d;
}
```

For `flutter_animate` calls, we will add `.toggle(enabled: !reducedMotion)` or use the library's built-in `Animate.restartOnHotReload` with a global `reducedMotion` flag.

---

## 4 — NAVIGATION BAR TOKEN PROPOSAL

### 4.1 New Shared Widget

```
lib/widgets/app_bottom_nav.dart  [NEW]
```

A single `AppBottomNav` widget that accepts only `currentIndex`:

```dart
const Color kNavBackground     = Color(0xFF09090B);
const Color kNavSelectedColor  = Color(0xFF7C3AED);
const Color kNavUnselectedColor = Color(0xFF7A7A83);
const TextStyle kNavSelectedLabel = TextStyle(
  fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1,
);
const TextStyle kNavUnselectedLabel = TextStyle(
  fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1,
);
```

Items (canonical, all uppercase labels, all with `activeIcon`):

| Index | Icon | Active Icon | Label |
|---|---|---|---|
| 0 | `timer_outlined` | `timer` | `FOCUS` |
| 1 | `check_circle_outline` | `check_circle` | `TASKS` |
| 2 | `hourglass_top_rounded` | `hourglass_bottom_rounded` | `POMO` |
| 3 | `calendar_today_outlined` | `calendar_today` | `PLANNER` |
| 4 | `code_outlined` | `code` | `GITHUB` |

### 4.2 Shared AppBar Factory

```
lib/widgets/app_top_bar.dart  [NEW]
```

```dart
const Color kAppBarBackground = Color(0xFF000000);
const double kAppBarTitleSize  = 20.0;
const FontWeight kAppBarTitleWeight = FontWeight.w700;
```

A builder function `buildFlowSpaceAppBar(...)` with parameters for optional `actions` and `title` override. Leading is always the hamburger menu with `color: kNavSelectedColor`.

### 4.3 Files Requiring Navbar Removal

These files will have their inline `BottomNavigationBar` / `AppBar` replaced with the shared widget:

| File | What to remove |
|---|---|
| `home_page.dart` | Lines 101–147 (BottomNavigationBar) + Lines 26–58 (AppBar) |
| `task_board_screen.dart` | Lines 522–557 (`_buildBottomNavigation`) + Lines 66–131 (AppBar) |
| `pomodoro_screen.dart` | Lines 73–120 (BottomNavigationBar) + Lines 211–242 (`_buildTopBar`) |
| `planner_screen.dart` | Lines 250–287 (BottomNavigationBar) + Lines 53–89 (AppBar) |
| `pulse_screen.dart` | Lines 229–266 (BottomNavigationBar) + Lines 80–131 (AppBar) |
| `pulse_dashboard_screen.dart` | Lines 113–160 (BottomNavigationBar) + Lines 31–54 (AppBar) |
| `analytics_screen.dart` | Lines 69–93 (AppBar) — no bottom nav currently |
| `task_detail_screen.dart` | Lines 36–43 (AppBar) — no bottom nav currently |

---

## 5 — VERIFICATION PLAN

### Automated
- `flutter analyze` — zero warnings
- `flutter build web --release` — successful build  

### Manual
- Run the app and navigate every tab — confirm navbar visually identical
- Trigger every animation category — confirm durations feel unified
- Toggle `prefers-reduced-motion` / `MediaQuery.disableAnimations` — confirm instant transitions

---

## Open Questions

> [!IMPORTANT]
> 1. **Timer ring** (`timer_ring.dart`, 1000ms): This drives the continuous ring repaint at 1 fps. It is **not** a UI transition — should I leave it as-is or unify it to a token?
> 2. **Cursor blink** (`event_stream_terminal.dart`, 500ms): This is a text-cursor blink rate, not a transition. Leave as-is?
> 3. **PulseScreen's `_PulseDrawer`**: Currently a custom drawer replacing `AppDrawer`. Should I merge it into `AppDrawer` with a conditional for GitHub-connected state, or leave as a separate drawer?
> 4. **AnalyticsScreen**: Currently has no `BottomNavigationBar`. Should I add one to match all other pages?
> 5. **Chart animation duration**: The proposed `kChartDuration = 800ms` is a compromise between the current 600ms (progress bars) and 950ms (bar chart). Are you happy with 800ms, or do you prefer the full 900–950ms for richer feel?
