import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event_category.dart';
import '../../models/event_model.dart';
import '../../providers/theme_provider.dart';
import '../../utils/firebase_functions.dart';
import '../../utils/widgets/custom_app_bar.dart';
import '../../utils/widgets/custom_elevated_button.dart';
import '../../utils/widgets/custom_text_field.dart';
import '../home/widgets/category_chip.dart';

class AddEventScreen extends StatefulWidget {
  static const String routeName = "add_event";
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  int selectedCategory = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    final primaryColor = Theme.of(context).primaryColor;
    var category = EventCategory.categories[selectedCategory];

    return Scaffold(
      appBar: CustomAppBar(title: "add_event".tr()),
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
                  category.imagePath,
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
                value: selectedDate == null
                    ? "choose_date".tr()
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                onTap: pickDate,
                color: primaryColor,
              ),
              const SizedBox(height: 16),
              buildPickerRow(
                icon: Icons.access_time,
                label: "event_time".tr(),
                value: selectedTime == null
                    ? "choose_time".tr()
                    : selectedTime!.format(context),
                onTap: pickTime,
                color: primaryColor,
              ),
              const SizedBox(height: 32),
              CustomElevatedButton(text: "add_event".tr(), onPressed: addEvent),
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
    var now = DateTime.now();
    var date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;
    setState(() {
      selectedDate = date;
    });
  }

  Future<void> pickTime() async {
    var time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      selectedTime = time;
    });
  }

  void addEvent() {
    if (formKey.currentState!.validate() == false) return;
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("select_date_time".tr())));
      return;
    }

    FirebaseFunctions.addEvent(
      EventModel(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        userId: FirebaseAuth.instance.currentUser!.uid,
        date: DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ),
        isFavorite: false,
        category: EventCategory.categories[selectedCategory],
      ),
    );

    Navigator.pop(context);
  }
}
