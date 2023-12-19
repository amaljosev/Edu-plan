import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/widgets/button_widget.dart';

final titileController = TextEditingController();
final topicController = TextEditingController();
final _formFormKey = GlobalKey<FormState>();

class ApplicationWidget extends StatelessWidget {
  const ApplicationWidget({
    super.key,
    required this.isTeacher,
    required this.name,
  });
  final bool isTeacher;
  final String name;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listener: (context, state) {
        if (state is TeacherNoticeLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(loadingSnakebarWidget());
        } else if (state is TeacherNoticeSuccessState) {
          AlertMessages().alertMessageSnakebar(context, 'Done', Colors.green);
          context
              .read<TeacherSecondBloc>()
              .add(FetchFormDatasEvent(isTeacher: isTeacher));
          titileController.text = '';
          topicController.text = ''; 
        } else if (state is TeacherNoticeErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Try Again', Colors.red);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  isTeacher ? 'Create an Event or Notice' : 'Leave Application',
                  style: titleTextStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.deepPurple,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: isTeacher ? 'Title' : 'Date of Leave',
                            ),
                            controller: titileController,
                            validator: (value) => titileController.text.isEmpty
                                ? isTeacher
                                    ? 'Please enter a title'
                                    : 'Please enter date'
                                : null,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: isTeacher ? 'Topic' : 'Reason',
                                border: InputBorder.none,
                                hintStyle: const TextStyle(fontSize: 20)),
                            controller: topicController,
                            validator: (value) => topicController.text.isEmpty
                                ? isTeacher
                                    ? 'Please enter a topic'
                                    : 'Please enter the reason'
                                : null,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonSubmissionWidget(
                    label: 'Share',
                    icon: Icons.send,
                    onTap: () {
                      if (_formFormKey.currentState!.validate()) {
                        onShare(context, isTeacher, name);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  onShare(BuildContext context, bool isTeacher, String name) {
    context.read<TeacherSecondBloc>().add(TeacherNoticeEvent(
        titleOrDate: titileController.text,
        topicOrReason: topicController.text,
        studentName: name,
        isTeacher: isTeacher));
  }
}
