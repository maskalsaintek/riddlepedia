import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:riddlepedia/constants/app_color.dart';
import 'package:riddlepedia/modul/home/bloc/bloc/home_bloc.dart';
import 'package:riddlepedia/modul/home/model/riddle_model.dart';
import 'package:riddlepedia/modul/riddle_detail/riddle_detail_screen.dart';
import 'package:riddlepedia/widget/riddle_card_list_widget.dart';
import 'package:riddlepedia/widget/rp_button_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final int _pageSize = 5;
  List<Riddle> _riddleList = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(SetLoadingIsVisibleEvent());
    context.read<HomeBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize, offset: 0, currentData: const []));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        child: BlocBuilder<HomeBloc, HomeState>(builder: (contex, state) {
          if (state is LoadingIsVisible) {
            return SizedBox(
                width: 100,
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppColor.secondaryColor, size: 75)));
          }

          if (state is LoadRiddleDataSuccess) {
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();
            _riddleList = state.data;

            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: const WaterDropHeader(),
              controller: _refreshController,
              onRefresh: _onRiddleDataRefresh,
              onLoading: _onRiddleDataLoading,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                itemCount: _riddleList.length,
                itemBuilder: (context, index) {
                  final Riddle riddle = _riddleList[index];

                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    RiddleDetailScreen(id: riddle.id)));
                      },
                      child: RiddleCardList(
                          title: riddle.title,
                          description: riddle.description,
                          level: riddle.difficulty,
                          rating: riddle.rating,
                          imageUrl: Supabase.instance.client.storage
                              .from('riddlepedia')
                              .getPublicUrl(
                                  'category/category-${riddle.categoryId}.jpeg'),
                          index: index));
                },
              ),
            );
          }
          return SizedBox(
              width: 100,
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RpButton(
                      title: "Refresh",
                      width: 100,
                      onPressed: () {
                        context
                            .read<HomeBloc>()
                            .add(SetLoadingIsVisibleEvent());
                        context.read<HomeBloc>().add(FetchRiddleDataEvent(
                            limit: _pageSize,
                            offset: 0,
                            currentData: const []));
                      })));
        }));
  }

  void _onRiddleDataRefresh() async {
    context.read<HomeBloc>().add(SetLoadingIsVisibleEvent());
    context.read<HomeBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize, offset: 0, currentData: const []));
  }

  void _onRiddleDataLoading() {
    context.read<HomeBloc>().add(FetchRiddleDataEvent(
        limit: _pageSize,
        offset: _riddleList.length,
        currentData: _riddleList));
  }
}
