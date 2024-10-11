import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db/controllers/course_controller.dart';

class AddCourse extends StatelessWidget {
  final CourseController courseController = Get.put(CourseController());

  AddCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Title
            buildTextField(
              'Title',
              courseController.titleController,
              onUnfocus: () {
                courseController.slugController.text = courseController
                    .titleController.text
                    .toLowerCase()
                    .replaceAll(
                        RegExp(r'\s+'), '-'); // Generate slug from title
              },
            ),
            const SizedBox(height: 20),

            // Slug
            buildTextField('Slug', courseController.slugController),
            const SizedBox(height: 20),

            // Description
            buildTextField(
                'Description', courseController.descriptionController,
                maxLines: 4),
            const SizedBox(height: 20),

            // Batch
            buildTextField('Batch', courseController.batchController),
            const SizedBox(height: 20),

            // Seats, Price, Discount (Responsive Row)

            Row(
              children: [
                Expanded(
                    child: buildTextField(
                        'Seats', courseController.seatsController)),
                Expanded(
                    child: buildTextField(
                        'Price', courseController.priceController)),
                Expanded(
                    child: buildTextField(
                        'Discount', courseController.discountController)),
              ],
            ),
            const SizedBox(height: 20),

            // Enrollment Date Range
            buildDateRangePicker(context, 'Enrollment Period',
                courseController.enrollStart, courseController.enrollEnd),

            // Image URL
            buildTextField('Image URL', courseController.imageUrlController),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: courseController.addCourseFromForm,
              child: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, Function(String)? onChanged, Function()? onUnfocus}) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus && onUnfocus != null) {
          onUnfocus(); // Trigger the slug generation when title loses focus
        }
      },
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget buildDateRangePicker(BuildContext context, String label,
      Rx<DateTime> start, Rx<DateTime> end) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Row(
          children: [
            Expanded(
              child: Obx(() => Text(
                  'From: ${start.value.toLocal().toString().split(' ')[0]}')),
            ),
            Expanded(
              child: Obx(() =>
                  Text('To: ${end.value.toLocal().toString().split(' ')[0]}')),
            ),
            IconButton(
              onPressed: () async {
                DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  start.value = picked.start;
                  end.value = picked.end;
                  print("Picked start: ${picked.start}, end: ${picked.end}");
                }
              },
              icon: const Icon(Icons.date_range),
            ),
          ],
        ),
      ],
    );
  }
}

//https://www.creativeitinstitute.com/images/course/course_1662724358.jpg
