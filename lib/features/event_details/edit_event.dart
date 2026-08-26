import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/event_category.dart';
import '../../models/event_model.dart';
import '../../utils/firebase_functions.dart';
import '../../utils/widgets/custom_app_bar.dart';
import '../../utils/widgets/custom_elevated_button.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../home/widgets/category_chip.dart';

class EditEvent extends StatefulWidget {
  static const String routeName = "edit_event";
  const EditEvent({super.key});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;

  int selectedCategory = 0;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  EventModel? _originalEvent;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is EventModel) {
        _originalEvent = args;
        titleController.text = args.title;
        descriptionController.text = args.description;

        final catIndex = EventCategory.categories.indexWhere(
          (c) => c.id == args.category.id,
        );
        selectedCategory = catIndex != -1 ? catIndex : 0;
        selectedDate = args.date;
        selectedTime = TimeOfDay.fromDateTime(args.date);
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final category = EventCategory.categories[selectedCategory];

    return Scaffold(
      appBar: CustomAppBar(title: "edit_event".tr()),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  category.imageFor(context),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CategoryChip(
                    category: EventCategory.categories[index],
                    isSelected: index == selectedCategory,
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemCount: EventCategory.categories.length,
                ),
              ),
              const SizedBox(height: 16),
              Text("title".tr(), style: fieldLabelStyle(context)),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: "title_hint".tr(),
                controller: titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "title_required".tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text("description".tr(), style: fieldLabelStyle(context)),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: "description_hint".tr(),
                controller: descriptionController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "description_required".tr();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              buildPickerRow(
                icon: Icons.calendar_month_outlined,
                label: "event_date".tr(),
                value: DateFormat('MMM d, yyyy').format(selectedDate),
                onTap: pickDate,
                color: primaryColor,
              ),
              const SizedBox(height: 16),
              buildPickerRow(
                icon: Icons.access_time,
                label: "event_time".tr(),
                value: selectedTime.format(context),
                onTap: pickTime,
                color: primaryColor,
              ),
              const SizedBox(height: 32),
              CustomElevatedButton(
                text: "update_event".tr(),
                onPressed: updateEvent,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle fieldLabelStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 16);

  Widget buildPickerRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label, style: fieldLabelStyle(context)),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: color,
                ),
          ),
        ),
      ],
    );
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (date == null) return;
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time == null) return;
    setState(() {
      selectedTime = time;
    });
  }

  void updateEvent() {
    if (formKey.currentState!.validate() == false) return;
    if (_originalEvent == null) return;

    final updatedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    final updatedEvent = EventModel(
      id: _originalEvent!.id,
      userId: _originalEvent!.userId,
      isFavorite: _originalEvent!.isFavorite,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: updatedDateTime,
      category: EventCategory.categories[selectedCategory],
    );

    FirebaseFunctions.updateEvent(updatedEvent);

    Navigator.pop(context, updatedEvent);
  }
}
