import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:launch_review/launch_review.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/config/config.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:news_app/utils/toast.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AppService {
  Future<bool?> checkInternet() async {
    bool? internet;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        internet = true;
      }
    } on SocketException catch (_) {
      print('not connected');
      internet = false;
    }
    return internet;
  }

  Future openLink(context, String url) async {
    if (await urlLauncher.canLaunch(url)) {
      urlLauncher.launch(url);
    } else {
      openToast1(context, "Can't launch the url");
    }
  }

  Future openEmailSupport() async {
    await urlLauncher.launch(
        'mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body=');
  }

  Future openLinkWithCustomTab(BuildContext context, String url) async {
    try {
      await FlutterWebBrowser.openWebPage(
        url: url,
        customTabsOptions: CustomTabsOptions(
          colorScheme: context.read<ThemeBloc>().darkTheme!
              ? CustomTabsColorScheme.dark
              : CustomTabsColorScheme.light,
          addDefaultShareMenuItem: true,
          instantAppsEnabled: true,
          showTitle: true,
          urlBarHidingEnabled: true,
        ),
        safariVCOptions: SafariViewControllerOptions(
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
          modalPresentationCapturesStatusBarAppearance: true,
        ),
      );
    } catch (e) {
      openToast1(context, 'Cant launch the url');
      debugPrint(e.toString());
    }
  }

  Future launchAppReview(context) async {
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await LaunchReview.launch(
        androidAppId: sb.packageName,
        iOSAppId: Config().iOSAppId,
        writeReview: false);
    if (Platform.isIOS) {
      if (Config().iOSAppId == '000000') {
        openToast1(
            context, 'The iOS version is not available on the AppStore yet');
      }
    }
  }

  static getYoutubeVideoIdFromUrl(String videoUrl) {
    return YoutubePlayer.convertUrlToId(videoUrl, trimWhitespaces: true);
  }
}
