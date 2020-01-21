import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircularHours extends StatefulWidget {
  final time;
  final radiansPerHour;
  CircularHours({this.time, this.radiansPerHour});
  @override
  _CircularHoursState createState() => _CircularHoursState();
}

class _CircularHoursState extends State<CircularHours>
    with SingleTickerProviderStateMixin {
  AnimationController _controllerHours;
  Animation<double> _animationHours;
  Timer _timerLand;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerLand =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _controllerHours = AnimationController(
        duration: Duration(milliseconds: 4000), vsync: this);
    _animationHours = Tween(begin: 0.0, end: _hours()).animate(CurvedAnimation(
      parent: _controllerHours,
      curve: Curves.linearToEaseOut,
    ));
    _controllerHours.forward(from: _hours());
    _controllerHours.addListener(
      () => setState(() {}),
    );
  }

  double _hours() {
    return widget.time.hour.toDouble() * widget.radiansPerHour;
  }

  void _getCurrentTime() {
    setState(() {
      _dateTime = DateTime.now();
      if (_dateTime.minute == 0 && _dateTime.second == 0) {
        _animationHours = Tween(
          begin: _dateTime.minute.toDouble() / 2 * widget.radiansPerHour,
          end: _hours(),
        ).animate(CurvedAnimation(
          parent: _controllerHours,
          curve: Curves.linearToEaseOut,
        ));
        _controllerHours.forward(from: 0.60);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerHours.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: _animationHours.value,
        child: SvgPicture.asset('assets/hours.svg'),
      ),
    );
  }
}
