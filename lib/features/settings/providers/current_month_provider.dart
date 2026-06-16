import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentMonthProvider = Provider<String>((ref) {
  final now = DateTime.now();

  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
});
