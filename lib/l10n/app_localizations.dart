import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Baity'**
  String get appTitle;

  /// No description provided for @welcomeText.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Baity'**
  String get welcomeText;

  /// No description provided for @exploreButton.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get exploreButton;

  /// No description provided for @slogan.
  ///
  /// In en, this message translates to:
  /// **'Find your next adventure in youth houses and camps!'**
  String get slogan;

  /// No description provided for @adminLogin.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get adminLogin;

  /// No description provided for @tabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tabAll;

  /// No description provided for @tabYouthHouses.
  ///
  /// In en, this message translates to:
  /// **'Youth Houses'**
  String get tabYouthHouses;

  /// No description provided for @tabYouthCamps.
  ///
  /// In en, this message translates to:
  /// **'Youth Camps'**
  String get tabYouthCamps;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @availableSpots.
  ///
  /// In en, this message translates to:
  /// **'Available Spots'**
  String get availableSpots;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Login'**
  String get loginTitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @editData.
  ///
  /// In en, this message translates to:
  /// **'Edit Data'**
  String get editData;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// No description provided for @detailsContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get detailsContact;

  /// No description provided for @detailsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get detailsPhone;

  /// No description provided for @detailsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get detailsEmail;

  /// No description provided for @detailsSocial.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get detailsSocial;

  /// No description provided for @detailsMap.
  ///
  /// In en, this message translates to:
  /// **'View on Google Maps'**
  String get detailsMap;

  /// No description provided for @detailsSpots.
  ///
  /// In en, this message translates to:
  /// **'Available Spots'**
  String get detailsSpots;

  /// No description provided for @detailsDescription.
  ///
  /// In en, this message translates to:
  /// **'A beautiful place for youth to stay and connect.'**
  String get detailsDescription;

  /// No description provided for @detailsFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get detailsFacebook;

  /// No description provided for @detailsInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get detailsInstagram;

  /// No description provided for @detailsTwitter.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get detailsTwitter;

  /// No description provided for @detailsAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get detailsAddress;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Baity'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Baity is a mobile application designed to help young people discover and explore youth houses and camps across Algeria. Our platform provides detailed information about various youth facilities, including locations, available spots, contact information, and social media links.'**
  String get aboutDescription;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical Details'**
  String get technicalDetails;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @versionNumber.
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get versionNumber;

  /// No description provided for @developedWith.
  ///
  /// In en, this message translates to:
  /// **'Developed with'**
  String get developedWith;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get credits;

  /// No description provided for @ideaBy.
  ///
  /// In en, this message translates to:
  /// **'Idea by'**
  String get ideaBy;

  /// No description provided for @developedBy.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developedBy;

  /// No description provided for @medjdoubHadjirat.
  ///
  /// In en, this message translates to:
  /// **'Medjdoub Hadjirat, Bourouaha Nassima, Haoulia Djamila '**
  String get medjdoubHadjirat;

  /// No description provided for @medjdoubZakaria.
  ///
  /// In en, this message translates to:
  /// **'Medjdoub Mohammed Zakaria'**
  String get medjdoubZakaria;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @editYouthHouse.
  ///
  /// In en, this message translates to:
  /// **'Edit Youth House'**
  String get editYouthHouse;

  /// No description provided for @addNewYouthHouse.
  ///
  /// In en, this message translates to:
  /// **'Add New Youth House'**
  String get addNewYouthHouse;

  /// No description provided for @updateYouthHouseInfo.
  ///
  /// In en, this message translates to:
  /// **'Update youth house information'**
  String get updateYouthHouseInfo;

  /// No description provided for @createNewYouthHouse.
  ///
  /// In en, this message translates to:
  /// **'Create a new youth house or camp'**
  String get createNewYouthHouse;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @socialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get socialMedia;

  /// No description provided for @nameArabic.
  ///
  /// In en, this message translates to:
  /// **'الاسم بالعربية'**
  String get nameArabic;

  /// No description provided for @nameLatin.
  ///
  /// In en, this message translates to:
  /// **'Name in Latin'**
  String get nameLatin;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @facebookUrl.
  ///
  /// In en, this message translates to:
  /// **'Facebook URL'**
  String get facebookUrl;

  /// No description provided for @instagramUrl.
  ///
  /// In en, this message translates to:
  /// **'Instagram URL'**
  String get instagramUrl;

  /// No description provided for @twitterUrl.
  ///
  /// In en, this message translates to:
  /// **'Twitter URL'**
  String get twitterUrl;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a location'**
  String get pleaseEnterLocation;

  /// No description provided for @pleaseEnterImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter an image URL'**
  String get pleaseEnterImageUrl;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @youthHouseUpdated.
  ///
  /// In en, this message translates to:
  /// **'Youth house updated successfully!'**
  String get youthHouseUpdated;

  /// No description provided for @youthHouseAdded.
  ///
  /// In en, this message translates to:
  /// **'Youth house added successfully!'**
  String get youthHouseAdded;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this youth house? This action cannot be undone.'**
  String get deleteConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccessfully;

  /// No description provided for @manageYouthHouses.
  ///
  /// In en, this message translates to:
  /// **'Manage youth houses and camps'**
  String get manageYouthHouses;

  /// No description provided for @locationsManaged.
  ///
  /// In en, this message translates to:
  /// **'{count} locations managed'**
  String locationsManaged(Object count);

  /// No description provided for @errorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEnterEmail;

  /// No description provided for @errorValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get errorValidEmail;

  /// No description provided for @errorEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get errorEnterPassword;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordLength;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as: {email}'**
  String loggedInAs(Object email);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// No description provided for @errorWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get errorWrongCredentials;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @adminInterface.
  ///
  /// In en, this message translates to:
  /// **'Administrators Interface'**
  String get adminInterface;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @numberofinstitution.
  ///
  /// In en, this message translates to:
  /// **'Number of institution'**
  String get numberofinstitution;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'No data Was found'**
  String get errorNotFound;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @facebookLinkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Facebook link not available'**
  String get facebookLinkNotAvailable;

  /// No description provided for @instagramLinkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Instagram link not available'**
  String get instagramLinkNotAvailable;

  /// No description provided for @twitterLinkNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'TikTok link not available'**
  String get twitterLinkNotAvailable;

  /// No description provided for @contribute.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contribute;

  /// No description provided for @contributeTitle.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get contributeTitle;

  /// No description provided for @contributeDescription.
  ///
  /// In en, this message translates to:
  /// **'Our app can only grow with the contribution of youth hostels across the country. To help us and add your own establishment, please email the following details to the email address below.'**
  String get contributeDescription;

  /// No description provided for @contributeDetails.
  ///
  /// In en, this message translates to:
  /// **'Details needed: Establishment name, Google Maps location, contact info, and social media links.'**
  String get contributeDetails;

  /// No description provided for @contributeEmail.
  ///
  /// In en, this message translates to:
  /// **'zakariamedjdoub.dev@gmail.com'**
  String get contributeEmail;

  /// No description provided for @contributeButton.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get contributeButton;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @jawalAssociation.
  ///
  /// In en, this message translates to:
  /// **'Jawal Association for youth activities'**
  String get jawalAssociation;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
