part of 'my_riddle_bloc.dart';

@immutable
sealed class MyRiddleEvent {}

class SetLoadingIsVisibleEvent extends MyRiddleEvent {}

class FetchRiddleDataEvent extends MyRiddleEvent {
  final int limit;
  final int offset;
  final List<Riddle> currentData;
  final String? keyword;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? categoryId;
  final String? approvalStatus;

  FetchRiddleDataEvent(
      {required this.limit,
      required this.offset,
      required this.currentData,
      this.keyword,
      this.startDate,
      this.endDate, 
      this.categoryId, 
      this.approvalStatus});
}
