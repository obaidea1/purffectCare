import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purffectcare/shared/component/constant.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/state.dart';
import '../../shared/network/local/CashHelper.dart';
import '../authentication/login_screen.dart';
import 'edit_profile/edit_profile.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 24),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfile(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  size: 26,
                ),
              ),
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
              ),
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 230,
                child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          height: 170,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "${cubit.userModel.coverImage}",
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            "${cubit.userModel.image}",
                          ),
                        ),
                      )
                    ]),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${cubit.userModel.name}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "${cubit.userModel.bio}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              const SizedBox(
                height: 32,
              ),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          "Your appointment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0,),
                      const AppointmentList(type: 'current'),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }
}

class AppointmentList extends StatelessWidget {
  final String type;

  const AppointmentList({super.key, required this.type});

  void _confirmDelete(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Appointment'),
          content:
          const Text('Are you sure you want to delete this appointment?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteAppointment(docId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAppointment(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(docId)
          .delete();

      print('Appointment deleted/cancelled successfully');
    } catch (e) {
      print('Failed to delete/cancel appointment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    const String adminUid = 'your-admin-uid-here';

    return StreamBuilder(
      stream:  FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: currentUser!.uid)
          .where('status', isEqualTo: type)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No $type appointments',
                style: GoogleFonts.poppins(fontSize: 16)),
          );
        }

        return ListView(
          shrinkWrap: true,
          // padding: const EdgeInsets.all(4.0),
          children: snapshot.data!.docs.map((doc){
            var data = doc.data() as Map<String, dynamic>;

            // Check if appointmentDate exists and is valid
            final appointmentDate = data['appointmentDate'] != null
                ? DateFormat.yMMMd()
                .format((data['appointmentDate'] as Timestamp).toDate())
                : 'Date not available';

            // Convert Firestore Timestamp to DateTime
            DateTime appointmentDateTime =
            (data['appointmentDate'] as Timestamp).toDate();
            DateTime now = DateTime.now();

            // Check if the appointment is in the future
            bool canDelete = appointmentDateTime.isAfter(now) &&
                data['status'] != 'cancelled';
            // Check if the appointment in the past and change the state to past
            if(appointmentDateTime.isBefore(now)) {
              FirebaseFirestore.instance.collection('appointments').doc(doc.id).update({'status': 'past'});
            }


            return AppointmentCard(
              petName: data['petName'] ??
                  'Unknown Pet',
              appointmentDate: appointmentDate,
              appointmentType: data['type'] ?? 'Unknown Type',
              status: data['status'] ?? 'Unknown Status',
              canDelete: canDelete,
              onDelete: canDelete
                  ? () => _confirmDelete(context, doc.id)
                  : null,
            );
          }).toList(),
        );
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String petName;
  final String appointmentDate;
  final String appointmentType;
  final String status;
  final Function()? onDelete;
  final bool canDelete;

  const AppointmentCard({
    required this.petName,
    required this.appointmentDate,
    required this.appointmentType,
    required this.status,
    this.onDelete,
    required this.canDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$petName - $appointmentType'),
        subtitle: Text('Date: $appointmentDate\nStatus: $status'),
        trailing: canDelete
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        )
            : null,
      ),
    );
  }
}

