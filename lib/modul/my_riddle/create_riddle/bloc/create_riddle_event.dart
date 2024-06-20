part of 'create_riddle_bloc.dart';

@immutable
sealed class CreateRiddleEvent {}

class SetLoadingIsVisibleEvent extends CreateRiddleEvent {}

class FetchCategoryDataEvent extends CreateRiddleEvent {}

class SubmitRiddleEvent extends CreateRiddleEvent {
  final String title;
  final String description;
  final String level;
  final int categoryId;
  final String hint1;
  final String hint2;
  final String hint3;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  final List<RiddleCategory> data;

  SubmitRiddleEvent(
      {required this.title,
      required this.description,
      required this.level,
      required this.categoryId,
      required this.hint1,
      required this.hint2,
      required this.hint3,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4, 
      required this.answer, 
      required this.data});
}
