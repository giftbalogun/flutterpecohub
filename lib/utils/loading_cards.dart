import 'package:flutter/material.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:provider/provider.dart';

class LoadingFeaturedCard extends StatelessWidget {
  const LoadingFeaturedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
        child: Container(
            margin: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: context.watch<ThemeBloc>().darkTheme == false
                    ? CustomColor().loadingColorLight
                    : CustomColor().loadingColorDark,
                borderRadius: BorderRadius.circular(5))));
  }
}

class LoadingCard extends StatelessWidget {
  final double? height;
  const LoadingCard({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SkeletonAnimation(
        child: Container(
          decoration: BoxDecoration(
              color: context.watch<ThemeBloc>().darkTheme == false
                  ? CustomColor().loadingColorLight
                  : CustomColor().loadingColorDark,
              borderRadius: BorderRadius.circular(5)),
          height: height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
