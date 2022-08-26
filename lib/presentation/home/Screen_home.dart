import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix_clone/application/home/home_bloc.dart';
import 'package:netflix_clone/core/colors/colors.dart';
import 'package:netflix_clone/core/constants.dart';
import 'package:netflix_clone/presentation/home/widget/background_card.dart';
import 'package:netflix_clone/presentation/home/widget/custom_button_widget.dart';
import 'package:netflix_clone/presentation/home/widget/number_card.dart';
import 'package:netflix_clone/presentation/home/widget/number_title_card.dart';
import 'package:netflix_clone/presentation/widget/main_title.dart';
import 'package:netflix_clone/presentation/widget/main_title_card.dart';

// ignore: must_be_immutable
class ScreenHome extends StatelessWidget {
  ScreenHome({Key? key}) : super(key: key);

  ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BlocProvider.of<HomeBloc>(context).add(const GetHomeScreenData());
    });
    return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: scrollNotifier,
            builder: (BuildContext context, index, _) {
              return NotificationListener<UserScrollNotification>(
                onNotification: (notificaton) {
                  final ScrollDirection direction = notificaton.direction;
                  if (direction == ScrollDirection.reverse) {
                    scrollNotifier.value = false;
                  } else if (direction == ScrollDirection.forward) {
                    scrollNotifier.value = true;
                  }
                  return true;
                },
                child: Stack(
                  children: [
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        } else if (state.hasError) {
                          return const Center(
                              child: Text(
                            "error while getting data",
                            style: TextStyle(color: kwhiteColor),
                          ));
                        }
                        // released past year
                        final _releasedPastYear = state.pastYearMovieList.map((m){
                          return '$imageAppendUrl${m.posterPath}';
                        }).toList();
                        // trending 
                        final _trending = state.trendingMovieList.map((m){
                          return '$imageAppendUrl${m.posterPath}';
                        }).toList();
                        _trending.shuffle();
                        //  trendse drama
                        final _trendse = state.tenseDramaMovieList.map((m){
                          return '$imageAppendUrl${m.posterPath}';
                        }).toList();
                        _trendse.shuffle();
                        // south indian movie
                        final _southIndia = state.southIndianMovieList.map((m){
                          return '$imageAppendUrl${m.posterPath}';
                        }).toList();
                        _southIndia.shuffle();
                        return ListView(
                          children:  [
                            BackgroundCard(),
                            kHeight,
                            MainTitleCard(
                              title: "Released in the past year",
                              posterList: _releasedPastYear,
                            ),
                            kHeight,
                            MainTitleCard(
                              title: "Trending Now",
                              posterList: _trending,
                            ),
                            kHeight,
                            NumberTitleCard(
                              title: "Top 10 TV shows in india today",
                            ),
                            kHeight,
                            MainTitleCard(
                              title: "Tense Dramas",
                              posterList: _trendse,
                            ),
                            kHeight,
                            MainTitleCard(
                              title: "South Indian Cinema",
                              posterList: _southIndia,
                            ),
                          ],
                        );
                      },
                    ),
                    scrollNotifier.value == true
                        ? AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            width: double.infinity,
                            height: 90,
                            color: Colors.black.withOpacity(0.2),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      'https://cdn-images-1.medium.com/max/1200/1*ty4NvNrGg4ReETxqU2N3Og.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.cast,
                                      size: 30,
                                      color: kwhiteColor,
                                    ),
                                    kWidth,
                                    Container(
                                      color: Colors.blue,
                                      width: 30,
                                      height: 30,
                                    ),
                                    kWidth
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Text(
                                      "TV Shows",
                                      style: kHomeTitleText,
                                    ),
                                    Text(
                                      "Movies",
                                      style: kHomeTitleText,
                                    ),
                                    Text(
                                      "Categories",
                                      style: kHomeTitleText,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        : kHeight
                  ],
                ),
              );
            }));
  }
}
