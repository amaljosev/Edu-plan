import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:eduplanapp/repositories/firebase/admin/signup_admin_functions.dart';

part 'admin_request_event.dart';
part 'admin_request_state.dart';

class AdminRequestBloc extends Bloc<AdminRequestEvent, AdminRequestState> {
  AdminRequestBloc() : super(AdminRequestInitial()) {
    on<ViewTeacherEvent>(viewTeacherEvent);
    on<AcceptButtonEvent>(acceptButtonEvent);
    on<RejectButtonEvent>(rejectButtonEvent);
  }

  FutureOr<void> viewTeacherEvent(ViewTeacherEvent event, Emitter<AdminRequestState> emit) {
    emit(ViewTeacherState(
      teacherData: event.teacherData 
    ));
  }
   FutureOr<void> acceptButtonEvent(AcceptButtonEvent event, Emitter<AdminRequestState> emit) {
    AdminActions().acceptRequest(event.id);
    emit(AcceptRequestState()); 
  }

  FutureOr<void> rejectButtonEvent(RejectButtonEvent event, Emitter<AdminRequestState> emit) {
    AdminActions().rejectRequest(event.id);
    emit(RejectRequestState());  
  }
}
