import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/event_category.dart';
import '../../../providers/theme_provider.dart';

class CategoryChip extends StatelessWidget {
  final EventCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var unselectedColor = provider.themeMode == ThemeMode.dark
        ? Colors.transparent
        : Colors.white;

    var iconColorLight = isSelected
        ? Theme.of(context).scaffoldBackgroundColor
        : primaryColor;
    var iconColorDark = isSelected
        ? Colors.white
        : primaryColor;

    var textColor = isSelected
        ?  Theme.of(context).scaffoldBackgroundColor
        : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : unselectedColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0xffD6D6D6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, size: 24, color: isDark?iconColorDark: iconColorLight),
            const SizedBox(width: 6),
            Text(
              category.nameKey.tr(),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: isDark?Colors.white:textColor ,fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}