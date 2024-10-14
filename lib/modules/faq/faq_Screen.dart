import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinic Location

          // const Text(

          //   'Clinic Location',

          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          // ),

          const SizedBox(height: 10),

          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(31.949031, 35.894664), // Replace with actual clinic location
                  zoom: 14,
                ),
                markers: {
                  const Marker(
                    markerId: MarkerId('clinicLocation'),
                    position: LatLng(31.949031, 35.894664), // Replace with actual location
                    infoWindow: InfoWindow(title: 'PurrfectCare Clinic',),
                  ),
                },
                onTap: (LatLng m ) async {
                  final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=31.949031, 35.894664';
                  if (await canLaunchUrl(googleMapsUrl as Uri)) {
                  launchUrl(googleMapsUrl as Uri);
                  } else {
                  // Handle the case where the launch failed
                  print('Could not launch Google Maps URL');
                  }
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'Clinic Information',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),

          const SizedBox(height: 10),

          const Text(
            'PurrfectCare is a pet clinic located in Amman, Jordan. We provide a wide range of services for pets, '
            'including check-ups, vaccinations, grooming, surgery, and more. Our clinic is dedicated to providing '
            'the highest quality care for your pets.',
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Common Questions

          Text(
            'Common Questions',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),

          const SizedBox(height: 10),

          const FAQQuestion(
            question: 'What are your working hours?',
            answer: 'We are open from 9:00 AM to 6:00 PM, Monday to Saturday.',
          ),

          const FAQQuestion(
            question: 'Do you offer emergency services?',
            answer: 'Yes, we provide 24/7 emergency services for urgent cases.',
          ),

          const FAQQuestion(
            question: 'Do you handle pet adoptions?',
            answer:
                'We are considering adding a pet adoption feature in the near future.',
          ),
        ],
      ),
    );
  }
}

class FAQQuestion extends StatelessWidget {
  final String question;

  final String answer;

  const FAQQuestion({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            answer,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
