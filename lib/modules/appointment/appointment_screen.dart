import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    void showAddAppointmentBottomSheet(BuildContext context) {
      DateTime? selectedDate;
      TimeOfDay? selectedTime;
      TextEditingController petNameController = TextEditingController();
      String? selectedAppointmentType;

      final List<String> appointmentTypes = [
        'Check-up',
        'Vaccination',
        'Grooming',
        'Surgery'
      ];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Picker
                ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: Theme.of(context).primaryColor),
                  title: const Text('Select Date',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: selectedDate != null
                      ? Text(
                          DateFormat.yMMMd().format(selectedDate!).toString())
                      : const Text('No date chosen'),
                  onTap: () async {
                    var pickedDates = await showCalendarDatePicker2Dialog(
                      context: context,
                      config: CalendarDatePicker2WithActionButtonsConfig(),
                      dialogSize: const Size(325, 400),
                    );
                    if (pickedDates != null && pickedDates.isNotEmpty) {
                      selectedDate = pickedDates.first;
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Time Picker
                ListTile(
                  leading: Icon(Icons.access_time,
                      color: Theme.of(context).primaryColor),
                  title: const Text('Select Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  subtitle: selectedTime != null
                      ? Text(selectedTime!.format(context))
                      : const Text('No time chosen'),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      selectedTime = pickedTime;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: petNameController,
                  decoration: InputDecoration(
                    labelText: 'Pet Name',
                    prefixIcon:
                        Icon(Icons.pets, color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 10),

                // Appointment Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedAppointmentType,
                  hint: const Text('Select Appointment Type'),
                  items: appointmentTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedAppointmentType = value;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.assignment,
                        color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDate != null &&
                        selectedTime != null &&
                        petNameController.text.isNotEmpty &&
                        selectedAppointmentType != null) {
                      // Save appointment to Firestore
                      final appointmentTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );

                      await FirebaseFirestore.instance
                          .collection('appointments')
                          .add({
                        'userId': currentUser?.uid,
                        'petName': petNameController.text,
                        'appointmentDate': appointmentTime,
                        'type': selectedAppointmentType,
                        'status': 'current', // default status as current
                      });

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please fill in all fields')),
                      );
                    }
                  },
                  child: const Text(
                    'Add Appointment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const TabBar(
            dividerColor: Colors.white,
            tabs: [
              Tab(text: 'Current'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AppointmentList(type: 'current'),
            AppointmentList(type: 'past'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddAppointmentBottomSheet(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
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
          padding: const EdgeInsets.all(16),
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
              canDelete:
                  canDelete,
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
