import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thefilms/model/preview_model.dart';
import 'package:thefilms/screens/details_movies_screen.dart';
import 'package:thefilms/screens/details_tv_screen.dart';
import 'package:thefilms/states/main_app_state.dart';
import 'package:thefilms/utils/star_calculator.dart' as starCalculator;
import 'package:sizer/sizer.dart';
import 'package:thefilms/utils/constants.dart';
import 'custom_loading_spin_kit_ring.dart';
import 'package:thefilms/utils/navi.dart' as navi;


class TheFilmCard extends StatelessWidget {
  final PreviewModels previewModels;
  final Color themeColor;
  final int? contentLoadedFromPage;

  TheFilmCard({
    required this.previewModels,
    required this.themeColor,
    this.contentLoadedFromPage,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars =
        starCalculator.getStars(rating: previewModels.rating, starSize: 2.h);

    return GestureDetector(
      onTap: () async {
        var buttomIndex = Provider.of<MainAppState>(context, listen: false)
            .getButtomPageIndex;

        await navi.newScreen(
          context: context,
          newScreen: () => buttomIndex == 0 ? DetailsScreenMovies(
            id: previewModels.id,
            themeColor: themeColor,
          ):DetailsScreenTv(
            id: previewModels.id,
            themeColor: themeColor,
          ),
        );
        if (contentLoadedFromPage != null)
          kHomeScreenKey.currentState!.pageSwitcher(contentLoadedFromPage!);
      },
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Stack(
          children: [
            Container(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.2.w),
                  child: CachedNetworkImage(
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Column(
                            children: [
                              Container(
                                height: 20.h,
                                child: CustomLoadingSpinKitRing(
                                    loadingColor: themeColor),
                              )
                            ],
                          ),
                      imageUrl: previewModels.imageUrl!,
                      errorWidget: (context, url, error) => Column(
                            children: [
                              Container(
                                height: 20.h,
                                child: CustomLoadingSpinKitRing(
                                    loadingColor: themeColor),
                              )
                            ],
                          )),
                ),
              ),
              height: 30.h,
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.w),
                color: Colors.black,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                children: [
                                  // Text("${previewModels.title} ",
                                  //     style: kBoldTitleTextStyle),
                                  Text(
                                      (previewModels.year == "")
                                          ? ""
                                          : "${previewModels.year}",
                                      style: kTitleTextStyle),
                                ],
                              ),
                            ),
                            if (previewModels.isFavorite)
                              Icon(
                                Icons.bookmark_sharp,
                                size: 15.sp,
                                color: kInactiveButtonColor,
                              ),
                            if (stars.length != 0) Row(children: stars),
                          ],
                        ),
                        // SizedBox(height: 1.5.w),
                        // if (stars.length != 0) Row(children: stars),
                        // SizedBox(height: 1.w),
                        // Text(
                        //   previewModels.overview,
                        //   style: kSubTitleCardBoxTextStyle,
                        //   overflow: TextOverflow.ellipsis,
                        //   maxLines: 3,
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
