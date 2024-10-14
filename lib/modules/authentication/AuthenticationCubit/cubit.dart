import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/modules/authentication/AuthenticationCubit/state.dart';

import '../../../models/user_model.dart';
import '../../../shared/component/constant.dart';
import '../../../shared/network/local/CashHelper.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitalState());

  static AuthenticationCubit get(BuildContext context) =>
      BlocProvider.of(context);

  bool isAbscure = true;

  void changeAbscure() {
    isAbscure = !isAbscure;
    emit(ChangeAbscureState());
  }

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      CashHelper.putData(key: "uId", value: value.user!.uid.toString());
      uId = value.user!.uid.toString();
      emit(LoginSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState(error: error.toString()));
    });
  }

  void createUser({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String uId,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(
          UserModel(
                  name: name,
                  email: email,
                  phone: phone,
                  bio: "Hi there I'm using chatty",
                  coverImage:
                      "https://img.freepik.com/free-photo/beige-old-stucco-template_1194-6746.jpg?t=st=1724334975~exp=1724338575~hmac=b32f28ae00d71ffebdf7dfa127f4b33935e296fcd28db2aee9e5505409d8ec6e&w=1380",
                  image:
                      "https://img.freepik.com/free-photo/medium-shot-contemplative-man-seaside_23-2150531618.jpg?t=st=1724334551~exp=1724338151~hmac=b5aa748d490b10f02d331e90b558f4f9973415dfec85e400d70ac74c686ac6f7&w=1380",
                  uId: uId,
                  isEmailVerification: false)
              .toMap(),
        )
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error: error.toString()));
    });
  }

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      uId = value.user!.uid;
      createUser(
          email: email,
          password: password,
          name: name,
          phone: phone,
          uId: value.user!.uid);
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error: error.toString()));
    });
  }
}

