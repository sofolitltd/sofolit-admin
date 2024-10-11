import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../db/controllers/course_controller.dart';

class EditCourse extends StatefulWidget {
  final String courseID; // Course ID to fetch course data

  EditCourse({super.key, required this.courseID});

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final CourseController courseController = Get.put(CourseController());

  @override
  void initState() {
    super.initState();
    // Fetch the course using the courseID
    courseController.fetchCourseById(widget.courseID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (courseController.selectedCourse.value == null) {
            return Center(child: CircularProgressIndicator());
          }

          final course = courseController.selectedCourse.value!;

          // Populate the text controllers with the current course data
          courseController.titleController.text = course.title;
          courseController.slugController.text = course.slug;
          courseController.descriptionController.text = course.description;
          courseController.batchController.text = course.batch;
          courseController.seatsController.text = course.seats.toString();
          courseController.priceController.text = course.price.toString();
          courseController.discountController.text = course.discount.toString();
          courseController.imageUrlController.text = course.imageUrls;
          courseController.enrollStart.value = course.enrollStart;
          courseController.enrollEnd.value = course.enrollEnd;

          return Column(
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
                onPressed: () {
                  // Call the update method from the controller
                  courseController.updateCourse(course);
                },
                child: const Text('Update Course'),
              ),
            ],
          );
        }),
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
