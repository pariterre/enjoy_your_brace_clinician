import '/models/mood_list.dart';

import 'wearing_time_list.dart';

class Patient {
  final String name;
  final WearingTimeList wearingData = WearingTimeList();
  final MoodList moodData = MoodList();

  Patient(this.name);
}
