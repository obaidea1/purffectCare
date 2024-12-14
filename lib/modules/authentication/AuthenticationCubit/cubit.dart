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
                      "https://images.unsplash.com/photo-1425082661705-1834bfd09dca?q=80&w=2076&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  image:
                      "https://plus.unsplash.com/premium_photo-1677545183884-421157b2da02?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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

