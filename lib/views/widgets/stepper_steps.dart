import 'package:flutter/material.dart';

class StepperSteps extends StatefulWidget {
  const StepperSteps({super.key});

  @override
  _StepperStepsState createState() => _StepperStepsState();
}

class _StepperStepsState extends State<StepperSteps> {
  final int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  @override
  Widget build(BuildContext context) {
    return Stepper(steps: const [],
        );
  }
}
