import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/form/widgets/textfield_widgets.dart';
import 'package:eduplanapp/screens/teacher/widgets/class_details.dart';

class ScreenStudentForm extends StatefulWidget {
  const ScreenStudentForm(
      {super.key,
      required this.isUpdate,
      required this.students,
      required this.studentId,
      required this.isTeacher});
  final bool isUpdate;
  final Map<String, dynamic>? students;
  final String? studentId;
  final bool isTeacher;
  @override
  State<ScreenStudentForm> createState() => _ScreenStudentFormState();
}

enum Gender { male, female }

final firstNameController = TextEditingController();
final secondNameController = TextEditingController();
final rollNoController = TextEditingController();
final guardianNameController = TextEditingController();
final ageController = TextEditingController();
final registrationNumberController = TextEditingController();
final emailController = TextEditingController();
final contactController = TextEditingController();
final passwordController = TextEditingController();

int totalStrength = 0;
int totalBoys = 0;
int totalGirls = 0;

class _ScreenStudentFormState extends State<ScreenStudentForm> {
  Gender? gender = Gender.female;
  late Stream<DocumentSnapshot<Object?>> teacherDatas = const Stream.empty();

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(FetchTeacherDatasEvent());
    if (widget.isUpdate) {
      firstNameController.text = widget.students?['first_name'] ?? '';
      secondNameController.text = widget.students?['second_name'] ?? '';
      rollNoController.text = widget.students?['roll_no'] ?? '';
      guardianNameController.text = widget.students?['guardian_name'] ?? '';
      ageController.text = widget.students?['age'] ?? '';
      registrationNumberController.text = widget.students?['register_no'] ?? '';
      emailController.text = widget.students?['email'] ?? '';
      contactController.text = widget.students?['contact_no'] ?? '';
      passwordController.text = widget.students?['password'] ?? '';
      final sex = widget.students?['gender'] ?? '';
      sex == 'Gender.male' ? gender = Gender.male : Gender.female;
    } else {
      firstNameController.text = '';
      secondNameController.text = '';
      rollNoController.text = '';
      guardianNameController.text = '';
      ageController.text = '';
      registrationNumberController.text = '';
      emailController.text = '';
      contactController.text = '';
      passwordController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentFormKey = GlobalKey<FormState>();
    return Scaffold(
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is AddStudentLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              loadingSnakebarWidget(),
            );
          } else if (state is AddStudentSuccessState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Student Added Successfully', Colors.green);
            Navigator.pop(context);
          } else if (state is AddStudentErrorState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Student not Added, Try again', Colors.red);
          } else if (state is RadioButtonState) {
            gender = state.gender;
          } else if (state is FetchTeacherDataState) {
            teacherDatas = state.teacherDatas!;
          }
          if (state is UpdateStudentDataSuccessState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Data Updated Successfully', Colors.green);
            Navigator.popUntil(
              context,
              (route) => route.isFirst,
            );
          } else if (state is UpdateStudentDataLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              loadingSnakebarWidget(),
            );
          } else if (state is UpdateStudentDataErrorState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Data not updated, Try again', Colors.red);
          } else if (state is StudentExistState) {
            AlertMessages().alertMessageSnakebar(
                context,
                'Entered  Email or Roll-no or Register no already registerd',
                Colors.red);
          }
        },
        builder: (context, state) {
          return StreamBuilder<DocumentSnapshot>(
              stream: teacherDatas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  DocumentSnapshot<Object?> documentSnapshot = snapshot.data!;
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>? ?? {};
                  final String teacher = data['name'];
                  final String standard = data['class'];
                  final String division = data['division'];
                  if (widget.isTeacher) {
                    totalStrength = classDatasGlobel?['total_students'] ?? 0;
                    totalBoys = classDatasGlobel?['total_boys'] ?? 0;
                    totalGirls = classDatasGlobel?['total_girls'] ?? 0;
                  }
                  return SafeArea(
                    child: Form(
                      key: studentFormKey,
                      child: TextFieldTilesWidgetAddStudent(
                          isTeacher: widget.isTeacher,
                          gender: gender,
                          studentId: widget.studentId,
                          widget: widget,
                          studentFormKey: studentFormKey,
                          teacher: teacher,
                          standard: standard,
                          division: division),
                    ),
                  );
                } else {
                  return const SizedBox(
                    child: Center(child: Text('Something went wrong')),
                  );
                }
              });
        },
      ),
    );
  }
}
