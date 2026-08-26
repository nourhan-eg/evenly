import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/event_category.dart';
import '../../../models/event_model.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../../../utils/firebase_functions.dart';
import '../../../providers/my_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/event_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  static final LightModeColors _lightColors = LightModeColors();
  static final DarkModeColors _darkColors = DarkModeColors();

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedFilter = 0;
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    var userProvider = Provider.of<MyProvider>(context);
    final userName = (userProvider.userModel?.name != null && userProvider.userModel!.name.isNotEmpty)
        ? userProvider.userModel!.name
        : FirebaseAuth.instance.currentUser?.displayName ?? "";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? HomeTab._darkColors.backgroundColor() : HomeTab._lightColors.backgroundColor(),
        leadingWidth: 160,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "welcome".tr(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isDark? Color(0xffD6D6D6): Color(0xff686868)),
              ),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              color: primaryColor,
              isDark ? Icons.bedtime_outlined : Icons.wb_sunny_outlined,
            ),
            onPressed: () {
              isDark?provider.changeTheme(ThemeMode.light):provider.changeTheme(ThemeMode.dark);
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              context.locale.languageCode.toUpperCase(),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    body: Column(
      children: [
        SizedBox(height: 24,),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) => CategoryChip(
              category: EventCategory.filters[index],
              isSelected: index == selectedFilter,
              onTap: () {
                selectedFilter = index;
                setState(() {});
              },
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: EventCategory.filters.length,
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<EventModel>>(
            stream: FirebaseFunctions.getEvents(
              EventCategory.filters[selectedFilter].id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError == true) {
                return Center(child: Text("something_went_wrong".tr()));
              }

              List<EventModel> data =
                  snapshot.data?.docs.map((e) {
                    return e.data();
                  }).toList() ??
                      [];

              if (data.isEmpty) {
                return Center(child: Text("no_events_found".tr()));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => EventCard(
                  event: data[index],
                  onFavoriteTap: () {
                    data[index].isFavorite = !data[index].isFavorite;
                    FirebaseFunctions.updateEvent(data[index]);
                  },
                ),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
                itemCount: data.length,
              );
            },
          ),
        ),


      ],
    ),
        );
  }
}
