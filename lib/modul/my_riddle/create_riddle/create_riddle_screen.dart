import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/core/extension/double.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  20.0.height,
                  const FormInput(
                    hint: "Enter title",
                    title: "Title",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Description",
                    title: "Description",
                    keyboardType: TextInputType.emailAddress,
                    maxLine: 5,
                  ),
                  20.0.height,
                  const OptionButton(title: "Type", hint: "Choose Type"),
                  20.0.height,
                  const OptionButton(title: "Level", hint: "Choose Difficulty"),
                  20.0.height,
                  const OptionButton(title: "Category", hint: "Choose Category"),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Hint 1",
                    title: "Hint 1",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Hint 2",
                    title: "Hint 2",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Hint 3",
                    title: "Hint 3",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Option 1",
                    title: "Option 1",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Option 2",
                    title: "Option 2",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Option 3",
                    title: "Option 3",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const FormInput(
                    hint: "Enter Option 4",
                    title: "Option 4",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  20.0.height,
                  const OptionButton(title: "Answer", hint: "Option 1"),
                  40.0.height,
                  const RpButton(title: "Submit"),
                  40.0.height
                ],
              ),
            ),
          ))),
    );
  }
}
