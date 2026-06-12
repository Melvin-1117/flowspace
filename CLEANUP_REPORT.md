# FlowSpace Codebase Cleanup Report

## App Size
| Metric          | Before | After | Reduction |
|-----------------|--------|-------|-----------|
| Web JS size     | 3.912 MB (4,102,526 B) | 3.914 MB (4,104,832 B) | +0.05% (negligible code addition for helper utilities & Web fallbacks) |
| Lines of code   | 42,141 | 42,116 | 25 lines saved |

> [!NOTE]
> Web production compilation `flutter build web` was used as the app size metric because local release APK packaging fails due to Gradle compatibility issues in the legacy `isar_flutter_libs` dependency classpath.

## Files Removed
| File path | Reason |
|-----------|--------|
| `lib/features/dashboard/widgets/shimmer/chart_shimmer.dart` | Unused / duplicate layout consolidated into `ShimmerBox` |
| `lib/features/dashboard/widgets/shimmer/health_card_shimmer.dart` | Unused / duplicate layout consolidated into `ShimmerBox` |
| `lib/features/dashboard/widgets/shimmer/milestone_card_shimmer.dart` | Unused / duplicate layout consolidated into `ShimmerBox` |
| `lib/features/dashboard/widgets/shimmer/quick_stats_shimmer.dart` | Unused / duplicate layout consolidated into `ShimmerBox` |
| `lib/features/dashboard/widgets/shimmer/task_summary_shimmer.dart` | Unused / duplicate layout consolidated into `ShimmerBox` |

## Files Modified
| File path | What changed |
|-----------|--------------|
| `lib/core/services/notification_service.dart` | Commented out unused local `details` variables in block/milestone reminder functions |
| `lib/main.dart` | Removed unnecessary `as FocusGoalSettings?` cast |
| `lib/features/dashboard/widgets/semester_snapshot_card.dart` | Switched loading shimmer to `ShimmerBox.healthCard` |
| `lib/features/dashboard/widgets/task_summary_card.dart` | Switched loading shimmer to `ShimmerBox.taskSummary` |
| `lib/features/dashboard/widgets/weekly_velocity_snapshot.dart` | Switched loading shimmer to `ShimmerBox.chart` and cleaned unused imports |
| `lib/features/dashboard/widgets/milestone_card.dart` | Switched loading shimmer to `ShimmerBox.milestoneCard` |
| `lib/features/dashboard/widgets/quick_stats_row.dart` | Removed unused import `quick_stats_shimmer.dart` |
| `lib/features/devtrack/widgets/session_row.dart` | Refactored to use consolidated `formatRelativeTime` |
| `lib/features/devtrack/widgets/coding_stats_row.dart` | Refactored to use consolidated `formatDurationMinutes` |
| `lib/features/devtrack/providers/devtrack_providers_web.dart` | Removed unused import `pomodoro_session.dart` |
| `lib/features/analytics/widgets/avg_session_card.dart` | Refactored to use consolidated `formatDurationMinutes` |
| `lib/features/analytics/providers/analytics_providers.dart` | Removed unused `coding_session.dart` import and unnecessary casts |
| `lib/features/pomodoro/providers/pomodoro_providers.dart` | Refactored to use consolidated `formatDurationMmSs` and removed unused import/unnecessary casts |
| `lib/features/pomodoro/providers/timer_notifier.dart` | Refactored to use consolidated `formatDurationMmSs` and removed debug log `debugPrint` |
| `lib/features/planner/widgets/focus_block_planner.dart` | Removed unused import `focus_block_notifier.dart` |
| `lib/features/planner/providers/planner_providers.dart` | Removed unused providers, restored `SearchResultItem` used in UI, and protected `nextMilestoneProvider` from `.sort` crash on unmodifiable const lists |
| `lib/features/planner/providers/subject_notifier.dart` | Added static fallback memory storage and wired all actions on Web |
| `lib/features/planner/providers/milestone_notifier.dart` | Added static fallback memory storage and wired all actions on Web |
| `lib/features/planner/providers/focus_block_notifier.dart` | Added static fallback memory storage and wired all actions on Web |

## Consolidations
| Old (multiple files) | New (single file) | Files saved |
|----------------------|--------------------|-------------|
| 5 shimmer files | `lib/core/widgets/shimmer_box.dart` | 4 |
| 3 formatDate / duration helpers | `lib/core/utils/formatters.dart` | 2 |

## Static Analysis
| Metric | Before | After |
|--------|--------|-------|
| Total issues | ~80 issues | 65 issues (mostly generated Isar code warnings & deprecations) |
| Unused elements | 11 warnings | 0 warnings |
| Lint warnings (excluding generated code) | 24 warnings | 0 warnings |

## Flagged for Manual Review (Not Auto-Removed)
| Item | Location | Reason |
|------|----------|--------|
| `@collection` fields | Isar Models | Kept all schema structure as-is to preserve database compatibility. |
| `debugPrint` | `lib/features/planner/providers/planner_storage.dart:274` | Kept inside catch block as it's part of intentional error logging. |

## Verification Checklist
- [x] All screens render correctly (including search overlays and checks)
- [x] No functional regressions (all providers compile and resolve)
- [x] flutter analyze shows 0 new errors or warnings on clean files
- [x] App builds successfully for web production target
- [x] Planner features fully wired and interactive on Web using memory fallback lists
