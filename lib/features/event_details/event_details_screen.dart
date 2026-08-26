import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/event_model.dart';
import '../../utils/firebase_functions.dart';
import '../../utils/widgets/custom_app_bar.dart';
import 'edit_event.dart';

class EventDetailsScreen extends StatefulWidget {
  static const String routeName = "details route";
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  EventModel? _event;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_event == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is EventModel) {
        _event = args;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_event == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "event_details".tr()),
        body: Center(child: Text("no_event_details".tr())),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final event = _event!;

    final formattedDate = DateFormat('d MMMM yyyy').format(event.date);
    final formattedTime = DateFormat('hh:mm a').format(event.date);

    return Scaffold(
      appBar: CustomAppBar(
        title: "event_details".tr(),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: primaryColor, size: 24),
            onPressed: () async {
              final updatedEvent = await Navigator.pushNamed(
                context,
                EditEvent.routeName,
                arguments: event,
              );
              if (updatedEvent is EventModel) {
                setState(() {
                  _event = updatedEvent;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
            onPressed: () => _confirmDelete(context, event.id),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                event.category.imageFor(context),
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF001440) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF002D8F) : Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: primaryColor,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedTime,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontSize: 14,
                              color: isDark ? Colors.white70 : Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "description".tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF001440) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF002D8F) : Colors.grey.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                event.description.isNotEmpty ? event.description : "",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String eventId) {
    final navigator = Navigator.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("delete_event".tr()),
        content: Text("delete_event_confirm".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await FirebaseFunctions.deleteEvent(eventId);
              if (mounted) {
                navigator.pop();
              }
            },
            child: Text(
              "delete".tr(),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
