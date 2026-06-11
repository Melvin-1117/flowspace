import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app/theme.dart';

class QuickStatsShimmer extends StatelessWidget {
  const QuickStatsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width - 48) / 3;
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceCard,
      highlightColor: AppTheme.surfaceBorder,
      child: Row(
        children: List.generate(3, (i) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: i == 0 ? 0 : 4,
                right: i == 2 ? 0 : 4,
              ),
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
            ),
          );
        }),
      ),
    );
  }
}
