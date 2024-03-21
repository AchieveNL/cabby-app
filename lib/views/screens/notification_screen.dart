import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const Center(
        child: Text('Nog geen melding!'),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Changed to white
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons
                .arrow_back_ios_new_rounded, // Simplified the back arrow for clarity
            color: Colors.black,
          ),
        ),
      ),
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Kennisgeving',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
        ),
      ),
      centerTitle: true,
    );
  }
}
