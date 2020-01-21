/*Copyright 2020 Squareball Studios Inc.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import 'package:clock_challenge/components/circularHours.dart';
import 'package:clock_challenge/components/circularMinutes.dart';
import 'package:clock_challenge/components/gradient_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math';

class Clock extends StatefulWidget {
  final ClockModel model;

  const Clock(this.model);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with SingleTickerProviderStateMixin {
  final radiansPerTick = radians(360 / 60);
  final radiansPerHour = radians(360 / 12);
  DateTime _dateTime = DateTime.now();
  Timer _timer, _timerLand;
  AnimationController _controller;
  Animation<double> _animation;
  bool statusAnimation;
  int currenMinute = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateTime();
    statusAnimation = false;
    _timerLand =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    _controller = AnimationController(
        duration: Duration(minutes: 1, seconds: 48), vsync: this);
    _animation = Tween(begin: 0.0, end: 11.0).animate(_controller);
    _controller.forward(from: _dateTime.second.toDouble() / 100);
    _controller.addListener(
      () => setState(() {
        if (_controller.isCompleted) {
          _controller.forward(from: 0.43);
        }
      }),
    );
  }

  void _getCurrentTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        updateTime,
      );
    });
  }

  double getAngleForRotateMinutesAxisY(int minutes) {
    return (sin(minutes) * radiansPerTick) + 0.0;
  }

  double getAngleForRotateMinutesAxisX(int minutes) {
    return (cos(minutes) * radiansPerTick) + 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Oswald',
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Oswald'),
        primaryTextTheme:
            Theme.of(context).textTheme.apply(fontFamily: 'Oswald'),
        accentTextTheme:
            Theme.of(context).textTheme.apply(fontFamily: 'Oswald'),
      ),
      home: AspectRatio(
        aspectRatio: 5 / 3,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFF2C2C2C),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2C2C2C),
                    offset: const Offset(0.0, 0.0),
                    spreadRadius: -600.0,
                    blurRadius: 600.0,
                  ),
                  BoxShadow(
                    color: const Color(0xFF2C2C2C),
                    offset: const Offset(0.0, 0.0),
                    spreadRadius: -600.0,
                    blurRadius: 600.0,
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: -510,
                    top: -322.0,
                    height: 1000,
                    width: 1000,
                    child: CircularMinutes(
                        time: _dateTime, radiansPerTick: radiansPerTick),
                  ),
                  Positioned(
                    left: -280,
                    top: -120.0,
                    height: 600,
                    width: 600,
                    child: CircularHours(
                        time: _dateTime, radiansPerHour: radiansPerHour),
                  ),
                  Positioned(
                    left: -126,
                    top: MediaQuery.of(context).size.height * 0.126,
                    child: Transform.rotate(
                      angle: _animation.value,
                      child: GradientBar(
                        strokeWidth: 6,
                        radius: 200,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF0844),
                            Color(0xFFFFB199),
                            Color(0xFF2C2C2C),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [.50, 0.00, .50],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Positioned(
                    left: -134,
                    top: MediaQuery.of(context).size.height * 0.09,
                    child: Image.asset(
                      'assets/disc_center.png',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: MediaQuery.of(context).size.height * 0.41,
                    child: Image.asset(
                      'assets/hand.png',
                      height: 50,
                      width: 240,
                    ),
                  ),
                  Positioned(
                    right: -40.0,
                    top: MediaQuery.of(context).size.height * 0.42,
                    height: 100,
                    width: 100,
                    child: Container(
                      child: Text(
                        _dateTime.hour > 11 ? 'PM' : 'AM',
                        style: TextStyle(
                            fontFamily: 'Passion One',
                            color: Color(0xFFFF0844),
                            fontSize: 35.8621,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.0,
                    top: MediaQuery.of(context).size.height * 0.52,
                    child: Container(
                      height: 3.59,
                      width: 12.1,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF0844),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Color(0xFF2C2C2C).withOpacity(.8),
                    Color(0xFF2C2C2C).withOpacity(.0),
                    Color(0xFF2C2C2C).withOpacity(.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
