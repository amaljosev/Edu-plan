// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/widgets/button_widget.dart';

final homeWorkController = TextEditingController();
final assignmentController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool isLoading = false;
String? dropDownValue;
DateTime? selectedDate;

class AddTaskWidget extends StatelessWidget {
  const AddTaskWidget({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  Widget build(BuildContext context) {
    const List<String> subjectList = <String>[
      'English',
      'Physics',
      'Maths',
      'Chemistry',
      'Biology',
      'Language 1',
      'Language 2',
      'Social Science',
      'Science',
      'IT',
      'Hindi',
    ];
    int index = 0;
    bool isLoading = false;

    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listenWhen: (previous, current) => current is TeacherSecondActionState,
      buildWhen: (previous, current) => current is! TeacherSecondActionState,
      listener: (context, state) {
        if (state is HomeWorkDropDownState) {
          index = state.index;
          dropDownValue = state.value;
        }
        if (state is HomeWorkSendLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            loadingSnakebarWidget(),
          );
          isLoading = true;
        } else if (state is HomeWorkSendSuccessState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Home Work Send Successfully', Colors.green);
          index = 0;
          dropDownValue = subjectList.first;
        } else if (state is HomeWorkSendErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Try again', Colors.red);
        }
        if (state is AssignmentSendLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            loadingSnakebarWidget(),
          );
          isLoading = true;
        } else if (state is AssignmentSendSuccessState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Assignment Send Successfully', Colors.green);
          index = 0;
          dropDownValue = subjectList.first;
          selectedDate = DateTime.now();
        } else if (state is AssignmentSendErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Try again', Colors.red);
        }
        if (state is DateSelectedState) {
          selectedDate = state.selectedDate;
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: DefaultTabController(
            length: 2,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(
                        text: 'Home Work',
                      ),
                      Tab(
                        text: 'Assignment',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: size.height * 0.70,
                      child: TabBarView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Select Subject',
                                    style: contentTextStyle,
                                  ),
                                  DropdownMenu<String>(
                                    initialSelection: subjectList.first,
                                    onSelected: (String? value) {
                                      index = subjectList
                                          .indexWhere((item) => item == value);

                                      return context
                                          .read<TeacherSecondBloc>()
                                          .add(TaskDropDownEvent(
                                              index: index, value: value));
                                    },
                                    dropdownMenuEntries: subjectList
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Task',
                                          hintText: 'eg: Complete Activity 5'),
                                      controller: homeWorkController,
                                      validator: (value) =>
                                          homeWorkController.text.isEmpty
                                              ? 'Please enter a Home Work'
                                              : null,
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                              ),
                              ButtonSubmissionWidget(
                                label: 'send',
                                icon: Icons.send,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    isLoading
                                        ? null
                                        : onSendHW(
                                            context,
                                            homeWorkController.text,
                                            dropDownValue ?? subjectList.first);
                                  }
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Select Subject',
                                    style: contentTextStyle,
                                  ),
                                  DropdownMenu<String>(
                                    initialSelection: subjectList.first,
                                    onSelected: (String? value) {
                                      index = subjectList
                                          .indexWhere((item) => item == value);

                                      return context
                                          .read<TeacherSecondBloc>()
                                          .add(TaskDropDownEvent(
                                              index: index, value: value));
                                    },
                                    dropdownMenuEntries: subjectList
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Set an Expiry Date', 
                                    style: contentTextStyle,
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => datePicker(context),
                                    icon: const Icon(Icons.date_range),
                                    label: const Text(' Calender'),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Topic',
                                          hintText:
                                              'eg: Write an assignment based on '),
                                      controller: assignmentController,
                                      validator: (value) =>
                                          assignmentController.text.isEmpty
                                              ? 'Please enter a Topic'
                                              : null,
                                      maxLines: 5,
                                    ),
                                  ),
                                ),
                              ),
                              ButtonSubmissionWidget(
                                label: 'send',
                                icon: Icons.send,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    isLoading
                                        ? null
                                        : onSendAssignment(
                                            context,
                                            assignmentController.text,
                                            dropDownValue ?? subjectList.first,
                                            selectedDate ?? DateTime.now());
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  datePicker(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime lastDateOfNextWeek = currentDate.add(const Duration(days: 60));

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: lastDateOfNextWeek,
      initialDatePickerMode: DatePickerMode.day,
      builder: (context, child) {
        return SizedBox(
          height: 555,
          width: 500,
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      context
          .read<TeacherSecondBloc>()
          .add(DateSelectedEvent(selectedDate: selectedDate));
    }
  }
}

onSendHW(BuildContext context, String task, String? value) {
  context
      .read<TeacherSecondBloc>()
      .add(HomeWorkSendEvent(task: task, subject: value as String));
  homeWorkController.text = '';
}

onSendAssignment(
  BuildContext context,
  String task,
  String? value,
  DateTime? selectedDate,
) {
  context.read<TeacherSecondBloc>().add(AssignmentSendEvent(
      task: task,
      subject: value as String,
      selectedDate: selectedDate as DateTime));
  assignmentController.text = '';
}
