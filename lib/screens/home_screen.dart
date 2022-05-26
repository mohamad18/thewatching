import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/screens/drawer_screen.dart';
import 'package:thefilms/screens/finder_screen.dart';
import 'package:thefilms/services/movie.dart';
import 'package:thefilms/services/tv.dart';
import 'package:thefilms/states/main_app_state.dart';
import 'package:thefilms/utils/constants.dart';
import 'package:thefilms/utils/file_manager.dart' as file;
import 'package:thefilms/utils/navi.dart' as navi;
import 'package:thefilms/utils/scroll_top_with_controller.dart' as scrollTop;
import 'package:thefilms/utils/toast_alert.dart' as alert;
import 'package:thefilms/widgets/bottom_navigation.dart';
import 'package:thefilms/widgets/bottom_navigation_item.dart';
import 'package:thefilms/widgets/custom_loading_spin_kit_ring.dart';
import 'package:thefilms/widgets/custom_main_appbar_content.dart';
import 'package:thefilms/widgets/drawer_item.dart';
import 'package:thefilms/widgets/movie_card.dart';
import 'package:thefilms/widgets/movie_card_container.dart';
import 'package:thefilms/widgets/shadowless_floating_button.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  //for custom drawer opening
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  //for scroll upping
  ScrollController? _scrollController;

  bool showBackToTopButton = false;
  Color? themeColor;
  int? activeInnerPageIndex;
  List<TheFilmCard>? _theFilmCards;
  bool showSlider = true;
  String title = kHomeScreenTitleText;
  int bottomBarIndex = 0;

  Future<void> loadData() async {
    MovieService movieService = MovieService();
    TvService tvService = TvService();

    switch (bottomBarIndex) {
      case 0:
        _theFilmCards = await movieService.getMovies(
            moviesType: MoviePageType.values[activeInnerPageIndex!],
            themeColor: themeColor!);
        break;
      case 1:
        _theFilmCards = await tvService.getTv(
            tvType: TvPageType.values[activeInnerPageIndex!],
            themeColor: themeColor!);
        break;
      default:
        _theFilmCards = await movieService.getFavorites(
            themeColor: themeColor!, bottomBarIndex: bottomBarIndex);
    }

    setState(() {
      scrollTop.scrollToTop(_scrollController!);
      showBackToTopButton = false;
    });
  }

  void pageSwitcher(int index) {
    Provider.of<MainAppState>(context, listen: false).setButtomPageIndex(index);

    setState(() {
      bottomBarIndex = index;
      title = (index == 2) ? kFavoriteScreenTitleText : kHomeScreenTitleText;
      showSlider = !(index == 2);
      _theFilmCards = null;
      loadData();
    });
  }

  void movieCategorySwitcher(int index) {
    setState(() {
      activeInnerPageIndex = index;
      _theFilmCards = null;
      loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    () async {
      themeColor = await file.currentTheme();
      print(themeColor);
      _scrollController = ScrollController()
        ..addListener(() {
          setState(() {
            showBackToTopButton = (_scrollController!.offset >= 200);
          });
        });
      activeInnerPageIndex = 0;
      setState(() {
        loadData();
      });
    }();
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (themeColor == null)
        ? CustomLoadingSpinKitRing(loadingColor: themeColor)
        : Scaffold(
            key: _scaffoldKey,
            appBar: bottomBarIndex == 2
                ? AppBar(
                    leading: Icon(Icons.person),
                    title: const Text("My Profile"),
                  )
                : AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: kAppBarColor,
                    shadowColor: Colors.transparent,
                    bottom: PreferredSize(
                      child: CustomMainAppBarContent(
                        showSlider: showSlider,
                        title: title,
                        activeButtonIndex: activeInnerPageIndex!,
                        activeColor: themeColor!,
                        bottomBarIndex: bottomBarIndex,
                        buttonZeroOnPressed: (index) =>
                            movieCategorySwitcher(index),
                        buttonFistOnPressed: (index) =>
                            movieCategorySwitcher(index),
                        buttonSecondOnPressed: (index) =>
                            movieCategorySwitcher(index),
                        buttonThirdOnPressed: (index) =>
                            movieCategorySwitcher(index),
                        searchOnPressed: () => navi.newScreen(
                          context: context,
                          newScreen: () => FinderScreen(
                            themeColor: themeColor!,
                          ),
                        ),
                      ),
                      preferredSize: Size.fromHeight(16.0.h),
                    ),
                  ),
            body: viewContent(bottomBarIndex),
            bottomNavigationBar: BottomNavigation(
              activeColor: themeColor!,
              index: bottomBarIndex,
              children: [
                BottomNavigationItem(
                  icon: Icon(Icons.movie_creation_outlined),
                  iconSize: 20.sp,
                  // onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  onPressed: () {
                    pageSwitcher(0);
                  },
                ),
                BottomNavigationItem(
                  icon: Icon(Icons.personal_video_outlined),
                  iconSize: 20.sp,
                  onPressed: () {
                    pageSwitcher(1);
                  },
                ),
                BottomNavigationItem(
                    icon: Icon(Icons.person),
                    iconSize: 20.sp,
                    onPressed: () {
                      pageSwitcher(2);
                    }),
              ],
            ),
            drawerEnableOpenDragGesture: false,
            drawer: DrawerScreen(colorChanged: (color) {
              themeColor = color;
              setState(() {
                alert.toastAlert(
                    message: kAppliedTheme, themeColor: themeColor);
              });
            }),
            floatingActionButton: showBackToTopButton
                ? ShadowlessFloatingButton(
                    iconData: Icons.keyboard_arrow_up_outlined,
                    onPressed: () {
                      setState(() {
                        scrollTop.scrollToTop(_scrollController!);
                      });
                    },
                    backgroundColor: themeColor,
                  )
                : null,
          );
  }

  Widget viewContent(int idx) {
    if (idx == 2) {
      return Column(
        children: [
          const ListTile(
            leading: Icon(Icons.person),
            title: Text("Mohamad Aspullah"),
          ),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text("085795601514"),
          ),
          const ListTile(
            leading: Icon(Icons.email),
            title: Text("mohamadaspullah@gmail.com"),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: DrawerItem(
              title: kDrawerTitleSecondText,
              desc: kDrawerAboutDescText,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: DrawerItem(
                title: kDrawerTitleThirdText,
                desc: kDrawerDependenciesDescText),
          ),
        ],
      );
    } else {
      if (_theFilmCards == null) {
        return CustomLoadingSpinKitRing(loadingColor: themeColor);
      } else {
        if (_theFilmCards!.length == 0) {
          return Center(child: Text(k404Text));
        } else {
          return TheFilmCardContainer(
            scrollController: _scrollController!,
            themeColor: themeColor!,
            theFilmCards: _theFilmCards!,
          );
        }
      }
    }
  }
}
