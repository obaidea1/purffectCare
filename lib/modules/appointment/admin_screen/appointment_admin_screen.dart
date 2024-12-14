import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AdminAppointmentScreen extends StatelessWidget {
  const AdminAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {


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
          content: const Text('Are you sure you want to delete this appointment?'),
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: type)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No $type appointments',
                style: TextStyle(fontSize: 16)),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: snapshot.data!.docs.map((doc) {
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

            // Automatically update status to 'past' if the appointment is in the past
            if (appointmentDateTime.isBefore(now) && data['status'] != 'past') {
              FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(doc.id)
                  .update({'status': 'past'});
            }

            return AppointmentCard(
              petName: data['petName'] ?? 'Unknown Pet',
              appointmentDate: appointmentDate,
              appointmentType: data['type'] ?? 'Unknown Type',
              status: data['status'] ?? 'Unknown Status',
              canDelete: canDelete,
              onDelete: canDelete ? () => _confirmDelete(context, doc.id) : null,
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
