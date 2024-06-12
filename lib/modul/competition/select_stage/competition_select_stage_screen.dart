import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/modul/competition/select_stage/bloc/competition_stage_bloc.dart';
import 'package:riddlepedia/modul/riddle_detail/riddle_detail_screen.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';

class CompetitionSelectStageScreen extends StatefulWidget {
  const CompetitionSelectStageScreen({super.key});

  @override
  State<CompetitionSelectStageScreen> createState() =>
      _CompetitionSelectStageScreen();
}

class _CompetitionSelectStageScreen
    extends State<CompetitionSelectStageScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompetitionStageBloc>().add(FetchRiddleStageDataCountEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: RpAppBar(
                title: "Select Stage",
                appBarType: RpAppBarType.back,
                onClosePageButtonPressen: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                }),
            body: BlocListener<CompetitionStageBloc, CompetitionStageState>(
                listener: (context, state) {},
                child: BlocBuilder<CompetitionStageBloc, CompetitionStageState>(
                    builder: (contex, state) {
                  if (state is LoadingIsVisible) {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColor.secondaryColor, size: 75)))
                    );
                  }
                  if (state is CompetitionStageCountResultState) {
                    return Container(
                        color: Colors.grey[300],
                        child: GridView.builder(
                          padding: const EdgeInsets.all(20.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Jumlah item per baris
                            crossAxisSpacing: 20.0,
                            mainAxisSpacing: 20.0,
                          ),
                          itemCount: state.count,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const RiddleDetailScreen(
                                                id: 0,
                                                isTimerVisible: true,
                                                isInfoVisible: false,
                                                isAuthorVisible: false)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.4),
                                        spreadRadius: 4,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: const TextStyle(
                                        color: AppColor.secondaryColor,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ));
                  }
                  return Container();
                }))));
  }
}
