import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/admin/bloc/admin_bloc.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:eduplanapp/screens/teacher/profile/widgets/profile_head_widget.dart';

class ScreenTeacherProfileAdmin extends StatelessWidget {
  const ScreenTeacherProfileAdmin(
      {super.key,
      required this.teacherData,
      required this.teacherId,
      required this.isRequest});
  final Map<String, dynamic> teacherData;
  final String? teacherId;
  final bool isRequest;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppbar('Teacher Profile'),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is ShowDialogState) {
            showTeacherDeleteDiaglog(context, teacherId ?? '');
          }
          if (state is DeleteTeacherLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              loadingSnakebarWidget(),
            );
          } else if (state is DeleteTeacherSuccessState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Successfully Deleted', Colors.green);
            Navigator.pop(context);
          } else if (state is DeleteTeacherSuccessState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Please try again', Colors.red);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              ProfileHeadWidget(
                  image: 'lib/assets/images/teacher.jpg',
                  name: teacherData['name']),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: appbarColor,
                  width: size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Class Teacher of", style: titleTextStyle),
                            Text('Mobile No', style: titleTextStyle),
                            Text('Email', style: titleTextStyle),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  " : ${teacherData['class']}-${teacherData['division']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: contentTextStyle),
                              Text(' : ${teacherData['contact']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: contentTextStyle),
                              Text(' : ${teacherData['email']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: contentTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              isRequest
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                            onPressed: () => context
                                .read<AdminBloc>()
                                .add(ShowDeleteAlertEvent()),
                            label: const Text('Delete Teacher'),
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showTeacherDeleteDiaglog(BuildContext context, String teacherId) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are You Sure !'),
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: headingColor),
        content: const Text(
          '''Deleting a teacher will also delete the associated class and students. Are you sure you want to proceed?''',
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Discard'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: () {
                  context
                      .read<AdminBloc>()
                      .add(DeleteTeacherEvent(teacherId: teacherId));
                  Navigator.pop(context);
                },
                child: const Text('Conform'),
              ),
            ],
          )
        ],
      );
    },
  );
}
