import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:thefilms/model/details_model.dart';
import 'package:thefilms/services/movie.dart';
import 'package:thefilms/services/tv.dart';
import 'package:thefilms/states/main_app_state.dart';
import 'package:thefilms/utils/constants.dart';
import 'package:thefilms/widgets/custom_loading_spin_kit_ring.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/utils/star_calculator.dart'
    as starCalculator;
import 'package:thefilms/utils/file_manager.dart' as file;
import 'package:thefilms/utils/toast_alert.dart' as alert;


class DetailsScreenTv extends StatefulWidget {
  final String id;
  final Color themeColor;

  DetailsScreenTv({required this.id, required this.themeColor});

  @override
  _DetailsScreenTvState createState() => _DetailsScreenTvState();

  Future<DetailModels> getTvDetails() async {
    TvService tvService = TvService();
    DetailModels temp = await tvService.getTvDetails(tvID: id);
    return temp;
  }
}

class _DetailsScreenTvState extends State<DetailsScreenTv> {
  DetailModels? tvDetailModels;
  List<Widget>? stars;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    () async {
      DetailModels temp = await widget.getTvDetails();
      List<Widget> temp2 =
          starCalculator.getStars(rating: temp.rating, starSize: 15.sp);

      setState(() {
        isFavorite = temp.isFavorite;
        tvDetailModels = temp;
        stars = temp2;
      });
    }();
  }

  saveFavorite() async {
    if (await file.addFavorite(movieID: widget.id)) {
      alert.toastAlert(
        message: kFavoriteAddedText,
        themeColor: widget.themeColor,
      );
    }
    setState(() {
      isFavorite = true;
    });
  }

  removeFavorite() async {
    if (await file.removeFavorite(movieID: widget.id)) {
      alert.toastAlert(
        message: kFavoriteRemovedText,
        themeColor: widget.themeColor,
      );
    }
    setState(() {
      isFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (stars == null)
          ? CustomLoadingSpinKitRing(loadingColor: widget.themeColor)
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  shadowColor: Colors.transparent,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  snap: false,
                  floating: false,
                  expandedHeight: 22.0.h,
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            (!isFavorite) ? saveFavorite() : removeFavorite();
                          });
                        },
                        icon: Icon((isFavorite)
                            ? Icons.bookmark_sharp
                            : Icons.bookmark_border_sharp),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(kDetailsScreenTitleText),
                    background: SafeArea(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SafeArea(
                          child: Container(
                            height: 22.h,
                            child: CustomLoadingSpinKitRing(
                                loadingColor: widget.themeColor),
                          ),
                        ),
                        imageUrl: tvDetailModels!.backgroundURL,
                        errorWidget: (context, url, error) => SafeArea(
                          child: Container(
                            height: 22.h,
                            child: CustomLoadingSpinKitRing(
                                loadingColor: widget.themeColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: 
                  Container(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 4.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.h),
                              child: Wrap(
                                children: [
                                  Text(
                                    "${tvDetailModels!.title} ",
                                    style: kDetailScreenBoldTitle,
                                  ),
                                  Text(
                                    (tvDetailModels!.year == "")
                                        ? ""
                                        : "(${tvDetailModels!.year})",
                                    style: kDetailScreenRegularTitle,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.h),
                              child: Row(children: stars!),
                            ),
                            SizedBox(height: 3.h),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.h),
                                child:
                                    Row(children: tvDetailModels!.getGenresList()),
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                        if (tvDetailModels!.overview != "")
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.h, vertical: 3.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 1.h,
                                      left: 1.h,
                                      bottom: 1.h,
                                    ),
                                    child: Container(
                                      child: Text(kStoryLineTitleText,
                                          style: kSmallTitleTextStyle),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 1.h,
                                          left: 1.h,
                                          top: 1.h,
                                          bottom: 4.h),
                                      child: Text(
                                        tvDetailModels!.overview,
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Color(0xFFC9C9C9)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
