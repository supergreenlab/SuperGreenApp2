// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(count) => "${Intl.plural(count, one: '${count} like', other: '${count} likes')}";

  static m1(nickname) => "Add a comment as ${nickname}...";

  static m2(n) => "(+${n} other)";

  static m3(comment) => "Comment was: \"${comment}\"";

  static m4(name) => "Plant ${name} is now public";

  static m5(title) => "Resume previous ${title} card draft?";

  static m6(basedOn) => "From: ${basedOn}";

  static m7(phase) => "Phase: ${phase}";

  static m8(name) => "Update ${name}?";

  static m9(progress) => "Syncing - ${progress}";

  static m10(leds) => "Led channels: ${leds}";

  static m11(number) => "Box #${number}";

  static m12(index, name) => "Reset box #${index} on controller ${name}?";

  static m13(name) => "Delete controller ${name}?";

  static m14(name) => "Controller ${name} updated!";

  static m15(name) => "Controller ${name} refreshed!";

  static m16(time) => "(100% power for ${time} s)";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "cancel" : MessageLookupByLibrary.simpleMessage("CANCEL"),
    "commentsFormPageCommentLikeCount" : m0,
    "commentsFormPageCommentTypeTitle" : MessageLookupByLibrary.simpleMessage("What kind of post do you want to do?"),
    "commentsFormPageInputHintText" : m1,
    "commentsFormPageLoadingMoreComments" : MessageLookupByLibrary.simpleMessage("Loading more comments.."),
    "commentsFormPageNOtherRecommendations" : m2,
    "commentsFormPagePleaseLogin" : MessageLookupByLibrary.simpleMessage("Please login to add a comment"),
    "commentsFormPageReplyButton" : MessageLookupByLibrary.simpleMessage("Reply"),
    "commentsFormPageReplyingTo" : MessageLookupByLibrary.simpleMessage("Replying to "),
    "commentsFormPageReportButton" : MessageLookupByLibrary.simpleMessage("Report"),
    "commentsFormPageReportDialogBody" : m3,
    "commentsFormPageReportDialogTitle" : MessageLookupByLibrary.simpleMessage("Report this comment?"),
    "commentsFormPageSendingCommentLoading" : MessageLookupByLibrary.simpleMessage("Sending comment.."),
    "commentsFormPageSubmitComment" : MessageLookupByLibrary.simpleMessage("Post"),
    "commentsFormPageTitle" : MessageLookupByLibrary.simpleMessage("Comments"),
    "commentsFormPageViewAllComments" : MessageLookupByLibrary.simpleMessage("View all comments"),
    "commentsFormPageViewingSingleComment" : MessageLookupByLibrary.simpleMessage("Viewing single comment"),
    "confirmUnRevertableChange" : MessageLookupByLibrary.simpleMessage("This can\'t be reverted. Continue?"),
    "done" : MessageLookupByLibrary.simpleMessage("Done!"),
    "explorerPagePleaseLoginDialogBody" : MessageLookupByLibrary.simpleMessage("You need to be logged in to make a plant public."),
    "explorerPagePleaseLoginDialogTitle" : MessageLookupByLibrary.simpleMessage("Make a plant public"),
    "explorerPagePublicPlantConfirmation" : m4,
    "explorerPageSelectPlantTitle" : MessageLookupByLibrary.simpleMessage("Select which plant you want to make public"),
    "explorerPageTitle" : MessageLookupByLibrary.simpleMessage("Explorer"),
    "feedCareCommonAfterPics" : MessageLookupByLibrary.simpleMessage("After pics"),
    "feedCareCommonBeforePics" : MessageLookupByLibrary.simpleMessage("Before pics"),
    "feedCareCommonDeletePicDialogBody" : MessageLookupByLibrary.simpleMessage("This can\'t be reverted. Continue?"),
    "feedCareCommonDeletePicDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete this pic?"),
    "feedCareCommonDraftRecoveryDialogBody" : m5,
    "feedCareCommonDraftRecoveryDialogTitle" : MessageLookupByLibrary.simpleMessage("Draft recovery"),
    "feedCareCommonFormSaving" : MessageLookupByLibrary.simpleMessage("Saving.."),
    "feedCareCommonObservations" : MessageLookupByLibrary.simpleMessage("Observations"),
    "feedLightCardPageChannel" : MessageLookupByLibrary.simpleMessage("channel"),
    "feedLightFormPageCancelling" : MessageLookupByLibrary.simpleMessage("Cancelling.."),
    "feedLightFormPageControllerRequired" : MessageLookupByLibrary.simpleMessage("Dimming control\nrequires an SGL controller"),
    "feedLightFormPageDIYNow" : MessageLookupByLibrary.simpleMessage("DIY NOW"),
    "feedLightFormPageOr" : MessageLookupByLibrary.simpleMessage("or"),
    "feedLightFormPageSaving" : MessageLookupByLibrary.simpleMessage("Saving.."),
    "feedLightFormPageShopNow" : MessageLookupByLibrary.simpleMessage("SHOP NOW"),
    "feedMeasureFormPageDeletePicDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete this pic?"),
    "feedMeasureFormPageObservations" : MessageLookupByLibrary.simpleMessage("Observations"),
    "feedMeasureFormPagePreviousMeasure" : MessageLookupByLibrary.simpleMessage("Previous measures"),
    "feedMeasureFormPageTodayMeasure" : MessageLookupByLibrary.simpleMessage("Today\'s measure"),
    "feedMeasureFormPageUnselectMeasureDialogTitle" : MessageLookupByLibrary.simpleMessage("Unselect this measure?"),
    "feedMediaFormPageAttachedMedia" : MessageLookupByLibrary.simpleMessage("Attached media"),
    "feedMediaFormPageDeletePicDialogTitle" : MessageLookupByLibrary.simpleMessage("Delete this pic?"),
    "feedMediaFormPageDraftRecoveryDialogBody" : MessageLookupByLibrary.simpleMessage("Resume previous grow log?"),
    "feedMediaFormPageDraftRecoveryDialogTitle" : MessageLookupByLibrary.simpleMessage("Draft recovery"),
    "feedMediaFormPageHelpRequest" : MessageLookupByLibrary.simpleMessage("Help request?"),
    "feedMediaFormPageObservations" : MessageLookupByLibrary.simpleMessage("Observations"),
    "feedNutrientMixCardFrom" : m6,
    "feedNutrientMixCardObservations" : MessageLookupByLibrary.simpleMessage("Observations"),
    "feedNutrientMixCardPhase" : m7,
    "feedNutrientMixCardTitle" : MessageLookupByLibrary.simpleMessage("Nutrient mix"),
    "feedNutrientMixCardWaterQuantity" : MessageLookupByLibrary.simpleMessage("Water quantity"),
    "feedNutrientMixFormPageEndMixMetricsSectionTitle" : MessageLookupByLibrary.simpleMessage("End mix metrics"),
    "feedNutrientMixFormPageLiquid" : MessageLookupByLibrary.simpleMessage("Liquid"),
    "feedNutrientMixFormPageMetricsObservations" : MessageLookupByLibrary.simpleMessage("Metrics & Observations"),
    "feedNutrientMixFormPageMixPhaseInstruction" : MessageLookupByLibrary.simpleMessage("Set the right phase for this nutrient mix for better categorization."),
    "feedNutrientMixFormPageMixPhaseSectionTitle" : MessageLookupByLibrary.simpleMessage("Mix phase"),
    "feedNutrientMixFormPageNameHint" : MessageLookupByLibrary.simpleMessage("Ex: Veg-1"),
    "feedNutrientMixFormPageNameLabel" : MessageLookupByLibrary.simpleMessage("Mix name"),
    "feedNutrientMixFormPageNoToolsYet" : MessageLookupByLibrary.simpleMessage("No nutrients in your toolbox yet.\nPress the + button up here."),
    "feedNutrientMixFormPageNutrientInYourMixPart1" : MessageLookupByLibrary.simpleMessage("Nutrients in your "),
    "feedNutrientMixFormPageNutrientInYourMixPart2" : MessageLookupByLibrary.simpleMessage("mix"),
    "feedNutrientMixFormPageObservations" : MessageLookupByLibrary.simpleMessage("Observations"),
    "feedNutrientMixFormPageReuseValuesSectionTitle" : MessageLookupByLibrary.simpleMessage("Reuse previous mix values?"),
    "feedNutrientMixFormPageSaveMix" : MessageLookupByLibrary.simpleMessage("Save this nutrient mix"),
    "feedNutrientMixFormPageSaveMixInstructions" : MessageLookupByLibrary.simpleMessage("You can give this nutrient mix a name, for future reuse. (optional)"),
    "feedNutrientMixFormPageSaveMixSectionTitle" : MessageLookupByLibrary.simpleMessage("Save for future re-use?"),
    "feedNutrientMixFormPageSelectPlant" : MessageLookupByLibrary.simpleMessage("Which plant(s) will receive this mix?"),
    "feedNutrientMixFormPageSolid" : MessageLookupByLibrary.simpleMessage("Solid"),
    "feedNutrientMixFormPageUpdateExistingDialogBody" : MessageLookupByLibrary.simpleMessage("A nutrient mix with that name already exists, overwrite?"),
    "feedNutrientMixFormPageUpdateExistingDialogNo" : MessageLookupByLibrary.simpleMessage("NO, CHANGE NAME"),
    "feedNutrientMixFormPageUpdateExistingDialogTitle" : m8,
    "feedNutrientMixFormPageVolume" : MessageLookupByLibrary.simpleMessage("Water quantity"),
    "feedProductsCardPageTitle" : MessageLookupByLibrary.simpleMessage("Towelie\'s selection"),
    "feedProductsCardPageViewButton" : MessageLookupByLibrary.simpleMessage("View"),
    "formAllowAnalytics" : MessageLookupByLibrary.simpleMessage("**Help us** discern what\'s **useful** from what\'s **useless** by sharing **anonymous** usage data.\n*Note: no third party (ie google, facebook..) is involved in our data analytics strategy.*"),
    "formCGU" : MessageLookupByLibrary.simpleMessage("*By proceeding, **you explicitly agree** that you are acting in coordinance with local, state, and federal or national laws. **SuperGreenLab will not be liable** for\nconsequences surrounding the legality of how the app, lights or grow bundle are used. "),
    "instructionsAutoScheduleHelper" : MessageLookupByLibrary.simpleMessage("Auto flower plants are a special type of strain that **won’t require light schedule change** in order to start flowering. Their vegetative stage duration **can’t be controlled**, and varies from one plant to another."),
    "instructionsBloomScheduleHelper" : MessageLookupByLibrary.simpleMessage("**Bloom stage** is the phase where the plant develops its flowers. It requires **at most 12h lights per days**, usual setting is **12h** per day."),
    "instructionsBlowerTemperatureModeDescription" : MessageLookupByLibrary.simpleMessage("This is the **Temperature based blower control**, in this mode the blower is **in sync with the box temperature sensor**."),
    "instructionsBlowerTimerModeDescription" : MessageLookupByLibrary.simpleMessage("This is the **timer based blower control**, in this mode the blower is **in sync with the light timer**. Perfect if the box doesn\'t have a temperature sensor.\n\nEx: when the timer says 100% (which means all lights are on), it will set the blower power at the **blower day** value below."),
    "instructionsExistingDevice" : MessageLookupByLibrary.simpleMessage("Please make sure your **mobile phone** is **connected to your home wifi**.\nThen we\'ll search for it **by name** or **by IP**, please **fill** the following text field."),
    "instructionsExistingDeviceTitle" : MessageLookupByLibrary.simpleMessage("Enter controller name or IP"),
    "instructionsManualTimerModeDescription" : MessageLookupByLibrary.simpleMessage("This is the **manual blower control** mode, just set a value and the blower will stay at this power."),
    "instructionsNewDeviceWifiFailed" : MessageLookupByLibrary.simpleMessage("**Couldn\'t connect** to the 🤖🍁 wifi! Please go to your **mobile phone settings** to connect manually with the **following credentials**:"),
    "instructionsNewDeviceWifiFailed2" : MessageLookupByLibrary.simpleMessage("Then press the **DONE** button below"),
    "instructionsVegScheduleHelper" : MessageLookupByLibrary.simpleMessage("**Vegetative stage** is the phase between germination and blooming, the plant **grows and develops** it’s branches. It requires **at least 13h lights per days**, usual setting is **18h** per day."),
    "ledTestingChannelTitle" : MessageLookupByLibrary.simpleMessage("Light"),
    "ledTestingInstructions" : MessageLookupByLibrary.simpleMessage("Press a led channel\nto switch it on/off:"),
    "ledTestingPageTitle" : MessageLookupByLibrary.simpleMessage("NEW BOX SETUP"),
    "ledTestingValidate" : MessageLookupByLibrary.simpleMessage("OK, ALL GOOD"),
    "loading" : MessageLookupByLibrary.simpleMessage("Loading..."),
    "loginCreateAccount" : MessageLookupByLibrary.simpleMessage("LOGIN / CREATE ACCOUNT"),
    "loginRequiredDialogBody" : MessageLookupByLibrary.simpleMessage("Please log in or create an account."),
    "loginRequiredDialogTitle" : MessageLookupByLibrary.simpleMessage("Login required"),
    "mainNavigatorUnknownRoute" : MessageLookupByLibrary.simpleMessage("Unknown route"),
    "no" : MessageLookupByLibrary.simpleMessage("NO"),
    "notificationPurposes" : MessageLookupByLibrary.simpleMessage("You will get notified for:\n- **Likes** on comments and public diary entry\n- **Comments** on public diary entries\n- **Replies** to your comments\n- **Smart reminders** and **grow tips**\n- **Temperature** and **humidity** alerts"),
    "notificationRequestButton" : MessageLookupByLibrary.simpleMessage("NOTIFY ME"),
    "notificationRequestButtonCancel" : MessageLookupByLibrary.simpleMessage("NO THANKS"),
    "notificationRequestTitle" : MessageLookupByLibrary.simpleMessage("Would you like to activate notifications?"),
    "ok" : MessageLookupByLibrary.simpleMessage("OK"),
    "or" : MessageLookupByLibrary.simpleMessage("OR"),
    "redBarSyncingProgress" : m9,
    "saving" : MessageLookupByLibrary.simpleMessage("Saving..."),
    "selectBoxPageAddNewGreenLab" : MessageLookupByLibrary.simpleMessage("Add new green lab"),
    "selectBoxPageCreateFirst" : MessageLookupByLibrary.simpleMessage("Create your first"),
    "selectBoxPageCreateFirstLab" : MessageLookupByLibrary.simpleMessage("GREEN LAB"),
    "selectBoxPageCreateLabButton" : MessageLookupByLibrary.simpleMessage("CREATE"),
    "selectBoxPageNoLab" : MessageLookupByLibrary.simpleMessage("You have no lab yet"),
    "selectBoxPageTapSelect" : MessageLookupByLibrary.simpleMessage("Tap to select"),
    "selectDeviceAdd" : MessageLookupByLibrary.simpleMessage("ADD"),
    "selectDeviceAddFirst" : MessageLookupByLibrary.simpleMessage("Add a first"),
    "selectDeviceAddFirstController" : MessageLookupByLibrary.simpleMessage("CONTROLLER"),
    "selectDeviceBoxAlreadyRunning" : MessageLookupByLibrary.simpleMessage("Already running"),
    "selectDeviceBoxAvailable" : MessageLookupByLibrary.simpleMessage("Available"),
    "selectDeviceBoxLedChannelDescription" : m10,
    "selectDeviceBoxNoLedChannelAssigned" : MessageLookupByLibrary.simpleMessage("No led channels assigned"),
    "selectDeviceBoxNoMoreLED" : MessageLookupByLibrary.simpleMessage("No more free led channels"),
    "selectDeviceBoxNumber" : m11,
    "selectDeviceBoxResetDialogTitle" : m12,
    "selectDeviceBoxSettingUp" : MessageLookupByLibrary.simpleMessage("Setting up.."),
    "selectDeviceBoxSlot" : MessageLookupByLibrary.simpleMessage("Select controller\'s box slot"),
    "selectDeviceContinueWithoutController" : MessageLookupByLibrary.simpleMessage("Continue without controller"),
    "selectDeviceDIYNow" : MessageLookupByLibrary.simpleMessage("DIY NOW"),
    "selectDeviceDeleteControllerDialogBody" : MessageLookupByLibrary.simpleMessage("This can\'t be reverted. Continue?"),
    "selectDeviceDeleteControllerDialogTitle" : m13,
    "selectDeviceListItemInstruction" : MessageLookupByLibrary.simpleMessage("Tap to select"),
    "selectDeviceListTitle" : MessageLookupByLibrary.simpleMessage("Select a controller below"),
    "selectDeviceNewBoxAvailableLEDChannels" : MessageLookupByLibrary.simpleMessage("Available LED channels"),
    "selectDeviceNewBoxLEDChannel" : MessageLookupByLibrary.simpleMessage("LED chan"),
    "selectDeviceNewBoxNoMoreBox" : MessageLookupByLibrary.simpleMessage("Device can\'t handle\nmore box!"),
    "selectDeviceNewBoxSelectedLEDChannels" : MessageLookupByLibrary.simpleMessage("Selected LED channels"),
    "selectDeviceNewBoxSettingUp" : MessageLookupByLibrary.simpleMessage("Setting up.."),
    "selectDeviceNewBoxSetupBox" : MessageLookupByLibrary.simpleMessage("SETUP BOX"),
    "selectDeviceNewController" : MessageLookupByLibrary.simpleMessage("NEW CONTROLLER"),
    "selectDeviceNoController" : MessageLookupByLibrary.simpleMessage("You have no controller\nfor your new lab."),
    "selectDeviceOr" : MessageLookupByLibrary.simpleMessage("OR"),
    "selectDeviceShopNow" : MessageLookupByLibrary.simpleMessage("SHOP NOW"),
    "selectDeviceSkipAddDevice" : MessageLookupByLibrary.simpleMessage("NO SGL DEVICE"),
    "settingsDevicePageControllerDone" : m14,
    "settingsDevicePageControllerNameSection" : MessageLookupByLibrary.simpleMessage("Controller name"),
    "settingsDevicePageControllerRefreshed" : m15,
    "settingsDevicePageControllerSettingsSection" : MessageLookupByLibrary.simpleMessage("Settings"),
    "settingsDevicePageLoading" : MessageLookupByLibrary.simpleMessage("Refreshing.."),
    "settingsDevicePageWifiConfigFailed" : MessageLookupByLibrary.simpleMessage("Wifi config change failed"),
    "settingsDevicePageWifiConfigSuccess" : MessageLookupByLibrary.simpleMessage("Wifi config changed successfully"),
    "settingsDevicePageWifiSettingsLabel" : MessageLookupByLibrary.simpleMessage("Change your controller\'s wifi config"),
    "settingsDevicePageWifiSettingsSection" : MessageLookupByLibrary.simpleMessage("Wifi config"),
    "testLEDTiming" : m16,
    "testingLEDDone" : MessageLookupByLibrary.simpleMessage("Testing done"),
    "testingLEDTitle" : MessageLookupByLibrary.simpleMessage("Testing LED"),
    "title" : MessageLookupByLibrary.simpleMessage("SuperGreenLab"),
    "towelieButtonCreatePlant" : MessageLookupByLibrary.simpleMessage("GO!"),
    "towelieButtonEndChecklist" : MessageLookupByLibrary.simpleMessage("Create plant"),
    "towelieButtonGoToChecklist" : MessageLookupByLibrary.simpleMessage("Go to checklist"),
    "towelieButtonIDontNeedHelp" : MessageLookupByLibrary.simpleMessage("Nope already got it all."),
    "towelieButtonINeedHelp" : MessageLookupByLibrary.simpleMessage("Yes I want help!"),
    "towelieButtonShowGrowingMedium" : MessageLookupByLibrary.simpleMessage("Next"),
    "towelieButtonShowNutrients" : MessageLookupByLibrary.simpleMessage("Next"),
    "towelieButtonShowProductsBundle" : MessageLookupByLibrary.simpleMessage("Next"),
    "towelieButtonShowProductsSeeds" : MessageLookupByLibrary.simpleMessage("Next"),
    "towelieButtonSkipChecklist" : MessageLookupByLibrary.simpleMessage("Skip checklist"),
    "towelieButtonStartChecklist" : MessageLookupByLibrary.simpleMessage("Start"),
    "towelieButtonViewPlant" : MessageLookupByLibrary.simpleMessage("View plant"),
    "towelieCreatePlant" : MessageLookupByLibrary.simpleMessage("Alright we\'re ready to start your **first plant!**\n\nThe app works like this:\n- you **create a plant**\n- setup **your green lab**\n- control and monitor it with a **SuperGreenController** (optional)\n\nOnce this is done, you will have access to it\'s **feed**, it\'s like a timeline of the **plant\'s life**.\nWhenever you **water**, change **light power**, **train the plant**, or any other action,\nit will **log** it in the plant\'s feed, so you can **share it**, or **replay it** for your next grow!\n\nPress the **Create plant** button below.\n"),
    "towelieGrowboxProducts" : MessageLookupByLibrary.simpleMessage("**First step to unlimited weed: The Growbox!**\n\nChoosing your **growbox** to fit your **available space** is the foundation to your future harvests.\nYour **canopy surface** is one of the key factors determining **yield**.\nWe curated a list of the **community\'s growboxes** for you to choose from and be **successful**.\n"),
    "towelieHelperAddDevice" : MessageLookupByLibrary.simpleMessage("**Good**.\nNow this is when you should **plug the controller to it\'s power supply** if not already.\nThen you will choose one of the options above to **connect to the controller**."),
    "towelieHelperAddExistingDevice" : MessageLookupByLibrary.simpleMessage("Ok, so your controller is **already running** and **connected to your home wifi**, let\'s search for it over the network!\nEnter the **name you gave it last time** (default is **supergreencontroller**), if you can\'t remember it, you can also type its **IP address**.\nThe **IP address** can be easily found on your **router\'s home page**.\nTo **access your router\'s homepage**: take the **IP** address of your **mobile phone** or **laptop**, replace the last digit by **1** and **type that** in a browser."),
    "towelieHelperCreateLab" : MessageLookupByLibrary.simpleMessage("Now we\'re creating our **first Lab**!\nA lab is where you **simulate a tiny ecosystem**\nwith artificial **lights and ventilation**."),
    "towelieHelperCreatePlant" : MessageLookupByLibrary.simpleMessage("Hey man, **welcome to the plant creation process**, I\'ll be there to guide you through it.\nFirst step is to **give your new plant a name**."),
    "towelieHelperDeviceWifi" : MessageLookupByLibrary.simpleMessage("**While not mandatory**, connecting your controller to your home wifi has a few benefits:\n- receive software **upgrade** and bug fixes\n- remote **monitoring**\n- remote **control** (coming soon)"),
    "towelieHelperFormMeasure" : MessageLookupByLibrary.simpleMessage("This is the **measuring tool**, while not perfectly accurate, it will still give you a **good hint for your next grow**. And as a **bonus feature**, it does **timelapses** of all the measures you\'ve taken!"),
    "towelieHelperFormMeasure2" : MessageLookupByLibrary.simpleMessage("It\'s the **first time** you\'re using it, so there is no \"before\" picture **to compare to**. Take a pic of what you **want to measure**, and take a measure again in **a few days** to have a **difference**."),
    "towelieHelperFormMeasure3" : MessageLookupByLibrary.simpleMessage("Looks like you **already took a measure**, you can select it in the **\"Previous measures\"** section, then press the **\"Today\'s measure\"** button to add a new measure. The previous one will be **displayed as a transparent overlay** for more accuracy."),
    "towelieHelperFormTakePic" : MessageLookupByLibrary.simpleMessage("Welcome to the **take pic** page, this screen is to take picture of your plant **and note observations**. **You\'ll be glad you took regular pictures on your next grow!**"),
    "towelieHelperMeasureAfterStretch" : MessageLookupByLibrary.simpleMessage("**Hey**! it might be a good idea to **take a measure** of your plant to **monitor the stretch**."),
    "towelieHelperMeasureReminder" : MessageLookupByLibrary.simpleMessage("Do you want me to **set a reminder** so you don\'t forget to take a measure again soon?"),
    "towelieHelperSelectDevice" : MessageLookupByLibrary.simpleMessage("Alright, now that your plant has a name we can **start its configuration**:)\nIf you own a **SuperGreenLab bundle**, you need to tell the app **which controller will control the plant\'s lights, ventilation and sensors**.\nBecause it\'s all brand new, let\'s first **setup a new controller**.\nIf you don\'t own a bundle, you can skip this by pressing \"NO SGL DEVICE\"."),
    "towelieHelperSelectNewPlantDeviceBox" : MessageLookupByLibrary.simpleMessage("Ok, this is where we\'ll choose which of the **controller\'s LED channel** will be used to light up the plant.\nTo **better understand** you should have your LED panels **connected to the controller**."),
    "towelieHelperSelectPlantDeviceBox" : MessageLookupByLibrary.simpleMessage("Your controller can **manage up to 3 boxes**, select an **already configured** box above, or create a **new one**."),
    "towelieHelperTestDevice" : MessageLookupByLibrary.simpleMessage("This test is to make sure everything is working, **connect** your **LED** panels **to the controller** if not already."),
    "towelieHelperWaterReminder" : MessageLookupByLibrary.simpleMessage("Do you want me to **set a reminder** so you don\'t forget to water again soon?"),
    "toweliePlantCreated" : MessageLookupByLibrary.simpleMessage("Awesome, **you created your first plant**!\n\nYou can access your newly plant feed either by **pressing the home button below**, or the **View plant** button below.\n"),
    "toweliePlantGermination" : MessageLookupByLibrary.simpleMessage("Ok, place your seed in water, follow the guide, and press the \"germinated\" button below\nwhen you\'re ready to place the seed in its growing medium."),
    "toweliePlantPhase" : MessageLookupByLibrary.simpleMessage("Alright tell me at **which stage** the plant is at.\nIs it already **vegging** or still **just a seed**?"),
    "toweliePlantStartSeedling" : MessageLookupByLibrary.simpleMessage("Alright, let me know when you\'re **ready to put the seed to germinate** by pressing the **start** button below.\nIn the meantime you can also **create an account**:P that will enable backups, remote control, sharing, etc..."),
    "toweliePlantTutoTakePic" : MessageLookupByLibrary.simpleMessage("Alright **let\'s start**!\nOne first thing you can do to **start** this journey is to **take a picture** of your **plant**."),
    "toweliePlantType" : MessageLookupByLibrary.simpleMessage("To better guide you to a **successful harvest**, I\'ll need a bit **more informations** about your plant.\nIs this plant an **auto** or **photo** strain?"),
    "towelieProductsBundle" : MessageLookupByLibrary.simpleMessage("**Lighting & ventilation - ensures environment and odor control.**\n\nWith **6 full spectrum** LED grow lights providing **dense light** and **little heat**.\nThis **complete grow box bundle** lets you build a grow box out of almost anything.\n"),
    "towelieProductsGrowingMedium" : MessageLookupByLibrary.simpleMessage("**Your plants\' new favorite diet - simple and efficient**\n\nThe **trick** to growing in soil: water **only** when the top soil is dry **1 knuckle deep**\nand the pot feels light. Simple as that.\n"),
    "towelieProductsIntro" : MessageLookupByLibrary.simpleMessage("**Thanks for checking out our quick start checklist:)**\n\nThis is a **selection** of products **we** and the **community** like and got **good results** with.\n\nThe topics covered are:\n\n- Build a **growbox**\n- Add **light and ventilation**\n- Get some **seeds**\n- **Growing medium**\n- **Nutrients**\n"),
    "towelieProductsNutrients" : MessageLookupByLibrary.simpleMessage("**Keep it simple, stupid - use soil!**\n\nOne single product from seedling to harvest, mix it in every watering\nand enjoy **lush plant** that yield **top quality** nugs every single time!\n"),
    "towelieProductsSeeds" : MessageLookupByLibrary.simpleMessage("**#1 rule of cannabis growing; genetics matter!**\n\nWith the overwhelming number of **strains available** and new ones coming out regularly;\nit\'s essential that you pick something that **meets your needs**!\nThe **SuperGreenLab** community seebank list is here to help you find **the strain for you**.\n"),
    "towelieWelcomeApp" : MessageLookupByLibrary.simpleMessage("Welcome to SuperGreenLab\'s grow diary app!\n===\nHey man, **welcome here**, my name’s **Towelie**, I’m here to make sure you don’t forget anything about your plant!\n\nTo start off on a right foot, we made a **quick start checklist** of all the stuffs you\'ll need to **start growing**.\n\nDo you need a hand to start growing?\n"),
    "towelieWelcomePlant" : MessageLookupByLibrary.simpleMessage("**Welcome to your plant feed!**\nThis is where you can **keep a history** of your plant\'s life.\n\nEverytime you **water**, **train**, or even just **observe something** about your plant,\nyou can **add an item** to the feed.\n\nSo you can see the **evolution** of your plant, **repeat it** later, or **share it!**"),
    "unsavedChangeDialogBody" : MessageLookupByLibrary.simpleMessage("Changes will not be saved. Continue?"),
    "unsavedChangeDialogTitle" : MessageLookupByLibrary.simpleMessage("Unsaved changes"),
    "yes" : MessageLookupByLibrary.simpleMessage("YES")
  };
}
