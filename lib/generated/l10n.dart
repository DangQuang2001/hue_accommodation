// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `English`
  String get language {
    return Intl.message(
      'English',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Hue Accommodation`
  String get home_page_title {
    return Intl.message(
      'Welcome to Hue Accommodation',
      name: 'home_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Motel House`
  String get home_page_motel {
    return Intl.message(
      'Motel House',
      name: 'home_page_motel',
      desc: '',
      args: [],
    );
  }

  /// `Forum`
  String get home_page_forum {
    return Intl.message(
      'Forum',
      name: 'home_page_forum',
      desc: '',
      args: [],
    );
  }

  /// `SuperMarket`
  String get home_page_super_market {
    return Intl.message(
      'SuperMarket',
      name: 'home_page_super_market',
      desc: '',
      args: [],
    );
  }

  /// `Hospital`
  String get home_page_hospital {
    return Intl.message(
      'Hospital',
      name: 'home_page_hospital',
      desc: '',
      args: [],
    );
  }

  /// `Household Goods`
  String get home_page_household_goods {
    return Intl.message(
      'Household Goods',
      name: 'home_page_household_goods',
      desc: '',
      args: [],
    );
  }

  /// `Extension`
  String get home_page_extension {
    return Intl.message(
      'Extension',
      name: 'home_page_extension',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get home_page_manage {
    return Intl.message(
      'Manage',
      name: 'home_page_manage',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get home_page_room {
    return Intl.message(
      'Room',
      name: 'home_page_room',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get home_page_rent {
    return Intl.message(
      'Rent',
      name: 'home_page_rent',
      desc: '',
      args: [],
    );
  }

  /// `Statistical`
  String get home_page_statistical {
    return Intl.message(
      'Statistical',
      name: 'home_page_statistical',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get home_page_qrcode {
    return Intl.message(
      'QR Code',
      name: 'home_page_qrcode',
      desc: '',
      args: [],
    );
  }

  /// `Nearby`
  String get home_page_nearby {
    return Intl.message(
      'Nearby',
      name: 'home_page_nearby',
      desc: '',
      args: [],
    );
  }

  /// `Feature`
  String get home_page_feature {
    return Intl.message(
      'Feature',
      name: 'home_page_feature',
      desc: '',
      args: [],
    );
  }

  /// `See all`
  String get home_page_see_all {
    return Intl.message(
      'See all',
      name: 'home_page_see_all',
      desc: '',
      args: [],
    );
  }

  /// `Reservation`
  String get home_page_reservation {
    return Intl.message(
      'Reservation',
      name: 'home_page_reservation',
      desc: '',
      args: [],
    );
  }

  /// `Transport`
  String get home_page_transport {
    return Intl.message(
      'Transport',
      name: 'home_page_transport',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get home_page_user {
    return Intl.message(
      'User',
      name: 'home_page_user',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get message_title {
    return Intl.message(
      'Messages',
      name: 'message_title',
      desc: '',
      args: [],
    );
  }

  /// `Search..`
  String get message_search {
    return Intl.message(
      'Search..',
      name: 'message_search',
      desc: '',
      args: [],
    );
  }

  /// `ago`
  String get message_ago {
    return Intl.message(
      'ago',
      name: 'message_ago',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification_title {
    return Intl.message(
      'Notification',
      name: 'notification_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete all`
  String get notification_delete {
    return Intl.message(
      'Delete all',
      name: 'notification_delete',
      desc: '',
      args: [],
    );
  }

  /// `No notifications!`
  String get notification_status {
    return Intl.message(
      'No notifications!',
      name: 'notification_status',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile_title {
    return Intl.message(
      'Profile',
      name: 'profile_title',
      desc: '',
      args: [],
    );
  }

  /// `CONTENT`
  String get profile_content {
    return Intl.message(
      'CONTENT',
      name: 'profile_content',
      desc: '',
      args: [],
    );
  }

  /// `PREFERENCE`
  String get profile_preference {
    return Intl.message(
      'PREFERENCE',
      name: 'profile_preference',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get profile_post {
    return Intl.message(
      'Posts',
      name: 'profile_post',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get profile_favourite {
    return Intl.message(
      'Favourites',
      name: 'profile_favourite',
      desc: '',
      args: [],
    );
  }

  /// `Rented`
  String get profile_rent {
    return Intl.message(
      'Rented',
      name: 'profile_rent',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get profile_language {
    return Intl.message(
      'Language',
      name: 'profile_language',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get profile_dark_mode {
    return Intl.message(
      'Dark mode',
      name: 'profile_dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get profile_logout {
    return Intl.message(
      'Log out',
      name: 'profile_logout',
      desc: '',
      args: [],
    );
  }

  /// `Change Avatar`
  String get profile_change_avatar {
    return Intl.message(
      'Change Avatar',
      name: 'profile_change_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get profile_change {
    return Intl.message(
      'Change',
      name: 'profile_change',
      desc: '',
      args: [],
    );
  }

  /// `Disable`
  String get profile_disable {
    return Intl.message(
      'Disable',
      name: 'profile_disable',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get profile_save {
    return Intl.message(
      'Save',
      name: 'profile_save',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get profile_language_english {
    return Intl.message(
      'English',
      name: 'profile_language_english',
      desc: '',
      args: [],
    );
  }

  /// `Vietnamese`
  String get profile_language_vietnamese {
    return Intl.message(
      'Vietnamese',
      name: 'profile_language_vietnamese',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile_title {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get edit_profile_name {
    return Intl.message(
      'Name',
      name: 'edit_profile_name',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get edit_profile_email {
    return Intl.message(
      'Email',
      name: 'edit_profile_email',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get edit_profile_address {
    return Intl.message(
      'Address',
      name: 'edit_profile_address',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get edit_profile_phone {
    return Intl.message(
      'Phone',
      name: 'edit_profile_phone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get edit_profile_password {
    return Intl.message(
      'Password',
      name: 'edit_profile_password',
      desc: '',
      args: [],
    );
  }

  /// `Boarding Houses`
  String get boardinghouse_title {
    return Intl.message(
      'Boarding Houses',
      name: 'boardinghouse_title',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get boardinghouse_explore {
    return Intl.message(
      'Explore',
      name: 'boardinghouse_explore',
      desc: '',
      args: [],
    );
  }

  /// `Rent`
  String get boardinghouse_rent {
    return Intl.message(
      'Rent',
      name: 'boardinghouse_rent',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get boardinghouse_buy {
    return Intl.message(
      'Buy',
      name: 'boardinghouse_buy',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get boardinghouse_project {
    return Intl.message(
      'Project',
      name: 'boardinghouse_project',
      desc: '',
      args: [],
    );
  }

  /// `Top Rating`
  String get boardinghouse_top_rating {
    return Intl.message(
      'Top Rating',
      name: 'boardinghouse_top_rating',
      desc: '',
      args: [],
    );
  }

  /// `Mini House`
  String get boardinghouse_mini_house {
    return Intl.message(
      'Mini House',
      name: 'boardinghouse_mini_house',
      desc: '',
      args: [],
    );
  }

  /// `Motel House`
  String get boardinghouse_motel_house {
    return Intl.message(
      'Motel House',
      name: 'boardinghouse_motel_house',
      desc: '',
      args: [],
    );
  }

  /// `Whole House`
  String get boardinghouse_whole_house {
    return Intl.message(
      'Whole House',
      name: 'boardinghouse_whole_house',
      desc: '',
      args: [],
    );
  }

  /// `New post`
  String get boardinghouse_filer_new_post {
    return Intl.message(
      'New post',
      name: 'boardinghouse_filer_new_post',
      desc: '',
      args: [],
    );
  }

  /// `Min price`
  String get boardinghouse_filer_min_price {
    return Intl.message(
      'Min price',
      name: 'boardinghouse_filer_min_price',
      desc: '',
      args: [],
    );
  }

  /// `Wifi`
  String get boardinghouse_filer_wifi {
    return Intl.message(
      'Wifi',
      name: 'boardinghouse_filer_wifi',
      desc: '',
      args: [],
    );
  }

  /// `Air conditioning`
  String get boardinghouse_filer_air_condition {
    return Intl.message(
      'Air conditioning',
      name: 'boardinghouse_filer_air_condition',
      desc: '',
      args: [],
    );
  }

  /// `PRICE`
  String get boardinghouse_filer_price {
    return Intl.message(
      'PRICE',
      name: 'boardinghouse_filer_price',
      desc: '',
      args: [],
    );
  }

  /// `SORT`
  String get boardinghouse_filer_sort {
    return Intl.message(
      'SORT',
      name: 'boardinghouse_filer_sort',
      desc: '',
      args: [],
    );
  }

  /// `CONVENIENT`
  String get boardinghouse_filer_convenient {
    return Intl.message(
      'CONVENIENT',
      name: 'boardinghouse_filer_convenient',
      desc: '',
      args: [],
    );
  }

  /// `Min`
  String get boardinghouse_filer_min {
    return Intl.message(
      'Min',
      name: 'boardinghouse_filer_min',
      desc: '',
      args: [],
    );
  }

  /// `Max`
  String get boardinghouse_filer_max {
    return Intl.message(
      'Max',
      name: 'boardinghouse_filer_max',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get boardinghouse_filer_apply {
    return Intl.message(
      'Apply',
      name: 'boardinghouse_filer_apply',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get boardinghouse_filer_search {
    return Intl.message(
      'Search',
      name: 'boardinghouse_filer_search',
      desc: '',
      args: [],
    );
  }

  /// `Beds`
  String get boardinghouse_detail_bed {
    return Intl.message(
      'Beds',
      name: 'boardinghouse_detail_bed',
      desc: '',
      args: [],
    );
  }

  /// `Bath`
  String get boardinghouse_detail_bath {
    return Intl.message(
      'Bath',
      name: 'boardinghouse_detail_bath',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get boardinghouse_detail_description {
    return Intl.message(
      'Description',
      name: 'boardinghouse_detail_description',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get boardinghouse_detail_total_price {
    return Intl.message(
      'Total Price',
      name: 'boardinghouse_detail_total_price',
      desc: '',
      args: [],
    );
  }

  /// `Rent Now`
  String get boardinghouse_detail_rent_now {
    return Intl.message(
      'Rent Now',
      name: 'boardinghouse_detail_rent_now',
      desc: '',
      args: [],
    );
  }

  /// `Rent Now`
  String get rent_now_title {
    return Intl.message(
      'Rent Now',
      name: 'rent_now_title',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get rent_now_user {
    return Intl.message(
      'User',
      name: 'rent_now_user',
      desc: '',
      args: [],
    );
  }

  /// `Host`
  String get rent_now_host {
    return Intl.message(
      'Host',
      name: 'rent_now_host',
      desc: '',
      args: [],
    );
  }

  /// `Rent date:`
  String get rent_now_rent_date {
    return Intl.message(
      'Rent date:',
      name: 'rent_now_rent_date',
      desc: '',
      args: [],
    );
  }

  /// `Number Days Rental:`
  String get rent_now_number_date {
    return Intl.message(
      'Number Days Rental:',
      name: 'rent_now_number_date',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get rent_now_day {
    return Intl.message(
      'Days',
      name: 'rent_now_day',
      desc: '',
      args: [],
    );
  }

  /// `Boarding house:`
  String get rent_now_boarding_house {
    return Intl.message(
      'Boarding house:',
      name: 'rent_now_boarding_house',
      desc: '',
      args: [],
    );
  }

  /// `Phone:`
  String get rent_now_phone {
    return Intl.message(
      'Phone:',
      name: 'rent_now_phone',
      desc: '',
      args: [],
    );
  }

  /// `Number of people:`
  String get rent_now_number_of_people {
    return Intl.message(
      'Number of people:',
      name: 'rent_now_number_of_people',
      desc: '',
      args: [],
    );
  }

  /// `Notes:`
  String get rent_now_note {
    return Intl.message(
      'Notes:',
      name: 'rent_now_note',
      desc: '',
      args: [],
    );
  }

  /// `RENT`
  String get rent_now_rent {
    return Intl.message(
      'RENT',
      name: 'rent_now_rent',
      desc: '',
      args: [],
    );
  }

  /// `Room Management`
  String get manage_room_title {
    return Intl.message(
      'Room Management',
      name: 'manage_room_title',
      desc: '',
      args: [],
    );
  }

  /// `Join date:`
  String get manage_room_join_date {
    return Intl.message(
      'Join date:',
      name: 'manage_room_join_date',
      desc: '',
      args: [],
    );
  }

  /// `Address:`
  String get manage_room_address {
    return Intl.message(
      'Address:',
      name: 'manage_room_address',
      desc: '',
      args: [],
    );
  }

  /// `Feedback chat:`
  String get manage_room_feedback {
    return Intl.message(
      'Feedback chat:',
      name: 'manage_room_feedback',
      desc: '',
      args: [],
    );
  }

  /// `Posted`
  String get manage_room_posted {
    return Intl.message(
      'Posted',
      name: 'manage_room_posted',
      desc: '',
      args: [],
    );
  }

  /// `Add Room`
  String get add_room_title {
    return Intl.message(
      'Add Room',
      name: 'add_room_title',
      desc: '',
      args: [],
    );
  }

  /// `Add Room`
  String get edit_room_title {
    return Intl.message(
      'Add Room',
      name: 'edit_room_title',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get add_room_name {
    return Intl.message(
      'Title',
      name: 'add_room_name',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get add_room_description {
    return Intl.message(
      'Description',
      name: 'add_room_description',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get add_room_address {
    return Intl.message(
      'Address',
      name: 'add_room_address',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get add_room_area {
    return Intl.message(
      'Area',
      name: 'add_room_area',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get add_room_price {
    return Intl.message(
      'Price',
      name: 'add_room_price',
      desc: '',
      args: [],
    );
  }

  /// `Furnishing`
  String get add_room_furnishing {
    return Intl.message(
      'Furnishing',
      name: 'add_room_furnishing',
      desc: '',
      args: [],
    );
  }

  /// `Type Room`
  String get add_room_type_room {
    return Intl.message(
      'Type Room',
      name: 'add_room_type_room',
      desc: '',
      args: [],
    );
  }

  /// `Room Images`
  String get add_room_room_image {
    return Intl.message(
      'Room Images',
      name: 'add_room_room_image',
      desc: '',
      args: [],
    );
  }

  /// `Forum`
  String get forum_title {
    return Intl.message(
      'Forum',
      name: 'forum_title',
      desc: '',
      args: [],
    );
  }

  /// `Post something for forum?`
  String get forum_post_something {
    return Intl.message(
      'Post something for forum?',
      name: 'forum_post_something',
      desc: '',
      args: [],
    );
  }

  /// `All Discussion`
  String get forum_all {
    return Intl.message(
      'All Discussion',
      name: 'forum_all',
      desc: '',
      args: [],
    );
  }

  /// `Roommate`
  String get forum_roommate {
    return Intl.message(
      'Roommate',
      name: 'forum_roommate',
      desc: '',
      args: [],
    );
  }

  /// `Transfer of property`
  String get forum_transfer {
    return Intl.message(
      'Transfer of property',
      name: 'forum_transfer',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get forum_other {
    return Intl.message(
      'Others',
      name: 'forum_other',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get forum_comment {
    return Intl.message(
      'Comment',
      name: 'forum_comment',
      desc: '',
      args: [],
    );
  }

  /// `Enter a comment...`
  String get forum_enter_comment {
    return Intl.message(
      'Enter a comment...',
      name: 'forum_enter_comment',
      desc: '',
      args: [],
    );
  }

  /// `Delete post`
  String get forum_delete {
    return Intl.message(
      'Delete post',
      name: 'forum_delete',
      desc: '',
      args: [],
    );
  }

  /// `Hidden post`
  String get forum_hidden {
    return Intl.message(
      'Hidden post',
      name: 'forum_hidden',
      desc: '',
      args: [],
    );
  }

  /// `Create post`
  String get forum_create {
    return Intl.message(
      'Create post',
      name: 'forum_create',
      desc: '',
      args: [],
    );
  }

  /// `Title:`
  String get forum_create_title {
    return Intl.message(
      'Title:',
      name: 'forum_create_title',
      desc: '',
      args: [],
    );
  }

  /// `Type your title...`
  String get forum_type_title {
    return Intl.message(
      'Type your title...',
      name: 'forum_type_title',
      desc: '',
      args: [],
    );
  }

  /// `Type your caption...`
  String get forum_type_caption {
    return Intl.message(
      'Type your caption...',
      name: 'forum_type_caption',
      desc: '',
      args: [],
    );
  }

  /// `Tag place`
  String get forum_choose_place {
    return Intl.message(
      'Tag place',
      name: 'forum_choose_place',
      desc: '',
      args: [],
    );
  }

  /// `Rent Management`
  String get manage_rent_title {
    return Intl.message(
      'Rent Management',
      name: 'manage_rent_title',
      desc: '',
      args: [],
    );
  }

  /// `Waiting`
  String get manage_rent_waiting {
    return Intl.message(
      'Waiting',
      name: 'manage_rent_waiting',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get manage_rent_confirmed {
    return Intl.message(
      'Confirmed',
      name: 'manage_rent_confirmed',
      desc: '',
      args: [],
    );
  }

  /// `UnConfirmed`
  String get manage_rent_UnConfirmed {
    return Intl.message(
      'UnConfirmed',
      name: 'manage_rent_UnConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Rent detail`
  String get manage_rent_detail {
    return Intl.message(
      'Rent detail',
      name: 'manage_rent_detail',
      desc: '',
      args: [],
    );
  }

  /// `Number of days:`
  String get manage_rent_number {
    return Intl.message(
      'Number of days:',
      name: 'manage_rent_number',
      desc: '',
      args: [],
    );
  }

  /// `days rental`
  String get manage_day_rent {
    return Intl.message(
      'days rental',
      name: 'manage_day_rent',
      desc: '',
      args: [],
    );
  }

  /// `Scan a code`
  String get qr_code_scan {
    return Intl.message(
      'Scan a code',
      name: 'qr_code_scan',
      desc: '',
      args: [],
    );
  }

  /// `Scanned Success`
  String get qr_code_scan_success {
    return Intl.message(
      'Scanned Success',
      name: 'qr_code_scan_success',
      desc: '',
      args: [],
    );
  }

  /// `Detail`
  String get qr_code_detail {
    return Intl.message(
      'Detail',
      name: 'qr_code_detail',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get qr_code_review {
    return Intl.message(
      'Review',
      name: 'qr_code_review',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get qr_code_review_title {
    return Intl.message(
      'Review',
      name: 'qr_code_review_title',
      desc: '',
      args: [],
    );
  }

  /// `SEND`
  String get qr_code_review_send {
    return Intl.message(
      'SEND',
      name: 'qr_code_review_send',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
