import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/layout/admin_layout.dart';
import 'package:purffectcare/modules/appointment/admin_screen/appointment_admin_screen.dart';
import 'package:purffectcare/modules/authentication/login_screen.dart';
import 'package:purffectcare/shared/component/constant.dart';
import 'package:purffectcare/shared/cubit/cubit.dart';
import 'package:purffectcare/shared/network/local/CashHelper.dart';
import 'package:purffectcare/shared/observer.dart';
import 'package:purffectcare/shared/style/theme.dart';

import 'layout/user_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  if(CashHelper.getData(key: "uId") != null){
    uId = CashHelper.getData(key: "uId");}
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  print(uId);
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getUserData(),
      child: MaterialApp(
        title: 'PurffectCare',
        theme: theme,
        debugShowCheckedModeBanner: false,
         home: uId == 'R6GxM5JvTgPWpUhg1vUNyNyZJUW2' ? const  AdminLayoutScreen():
            uId.isEmpty? const  LoginScreen(): const HomeLayoutScreen(),
      ),
    );
  }
}
