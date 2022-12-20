import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/enums.dart';
import '/models/mood.dart';
import '/models/patient.dart';
import '/models/wearing_time.dart';
import '/widgets/patient_overview.dart';
import '/ezlogin_mock.dart';

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

  static String routeName = '/patient-overview-screen';

  @override
  Widget build(BuildContext context) {
    final windowWidth = MediaQuery.of(context).size.width;
    final width = windowWidth >= 600 ? 200.0 : windowWidth / 3;
    final height = width * 3 / 2;

    final logger = Provider.of<EzloginMock>(context, listen: false);

    return Scaffold(
      body: Center(
          child: ListView.builder(
        itemBuilder: (ctx, index) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(logger.currentUser!.notes.toString()),
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
