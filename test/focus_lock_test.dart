import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowspace/features/focus_lock/providers/focus_lock_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FocusLockNotifier Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is idle', () {
      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.idle);
      expect(state.strikes, 0);
      expect(state.isVoid, false);
      expect(state.isComplete, false);
    });

    test('prepareSession transitions to waitingForFlip', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.waitingForFlip);
      expect(state.totalSeconds, 25 * 60);
      expect(state.remainingSeconds, 25 * 60);
      expect(state.strikes, 0);
    });

    test('onPhoneFlippedDown when waitingForFlip transitions to active', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);
      notifier.onPhoneFlippedDown();

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.active);
      expect(state.showStrikeWarning, false);
    });

    test('onPhoneFlippedUp when active registers strike and warning', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);
      notifier.onPhoneFlippedDown();
      notifier.onPhoneFlippedUp();

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.strikeWarning);
      expect(state.strikes, 1);
      expect(state.showStrikeWarning, true);
    });

    test('dismissStrikeWarning transitions back to waitingForFlip', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);
      notifier.onPhoneFlippedDown();
      notifier.onPhoneFlippedUp();
      notifier.dismissStrikeWarning();

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.waitingForFlip);
      expect(state.showStrikeWarning, false);
    });

    test('3 strikes transitions to void state and stops timer', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);
      notifier.onPhoneFlippedDown();

      // Strike 1
      notifier.onPhoneFlippedUp();
      notifier.onPhoneFlippedDown();

      // Strike 2
      notifier.onPhoneFlippedUp();
      notifier.onPhoneFlippedDown();

      // Strike 3 (triggers void immediately)
      notifier.onPhoneFlippedUp();

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.void_);
      expect(state.strikes, 3);
      expect(state.isVoid, true);
      expect(state.isComplete, false);
    });

    test('reset clears state to idle', () {
      final notifier = container.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(25);
      notifier.onPhoneFlippedDown();
      notifier.reset();

      final state = container.read(focusLockNotifierProvider);
      expect(state.status, FocusLockStatus.idle);
      expect(state.strikes, 0);
    });
   group('Focus Score calculations', () {
    test('perfect score is minutes * 2', () {
      expect(calculateFocusScore(25, 0), 50);
      expect(focusScoreLabel(25, 0), '50 ⭐ S Rank');
    });

    test('score decreases with strikes', () {
      expect(calculateFocusScore(25, 1), 50 - 8); // penalty = 1 * (25 ~/ 3) = 8
      expect(calculateFocusScore(25, 2), 50 - 16);
    });
  });
  });
}
