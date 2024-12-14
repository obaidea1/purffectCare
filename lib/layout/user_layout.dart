import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purffectcare/modules/authentication/login_screen.dart';
import 'package:purffectcare/modules/profile/profile.dart';
import 'package:purffectcare/modules/shop/cart_screen.dart';
import 'package:purffectcare/shared/network/local/CashHelper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../shared/cubit/cubit.dart';
import '../shared/cubit/state.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(cubit.currentIndex == 0 ?"PurffectCare":cubit.userTitle[cubit.currentIndex]),
            actions: [
              if (cubit.currentIndex != 3)
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ProfileScreen()));
                  },
                  icon: const Icon(Icons.person_outline,size: 32,),
                ),
              if(cubit.currentIndex == 2 )
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CartScreen()));
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
              if(cubit.currentIndex == 3)
                IconButton(
                  onPressed: () async {
                    await launchUrlString("tel:+962799872891");
                  },
                  icon: const Icon(Icons.phone_outlined),
                ),


              //if (cubit.currentIndex == 4)
              // IconButton(
              //   // onPressed: () {
              //   //   Navigator.of(context).push(
              //   //     MaterialPageRoute(
              //   //       builder: (context) => const EditProfile(),
              //   //     ),
              //   //   );
              //   },
              //   icon: const Icon(Icons.edit),
              // ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined), label: "Appointment"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined), label: "Shop"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline), label: "Faq"),
            ],
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavigation(index, context);
            },
          ),
          body: cubit.userPages[cubit.currentIndex],
        );
      },
    );
  }
}
