import 'dart:math';

import 'package:enjoy_your_brace_clinician/models/enums.dart';
import 'package:flutter/material.dart';

import '/models/mood.dart';
import '/models/patient.dart';
import '/models/wearing_time.dart';
import '/widgets/patient_overview.dart';

Patient _generateData(durationOffset) {
  final patient =
      Patient('Robert G Sauvé Larivière Joyal Tremblay Noël Beauchamps Girard');
  const nbWearingDataPoints = 51;
  const nbMoodDataPoints = 3;
  final rand = Random();

  // Add some wearing data points
  for (int i = 0; i < nbWearingDataPoints; i++) {
    patient.wearingData.add(
      WearingTime(
        DateTime.now()
            .subtract(Duration(minutes: 30 * (nbWearingDataPoints - i))),
        Duration(
            minutes: rand.nextDouble() + durationOffset > 0.5 &&
                    i != nbWearingDataPoints - 1
                ? 30
                : 0),
      ),
    );
  }

  // Add some mood data points
  for (int i = 0; i < nbMoodDataPoints; i++) {
    patient.moodData.add(
      Mood(
        DateTime.now().subtract(Duration(days: nbMoodDataPoints - i - 1)),
        emotion: MoodDataLevelPath.fromDouble(rand.nextInt(5) + 1),
        comfort: MoodDataLevelPath.fromDouble(rand.nextInt(5) + 1),
        humidity: MoodDataLevelPath.fromDouble(rand.nextInt(5) + 1),
        autonomy: MoodDataLevelPath.fromDouble(rand.nextInt(5) + 1),
      ),
    );
  }
  return patient;
}

class PatientOverviewScreen extends StatelessWidget {
  const PatientOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final width = windowWidth >= 600 ? 200.0 : windowWidth / 3;
    final height = width * 3 / 2;

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
                  width: width,
                  height: height,
                ),
                PatientOverview(
                  _generateData(0),
                  width: width,
                  height: height,
                ),
                PatientOverview(
                  _generateData(0.5),
                  width: width,
                  height: height,
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
