import 'package:flutter/material.dart';
import 'package:thefilms/widgets/custom_movies_button.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/utils/constants.dart';


class CustomMainAppBarContent extends StatefulWidget {
  final String title;
  final Color? activeColor;
  final int? bottomBarIndex;
  final Function? searchOnPressed;
  final Function(int)? buttonZeroOnPressed;
  final Function(int)? buttonFistOnPressed;
  final Function(int)? buttonSecondOnPressed;
  final Function(int)? buttonThirdOnPressed;
  final bool showSlider;
  final int? activeButtonIndex;
  Color _zeroColor = kLightGrey;
  Color _firstColor = kLightGrey;
  Color _secondColor = kLightGrey;
  Color _thirdColor = kLightGrey;

  CustomMainAppBarContent({
    required this.showSlider,
    required this.title,
    this.activeButtonIndex,
    this.activeColor,
    this.bottomBarIndex,
    required this.searchOnPressed,
    this.buttonZeroOnPressed,
    this.buttonFistOnPressed,
    this.buttonSecondOnPressed,
    this.buttonThirdOnPressed,
  }) {
    if (activeButtonIndex != null) changeButtonsColor(activeButtonIndex!);
  }

  void changeButtonsColor(int index) {
    switch (index) {
      case 0:
        _zeroColor = activeColor!;
        _firstColor = kLightGrey;
        _secondColor = kLightGrey;
        _thirdColor = kLightGrey;
        break;
      case 1:
        _zeroColor = kLightGrey;
        _firstColor = activeColor!;
        _secondColor = kLightGrey;
        _thirdColor = kLightGrey;
        break;
      case 2:
        _zeroColor = kLightGrey;
        _firstColor = kLightGrey;
        _secondColor = activeColor!;
        _thirdColor = kLightGrey;
        break;
      default:
        _zeroColor = kLightGrey;
        _firstColor = kLightGrey;
        _secondColor = kLightGrey;
        _thirdColor = activeColor!;
    }
  }

  @override
  _CustomMainAppBarContentState createState() =>
      _CustomMainAppBarContentState();
}

class _CustomMainAppBarContentState extends State<CustomMainAppBarContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title, style: kAppBarTitleTextStyle),
          // trailing: (widget.showSlider)
          //     ? IconButton(
          //         onPressed: () {
          //           widget.searchOnPressed!();
          //         },
          //         icon: Icon(Icons.search, size: 22.sp),
          //       )
          //     : null,
        ),
        SizedBox(height: 3.h),
        if (widget.showSlider)
          if (widget.activeButtonIndex != null)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.only(bottom: 2.0.h, left: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomMoviesButton(
                      text: widget.bottomBarIndex == 0 ? kHomeScreenButtonZeroText:kTVScreenButtonZeroText,
                      onPressed: () {
                        setState(() {
                          widget.buttonZeroOnPressed!(0);
                        });
                      },
                      color: widget._zeroColor,
                    ),
                    SizedBox(width: 2.w),
                    CustomMoviesButton(
                      text: widget.bottomBarIndex == 0 ? kHomeScreenButtonFirstText:kTVScreenButtonFirstText,
                      onPressed: () {
                        setState(() {
                          widget.buttonFistOnPressed!(1);
                        });
                      },
                      color: widget._firstColor,
                    ),
                    SizedBox(width: 2.w),
                    CustomMoviesButton(
                      text: widget.bottomBarIndex == 0 ? kHomeScreenButtonSecondText:kTVScreenButtonSecondText,
                      onPressed: () {
                        setState(() {
                          widget.buttonSecondOnPressed!(2);
                        });
                      },
                      color: widget._secondColor,
                    ),
                    SizedBox(width: 2.w),
                    CustomMoviesButton(
                      text: widget.bottomBarIndex == 0 ? kHomeScreenButtonThirdText:kTVScreenButtonThirdText,
                      onPressed: () {
                        setState(() {
                          widget.buttonThirdOnPressed!(3);
                        });
                      },
                      color: widget._thirdColor,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
