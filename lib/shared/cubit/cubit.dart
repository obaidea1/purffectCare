import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purffectcare/modules/appointment/admin_screen/appointment_admin_screen.dart';
import 'package:purffectcare/modules/appointment/userscren/appointment_screen.dart';
import 'package:purffectcare/modules/faq/faq_Screen.dart';
import 'package:purffectcare/modules/orders/orders_screen.dart';
import 'package:purffectcare/modules/shop/admin_screens/admin_shop_screen.dart';
import 'package:purffectcare/modules/shop/user_screens/shop_screen.dart';
import 'package:purffectcare/shared/cubit/state.dart';

import '../../models/user_model.dart';
import '../../modules/home/home.dart';
import '../component/constant.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitalState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> userPages = const [
    HomeScreen(),
    AppointmentScreen(),
    UserShopScreen(),
    FaqScreen(),
  ];
  List<String> userTitle = [
    "Home",
    "Appointment",
    "Shop",
    "FAQ",
  ];
  List<Widget> adminPages = [
    AdminAppointmentScreen(),
    AdminShopScreen(),
    AdminOrdersScreen(),
  ];
  List<String> adminTitle = [
    "Appointment",
    "Shop",
    "Orders",

  ];

  void changeBottomNavigation(int index, BuildContext context) {
      currentIndex = index;
      emit(ChangeBottomNavigationBarSate());
  }
  late UserModel userModel;
  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState(error.toString()));
    });
  }
  File? fileImage;
  var picker = ImagePicker();
  void changeImage() async {
    await picker
        .pickImage(source: ImageSource.camera, requestFullMetadata: true)
        .then((value) {
      if (value != null) {
        fileImage = File(value.path);
        uploadProfileImage();
        emit(ChangeImageSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ChangeImageErrorState());
    });
  }

  File? fileCoverImage;
  void changeCoverImage() async {
    await picker
        .pickImage(source: ImageSource.camera, requestFullMetadata: true)
        .then((value) {
      if (value != null) {
        fileCoverImage = File(value.path);
        print(fileImage);
        emit(ChangeCoverImageSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(ChangeCoverImageErrorState());
    });
  }
  Future<void> markOrderAsDone(String orderId) async {
    try {
      // Update the order status to 'done' in Firestore
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'status': 'done',
      });

      // Emit a success state to notify the UI
      emit(OrderMarkedAsDone());
    } catch (e) {
      // Handle errors and emit an error state if necessary
      emit(OrderUpdateFailed(errorMessage: e.toString()));
    }
  }

  String profileImage = '';
  void uploadProfileImage() async {
    FirebaseStorage.instance
        .ref()
        .child("users/$uId/${Uri.file(fileImage!.path).pathSegments.last}")
        .putFile(fileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        profileImage = value;
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(UploadProfileImageErrorState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UploadProfileImageErrorState());
    });
  }

  String coverImage = '';
  void uploadCoverImage() async {
    FirebaseStorage.instance
        .ref()
        .child(
            "usersCover/$uId/${Uri.file(fileCoverImage!.path).pathSegments.last}")
        .putFile(fileCoverImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then((value) {
          print(value);
          coverImage = value;
          emit(UploadCoverImageSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(UploadCoverImageErrorState());
        });
      },
    ).catchError((error) {
      print(error.toString());
      emit(UploadCoverImageErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(UpdateUserDataLoadingState());

    Map<String, dynamic> updatedData = {
      "uId": userModel.uId,
      "name": name,
      "bio": bio,
      "phone": phone,
      "email": userModel.email,
      "image": profileImage.isNotEmpty ? profileImage : userModel.image,
      "coverImage": coverImage.isNotEmpty ? coverImage : userModel.coverImage,
    };

    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uId)
        .update(updatedData)
        .then((value) {
      getUserData();
      emit(UpdateUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }

  File? filePostImage;
  void takePostImage() async {
    await picker
        .pickImage(source: ImageSource.camera, requestFullMetadata: true)
        .then((value) {
      if (value != null) {
        filePostImage = File(value.path);
        emit(TakePostImageSuccessState());
      }
    }).catchError((error) {
      print(error.toString());
      emit(TakePostImageErrorState());
    });
  }

  String postImage = '';
  void uploadPostImage() async {
    FirebaseStorage.instance
        .ref()
        .child(
            "postImage/$uId/${Uri.file(fileCoverImage!.path).pathSegments.last}")
        .putFile(filePostImage!)
        .then(
      (value) {
        value.ref.getDownloadURL().then((value) {
          print(value);
          postImage = value;
          emit(UploadPostImageSuccessState());
        }).catchError((error) {
          print(error.toString());
          emit(UploadPostImageErrorState());
        });
      },
    ).catchError((error) {
      print(error.toString());
      emit(UploadPostImageErrorState());
    });
  }

  void uploadPost({
    required String text,
    required String name,
    required String postImage,
    required String uId,
  }) async {}
}
