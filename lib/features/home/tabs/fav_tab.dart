import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/event_model.dart';
import '../../../providers/theme_provider.dart';
import '../../../utils/firebase_functions.dart';
import '../../../utils/widgets/custom_text_field.dart';
import '../widgets/event_card.dart';

class FavTab extends StatefulWidget {
  const FavTab({super.key});

  @override
  State<FavTab> createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {
  String searchText = "";
  late final favStream = FirebaseFunctions.getfavEvents();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return StreamBuilder(
      stream: favStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError == true) {
          return Center(child: Text("Something went wrong"));
        }

        List<EventModel> data =
            snapshot.data?.docs.map((e) {
              return e.data();
            }).toList() ??
                [];

        if (data.isEmpty) {
          return Center(
            child: Text(
              "no_favorites".tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        List<EventModel> filteredData = searchText.isEmpty
            ? data
            : data
            .where((event) => event.title!
            .toLowerCase()
            .contains(searchText.toLowerCase()))
            .toList();

        return Column(
          children: [
            SizedBox(height: 20),
            SizedBox(
              height: 48,
              width: 370,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search for event",
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: isDark?Colors.white:Color(0xff686868),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                    size: 30,
                  ),
                  filled: true,
                  fillColor: isDark?Color(0xff001440):Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide( color: isDark
                        ? Color(0xff002D8F)
                        : Colors.grey.withValues(alpha: 0.2),
                      width: 1,),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Color(0xFF4F6FCF)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => EventCard(
                  event: filteredData[index],
                  onFavoriteTap: () {
                    setState(() {
                      filteredData[index].isFavorite =
                      !filteredData[index].isFavorite;
                    });
                  },
                ),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 16),
                itemCount: filteredData.length,
              ),
            ),
          ],
        );
      },
    );
  }
}