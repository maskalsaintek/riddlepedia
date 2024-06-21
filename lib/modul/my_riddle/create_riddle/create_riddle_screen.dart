import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/my_riddle/create_riddle/bloc/create_riddle_bloc.dart';
import 'package:riddlepedia/modul/my_riddle/model/riddle_category.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/widget/form_input_widget.dart';
import 'package:riddlepedia/widget/option_button_widget.dart';
import 'package:riddlepedia/widget/rp_button_widget.dart';

class CreateRiddleScreen extends StatefulWidget {
  const CreateRiddleScreen({super.key});

  @override
  State<CreateRiddleScreen> createState() => _CreateRiddleScreen();
}

class _CreateRiddleScreen extends State<CreateRiddleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hint1Controller = TextEditingController();
  final TextEditingController _hint2Controller = TextEditingController();
  final TextEditingController _hint3Controller = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();

  String _level = "Choose Difficulty";
  int _answer = -1;
  RiddleCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    context.read<CreateRiddleBloc>().add(SetLoadingIsVisibleEvent());
    context.read<CreateRiddleBloc>().add(FetchCategoryDataEvent());
  }

  @override
  Widget build(BuildContext contexts) {
    return MaterialApp(
      home: Scaffold(
          appBar: RpAppBar(
              title: "Create Riddle",
              appBarType: RpAppBarType.back,
              onClosePageButtonPressen: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              }),
          body: BlocListener<CreateRiddleBloc, CreateRiddleState>(
              listener: (context, state) {
            if (state is LoadCategoryDataSuccess) {
              if (state.isPopBack) {
                EasyLoading.dismiss();
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.success,
                  animType: AnimType.topSlide,
                  title: 'Congratulation',
                  desc: 'Your Riddle has been submitted',
                  btnOkOnPress: () {
                    if (Navigator.canPop(contexts)) {
                      Navigator.pop(contexts);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                ).show();
              }
            }
          }, child: BlocBuilder<CreateRiddleBloc, CreateRiddleState>(
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

            if (state is LoadCategoryDataSuccess) {
              return SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      20.0.height,
                      FormInput(
                          hint: "Enter title",
                          title: "Title",
                          controller: _titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Description",
                          title: "Description",
                          maxLine: 5,
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      OptionButton(
                          title: "Level",
                          hint: capitalize(_level),
                          onPressed: () {
                            _showChooseLevelActionSheet(context);
                          }),
                      20.0.height,
                      OptionButton(
                          title: "Category",
                          hint: _selectedCategory == null
                              ? "Choose Category"
                              : _selectedCategory!.name,
                          onPressed: () {
                            _showChooseCategoryActionSheet(contex, state.data);
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Hint 1",
                          title: "Hint 1",
                          controller: _hint1Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Hint 2",
                          title: "Hint 2",
                          controller: _hint2Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Hint 3",
                          title: "Hint 3",
                          controller: _hint3Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Option 1",
                          title: "Option 1",
                          controller: _option1Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Option 2",
                          title: "Option 2",
                          controller: _option2Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Option 3",
                          title: "Option 3",
                          controller: _option3Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      FormInput(
                          hint: "Enter Option 4",
                          title: "Option 4",
                          controller: _option4Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          }),
                      20.0.height,
                      OptionButton(
                          title: "Answer",
                          hint: _answer == -1
                              ? "Choose Answer"
                              : "Option ${_answer + 1}",
                          onPressed: () {
                            _showChooseOptionAnswerActionSheet(context);
                          }),
                      40.0.height,
                      RpButton(
                          title: "Submit",
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            if (_level == "Choose Difficulty") {
                              showPlatformDialog(
                                context: context,
                                builder: (context) => BasicDialogAlert(
                                  title: const Text("Information"),
                                  content: const Text("Difficulty is Required"),
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

                              return;
                            }

                            if (_answer < 0) {
                              showPlatformDialog(
                                context: context,
                                builder: (context) => BasicDialogAlert(
                                  title: const Text("Information"),
                                  content: const Text("Answer is Required"),
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
                              return;
                            }

                            if (_selectedCategory == null) {
                              showPlatformDialog(
                                context: context,
                                builder: (context) => BasicDialogAlert(
                                  title: const Text("Information"),
                                  content: const Text("Category is Required"),
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
                              return;
                            }

                            EasyLoading.show(
                              status: 'Loading...', maskType: EasyLoadingMaskType.black);

                            String answerValue;
                            switch (_answer) {
                              case 0:
                                answerValue = _option1Controller.text;
                                break;

                              case 1:
                                answerValue = _option2Controller.text;
                                break;

                              case 2:
                                answerValue = _option3Controller.text;
                                break;

                              default:
                                answerValue = _option4Controller.text;
                            }

                            context.read<CreateRiddleBloc>().add(
                                SubmitRiddleEvent(
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    categoryId: _selectedCategory!.id,
                                    level: _level,
                                    hint1: _hint1Controller.text,
                                    hint2: _hint2Controller.text,
                                    hint3: _hint3Controller.text,
                                    option1: _option1Controller.text,
                                    option2: _option2Controller.text,
                                    option3: _option3Controller.text,
                                    option4: _option4Controller.text,
                                    answer: answerValue,
                                    data: state.data));
                          }),
                      40.0.height
                    ],
                  ),
                ),
              ));
            }

            return Container();
          }))),
    );
  }

  void _showChooseLevelActionSheet(BuildContext context) {
    List<String> levels = ["Easy", "Medium", "Hard"];

    List<CupertinoActionSheetAction> buildActionSheetActions() {
      return levels.map((String level) {
        return CupertinoActionSheetAction(
          onPressed: () {
            setState(() {
              _level = level;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(level[0].toUpperCase() +
              level.substring(1)),
        );
      }).toList();
    }

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Difficulty'),
        actions: buildActionSheetActions(),
      ),
    );
  }

  void _showChooseOptionAnswerActionSheet(BuildContext context) {
    List<Widget> buildActionSheetActions() {
      List<Widget> actions = [];
      for (int i = 0; i <= 3; i++) {
        actions.add(
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                _answer = i;
              });
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Option ${i + 1}'),
          ),
        );
      }
      return actions;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: Text('Select Answer'), actions: buildActionSheetActions()),
    );
  }

  void _showChooseCategoryActionSheet(
      BuildContext context, List<RiddleCategory> categoryList) {
    List<CupertinoActionSheetAction> buildActionSheetActions() {
      return categoryList.map((RiddleCategory riddleCategory) {
        return CupertinoActionSheetAction(
          onPressed: () {
            setState(() {
              _selectedCategory = riddleCategory;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(
              riddleCategory.name), // Mengubah huruf pertama menjadi kapital
        );
      }).toList();
    }

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select Category'),
        actions: buildActionSheetActions(),
      ),
    );
  }

  String capitalize(String s) {
    if (s == null || s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
