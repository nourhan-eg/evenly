import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: provider.themeMode == ThemeMode.dark
                  ? Colors.transparent
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: primaryColor,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge!.copyWith(color: primaryColor),
      ),
      actions: actions,
    );
  }
}
