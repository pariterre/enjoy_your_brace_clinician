import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '/models/enums.dart';
import '/models/mood_list.dart';
import '/models/patient.dart';
import '/models/wearing_time_list.dart';

class _BackgroundColors {
  final Color extraLight;
  final Color light;
  final Color dark;

  const _BackgroundColors(
      {required this.extraLight, required this.light, required this.dark});

  _BackgroundColors.red()
      : extraLight = const Color.fromARGB(255, 255, 187, 194),
        light = Colors.red[200]!,
        dark = Colors.red;

  _BackgroundColors.orange()
      : extraLight = Colors.orange[100]!,
        light = Colors.orange[200]!,
        dark = Colors.orange;

  _BackgroundColors.green()
      : extraLight = Colors.lightGreen[100]!,
        light = Colors.lightGreen[200]!,
        dark = Colors.green;

  factory _BackgroundColors.choseFromData(WearingTimeList data) {
    if (data.meanWearingTimePerDay < ExpectedWearingTime.bad.id) {
      return _BackgroundColors.red();
    } else if (data.meanWearingTimePerDay < ExpectedWearingTime.good.id) {
      return _BackgroundColors.orange();
    } else {
      return _BackgroundColors.green();
    }
  }
}

class _Layout {
  final double height;
  final double width;
  final double cornerRadius;
  final double borderWidth;

  _Layout({
    required this.height,
    required this.width,
    required this.cornerRadius,
    required this.borderWidth,
  });
}

class PatientOverview extends StatefulWidget {
  PatientOverview(
    this.patient, {
    super.key,
    double height = 200.0,
    double width = 100.0,
  }) : _layout = _Layout(
            height: height, width: width, cornerRadius: 10, borderWidth: 4);

  final Patient patient;
  final _Layout _layout;

  @override
  State<PatientOverview> createState() => _PatientOverviewState();
}

class _PatientOverviewState extends State<PatientOverview> {
  int _selected = 1;

  void select(int index) {
    _selected = index;
    setState(() {});
  }

  DateTime get _fromSelection {
    if (_selected == 0) {
      return DateTime.now().subtract(const Duration(days: 1));
    } else if (_selected == 1) {
      return DateTime.now().subtract(const Duration(days: 7));
    } else if (_selected == 2) {
      return DateTime.now().subtract(const Duration(days: 30));
    } else {
      return DateTime.now().subtract(const Duration(days: 365));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the requested data by the user
    final wearingData =
        widget.patient.wearingData.getFrom(from: _fromSelection);
    final moodData = widget.patient.moodData.getFrom(from: _fromSelection);

    // Base the main color on the last 7 days
    final wearingListSevenDays = widget.patient.wearingData
        .getFrom(from: DateTime.now().subtract(const Duration(days: 7)));
    final moodListSevenDays = widget.patient.moodData
        .getFrom(from: DateTime.now().subtract(const Duration(days: 7)));
    final colors = _BackgroundColors.choseFromData(wearingListSevenDays);
    final colorMood =
        moodListSevenDays.mean.hasVeryBad ? _BackgroundColors.red() : colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _HeaderSection(widget.patient.name,
            layout: widget._layout, colors: colors),
        _MeanTimeSection(wearingData, layout: widget._layout, colors: colors),
        _MoodSection(moodData, layout: widget._layout, colors: colorMood),
        _DayButtonsSection(_selected,
            layout: widget._layout, colors: colors, onPressed: select),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection(
    this.name, {
    Key? key,
    required this.layout,
    required this.colors,
  }) : super(key: key);

  final String name;
  final _Layout layout;
  final _BackgroundColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: layout.height * 4 / 20,
      width: layout.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(layout.cornerRadius),
              topRight: Radius.circular(layout.cornerRadius)),
          border: Border.all(color: colors.dark, width: 4),
          color: colors.dark),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: AutoSizeText(
            name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            minFontSize: Theme.of(context).textTheme.titleSmall!.fontSize!,
            maxFontSize: Theme.of(context).textTheme.titleLarge!.fontSize!,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}

class _MeanTimeSection extends StatelessWidget {
  const _MeanTimeSection(this.data,
      {required this.layout, required this.colors});

  final WearingTimeList data;
  final _Layout layout;
  final _BackgroundColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: layout.height * 3 / 20,
      width: layout.width,
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(color: colors.dark, width: layout.borderWidth)),
          color: colors.light),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: AutoSizeText(
                  'Porté en moyenne : ${data.meanWearingTimePerDay.toStringAsFixed(1)}h',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTextButton extends StatelessWidget {
  const _DayTextButton(
    this.text, {
    Key? key,
    required this.layout,
    required this.colors,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final _Layout layout;
  final Color colors;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: colors,
            minimumSize: Size(layout.width / 4, layout.height * 1 / 6 / 1.3),
            side:
                BorderSide(color: Colors.black, width: layout.borderWidth / 4),
          ),
          onPressed: onPressed,
          child:
              AutoSizeText(text, style: const TextStyle(color: Colors.black)),
        ));
  }
}

class _MoodSection extends StatelessWidget {
  const _MoodSection(
    this.moodData, {
    required this.layout,
    required this.colors,
  });

  final MoodList moodData;
  final _Layout layout;
  final _BackgroundColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.light,
        border: Border(
            bottom: BorderSide(color: colors.dark, width: layout.borderWidth)),
      ),
      height: layout.height * 10 / 20,
      width: layout.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _meanMoodShow(context, layout, 'Émotion', moodData.mean.emotion),
              _meanMoodShow(context, layout, 'Confort', moodData.mean.comfort),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _meanMoodShow(
                  context, layout, 'Humidité', moodData.mean.humidity),
              _meanMoodShow(
                  context, layout, 'Autonomy', moodData.mean.autonomy),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meanMoodShow(BuildContext context, _Layout layout, String category,
      MoodDataLevel mood) {
    return Column(
      children: [
        AutoSizeText(category, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 3),
        if (mood != MoodDataLevel.none)
          Image.asset(
            mood.path,
            cacheWidth: layout.width ~/ 5,
          ),
      ],
    );
  }
}

class _DayButtonsSection extends StatelessWidget {
  const _DayButtonsSection(
    this.selected, {
    required this.layout,
    required this.colors,
    required this.onPressed,
  });

  final _Layout layout;
  final _BackgroundColors colors;
  final int selected;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: layout.width,
      height: layout.height * 3 / 20,
      decoration: BoxDecoration(
          color: colors.light,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(layout.cornerRadius),
            bottomRight: Radius.circular(layout.cornerRadius),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DayTextButton('1j',
              layout: layout,
              colors: selected == 0 ? colors.dark : colors.extraLight,
              onPressed: () => onPressed(0)),
          _DayTextButton('7j',
              layout: layout,
              colors: selected == 1 ? colors.dark : colors.extraLight,
              onPressed: () => onPressed(1)),
          _DayTextButton('30j',
              layout: layout,
              colors: selected == 2 ? colors.dark : colors.extraLight,
              onPressed: () => onPressed(2)),
          _DayTextButton('1a',
              layout: layout,
              colors: selected == 3 ? colors.dark : colors.extraLight,
              onPressed: () => onPressed(3)),
        ],
      ),
    );
  }
}
