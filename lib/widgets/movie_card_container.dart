import 'package:flutter/material.dart';
import 'package:thefilms/widgets/movie_card.dart';
import 'package:sizer/sizer.dart';

class TheFilmCardContainer extends StatelessWidget {
  final Color themeColor;
  final ScrollController scrollController;
  final List<TheFilmCard> theFilmCards;

  TheFilmCardContainer({
    required this.themeColor,
    required this.scrollController,
    required this.theFilmCards,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //movie_card_container
      child: Padding(
        padding: EdgeInsets.only(right: 2.w, left: 2.w),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(top: 1.5.h),
            child: Wrap(children: theFilmCards),
          ),
        ),
      ),
    );
  }
}
