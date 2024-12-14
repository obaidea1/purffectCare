import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purffectcare/shared/cubit/cubit.dart';
import 'package:purffectcare/shared/cubit/state.dart';

import '../../shared/component/componant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to PurrfectCare!',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your one-stop app for pet care services, appointments, and products.',
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 20),

                  // Section: Make Appointment
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      title: const Text('Make an Appointment!'),
                      subtitle:
                          const Text('Book an appointment with our clinic.'),
                      trailing: Icon(Icons.arrow_forward_ios,
                          color: Theme.of(context).primaryColor),
                      onTap: () {
                        cubit.changeBottomNavigation(1, context);
                      },
                    ),
                  ),
                  SizedBox(height: 20),

                  // Section: Featured Products (Toys and Food)
                  Text(
                    'Pet Toys & Food',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 10),
                  // Product Carousel or Grid (Add your products here)
                  Container(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildProductCard(
                            'Dog Toy', 'assets/images/dog_toy.png'),
                        buildProductCard(
                            'Cat Food', 'assets/images/cat_food.png'),
                        buildProductCard(
                            'Bird Cage', 'assets/images/bird_cage.png'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Article & Tips',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 500,
                    width: double.infinity,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        articleBuilder(
                          img:
                              'https://img.freepik.com/free-photo/young-woman-walking-with-her-dog-winter-park_1303-13091.jpg',
                          title: 'How to Take Care of Your Pets During Winter',
                          url:
                              'https://www.humanesociety.org/resources/five-ways-protect-pets-winter',
                        ),
                        const SizedBox(height: 16),
                        articleBuilder(
                          img:
                              'https://img.freepik.com/free-photo/toy-animals-near-ropes_23-2147853649.jpg',
                          title: 'The Best Toys for Active Pets',
                          url:
                              'https://www.thesprucepets.com/best-interactive-dog-toys-8363714',
                        ),
                        const SizedBox(height: 16),
                        articleBuilder(
                          img:
                              'https://img.freepik.com/free-photo/delicacy-toys-dogs-white-surface_23-2148181706.jpg',
                          title: 'Choosing the Right Food for Your Pet',
                          url:
                              'https://www.animalhumanesociety.org/resource/choosing-right-food-your-dog-or-cat',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
