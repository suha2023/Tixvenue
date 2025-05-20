import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBookingsScreen extends StatelessWidget {
  const AdminBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Bookings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .snapshots(), // استرجاع جميع الحجوزات
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No bookings found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              String eventName = booking['eventName'];
              String userName = booking['userName'];
              double eventPrice = booking['eventPrice'];
              String eventEndDate = booking['eventEndDate'];
              String bookingDate = booking['bookingDate'];
              bool isPaid = booking['isPaid'];

              return Card(
                elevation: 8,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الحدث
                      Text(
                        eventName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // اسم المستخدم
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'User: $userName',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // سعر الحدث
                      Row(
                        children: [
                          const Icon(Icons.attach_money, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Price: \$${eventPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // تاريخ انتهاء الحدث
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Event End Date: $eventEndDate',
                              style: const TextStyle(
                                fontSize: 14, // تقليل حجم الخط
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis, // تجنب خروج النص
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // تاريخ الحجز
                      Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Booking Date: $bookingDate',
                              style: const TextStyle(
                                fontSize: 14, // تقليل حجم الخط
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis, // تجنب خروج النص
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // حالة الدفع
                      Row(
                        children: [
                          const Icon(Icons.payment, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Payment Status: ',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            isPaid ? 'Paid' : 'Not Paid',
                            style: TextStyle(
                              fontSize: 16,
                              color: isPaid ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}