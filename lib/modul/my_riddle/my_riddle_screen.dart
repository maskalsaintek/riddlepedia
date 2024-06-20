import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/core/extension/double.dart';
import 'package:riddlepedia/modul/home/model/riddle_model.dart';
import 'package:riddlepedia/modul/my_riddle/bloc/my_riddle_bloc.dart';
import 'package:riddlepedia/modul/my_riddle/create_riddle/create_riddle_screen.dart';
import 'package:riddlepedia/modul/my_riddle/model/riddle_category.dart';
import 'package:riddlepedia/modul/riddle_detail/riddle_detail_screen.dart';
import 'package:riddlepedia/widget/riddle_card_list_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRiddleScreen extends StatefulWidget {
  const MyRiddleScreen({super.key});

  @override
  State<MyRiddleScreen> createState() => _MyRiddleScreen();
}

class _MyRiddleScreen extends State<MyRiddleScreen> {
  final int _pageSize = 5;
  List<Riddle> _riddleList = [];
  List<RiddleCategory> _riddleCategoryList = [];
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');
  final TextEditingController _searchTextFieldController =
      TextEditingController();
  final TextEditingController _startDateTextFieldController =
      TextEditingController();
  final TextEditingController _endDateTextFieldController =
      TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  RiddleCategory? _selectedCategory;
  String? _selectedStatus = 'All';
  DateTime? _startDate;
  DateTime? _endDate;
  String? _keyword;

  @override
  void initState() {
    super.initState();

    context.read<MyRiddleBloc>().add(SetLoadingIsVisibleEvent());
    context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize, offset: 0, currentData: const []));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyRiddleBloc, MyRiddleState>(
        listener: (context, state) {
      if (state is LoadRiddleDataSuccess) {
        _riddleList = state.data;
        _riddleCategoryList = [];
        _riddleCategoryList.add(RiddleCategory(
            id: -1,
            createdAt: DateTime.now(),
            lastUpdatedAt: DateTime.now(),
            createBy: 'app',
            lastUpdateBy: 'app',
            recordFlag: 'active',
            name: "All"));
        _riddleCategoryList.addAll(state.categoryData);
        _selectedCategory = _riddleCategoryList.first;
      }
    }, child:
            BlocBuilder<MyRiddleBloc, MyRiddleState>(builder: (contex, state) {
      return Container(
          color: Colors.grey[300],
          child: Column(children: [
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TextField(
                        controller: _searchTextFieldController,
                        onChanged: (value) {
                          _keyword = value;
                          context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
                              keyword: _keyword,
                              startDate: _startDate,
                              endDate: _endDate,
                              categoryId: '${_selectedCategory!.id}',
                              limit: _pageSize,
                              offset: 0,
                              currentData: const []));
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          contentPadding: const EdgeInsets.all(10),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black38),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: const BorderSide(
                                width: 1, color: Colors.black38),
                          ),
                        ),
                      ),
                    ),
                  ),
                  8.0.width,
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: const Icon(Icons.filter_list,
                              color: AppColor.secondaryColor))),
                ],
              ),
            ),
            state is LoadingIsVisible
                ? Expanded(
                    child: SizedBox(
                        width: 100,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppColor.secondaryColor, size: 75))))
                : state is LoadRiddleDataSuccess
                    ? Expanded(
                        child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: const WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: _onRiddleDataRefresh,
                        onLoading: _onRiddleDataLoading,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final Riddle riddle = state.data[index];

                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              RiddleDetailScreen(
                                                  id: riddle.id)));
                                },
                                child: RiddleCardList(
                                    title: riddle.title,
                                    description: riddle.description,
                                    level: riddle.recordFlag,
                                    rating: riddle.rating,
                                    imageUrl: Supabase.instance.client.storage
                                        .from('riddlepedia')
                                        .getPublicUrl(
                                            'category/category-${riddle.categoryId}.jpeg'),
                                    index: index));
                          },
                        ),
                      ))
                    : Container(),
            Container(
              margin: const EdgeInsets.all(20.0),
              height: 44,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(6)),
              child: TextButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CreateRiddleScreen()));
                    _onRiddleDataRefresh();
                  },
                  child: const Text("Create Riddle",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14))),
            )
          ]));
    }));
  }

  void _onRiddleDataRefresh() async {
    context.read<MyRiddleBloc>().add(SetLoadingIsVisibleEvent());
    context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize,
        offset: 0,
        keyword: _keyword,
        currentData: const [],
        startDate: _startDate,
        categoryId: '${_selectedCategory!.id}',
        approvalStatus: _selectedStatus,
        endDate: _endDate));
  }

  void _onRiddleDataLoading() {
    context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize,
        offset: _riddleList.length,
        keyword: _keyword,
        categoryId: '${_selectedCategory!.id}',
        approvalStatus: _selectedStatus,
        startDate: _startDate,
        endDate: _endDate,
        currentData: _riddleList));
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: const Text('Filter Data'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _startDateTextFieldController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context);
                    _startDate = pickedDate;
                    if (pickedDate != null) {
                      _startDateTextFieldController.text =
                          _dateFormat.format(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelStyle: TextStyle(color: Colors.black38),
                      floatingLabelStyle: TextStyle(color: Colors.black38),
                      hintStyle: TextStyle(
                        color: _startDateTextFieldController.text.isEmpty
                            ? Colors.grey[400]
                            : Colors.transparent,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      )),
                ),
                TextField(
                  controller: _endDateTextFieldController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await _selectDate(context);
                    _endDate = pickedDate;
                    if (pickedDate != null) {
                      _endDateTextFieldController.text =
                          _dateFormat.format(pickedDate);
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: const Icon(Icons.calendar_today),
                      labelStyle: TextStyle(color: Colors.black38),
                      floatingLabelStyle: TextStyle(color: Colors.black38),
                      hintStyle: TextStyle(
                        color: _endDateTextFieldController.text.isEmpty
                            ? Colors.grey[400]
                            : Colors.transparent,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      )),
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black38),
                      floatingLabelStyle: TextStyle(color: Colors.black38),
                      hintStyle: TextStyle(
                        color: Colors.transparent,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      labelText: 'Category'),
                  value: '${_selectedCategory!.id}',
                  items: _riddleCategoryList
                      .map((category) => DropdownMenuItem<String>(
                            value: '${category.id}',
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = _riddleCategoryList
                          .firstWhere((element) => '${element.id}' == value);
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black38),
                      floatingLabelStyle: TextStyle(color: Colors.black38),
                      hintStyle: TextStyle(
                        color: Colors.transparent,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                      labelText: 'Status'),
                  value: _selectedStatus,
                  items: ['All', 'Approved', 'Rejected', 'In Review']
                      .map((status) => DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startDateTextFieldController.text = "";
                _startDate = null;
                _endDateTextFieldController.text = "";
                _endDate = null;
                _selectedCategory = _riddleCategoryList.first;
                _selectedStatus = 'All';
                context.read<MyRiddleBloc>().add(SetLoadingIsVisibleEvent());
                context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
                    limit: _pageSize,
                    offset: 0,
                    keyword: _keyword,
                    currentData: const []));
              },
              child: const Text('Reset',
                  style: TextStyle(color: AppColor.secondaryColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColor.secondaryColor, //change text color of button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 55.0,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<MyRiddleBloc>().add(SetLoadingIsVisibleEvent());
                context.read<MyRiddleBloc>().add(FetchRiddleDataEvent(
                    limit: _pageSize,
                    offset: 0,
                    keyword: _keyword,
                    currentData: const [],
                    startDate: _startDate,
                    categoryId: '${_selectedCategory!.id}',
                    approvalStatus: _selectedStatus,
                    endDate: _endDate));
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }
}
