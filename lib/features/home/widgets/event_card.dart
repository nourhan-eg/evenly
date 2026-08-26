import 'package:flutter/material.dart';
import '../../../models/event_model.dart';
import '../../event_details/event_details_screen.dart';

class EventCard extends StatefulWidget {
  final EventModel event;
  final VoidCallback onFavoriteTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onFavoriteTap,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          EventDetailsScreen.routeName,
          arguments: widget.event,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Color(0xff001440) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Color(0xff002D8F)
                : Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.event.category.imageFor(context),
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: isDark
                            ? Color(0xff002D8F)
                            : Colors.grey.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          widget.event.day,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: primaryColor, fontSize: 16),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.event.month,
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(color: primaryColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 5),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? Color(0xff001440) : backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Color(0xff002D8F)
                        : Colors.grey.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.event.title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(
                            color: isDark?Colors.white:Colors.black),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onFavoriteTap,
                      child: Icon(
                        widget.event.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
