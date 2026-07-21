import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Ho ho ho! Who are you?'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get loginButton;

  /// No description provided for @registerLinkText.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get registerLinkText;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerLink;

  /// No description provided for @errorEmptyEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get errorEmptyEmail;

  /// No description provided for @errorShortPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorShortPassword;

  /// No description provided for @welcomeImageText.
  ///
  /// In en, this message translates to:
  /// **'Merry Christmas!'**
  String get welcomeImageText;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get continueWith;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @cardTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get cardTitle;

  /// No description provided for @cardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Christmas is coming, let\'s get you logged in.'**
  String get cardSubtitle;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully logged in!'**
  String get loginSuccess;

  /// No description provided for @registerAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAppBarTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a Secret Santa'**
  String get registerTitle;

  /// No description provided for @registerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Join the fun and start exchanging gifts today!'**
  String get registerSubTitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @termsAndConditionsLabel.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get termsAndConditionsLabel;

  /// No description provided for @termsAndConditionsLink.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditionsLink;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get registerButton;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please log in.'**
  String get registerSuccess;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatchError;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @activeExchanges.
  ///
  /// In en, this message translates to:
  /// **'Active\nExchanges'**
  String get activeExchanges;

  /// No description provided for @noActiveExchanges.
  ///
  /// In en, this message translates to:
  /// **'You have no active exchanges.'**
  String get noActiveExchanges;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @nextDrawingIn.
  ///
  /// In en, this message translates to:
  /// **'Next Drawing In'**
  String get nextDrawingIn;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @allGroup.
  ///
  /// In en, this message translates to:
  /// **'All Groups'**
  String get allGroup;

  /// No description provided for @drawingSoon.
  ///
  /// In en, this message translates to:
  /// **'Drawing Soon'**
  String get drawingSoon;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @rdyToStartRecruting.
  ///
  /// In en, this message translates to:
  /// **'Ready to start recruting elevs'**
  String get rdyToStartRecruting;

  /// No description provided for @elvesRecruting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for organizer'**
  String get elvesRecruting;

  /// No description provided for @drawingComplete.
  ///
  /// In en, this message translates to:
  /// **'Drawing completed check your person'**
  String get drawingComplete;

  /// No description provided for @elvesAreHelpingSanta.
  ///
  /// In en, this message translates to:
  /// **'Elves are helping santa'**
  String get elvesAreHelpingSanta;

  /// No description provided for @evryoneGotAPresents.
  ///
  /// In en, this message translates to:
  /// **'Everyone got a presents'**
  String get evryoneGotAPresents;

  /// No description provided for @participantsJoined.
  ///
  /// In en, this message translates to:
  /// **'Elevs Joined'**
  String get participantsJoined;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit Group'**
  String get editGroup;

  /// No description provided for @viewMatch.
  ///
  /// In en, this message translates to:
  /// **'View Match'**
  String get viewMatch;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Secret Santa Groups'**
  String get homeTitle;

  /// No description provided for @drawingIn.
  ///
  /// In en, this message translates to:
  /// **'Next drawing in'**
  String get drawingIn;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get createNewGroup;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started!'**
  String get letsGetStarted;

  /// No description provided for @hostOrJoin.
  ///
  /// In en, this message translates to:
  /// **'Host a new exchange or join the fun with your friends!'**
  String get hostOrJoin;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @createNewGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a new Secret  Santa exchange. Invite friends, set rules, and draw names.'**
  String get createNewGroupDescription;

  /// No description provided for @joinExistingGroup.
  ///
  /// In en, this message translates to:
  /// **'Join Existing Group'**
  String get joinExistingGroup;

  /// No description provided for @joinExistingGroupDescription.
  ///
  /// In en, this message translates to:
  /// **'Got an invite code? Enter it here to join your firends\' gift exchange.'**
  String get joinExistingGroupDescription;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get enterCode;

  /// No description provided for @groupNameField.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameField;

  /// No description provided for @groupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g North Pole Party'**
  String get groupNameHint;

  /// No description provided for @budgetText.
  ///
  /// In en, this message translates to:
  /// **'Budget Limit'**
  String get budgetText;

  /// No description provided for @whoIsInvited.
  ///
  /// In en, this message translates to:
  /// **'Who is invited?'**
  String get whoIsInvited;

  /// No description provided for @addFirendsManually.
  ///
  /// In en, this message translates to:
  /// **'Add Friends Manually'**
  String get addFirendsManually;

  /// No description provided for @inputNameAndEmail.
  ///
  /// In en, this message translates to:
  /// **'Input email, copy link or invite code'**
  String get inputNameAndEmail;

  /// No description provided for @selectFromFriends.
  ///
  /// In en, this message translates to:
  /// **'Select from Friends'**
  String get selectFromFriends;

  /// No description provided for @quickAddFromContacts.
  ///
  /// In en, this message translates to:
  /// **'Quick Add from contact list'**
  String get quickAddFromContacts;

  /// No description provided for @importFromPast.
  ///
  /// In en, this message translates to:
  /// **'Import from Past'**
  String get importFromPast;

  /// No description provided for @reuseAPreviousGroupList.
  ///
  /// In en, this message translates to:
  /// **'Reuse a previous group list'**
  String get reuseAPreviousGroupList;

  /// No description provided for @yourElfSquadIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your elf squad is empty'**
  String get yourElfSquadIsEmpty;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @manuallyInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite by Email'**
  String get manuallyInviteTitle;

  /// No description provided for @manuallyInviteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add firends one by one to your group by writing email below'**
  String get manuallyInviteSubtitle;

  /// No description provided for @emailFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailFieldLabel;

  /// No description provided for @emailFieldHint.
  ///
  /// In en, this message translates to:
  /// **'example@example.com'**
  String get emailFieldHint;

  /// No description provided for @inviteButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get inviteButton;

  /// No description provided for @setDateAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Drawing Date'**
  String get setDateAppBarTitle;

  /// No description provided for @setDateTitle.
  ///
  /// In en, this message translates to:
  /// **'When is the big day?'**
  String get setDateTitle;

  /// No description provided for @setDateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a date for your Secret Santa party. We\'ll make sure everyone gets their match in time!'**
  String get setDateSubtitle;

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected Date'**
  String get selectedDate;

  /// No description provided for @groupNameCard.
  ///
  /// In en, this message translates to:
  /// **'Group Name'**
  String get groupNameCard;

  /// No description provided for @budgetCard.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetCard;

  /// No description provided for @dateCard.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateCard;

  /// No description provided for @membersCard.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersCard;

  /// No description provided for @reviewGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Group'**
  String get reviewGroupTitle;

  /// No description provided for @participantsReview.
  ///
  /// In en, this message translates to:
  /// **'Participants Review'**
  String get participantsReview;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add more'**
  String get addMore;

  /// No description provided for @editListOrder.
  ///
  /// In en, this message translates to:
  /// **'Edit List Order'**
  String get editListOrder;

  /// No description provided for @readyToDrawNames.
  ///
  /// In en, this message translates to:
  /// **'READY TO DRAW NAMES?'**
  String get readyToDrawNames;

  /// No description provided for @confirmGroupCreation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Group Creation'**
  String get confirmGroupCreation;

  /// No description provided for @addFriendsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Friends'**
  String get addFriendsAppBarTitle;

  /// No description provided for @inviteToYourGroup.
  ///
  /// In en, this message translates to:
  /// **'Invite to your group'**
  String get inviteToYourGroup;

  /// No description provided for @chooseInviteMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to invite your friends.'**
  String get chooseInviteMethod;

  /// No description provided for @codeTab.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeTab;

  /// No description provided for @linkTab.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkTab;

  /// No description provided for @emailTab.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTab;

  /// No description provided for @groupCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Group Code'**
  String get groupCodeLabel;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code Copied!'**
  String get codeCopied;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @codeInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Share this code with your friends. They can enter it when joining a group.'**
  String get codeInfoBanner;

  /// No description provided for @inviteLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Link'**
  String get inviteLinkLabel;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @linkInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this link can join your group directly — no code required.'**
  String get linkInfoBanner;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressLabel;

  /// No description provided for @emailAddressHint.
  ///
  /// In en, this message translates to:
  /// **'friend@example.com'**
  String get emailAddressHint;

  /// No description provided for @errorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get errorEnterEmail;

  /// No description provided for @errorAlreadySentEmail.
  ///
  /// In en, this message translates to:
  /// **'Invite already sent to this email'**
  String get errorAlreadySentEmail;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite Sent!'**
  String get inviteSent;

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send Invite'**
  String get sendInvite;

  /// No description provided for @pendingInvites.
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvites;

  /// No description provided for @invitePending.
  ///
  /// In en, this message translates to:
  /// **'Invite pending'**
  String get invitePending;

  /// No description provided for @removeInviteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove invite'**
  String get removeInviteTooltip;

  /// No description provided for @emailInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Your friends will receive an email with a direct link to join your group.'**
  String get emailInfoBanner;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @exchangeDate.
  ///
  /// In en, this message translates to:
  /// **'Exchange Date'**
  String get exchangeDate;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @elevs.
  ///
  /// In en, this message translates to:
  /// **'Elevs'**
  String get elevs;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @manageParticipantAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Participant'**
  String get manageParticipantAppBarTitle;

  /// No description provided for @manageParticipantSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get manageParticipantSaveChanges;

  /// No description provided for @manageParticipantAdminBadge.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get manageParticipantAdminBadge;

  /// No description provided for @exludionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Exclusion Section'**
  String get exludionSectionTitle;

  /// No description provided for @exludionSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cannot give a gift to someone who gave you a gift.'**
  String get exludionSectionSubtitle;

  /// No description provided for @noExlusionsAdded.
  ///
  /// In en, this message translates to:
  /// **'No exclusions added'**
  String get noExlusionsAdded;

  /// No description provided for @addExlusionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add someone who CANNOT receive a gift from you'**
  String get addExlusionSubtitle;

  /// No description provided for @exclusions.
  ///
  /// In en, this message translates to:
  /// **'Exclusions'**
  String get exclusions;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @dangerZoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Changes are irreversible. Act with caution.'**
  String get dangerZoneSubtitle;

  /// No description provided for @dangerZoneRemoveParticipant.
  ///
  /// In en, this message translates to:
  /// **'Remove Participant'**
  String get dangerZoneRemoveParticipant;

  /// No description provided for @exclude.
  ///
  /// In en, this message translates to:
  /// **'Exclude'**
  String get exclude;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @excludedSummary.
  ///
  /// In en, this message translates to:
  /// **'participants are excluded. This participant cannot receive their gift.'**
  String get excludedSummary;

  /// No description provided for @noMoreParticipants.
  ///
  /// In en, this message translates to:
  /// **'No more participants in group.'**
  String get noMoreParticipants;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @fromGroup.
  ///
  /// In en, this message translates to:
  /// **'from group'**
  String get fromGroup;

  /// No description provided for @cantRemoveAdmin.
  ///
  /// In en, this message translates to:
  /// **'You cannot remove admin'**
  String get cantRemoveAdmin;

  /// No description provided for @removePatricipant.
  ///
  /// In en, this message translates to:
  /// **'Remove participant'**
  String get removePatricipant;

  /// No description provided for @sureDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get sureDelete;

  /// No description provided for @sureDeleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'from the group? This action is irreversible and will remove all assigned exclusions'**
  String get sureDeleteSubtitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @groupDetailsAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Group Details'**
  String get groupDetailsAppBarTitle;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @declined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get declined;

  /// No description provided for @startDrawing.
  ///
  /// In en, this message translates to:
  /// **'Start Drawing'**
  String get startDrawing;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCodeLabel;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @noParticipants.
  ///
  /// In en, this message translates to:
  /// **'No participants'**
  String get noParticipants;

  /// No description provided for @addParticipantsToStart.
  ///
  /// In en, this message translates to:
  /// **'Add participants to start drawing'**
  String get addParticipantsToStart;

  /// No description provided for @drawnPairsTitle.
  ///
  /// In en, this message translates to:
  /// **'Drawn Pairs'**
  String get drawnPairsTitle;

  /// No description provided for @profileNavigationMock.
  ///
  /// In en, this message translates to:
  /// **'Profile: {name}'**
  String profileNavigationMock(String name);

  /// No description provided for @failedToDrawPairs.
  ///
  /// In en, this message translates to:
  /// **'Failed to draw pairs'**
  String get failedToDrawPairs;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @drawAgain.
  ///
  /// In en, this message translates to:
  /// **'Draw again'**
  String get drawAgain;

  /// No description provided for @confirmedCheck.
  ///
  /// In en, this message translates to:
  /// **'Confirmed ✓'**
  String get confirmedCheck;

  /// No description provided for @confirmDrawing.
  ///
  /// In en, this message translates to:
  /// **'Confirm drawing'**
  String get confirmDrawing;

  /// No description provided for @evenParticipantsRequired.
  ///
  /// In en, this message translates to:
  /// **'Group must have an even number of participants. Add more or add a special role for one participant to make an additional pair.'**
  String get evenParticipantsRequired;

  /// No description provided for @atLeastTwoParticipants.
  ///
  /// In en, this message translates to:
  /// **'Group must have at least 2 participants'**
  String get atLeastTwoParticipants;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @invitedParticipantsWillBeRemoved.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to continue? Invited participants will be removed from the group and will not be able to accept the invitation.'**
  String get invitedParticipantsWillBeRemoved;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @excludedCountOf.
  ///
  /// In en, this message translates to:
  /// **'{excluded} of {total}'**
  String excludedCountOf(int excluded, int total);

  /// No description provided for @groupDrawnSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupDrawnSuccessfully;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @secretSantaGroup.
  ///
  /// In en, this message translates to:
  /// **'Secret Santa Group'**
  String get secretSantaGroup;

  /// No description provided for @enterNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter name'**
  String get enterNameHint;

  /// No description provided for @membersCountText.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Elf} other{{count} Elves}}'**
  String membersCountText(num count);

  /// No description provided for @savingMatches.
  ///
  /// In en, this message translates to:
  /// **'Saving matches...'**
  String get savingMatches;

  /// No description provided for @giversColumnHeader.
  ///
  /// In en, this message translates to:
  /// **'Givers'**
  String get giversColumnHeader;

  /// No description provided for @receiversColumnHeader.
  ///
  /// In en, this message translates to:
  /// **'Receivers'**
  String get receiversColumnHeader;

  /// No description provided for @drawnPairsAdminTitle.
  ///
  /// In en, this message translates to:
  /// **'Drawn Pairs'**
  String get drawnPairsAdminTitle;

  /// No description provided for @waitingForDraw.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the organizer to start the draw'**
  String get waitingForDraw;

  /// No description provided for @waitingForDrawSub.
  ///
  /// In en, this message translates to:
  /// **'The big reveal is coming soon! 🎄'**
  String get waitingForDrawSub;

  /// No description provided for @yourSecretRecipient.
  ///
  /// In en, this message translates to:
  /// **'Your Secret Recipient'**
  String get yourSecretRecipient;

  /// No description provided for @sendAnonymousMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Anonymous Message'**
  String get sendAnonymousMessage;

  /// No description provided for @sendAnonymousMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message...'**
  String get sendAnonymousMessageHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @messageSentMock.
  ///
  /// In en, this message translates to:
  /// **'Message sent anonymously! 🎅'**
  String get messageSentMock;

  /// No description provided for @myWishlistForGroup.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist for This Group'**
  String get myWishlistForGroup;

  /// No description provided for @allParticipants.
  ///
  /// In en, this message translates to:
  /// **'All Participants'**
  String get allParticipants;

  /// No description provided for @hoHoHo.
  ///
  /// In en, this message translates to:
  /// **'Ho Ho Ho!'**
  String get hoHoHo;

  /// No description provided for @youAreSecretSantaFor.
  ///
  /// In en, this message translates to:
  /// **'You are the Secret Santa for'**
  String get youAreSecretSantaFor;

  /// No description provided for @viewTheirWishlist.
  ///
  /// In en, this message translates to:
  /// **'View Their Wishlist'**
  String get viewTheirWishlist;

  /// No description provided for @makeSureToGetSomethingNice.
  ///
  /// In en, this message translates to:
  /// **'Make sure to get something nice before Dec 25th!'**
  String get makeSureToGetSomethingNice;

  /// No description provided for @wishlistSuffix.
  ///
  /// In en, this message translates to:
  /// **'\'s Wishlist'**
  String get wishlistSuffix;

  /// No description provided for @youAreTheirSecretSanta.
  ///
  /// In en, this message translates to:
  /// **'You are their Secret Santa! 🤫'**
  String get youAreTheirSecretSanta;

  /// No description provided for @budgetPrefix.
  ///
  /// In en, this message translates to:
  /// **'Budget:'**
  String get budgetPrefix;

  /// No description provided for @topPicks.
  ///
  /// In en, this message translates to:
  /// **'Top Picks'**
  String get topPicks;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ITEMS'**
  String itemsCount(num count);

  /// No description provided for @viewOnline.
  ///
  /// In en, this message translates to:
  /// **'View Online'**
  String get viewOnline;

  /// No description provided for @highPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// No description provided for @preferred.
  ///
  /// In en, this message translates to:
  /// **'preferred'**
  String get preferred;

  /// No description provided for @secretSantaUpper.
  ///
  /// In en, this message translates to:
  /// **'SECRET SANTA'**
  String get secretSantaUpper;

  /// No description provided for @doneUpper.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get doneUpper;

  /// No description provided for @meSuffix.
  ///
  /// In en, this message translates to:
  /// **'(me)'**
  String get meSuffix;

  /// No description provided for @mockItemMugTitle.
  ///
  /// In en, this message translates to:
  /// **'Ceramic Travel Mug'**
  String get mockItemMugTitle;

  /// No description provided for @mockItemMugDesc.
  ///
  /// In en, this message translates to:
  /// **'Blue glaze preferred'**
  String get mockItemMugDesc;

  /// No description provided for @mockItemBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Sci-Fi Novel'**
  String get mockItemBookTitle;

  /// No description provided for @mockItemYarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Wool Knitting Yarn'**
  String get mockItemYarnTitle;

  /// No description provided for @mockItemYarnDesc.
  ///
  /// In en, this message translates to:
  /// **'Any shade of red'**
  String get mockItemYarnDesc;

  /// No description provided for @groupHubMyWishlistBtn.
  ///
  /// In en, this message translates to:
  /// **'My Wishes'**
  String get groupHubMyWishlistBtn;

  /// No description provided for @groupHubMyLotBtn.
  ///
  /// In en, this message translates to:
  /// **'My Secret Recipient'**
  String get groupHubMyLotBtn;

  /// No description provided for @groupHubDrawNotReady.
  ///
  /// In en, this message translates to:
  /// **'Draw hasn\'t happened yet'**
  String get groupHubDrawNotReady;

  /// No description provided for @groupHubDrawNotReadySub.
  ///
  /// In en, this message translates to:
  /// **'Come back once the organizer starts the draw!'**
  String get groupHubDrawNotReadySub;

  /// No description provided for @groupHubGroupInfo.
  ///
  /// In en, this message translates to:
  /// **'Group Info'**
  String get groupHubGroupInfo;

  /// No description provided for @myWishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'My Wishes'**
  String get myWishlistTitle;

  /// No description provided for @myWishlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add items you\'d love to receive'**
  String get myWishlistSubtitle;

  /// No description provided for @myWishlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'No wishes yet'**
  String get myWishlistEmpty;

  /// No description provided for @myWishlistEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to add your first wish!'**
  String get myWishlistEmptySub;

  /// No description provided for @addWish.
  ///
  /// In en, this message translates to:
  /// **'Add a Wish'**
  String get addWish;

  /// No description provided for @editWish.
  ///
  /// In en, this message translates to:
  /// **'Edit Wish'**
  String get editWish;

  /// No description provided for @wishTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get wishTitleLabel;

  /// No description provided for @wishTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Coffee Mug, Book, Game...'**
  String get wishTitleHint;

  /// No description provided for @wishPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (optional)'**
  String get wishPriceLabel;

  /// No description provided for @wishPriceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 25.00'**
  String get wishPriceHint;

  /// No description provided for @wishLinkLabel.
  ///
  /// In en, this message translates to:
  /// **'Link to product (optional)'**
  String get wishLinkLabel;

  /// No description provided for @wishLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://...'**
  String get wishLinkHint;

  /// No description provided for @wishNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get wishNoteLabel;

  /// No description provided for @wishNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Colour, size, edition...'**
  String get wishNoteHint;

  /// No description provided for @wishImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image URL (optional)'**
  String get wishImageLabel;

  /// No description provided for @wishImageHint.
  ///
  /// In en, this message translates to:
  /// **'https://... (direct image link)'**
  String get wishImageHint;

  /// No description provided for @wishHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get wishHighPriority;

  /// No description provided for @wishSave.
  ///
  /// In en, this message translates to:
  /// **'Save wish'**
  String get wishSave;

  /// No description provided for @wishDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get wishDelete;

  /// No description provided for @wishDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove this wish?'**
  String get wishDeleteConfirm;

  /// No description provided for @wishDeleteConfirmSub.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get wishDeleteConfirmSub;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get confirmDelete;

  /// No description provided for @wishAddedSnack.
  ///
  /// In en, this message translates to:
  /// **'Wish added! 🎁'**
  String get wishAddedSnack;

  /// No description provided for @wishRemovedSnack.
  ///
  /// In en, this message translates to:
  /// **'Wish removed'**
  String get wishRemovedSnack;

  /// No description provided for @revealAlreadySeen.
  ///
  /// In en, this message translates to:
  /// **'You already know your recipient. Tap to see their wishlist.'**
  String get revealAlreadySeen;

  /// No description provided for @seeRecipientWishlist.
  ///
  /// In en, this message translates to:
  /// **'See their wishlist'**
  String get seeRecipientWishlist;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from gallery'**
  String get pickFromGallery;

  /// No description provided for @uploadingImage.
  ///
  /// In en, this message translates to:
  /// **'Uploading image...'**
  String get uploadingImage;

  /// No description provided for @imageUploaded.
  ///
  /// In en, this message translates to:
  /// **'Image uploaded!'**
  String get imageUploaded;

  /// No description provided for @wishTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Item name is required'**
  String get wishTitleRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
