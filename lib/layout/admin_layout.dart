import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/modules/authentication/login_screen.dart';
import 'package:purffectcare/modules/profile/profile.dart';
import 'package:purffectcare/modules/shop/cart_screen.dart';
import 'package:purffectcare/shared/network/local/CashHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../shared/component/constant.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/state.dart';

class AdminLayoutScreen extends StatelessWidget {
  const AdminLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(cubit.currentIndex == 0 ?"PurffectCare":cubit.adminTitle[cubit.currentIndex]),
            actions: [
              IconButton(
                onPressed: () {
                  CashHelper.removeData(key: "uId");
                  uId='';
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                          (route) => false);
                },
                icon: const Icon(Icons.login_outlined),
              )
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Appointment"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined), label: "Shop"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: "Order"),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavigation(index, context);
            },
          ),
          body: cubit.adminPages[cubit.currentIndex],
        );
      },
    );
  }
}
