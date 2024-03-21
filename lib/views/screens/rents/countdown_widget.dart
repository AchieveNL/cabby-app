import 'package:flutter/material.dart';
import 'dart:async';

class CountdownCardWidget extends StatefulWidget {
  final DateTime rentalStartDate;
  final VoidCallback onCountdownCompleted;

  const CountdownCardWidget({
    Key? key,
    required this.rentalStartDate,
    required this.onCountdownCompleted,
  }) : super(key: key);

  @override
  State<CountdownCardWidget> createState() => _CountdownCardWidgetState();
}

class _CountdownCardWidgetState extends State<CountdownCardWidget> {
  Timer? _timer;
  Duration _duration = Duration();

  void startTimer() {
    final now = DateTime.now();
    if (widget.rentalStartDate.isBefore(now)) {
      widget.onCountdownCompleted();
      return;
    }

    _duration = widget.rentalStartDate.difference(now);

    _timer?.cancel(); // Cancel any previous timer.
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final remaining = widget.rentalStartDate.difference(now);

      if (remaining <= Duration.zero) {
        _timer?.cancel();
        widget.onCountdownCompleted();
      } else {
        setState(() {
          _duration = remaining;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(_duration.inDays);
    final hours = twoDigits(_duration.inHours.remainder(24));
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Nog even geduld, zodra uw huurperiode begint kunt u de autu in gebruik nemen.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              '$days:$hours:$minutes:$seconds',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
