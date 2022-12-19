import 'dart:math';

import 'package:flutter/material.dart';

import '/models/patient.dart';
import '/models/wearing_time.dart';
import '/widgets/patient_overview.dart';

Patient _generateData(offset) {
  final patient =
      Patient('Robert G Sauvé Larivière Joyal Tremblay Noël Beauchamps Girard');
  const max = 51;
  final rand = Random();
  for (int i = 0; i < max; i++) {
    patient.wearingData.add(
      WearingTime(
        DateTime.now().subtract(Duration(minutes: 30 * (max - i))),
        Duration(
            minutes: rand.nextDouble() + offset > 0.5 && i != max - 1 ? 30 : 0),
      ),
    );
  }
  return patient;
}

class PatientOverviewScreen extends StatelessWidget {
  const PatientOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rand = Random();

    return Scaffold(
      body: Center(
          child: ListView.builder(
        itemBuilder: (ctx, index) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PatientOverview(
                  _generateData(-0.5),
                  width: 200,
                  height: 300,
                ),
                PatientOverview(
                  _generateData(0),
                  width: 200,
                  height: 300,
                ),
                PatientOverview(
                  _generateData(0.5),
                  width: 200,
                  height: 300,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        itemCount: 20,
      )),
    );
  }
}
