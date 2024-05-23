import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
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
            body: Container(
                color: Colors.grey[300],
                child: GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Jumlah item per baris
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const RiddleDetailScreen(
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
                            (index+1).toString(),
                            style: const TextStyle(
                              color: AppColor.secondaryColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))));
  }
}
