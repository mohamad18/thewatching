import 'package:flutter/material.dart';
import 'package:thefilms/widgets/bottom_navigation_item.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/utils/constants.dart';


class BottomNavigation extends StatelessWidget {
  final List<BottomNavigationItem> children;
  final int index;
  final Color activeColor;

  BottomNavigation({
    required this.children,
    required this.index,
    required this.activeColor,
  }) {
    children[index].color = activeColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(10.0.sp), topRight:Radius.circular(10.0.sp)),
        color: Colors.white,
        boxShadow: kBoxShadow,
      ),
      height: 7.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }
}
