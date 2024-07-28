import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riddlepedia/modul/home/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/user/bloc/user_bloc.dart';
import 'package:riddlepedia/modul/user/model/user_model.dart';
import 'package:riddlepedia/modul/home/home_screen.dart';
import 'package:riddlepedia/modul/my_riddle/my_riddle_screen.dart';
import 'package:riddlepedia/modul/competition/competition_screen.dart';
import 'package:riddlepedia/modul/user/login/login_screen.dart';
import 'package:riddlepedia/modul/user/profile/profile_screen.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:riddlepedia/util/preference_util.dart';
import 'package:riddlepedia/modul/setting/setting_screen.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:riddlepedia/modul/main/main_screen.dart';  // Adjust the import path if necessary

class MockHomeBloc extends MockBloc<HomeEvent, HomeState> implements HomeBloc {}
class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

void main() {
  late MockHomeBloc homeBloc;
  late MockUserBloc userBloc;

  setUp(() {
    homeBloc = MockHomeBloc();
    userBloc = MockUserBloc();

    when(() => homeBloc.state).thenReturn(HomeInitial());
    when(() => userBloc.state).thenReturn(UserInitial());
  });

  testWidgets('MainScreen initializes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(create: (_) => homeBloc),
          BlocProvider<UserBloc>(create: (_) => userBloc),
        ],
        child: const MaterialApp(
          home: MainScreen(),
        ),
      ),
    );

    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'Profile'), findsOneWidget);
    expect(find.widgetWithText(Tab, 'My Riddle'), findsOneWidget);    
    expect(find.widgetWithText(Tab, 'Contest'), findsOneWidget);    
  });

  // testWidgets('Tab tapping updates screen title', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [
  //         BlocProvider<HomeBloc>(create: (_) => homeBloc),
  //         BlocProvider<UserBloc>(create: (_) => userBloc),
  //       ],
  //       child: const MaterialApp(
  //         home: MainScreen(),
  //       ),
  //     ),
  //   );

  //   expect(find.text('Riddlepedia'), findsOneWidget);

  //   await tester.tap(find.byIcon(Icons.dashboard));
  //   await tester.pump();
  //   expect(find.text('My Riddle'), findsOneWidget);

  //   await tester.tap(find.byIcon(Symbols.trophy));
  //   await tester.pump();
  //   expect(find.text('Contest'), findsOneWidget);

  //   await tester.tap(find.byIcon(Icons.person));
  //   await tester.pump();
  //   expect(find.text('Login'), findsOneWidget);
  // });

  // testWidgets('BlocListeners handle states correctly', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     MultiBlocProvider(
  //       providers: [
  //         BlocProvider<HomeBloc>(create: (_) => homeBloc),
  //         BlocProvider<UserBloc>(create: (_) => userBloc),
  //       ],
  //       child: const MaterialApp(
  //         home: MainScreen(),
  //       ),
  //     ),
  //   );

  //   // Test for HomeBloc state
  //   whenListen(
  //     homeBloc,
  //     Stream.fromIterable([LoadRiddleDataFailed()]),
  //   );

  //   await tester.pump();
  //   expect(find.text('There is something wrong in our system.'), findsOneWidget);

  //   // Test for UserBloc state
  //   whenListen(
  //     userBloc,
  //     Stream.fromIterable([LoginFailed(error: 'Login failed')]),
  //   );

  //   await tester.pump();
  //   expect(find.text('Login failed'), findsOneWidget);
  // });
}
