import 'dart:math';

import 'package:flutter/material.dart';

import '/models/patient.dart';
import '/models/temperature_data_point.dart';
import '/widgets/patient_overview.dart';

Patient _generateData(offset) {
  final patient =
      Patient('Robert G Sauvé Larivière Joyal Tremblay Noël Beauchamps Girard');
  const max = 51;
  final rand = Random();
  for (int i = 0; i < max; i++) {
    patient.data.add(TemperatureDataPoint(rand.nextDouble() * 5 + offset,
        date: DateTime.now().subtract(Duration(minutes: 30 * (max - i)))));
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
                  _generateData(rand.nextDouble() * 5 + 20),
                  width: 200,
                  height: 300,
                ),
                PatientOverview(
                  _generateData(rand.nextDouble() * 5 + 20),
                  width: 200,
                  height: 300,
                ),
                PatientOverview(
                  _generateData(rand.nextDouble() * 5 + 20),
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
