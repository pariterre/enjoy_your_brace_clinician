import 'package:enhanced_containers/enhanced_containers.dart';

import '/models/enums.dart';
import '/models/mood_list.dart';

class Mood extends ItemSerializable {
  /// This method is the clinician side of [MoodDataPoint] of patient side
  /// It should therefore deserialize a MoodDataPoint.

  DateTime date;
  MoodDataLevel emotion;
  MoodDataLevel comfort;
  MoodDataLevel humidity;
  MoodDataLevel autonomy;

  Mood(
    this.date, {
    required this.emotion,
    required this.comfort,
    required this.humidity,
    required this.autonomy,
  });

  factory Mood.fromList(MoodList lst) {
    if (lst.isEmpty) {
      return Mood(DateTime.now(),
          emotion: MoodDataLevel.none,
          comfort: MoodDataLevel.none,
          humidity: MoodDataLevel.none,
          autonomy: MoodDataLevel.none);
    }

    final meanEmotion =
        lst.fold(0, (prev, e) => prev + e.emotion.index) / lst.length;
    final meanComfort =
        lst.fold(0, (prev, e) => prev + e.comfort.index) / lst.length;
    final meanHumidity =
        lst.fold(0, (prev, e) => prev + e.humidity.index) / lst.length;
    final meanAutonomy =
        lst.fold(0, (prev, e) => prev + e.autonomy.index) / lst.length;

    return Mood(
      DateTime.now(),
      emotion: MoodDataLevelPath.fromDouble(meanEmotion),
      comfort: MoodDataLevelPath.fromDouble(meanComfort),
      humidity: MoodDataLevelPath.fromDouble(meanHumidity),
      autonomy: MoodDataLevelPath.fromDouble(meanAutonomy),
    );
  }

  /// This is how the [serializeMap] of the [MoodDataPoint] looks like
  @override
  Map<String, dynamic> serializedMap() => {
        'date': date.millisecondsSinceEpoch ~/ 1000 ~/ 60,
        'emotion': emotion.index,
        'comfort': comfort.index,
        'humidity': humidity.index,
        'autonomy': autonomy.index,
      };

  Mood.deserialize(map)
      : date = DateTime.parse(((map['date'] as int) * 60 * 1000).toString()),
        emotion = MoodDataLevel.values[['emotion'] as int],
        comfort = MoodDataLevel.values[map['comfort'] as int],
        humidity = MoodDataLevel.values[map['humidty'] as int],
        autonomy = MoodDataLevel.values[map['autonomy'] as int];

  bool get hasVeryBad =>
      emotion == MoodDataLevel.veryBad ||
      comfort == MoodDataLevel.veryBad ||
      humidity == MoodDataLevel.veryBad ||
      autonomy == MoodDataLevel.veryBad;
}
