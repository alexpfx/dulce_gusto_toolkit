import 'package:dulce_gusto_toolkit/model/page_summary.dart';
import 'package:flutter/material.dart';

//const TextStyle kCupomCodeTextStyle = TextStyle(
//    color: kPrimaryTextColor,
//    fontSize: 20,
//  fontWeight: FontWeight.bold
//);
//
//const TextStyle kMainActionButtonTextStyle = TextStyle(
//    color: kPrimaryTextColor,
//    fontSize: 14,
//    fontWeight: FontWeight.w400
//);
//
//
//const TextStyle kCupomSecondaryInfoTextStyle = TextStyle(
//    color: kSecondaryTextColor,
//    fontSize: 12,
//);
//
//const TextStyle kMenuTitleTextStyle = TextStyle(
//  color: kPrimaryTextColor,
//  fontSize: 16
//
//);
//const TextStyle kMenuSubTitleTextStyle = TextStyle(
//    color: kSecondaryTextColor,
//  fontSize: 13
//);
//
////const TextStyle kAppNameTextStyle = TextStyle(
////  fontSize: 24,
////  color: kAppNameColor
////);
//
const kPageTimer = const PageSummary(
  route: '/timer',
  title: 'Timer',
  subtitle: 'Make a perfect coffee',
  icon: Icons.timer,
);
const kPagePods = const PageSummary(
    route: '/flavors',
    title: 'Flavors',
    subtitle: 'All dolce gusto flavors',
    icon: Icons.filter_vintage);
const kPageCoupons = const PageSummary(
    route: '/coupons',
    title: 'MY Coupons',
    subtitle: 'My dolce gusto coupons',
    icon: Icons.card_giftcard);

const pages = [kPageTimer, kPagePods, kPageCoupons];

const kDolceGustoLoginKey = 'dolce_gusto_login';
const kDolceGustoPassKey = 'dolce_gusto_pass';

double kDefaultBarHeight = 56;
