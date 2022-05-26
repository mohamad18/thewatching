import 'package:flutter/material.dart';
import 'package:thefilms/services/movie.dart';
import 'package:thefilms/utils/constants.dart';
import 'package:thefilms/widgets/custom_loading_spin_kit_ring.dart';
import 'package:thefilms/widgets/custom_search_appbar_content.dart';
import 'package:thefilms/widgets/movie_card.dart';
import 'package:thefilms/widgets/movie_card_container.dart';
import 'package:thefilms/widgets/shadowless_floating_button.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/utils/scroll_top_with_controller.dart'
    as scrollTop;


class FinderScreen extends StatefulWidget {
  final Color themeColor;

  FinderScreen({required this.themeColor});

  @override
  _FinderScreenState createState() => _FinderScreenState();
}

class _FinderScreenState extends State<FinderScreen> {
  String textFieldValue = "";
  //for scroll upping
  late ScrollController _scrollController;
  bool showBackToTopButton = false;
  List<TheFilmCard>? _theFilmCards;
  bool showLoadingScreen = false;

  Future<void> loadData(String movieName) async {
    MovieService movieService = MovieService();
    _theFilmCards = await movieService.searchMovies(
        movieName: movieName, themeColor: widget.themeColor);

    setState(() {
      scrollTop.scrollToTop(_scrollController);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          showBackToTopButton = (_scrollController.offset >= 200);
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 18.h,
        title: Text(kFinderScreenTitleText, style: kSmallAppBarTitleTextStyle),
        backgroundColor: kSearchAppBarColor,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          child: CustomSearchAppbarContent(
              onChanged: (value) => textFieldValue = value,
              onEditingComplete: () {
                if (textFieldValue.length > 0) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showLoadingScreen = true;

                  setState(() {
                    _theFilmCards = null;
                    loadData(textFieldValue);
                  });
                }
              }),
          preferredSize: Size.zero,
        ),
      ),
      body: (_theFilmCards == null)
          ? ((showLoadingScreen)
              ? CustomLoadingSpinKitRing(loadingColor: widget.themeColor)
              : null)
          : (_theFilmCards!.length == 0)
              ? Center(
                  child: Text(
                  kNotFoundErrorText,
                  style: kSplashScreenTextStyle,
                ))
              : TheFilmCardContainer(
                  scrollController: _scrollController,
                  themeColor: widget.themeColor,
                  theFilmCards: _theFilmCards!,
                ),
      floatingActionButton: showBackToTopButton
          ? ShadowlessFloatingButton(
              backgroundColor: widget.themeColor,
              iconData: Icons.keyboard_arrow_up_outlined,
              onPressed: () =>
                  setState(() => scrollTop.scrollToTop(_scrollController)),
            )
          : null,
    );
  }
}
