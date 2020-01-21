import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';

class CircularMinutes extends StatefulWidget {
  final time;
  final radiansPerTick;
  CircularMinutes({this.time, this.radiansPerTick});
  @override
  _CircularMinutesState createState() => _CircularMinutesState();
}

class _CircularMinutesState extends State<CircularMinutes>
    with SingleTickerProviderStateMixin {
  Animation<double> _animationMinutes;
  AnimationController _controllerMinutes;
  Timer _timerLand;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerLand =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _controllerMinutes = AnimationController(
        duration: Duration(milliseconds: 4000), vsync: this);
    _animationMinutes = Tween(
      begin: _dateTime.minute.toDouble() / 2 * widget.radiansPerTick,
      end: _minutes(),
    ).animate(CurvedAnimation(
      parent: _controllerMinutes,
      curve: Curves.linearToEaseOut,
    ));
    _controllerMinutes.forward(from: _minutes());
    _controllerMinutes.addListener(
      () => setState(() {}),
    );
  }

  void _getCurrentTime() {
    setState(() {
      _dateTime = DateTime.now();
      if (_dateTime.second == 0) {
        _animationMinutes = Tween(
          begin: _dateTime.minute.toDouble() / 2 * widget.radiansPerTick,
          end: _minutes(),
        ).animate(CurvedAnimation(
          parent: _controllerMinutes,
          curve: Curves.linearToEaseOut,
        ));
        _controllerMinutes.forward(from: 0.60);
      }
    });
  }

  double _minutes() {
    return widget.time.minute.toDouble() * widget.radiansPerTick;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerMinutes.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: _animationMinutes.value,
        child: SvgPicture.asset('assets/minutes.svg'),
      ),
    );
  }
}
