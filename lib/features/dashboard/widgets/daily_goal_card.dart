/// Dashboard re-export of the Pomodoro DailyGoalCard.
///
/// The pomodoro feature already has a fully functional DailyGoalCard that
/// reads from [dailyGoalProvider] and shows an interactive goal sheet.
/// We re-export it here so dashboard_content.dart has a clean import path.
library;

export '../../../features/pomodoro/widgets/daily_goal_card.dart';
