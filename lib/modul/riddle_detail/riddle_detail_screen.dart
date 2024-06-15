import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/riddle_detail/bloc/riddle_detail_bloc.dart';
import 'package:riddlepedia/modul/riddle_detail/model/riddle_detail_model.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/hint_dialog_widget.dart';
import 'package:riddlepedia/widget/rp_button_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RiddleDetailScreen extends StatefulWidget {
  final int id;
  final bool isTimerVisible;
  final bool isInfoVisible;
  final bool isAuthorVisible;
  final bool isCompetition;
  final String pageTitle;

  const RiddleDetailScreen(
      {super.key,
      required this.id,
      this.isTimerVisible = false,
      this.isInfoVisible = true,
      this.isAuthorVisible = true,
      this.isCompetition = false,
      this.pageTitle = "Riddle Detail"});

  @override
  State<RiddleDetailScreen> createState() => _RiddleDetailScreen();
}

class _RiddleDetailScreen extends State<RiddleDetailScreen> {
  String? _selectedOption;
  String? _realAnswer;
  List<String> _hints = [];
  late Timer _timer;
  int _seconds = 0;
  final int _basePoint = 100;
  final int _limitBonusPointDuration = 300;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();

    _startTimer();
    context.read<RiddleDetailBloc>().add(SetLoadingIsVisibleEvent());
    context.read<RiddleDetailBloc>().add(FetchRiddleDataEvent(id: widget.id));
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
                title: widget.pageTitle,
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
                    onPressed: () {
                      if (_hints.isEmpty) {
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return HintDialog(hints: _hints);
                        },
                      );
                    },
                  ),
                ]),
            body: BlocListener<RiddleDetailBloc, RiddleDetailState>(
                listener: (blocContext, state) {
              if (state is LoadRiddleDataSuccess && state.isPopBack) {
                EasyLoading.dismiss();
                if (_isCorrect) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.topSlide,
                    title: 'Congratulation',
                    desc: 'Your Answer is Correct',
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                  ).show();
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.topSlide,
                    title: 'Sorry',
                    desc: 'Your Answer is Wrong',
                    btnOkColor: Colors.red[700],
                    btnOkOnPress: () {
                      Navigator.pop(context);
                    },
                  ).show();
                }
              }
            }, child: BlocBuilder<RiddleDetailBloc, RiddleDetailState>(
                    builder: (contex, state) {
              if (state is LoadingIsVisible) {
                return Center(
                    child: SizedBox(
                        width: 100,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColor.secondaryColor, size: 75))));
              }

              if (state is LoadRiddleDataSuccess) {
                final RiddleDetail data = state.data;
                _realAnswer = data.answer;
                _hints = [data.hint1, data.hint2, data.hint3];

                return SingleChildScrollView(
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
                                      _formatDuration(
                                          Duration(seconds: _seconds)),
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
                                  child: Image.network(
                                    Supabase.instance.client.storage
                                        .from('riddlepedia')
                                        .getPublicUrl(
                                            'category/category-${data.categoryId}.jpeg'), // Path to your image asset
                                    fit: BoxFit
                                        .cover, // Adjust how the image fits within the container
                                  ),
                                )),
                            Visibility(
                                visible: widget.isInfoVisible,
                                child: Column(
                                  children: [
                                    20.0.height,
                                    IntrinsicHeight(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            children: [
                                              const Text("Category",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0)),
                                              1.0.height,
                                              Text(
                                                data.categoryName,
                                                style: const TextStyle(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        )),
                                        Center(
                                            child: SizedBox(
                                          height: 20,
                                          width: 1,
                                          child: Container(
                                              color: Colors.grey[350]),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            children: [
                                              const Text("Level",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0)),
                                              1.0.height,
                                              Text(data.difficulty,
                                                  style: TextStyle(
                                                      fontSize: 11.0,
                                                      color: data.difficulty ==
                                                              "Hard"
                                                          ? Colors.red[700]
                                                          : data.difficulty ==
                                                                  "Normal"
                                                              ? Colors.orange
                                                              : AppColor
                                                                  .secondaryColor,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        )),
                                        Center(
                                            child: SizedBox(
                                          height: 20,
                                          width: 1,
                                          child: Container(
                                              color: Colors.grey[350]),
                                        )),
                                        Expanded(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Column(
                                            children: [
                                              const Text("Rating",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15.0)),
                                              1.0.height,
                                              Text(
                                                data.rating.toString(),
                                                style: const TextStyle(
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          ),
                                        ))
                                      ],
                                    ))
                                  ],
                                )),
                            18.0.height,
                            Text(data.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23.0,
                                    color: Colors.black)),
                            Visibility(
                                visible: widget.isAuthorVisible,
                                child: Row(children: [
                                  Icon(Icons.person,
                                      color: Colors.grey[700], size: 15.0),
                                  3.0.width,
                                  Text(data.authorFullName,
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey[700]))
                                ])),
                            widget.isAuthorVisible ? 18.0.height : 10.0.height,
                            Text(data.description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: Colors.black)),
                            25.0.height,
                            _buildRadioButton(data.options[0]),
                            _buildRadioButton(data.options[1]),
                            _buildRadioButton(data.options[2]),
                            _buildRadioButton(data.options[3]),
                            40.0.height,
                            RpButton(
                                title: "Answer",
                                onPressed: () {
                                  _checkAnswer(state.data);
                                }),
                            20.0.height
                          ],
                        )));
              }

              return Container();
            }))));
  }

  Widget _buildRadioButton(String label) {
    return InkWell(
        onTap: () {
          setState(() {
            _selectedOption = label;
          });
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Container(
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
                label,
                style: const TextStyle(fontSize: 18.0),
              )),
            ],
          ),
        ));
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

  void _checkAnswer(RiddleDetail riddleDetail) {
    if (_selectedOption == null) {
      showPlatformDialog(
        context: context,
        builder: (context) => BasicDialogAlert(
          title: const Text("Alert"),
          content: const Text("You must choose answer option"),
          actions: <Widget>[
            BasicDialogAction(
              title: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    EasyLoading.show(status: 'Loading...', maskType: EasyLoadingMaskType.black);

    if (_selectedOption! == _realAnswer) {
      final int bonusPoint = _limitBonusPointDuration - _seconds;
      final int score = bonusPoint < 0 ? _basePoint : _basePoint + bonusPoint;
      _isCorrect = true;

      context.read<RiddleDetailBloc>().add(SubmitCompetitionDataEvent(
          data: riddleDetail,
          riddleId: widget.id,
          score: score,
          isCorrect: true,
          duration: _seconds));
    } else {
      _isCorrect = false;
      context.read<RiddleDetailBloc>().add(SubmitCompetitionDataEvent(
          data: riddleDetail,
          riddleId: widget.id,
          score: 0,
          isCorrect: false,
          duration: _seconds));
    }
  }
}
