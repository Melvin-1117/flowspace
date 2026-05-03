import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  throw UnsupportedError('Isar is not supported on web.');
});
