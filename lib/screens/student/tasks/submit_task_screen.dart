// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:eduplanapp/screens/student/tasks/student_tasks_screen.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/teacher/tasks/submitted_tasks/full_screen.dart';
import 'package:eduplanapp/screens/widgets/button_widget.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

final studentnoteController = TextEditingController();

class ScreenSubmitTask extends StatelessWidget {
  const ScreenSubmitTask({
    super.key,
    required this.widget,
    required this.name,
    required this.subject,
    required this.topic,
  });

  final ScreenStudentTasks widget;
  final String name;
  final String subject;
  final String topic;

  @override
  Widget build(BuildContext context) {
    List<PlatformFile> pickedFiles = [];
    List<UploadTask?> uploadTasks = [];

    return Scaffold(
      appBar: myAppbar('Submit ${widget.taskName}'),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is SubmitWorkLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              loadingSnakebarWidget(),
            );
          } else if (state is SubmitWorkSuccessState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Submitted', Colors.green);
            studentnoteController.text = '';
            Navigator.pop(context);
          } else if (state is SubmitWorkErrorState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Please try again', Colors.red);
          }
          if (state is LoadingState) {
            if (state.isCompleted) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }
          }

          if (state is SelectFileState) {
            pickedFiles = state.platformFiles;
          }
          if (state is UploadFileSuccessState) {
            final bool isUpload = state.isComplete;
            if (isUpload) {
              uploadTasks.remove(state.uploadTask);
              pickedFiles = [];
            } else {
              uploadTasks.add(state.uploadTask);
            }
          }
          if (state is DeletePickedImageState) {
            pickedFiles.removeAt(state.index);
          }
        },
        builder: (context, state) {
          return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subject : $subject',
                                style: listViewTextStyle,
                              ),
                              Text(
                                'Topic : $topic',
                                style: listViewTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          decoration: const InputDecoration(labelText: 'Notes'),
                          controller: studentnoteController,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pickedFiles.isEmpty
                          ? TextButton.icon(
                              label: const Text('Select Files'),
                              onPressed: () => selectedFiles(context),
                              icon: const Icon(Icons.add),
                            )
                          : const SizedBox(),
                      ButtonSubmissionWidget(
                          label: 'send',
                          icon: Icons.send,
                          onTap: () {
                            uploadFiles(
                                context: context,
                                pickedFiles: pickedFiles,
                                name: name,
                                subject: subject,
                                topic: topic);
                          }),
                    ],
                  ),
                  kHeight,
                  buildProgress(uploadTasks),
                  kHeight,
                  kHeight,
                  Expanded(
                    child: pickedFiles.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.all(5),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemCount: pickedFiles.length,
                            itemBuilder: (context, index) {
                              final file = pickedFiles[index];
                              return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ScreenFullScreenImage(
                                                imageUrl: file.path!,
                                                isChecking: true),
                                      )),
                                  child: buildFileWidget(file, context, index));
                            },
                          )
                        : const Center(child: Text('No file selected')),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildFileWidget(PlatformFile file, BuildContext context, int index) {
    if (file.extension == 'jpg' ||
        file.extension == 'jpeg' ||
        file.extension == 'png') {
      return SizedBox(
        child: Stack(
          children: [
            Image.file(
              File(file.path!),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () => context
                        .read<StudentBloc>()
                        .add(DeletePickedImage(index: index)),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ))
              ],
            ),
          ],
        ),
      );
    } else {
      return const Text(
        'Unsupported file format. You can only upload PDF or image files.',
      );
    }
  }

  Future selectedFiles(
    BuildContext context,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result == null) return;

    final platformFiles = result.files;
    context.read<StudentBloc>().add(SelectFileEvent(
        platformFiles: platformFiles
            .where((file) =>
                file.extension == 'jpg' ||
                file.extension == 'jpeg' ||
                file.extension == 'png')
            .toList()));
  }

  Widget buildProgress(List<UploadTask?> uploadTasks) => Column(
        children: uploadTasks.map((uploadTask) {
          return StreamBuilder<TaskSnapshot>(
            stream: uploadTask?.snapshotEvents,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                double progress = data.bytesTransferred / data.totalBytes;
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white,
                  ),
                );
              } else {
                return const SizedBox(
                  height: 50,
                );
              }
            },
          );
        }).toList(),
      );
}

Future uploadFiles(
    {required BuildContext context,
    required List<PlatformFile> pickedFiles,
    required String topic,
    required String subject,
    required String name}) async {
  context.read<StudentBloc>().add(LoadingEvent(isCompleted: false));
  final List<String> urlList = [];
  for (var pickedFile in pickedFiles) {
    if (pickedFile == null) {
      continue;
    }

    final path = 'files/${pickedFile.name}';
    final file = File(pickedFile.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);

    context
        .read<StudentBloc>()
        .add(UploadFileEvent(uploadTask: uploadTask, isComplete: false));

    try {
      await uploadTask.whenComplete(() {});
      final urlDownload = await ref.getDownloadURL();

      urlList.add(urlDownload);
      log('Download Link : $urlDownload');
    } catch (error) {
      log('Error uploading file: $error');
    } finally {
      context
          .read<StudentBloc>()
          .add(UploadFileEvent(uploadTask: uploadTask, isComplete: true));
    }
  }
  context.read<StudentBloc>().add(SubmitWorkEvent(
      topic: topic,
      subject: subject,
      note: studentnoteController.text,
      name: name,
      imageUrlList: urlList,
      isHw: isHw));
  context.read<StudentBloc>().add(LoadingEvent(isCompleted: true));
}
