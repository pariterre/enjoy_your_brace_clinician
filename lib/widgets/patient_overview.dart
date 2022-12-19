import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/enums.dart';
import '/models/patient.dart';
import '/models/wearing_time_list.dart';

class _BackgroundColors {
  final Color extraLight;
  final Color light;
  final Color dark;

  const _BackgroundColors(
      {required this.extraLight, required this.light, required this.dark});

  factory _BackgroundColors.choseFromData(WearingTimeList data) {
    if (data.meanWearingTimePerDay < ExpectedWearingTime.bad.id) {
      return _BackgroundColors(
          extraLight: const Color.fromARGB(255, 255, 187, 194),
          light: Colors.red[200]!,
          dark: Colors.red);
    } else if (data.meanWearingTimePerDay < ExpectedWearingTime.good.id) {
      return _BackgroundColors(
          extraLight: Colors.orange[100]!,
          light: Colors.orange[200]!,
          dark: Colors.orange);
    } else {
      return _BackgroundColors(
          extraLight: Colors.lightGreen[100]!,
          light: Colors.lightGreen[200]!,
          dark: Colors.green);
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

class PatientOverview extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = _BackgroundColors.choseFromData(patient.wearingData);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Header(patient, layout: _layout, colors: colors),
        _MeanTimeShow(patient.wearingData, layout: _layout, colors: colors),
        Container(
          height: _layout.height * 4 / 6,
          width: _layout.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(_layout.cornerRadius),
              bottomRight: Radius.circular(_layout.cornerRadius),
            ),
            color: colors.light,
          ),
          child: const Center(child: Text('coucou')),
        ),
      ],
    );
  }
}

class _MeanTimeShow extends StatefulWidget {
  const _MeanTimeShow(this.data, {required this.layout, required this.colors});

  final WearingTimeList data;
  final _Layout layout;
  final _BackgroundColors colors;

  @override
  State<_MeanTimeShow> createState() => _MeanTimeShowState();
}

class _MeanTimeShowState extends State<_MeanTimeShow> {
  int _selected = 1;

  void select(int index) {
    _selected = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    late final DateTime from;
    if (_selected == 0) {
      from = DateTime.now().subtract(const Duration(days: 1));
    } else if (_selected == 1) {
      from = DateTime.now().subtract(const Duration(days: 7));
    } else if (_selected == 2) {
      from = DateTime.now().subtract(const Duration(days: 30));
    } else {
      from = DateTime.now().subtract(const Duration(days: 365));
    }
    final meanWearingTime =
        widget.data.getFrom(from: from).meanWearingTimePerDay;

    return Container(
      height: widget.layout.height * 2 / 6,
      width: widget.layout.width,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: widget.colors.dark, width: widget.layout.borderWidth)),
          color: widget.colors.light),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: AutoSizeText(
                'Porté en moyenne : ${meanWearingTime.toStringAsFixed(1)}h',
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DayTextButton('1j',
                    layout: widget.layout,
                    colors: _selected == 0
                        ? widget.colors.dark
                        : widget.colors.extraLight,
                    onPressed: () => select(0)),
                _DayTextButton('7j',
                    layout: widget.layout,
                    colors: _selected == 1
                        ? widget.colors.dark
                        : widget.colors.extraLight,
                    onPressed: () => select(1)),
                _DayTextButton('30j',
                    layout: widget.layout,
                    colors: _selected == 2
                        ? widget.colors.dark
                        : widget.colors.extraLight,
                    onPressed: () => select(2)),
                _DayTextButton('1a',
                    layout: widget.layout,
                    colors: _selected == 3
                        ? widget.colors.dark
                        : widget.colors.extraLight,
                    onPressed: () => select(3)),
              ],
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
          child: Text(text, style: const TextStyle(color: Colors.black)),
        ));
  }
}

class _Header extends StatelessWidget {
  const _Header(
    this.patient, {
    Key? key,
    required this.layout,
    required this.colors,
  }) : super(key: key);

  final Patient patient;
  final _Layout layout;
  final _BackgroundColors colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: layout.height * 1 / 6,
      width: layout.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(layout.cornerRadius),
              topRight: Radius.circular(layout.cornerRadius)),
          border: Border.all(color: colors.dark, width: 4),
          color: colors.dark),
      child: Center(
        child: AutoSizeText(
          patient.name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          minFontSize: Theme.of(context).textTheme.titleSmall!.fontSize!,
          maxFontSize: Theme.of(context).textTheme.titleLarge!.fontSize!,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
