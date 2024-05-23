import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/rp_button_widget.dart';

class RiddleDetailScreen extends StatefulWidget {
  final bool isTimerVisible;
  final bool isInfoVisible;
  final bool isAuthorVisible;

  const RiddleDetailScreen(
      {super.key,
      this.isTimerVisible = false,
      this.isInfoVisible = true,
      this.isAuthorVisible = true});

  @override
  State<RiddleDetailScreen> createState() => _RiddleDetailScreen();
}

class _RiddleDetailScreen extends State<RiddleDetailScreen> {
  String _selectedOption = 'A';
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: RpAppBar(
                title: "Riddle Detail",
                appBarType: RpAppBarType.back,
                onClosePageButtonPressen: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                actions: [
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: 'Hint',
                    onPressed: () {},
                  ),
                ]),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: widget.isTimerVisible,
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                    child: Text(
                                  _formatDuration(Duration(seconds: _seconds)),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                )),
                                15.0.height
                              ],
                            ))),
                        Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  12.0), // Same border radius as container
                              child: Image.asset(
                                'assets/image/cyborg.jpg', // Path to your image asset
                                fit: BoxFit
                                    .cover, // Adjust how the image fits within the container
                              ),
                            )),
                        Visibility(
                            visible: widget.isInfoVisible,
                            child: Column(
                              children: [
                                20.0.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        children: [
                                          const Text("Category",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0)),
                                          1.0.height,
                                          const Text(
                                            "Misteri",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    )),
                                    SizedBox(
                                      height: 20,
                                      width: 1,
                                      child: Container(color: Colors.grey[350]),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        children: [
                                          const Text("Level",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0)),
                                          1.0.height,
                                          const Text("Hard",
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    )),
                                    SizedBox(
                                      height: 20,
                                      width: 1,
                                      child: Container(color: Colors.grey[350]),
                                    ),
                                    Expanded(
                                        child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Column(
                                        children: [
                                          const Text("Rating",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0)),
                                          1.0.height,
                                          const Text(
                                            "4.5",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            )),
                        18.0.height,
                        const Text("Riddle Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0,
                                color: Colors.black)),
                        Visibility(
                            visible: widget.isAuthorVisible,
                            child: Row(children: [
                              Icon(Icons.person,
                                  color: Colors.grey[700], size: 15.0),
                              3.0.width,
                              Text("Budi Gunawan",
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.grey[700]))
                            ])),
                        widget.isAuthorVisible ? 18.0.height : 10.0.height,
                        const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: Colors.black)),
                        25.0.height,
                        _buildRadioButton('A'),
                        _buildRadioButton('B'),
                        _buildRadioButton('C'),
                        _buildRadioButton('D'),
                        40.0.height,
                        const RpButton(title: "Answer"),
                        20.0.height
                      ],
                    )))));
  }

  Widget _buildRadioButton(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColor.secondaryColor),
      ),
      child: Row(
        children: <Widget>[
          Radio<String>(
            value: label,
            groupValue: _selectedOption,
            focusColor: AppColor.secondaryColor,
            activeColor: AppColor.secondaryColor,
            onChanged: (value) {
              setState(() {
                _selectedOption = value!;
              });
            },
          ),
          Expanded(
            child: Text(
              'Option $label',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
