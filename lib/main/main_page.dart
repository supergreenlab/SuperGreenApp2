/*
 * Copyright (C) 2018  SuperGreenLab <towelie@supergreenlab.com>
 * Author: Constantin Clauzel <constantin.clauzel@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:super_green_app/data/rel/rel_db.dart';
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/device_daemon/device_daemon_bloc.dart';
import 'package:super_green_app/device_daemon/device_reachable_listener_bloc.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
import 'package:super_green_app/notifications/notifications.dart';
import 'package:super_green_app/pages/add_device/device_pairing/device_pairing_bloc.dart';
import 'package:super_green_app/pages/add_device/device_pairing/device_pairing_page.dart';
import 'package:super_green_app/pages/add_plant/create_box/create_box_bloc.dart';
import 'package:super_green_app/pages/add_plant/create_box/create_box_page.dart';
import 'package:super_green_app/pages/add_plant/create_plant/create_plant_bloc.dart';
import 'package:super_green_app/pages/add_plant/create_plant/create_plant_page.dart';
import 'package:super_green_app/pages/add_plant/select_box/select_box_bloc.dart';
import 'package:super_green_app/pages/add_plant/select_box/select_box_page.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device/select_device_page.dart';
import 'package:super_green_app/pages/add_device/select_device_box/select_device_box_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device_new_box/select_device_new_box_bloc.dart';
import 'package:super_green_app/pages/add_device/select_device_box/select_device_box_page.dart';
import 'package:super_green_app/pages/add_device/select_device_new_box/select_device_new_box_page.dart';
import 'package:super_green_app/pages/add_device/add_device/add_device_bloc.dart';
import 'package:super_green_app/pages/add_device/add_device/add_device_page.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/device_name_page.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/device_setup_page.dart';
import 'package:super_green_app/pages/add_device/device_test/device_test_bloc.dart';
import 'package:super_green_app/pages/add_device/device_test/device_test_page.dart';
import 'package:super_green_app/pages/add_device/device_wifi/device_wifi_bloc.dart';
import 'package:super_green_app/pages/add_device/device_wifi/device_wifi_page.dart';
import 'package:super_green_app/pages/add_device/existing_device/existing_device_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/existing_device_page.dart';
import 'package:super_green_app/pages/add_device/new_device/new_device_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/new_device_page.dart';
import 'package:super_green_app/pages/app_init/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/app_init_page.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_bloc.dart';
import 'package:super_green_app/pages/bookmarks/bookmarks_page.dart';
import 'package:super_green_app/pages/explorer/follows/follows_feed_bloc.dart';
import 'package:super_green_app/pages/explorer/follows/follows_feed_page.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/common/comments/form/comments_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/form/feed_bending_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_bending/form/feed_bending_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/form/feed_defoliation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_defoliation/form/feed_defoliation_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/form/feed_fimming_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_fimming/form/feed_fimming_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/form/feed_topping_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_topping/form/feed_topping_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_transplant/form/feed_transplant_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_care/feed_transplant/form/feed_transplant_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_life_event/form/feed_life_event_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_life_event/form/feed_life_event_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/feed_light_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/feed_light_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_measure/form/feed_measure_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/feed_media_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/feed_media_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_nutrient_mix/form/feed_nutrient_mix_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_nutrient_mix/form/feed_nutrient_mix_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/feed_schedule_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/feed_schedule_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/feed_ventilation_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/feed_water_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/feed_water_form_page.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/remote/remote_box_feed_bloc.dart';
import 'package:super_green_app/pages/feeds/home/box_feeds/remote/remote_box_feed_page.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/public_plant_bloc.dart';
import 'package:super_green_app/pages/feeds/home/plant_feeds/remote/public_plant_page.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_bloc.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_page.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_page.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_bloc.dart';
import 'package:super_green_app/pages/home/home_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_page.dart';
import 'package:super_green_app/pages/image_capture/capture/capture_bloc.dart';
import 'package:super_green_app/pages/image_capture/capture/capture_page.dart';
import 'package:super_green_app/pages/image_capture/playback/playback_bloc.dart';
import 'package:super_green_app/pages/image_capture/playback/playback_page.dart';
import 'package:super_green_app/pages/notification/notification_request_bloc.dart';
import 'package:super_green_app/pages/notification/notification_request_page.dart';
import 'package:super_green_app/pages/plant_picker/plant_picker_bloc.dart';
import 'package:super_green_app/pages/plant_picker/plant_picker_page.dart';
import 'package:super_green_app/pages/products/product/product_category/product_category_bloc.dart';
import 'package:super_green_app/pages/products/product/product_category/product_category_page.dart';
import 'package:super_green_app/pages/products/product/product_infos/product_infos_bloc.dart';
import 'package:super_green_app/pages/products/product/product_infos/product_infos_page.dart';
import 'package:super_green_app/pages/products/product_supplier/product_supplier_bloc.dart';
import 'package:super_green_app/pages/products/product_supplier/product_supplier_page.dart';
import 'package:super_green_app/pages/products/search_new_product/select_new_product_bloc.dart';
import 'package:super_green_app/pages/products/search_new_product/select_new_product_page.dart';
import 'package:super_green_app/pages/select_plant/select_plant_bloc.dart';
import 'package:super_green_app/pages/select_plant/select_plant_page.dart';
import 'package:super_green_app/pages/settings/auth/create_account/settings_create_account_bloc.dart';
import 'package:super_green_app/pages/settings/auth/create_account/settings_create_account_page.dart';
import 'package:super_green_app/pages/settings/auth/login/settings_login_bloc.dart';
import 'package:super_green_app/pages/settings/auth/login/settings_login_page.dart';
import 'package:super_green_app/pages/settings/auth/settings_auth_bloc.dart';
import 'package:super_green_app/pages/settings/auth/settings_auth_page.dart';
import 'package:super_green_app/pages/settings/boxes/edit_config/settings_box_bloc.dart';
import 'package:super_green_app/pages/settings/boxes/edit_config/settings_box_page.dart';
import 'package:super_green_app/pages/settings/boxes/settings_boxes_bloc.dart';
import 'package:super_green_app/pages/settings/boxes/settings_boxes_page.dart';
import 'package:super_green_app/pages/settings/devices/auth/settings_device_auth_bloc.dart';
import 'package:super_green_app/pages/settings/devices/auth/settings_device_auth_page.dart';
import 'package:super_green_app/pages/settings/devices/auth_modal/auth_modal_bloc.dart';
import 'package:super_green_app/pages/settings/devices/auth_modal/auth_modal_page.dart';
import 'package:super_green_app/pages/settings/devices/edit_config/settings_device_bloc.dart';
import 'package:super_green_app/pages/settings/devices/edit_config/settings_device_page.dart';
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_bloc.dart';
import 'package:super_green_app/pages/settings/devices/remote_control/settings_remote_control_page.dart';
import 'package:super_green_app/pages/settings/devices/settings_devices_bloc.dart';
import 'package:super_green_app/pages/settings/devices/settings_devices_page.dart';
import 'package:super_green_app/pages/settings/devices/upgrade/settings_upgrade_device_bloc.dart';
import 'package:super_green_app/pages/settings/devices/upgrade/settings_upgrade_device_page.dart';
import 'package:super_green_app/pages/settings/plants/alerts/settings_plant_alerts_bloc.dart';
import 'package:super_green_app/pages/settings/plants/alerts/settings_plant_alerts_page.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_bloc.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_page.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_bloc.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_page.dart';
import 'package:super_green_app/pages/timelapse/timelapse_viewer/timelapse_viewer_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_viewer/timelapse_viewer_page.dart';
import 'package:super_green_app/pages/tip/tip_bloc.dart';
import 'package:super_green_app/pages/tip/tip_page.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/helpers/misc/towelie_action_help_notification.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_helper.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey();

//final RouteObserver<PageRoute> _analyticsObserver = AnalyticsObserver();

class MainPage extends StatefulWidget {
  static String redBarSyncingProgress(progress) {
    return Intl.message(
      'Syncing - $progress',
      args: [progress],
      name: 'redBarSyncingProgress',
      desc: 'Syncing progress indicator in top red bar, when fetching all new diary cards',
      locale: SGLLocalizations.current?.localeName,
      examples: const {'progress': 'medias 12/17'},
    );
  }

  static String get mainNavigatorUnknownRoute {
    return Intl.message(
      'Unknown route',
      name: 'mainNavigatorUnknownRoute',
      desc: 'Unknown route message (shouldnt appear)',
      locale: SGLLocalizations.current?.localeName,
    );
  }

  final GlobalKey<NavigatorState> _navigatorKey;

  MainPage(this._navigatorKey);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _showingNotificationRequest = false;
  bool _showingDeviceAuth = false;
  Queue<BuildContext> lastRouteContextsStack = Queue<BuildContext>();
  BuildContext? lastRouteContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: wrapListeners(
          MaterialApp(
            //navigatorObservers: [_analyticsObserver,],
            localizationsDelegates: [
              const SGLLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'),
              const Locale('es'),
              const Locale('fr'),
            ],
            navigatorKey: widget._navigatorKey,
            onGenerateTitle: (BuildContext context) => SGLLocalizations.of(context)!.title,
            onGenerateRoute: (settings) => CupertinoPageRoute(
                settings: settings,
                builder: (context) {
                  if (lastRouteContext != null) {
                    lastRouteContextsStack.addLast(lastRouteContext!);
                  }
                  lastRouteContext = context;
                  return wrapSyncIndicator(TowelieHelper.wrapWidget(
                      settings,
                      context,
                      _onGenerateRoute(context, settings, onPop: () {
                        lastRouteContext = lastRouteContextsStack.removeLast();
                      })));
                }),
            theme: ThemeData(
              fontFamily: 'Roboto',
            ),
            home: BlocProvider<AppInitBloc>(
              create: (context) => AppInitBloc(),
              child: AppInitPage(),
            ),
          ),
        ));
  }

  Widget wrapListeners(Widget body) {
    return BlocListener<NotificationsBloc, NotificationsBlocState>(
        listener: (BuildContext context, NotificationsBlocState state) {
          if (state is NotificationsBlocStateMainNavigation) {
            BlocProvider.of<MainNavigatorBloc>(context).add(state.mainNavigatorEvent);
          } else if (state is NotificationsBlocStateRequestPermission) {
            _requestNotificationPermissions(lastRouteContext!);
          } else if (state is NotificationsBlocStateNotification) {
            BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventTrigger(
                TowelieActionHelpNotification.id, state, ModalRoute.of(context)!.settings.name!));
          }
        },
        child: BlocListener<TowelieBloc, TowelieBlocState>(
            listener: (BuildContext context, state) {
              if (state is TowelieBlocStateMainNavigation) {
                BlocProvider.of<MainNavigatorBloc>(context).add(state.mainNavigatorEvent);
              } else if (state is TowelieBlocStateLocalNotification) {
                BlocProvider.of<NotificationsBloc>(context).add(state.localNotificationBlocEventReminder);
              }
            },
            child: BlocListener<DeepLinkBloc, DeepLinkBlocState>(
              listener: (BuildContext context, state) {
                if (state is DeepLinkBlocStateMainNavigation) {
                  BlocProvider.of<MainNavigatorBloc>(context).add(state.mainNavigatorEvent);
                }
              },
              child: BlocListener<DeviceDaemonBloc, DeviceDaemonBlocState>(
                  listener: (BuildContext context, DeviceDaemonBlocState state) {
                    if (state is DeviceDaemonBlocStateRequiresLogin) {
                      _promptDeviceAuth(lastRouteContext!, state.device);
                    }
                  },
                  child: body),
            )));
  }

  Widget wrapSyncIndicator(Widget body) {
    return BlocBuilder<SyncerBloc, SyncerBlocState>(
      builder: (BuildContext context, SyncerBlocState state) {
        List<Widget> content = [body];
        if (state is SyncerBlocStateSyncing && state.syncing) {
          content.add(Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: 40,
              child: Scaffold(
                body: Container(
                    color: Colors.red,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 21.0),
                        child: Center(
                            child: Text(MainPage.redBarSyncingProgress(state.text),
                                style: TextStyle(color: Colors.white))),
                      ),
                    )),
              )));
        }
        return Stack(
          children: content,
        );
      },
    );
  }

  Widget _onGenerateRoute(BuildContext context, RouteSettings settings, {required Function() onPop}) {
    Timer(Duration(milliseconds: 100), () {
      BlocProvider.of<TowelieBloc>(context).add(TowelieBlocEventRoute(settings));
    });
    switch (settings.name) {
      case '/home':
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeNavigatorBloc>(
                create: (context) =>
                    HomeNavigatorBloc(settings.arguments as MainNavigateToHomeEvent, _homeNavigatorKey)),
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(),
            )
          ],
          child: addOnPopCallBack(HomePage(_homeNavigatorKey), onPop),
        );
      case '/plant/new':
        return BlocProvider(
          create: (context) => CreatePlantBloc(),
          child: addOnPopCallBack(CreatePlantPage(), onPop),
        );
      case '/plant/box':
        return BlocProvider(
          create: (context) => SelectBoxBloc(settings.arguments as MainNavigateToSelectBoxEvent),
          child: addOnPopCallBack(SelectBoxPage(), onPop),
        );
      case '/plant/box/new':
        return BlocProvider(
          create: (context) => CreateBoxBloc(settings.arguments as MainNavigateToCreateBoxEvent),
          child: addOnPopCallBack(CreateBoxPage(), onPop),
        );
      case '/box/device':
        return BlocProvider(
          create: (context) => SelectDeviceBloc(settings.arguments as MainNavigateToSelectDeviceEvent),
          child: addOnPopCallBack(SelectDevicePage(), onPop),
        );
      case '/box/device/box':
        return BlocProvider(
          create: (context) => SelectDeviceBoxBloc(settings.arguments as MainNavigateToSelectDeviceBoxEvent),
          child: addOnPopCallBack(SelectDeviceBoxPage(), onPop),
        );
      case '/box/device/box/new':
        return BlocProvider(
          create: (context) => SelectDeviceNewBoxBloc(settings.arguments as MainNavigateToSelectNewDeviceBoxEvent),
          child: addOnPopCallBack(SelectDeviceNewBoxPage(), onPop),
        );
      case '/device/add':
        return BlocProvider(
          create: (context) => AddDeviceBloc(settings.arguments as MainNavigateToAddDeviceEvent),
          child: addOnPopCallBack(AddDevicePage(), onPop),
        );
      case '/device/new':
        return BlocProvider(
          create: (context) => NewDeviceBloc(settings.arguments as MainNavigateToNewDeviceEvent),
          child: addOnPopCallBack(NewDevicePage(), onPop),
        );
      case '/device/existing':
        return BlocProvider(
          create: (context) => ExistingDeviceBloc(settings.arguments as MainNavigateToExistingDeviceEvent),
          child: addOnPopCallBack(ExistingDevicePage(), onPop),
        );
      case '/device/load':
        return BlocProvider(
          create: (context) => DeviceSetupBloc(settings.arguments as MainNavigateToDeviceSetupEvent),
          child: addOnPopCallBack(DeviceSetupPage(), onPop),
        );
      case '/device/name':
        return BlocProvider(
          create: (context) => DeviceNameBloc(settings.arguments as MainNavigateToDeviceNameEvent),
          child: addOnPopCallBack(DeviceNamePage(), onPop),
        );
      case '/device/pairing':
        return BlocProvider(
          create: (context) => DevicePairingBloc(settings.arguments as MainNavigateToDevicePairingEvent),
          child: addOnPopCallBack(DevicePairingPage(), onPop),
        );
      case '/device/test':
        return BlocProvider(
          create: (context) => DeviceTestBloc(settings.arguments as MainNavigateToDeviceTestEvent),
          child: addOnPopCallBack(DeviceTestPage(), onPop),
        );
      case '/device/wifi':
        return BlocProvider(
          create: (context) => DeviceWifiBloc(settings.arguments as MainNavigateToDeviceWifiEvent),
          child: addOnPopCallBack(DeviceWifiPage(), onPop),
        );
      case '/feed/form/light':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => DeviceReachableListenerBloc(settings.arguments as DeviceNavigationArgHolder)),
            BlocProvider(
                create: (context) => FeedLightFormBloc(settings.arguments as MainNavigateToFeedLightFormEvent)),
          ],
          child: addOnPopCallBack(FeedLightFormPage(), onPop),
        );
      case '/feed/form/media':
        return BlocProvider(
          create: (context) => FeedMediaFormBloc(settings.arguments as MainNavigateToFeedMediaFormEvent),
          child: addOnPopCallBack(FeedMediaFormPage(), onPop),
        );
      case '/feed/form/measure':
        return BlocProvider(
          create: (context) => FeedMeasureFormBloc(settings.arguments as MainNavigateToFeedMeasureFormEvent),
          child: addOnPopCallBack(FeedMeasureFormPage(), onPop),
        );
      case '/feed/form/schedule':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => DeviceReachableListenerBloc(settings.arguments as DeviceNavigationArgHolder)),
            BlocProvider(
                create: (context) => FeedScheduleFormBloc(settings.arguments as MainNavigateToFeedScheduleFormEvent)),
          ],
          child: addOnPopCallBack(FeedScheduleFormPage(), onPop),
        );
      case '/feed/form/defoliation':
        return BlocProvider(
          create: (context) => FeedDefoliationFormBloc(settings.arguments as MainNavigateToFeedCareCommonFormEvent),
          child: addOnPopCallBack(FeedDefoliationFormPage(), onPop),
        );
      case '/feed/form/topping':
        return BlocProvider(
          create: (context) => FeedToppingFormBloc(settings.arguments as MainNavigateToFeedCareCommonFormEvent),
          child: addOnPopCallBack(FeedToppingFormPage(), onPop),
        );
      case '/feed/form/fimming':
        return BlocProvider(
          create: (context) => FeedFimmingFormBloc(settings.arguments as MainNavigateToFeedCareCommonFormEvent),
          child: addOnPopCallBack(FeedFimmingFormPage(), onPop),
        );
      case '/feed/form/bending':
        return BlocProvider(
          create: (context) => FeedBendingFormBloc(settings.arguments as MainNavigateToFeedCareCommonFormEvent),
          child: addOnPopCallBack(FeedBendingFormPage(), onPop),
        );
      case '/feed/form/transplant':
        return BlocProvider(
          create: (context) => FeedTransplantFormBloc(settings.arguments as MainNavigateToFeedCareCommonFormEvent),
          child: addOnPopCallBack(FeedTransplantFormPage(), onPop),
        );
      case '/feed/form/ventilation':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => DeviceReachableListenerBloc(settings.arguments as DeviceNavigationArgHolder)),
            BlocProvider(
                create: (context) =>
                    FeedVentilationFormBloc(settings.arguments as MainNavigateToFeedVentilationFormEvent)),
          ],
          child: addOnPopCallBack(FeedVentilationFormPage(), onPop),
        );
      case '/feed/form/water':
        return BlocProvider(
          create: (context) => FeedWaterFormBloc(settings.arguments as MainNavigateToFeedWaterFormEvent),
          child: addOnPopCallBack(FeedWaterFormPage(), onPop),
        );
      case '/feed/form/lifeevents':
        return BlocProvider(
          create: (context) => FeedLifeEventFormBloc(settings.arguments as MainNavigateToFeedLifeEventFormEvent),
          child: addOnPopCallBack(FeedLifeEventFormPage(), onPop),
        );
      case '/feed/form/nutrient':
        return BlocProvider(
          create: (context) => FeedNutrientMixFormBloc(settings.arguments as MainNavigateToFeedNutrientMixFormEvent),
          child: addOnPopCallBack(FeedNutrientMixFormPage(), onPop),
        );
      case '/feed/form/comment':
        return BlocProvider(
          create: (context) => CommentsFormBloc(settings.arguments as MainNavigateToCommentFormEvent),
          child: addOnPopCallBack(CommentsFormPage(), onPop),
        );
      case '/tip':
        return BlocProvider(
          create: (context) => TipBloc(settings.arguments as MainNavigateToTipEvent),
          child: addOnPopCallBack(TipPage(), onPop),
        );
      case '/capture':
        return BlocProvider(
          create: (context) => CaptureBloc(settings.arguments as MainNavigateToImageCaptureEvent),
          child: addOnPopCallBack(CapturePage(), onPop),
        );
      case '/capture/playback':
        return BlocProvider(
          create: (context) => PlaybackBloc(settings.arguments as MainNavigateToImageCapturePlaybackEvent),
          child: addOnPopCallBack(PlaybackPage(), onPop),
        );
      case '/media':
        return BlocProvider(
          create: (context) => FullscreenMediaBloc(settings.arguments as MainNavigateToFullscreenMedia),
          child: addOnPopCallBack(FullscreenMediaPage(), onPop),
        );
      case '/picture':
        return BlocProvider(
          create: (context) => FullscreenPictureBloc(settings.arguments as MainNavigateToFullscreenPicture),
          child: addOnPopCallBack(FullscreenPicturePage(), onPop),
        );
      case '/timelapse/viewer':
        return BlocProvider(
          create: (context) => TimelapseViewerBloc(settings.arguments as MainNavigateToTimelapseViewer),
          child: addOnPopCallBack(TimelapseViewerPage(), onPop),
        );
      case '/settings/auth':
        return BlocProvider(
          create: (context) => SettingsAuthBloc(settings.arguments as MainNavigateToSettingsAuth),
          child: addOnPopCallBack(SettingsAuthPage(), onPop),
        );
      case '/settings/login':
        return BlocProvider(
          create: (context) => SettingsLoginBloc(settings.arguments as MainNavigateToSettingsLogin),
          child: addOnPopCallBack(SettingsLoginPage(), onPop),
        );
      case '/settings/createaccount':
        return BlocProvider(
          create: (context) => SettingsCreateAccountBloc(settings.arguments as MainNavigateToSettingsCreateAccount),
          child: addOnPopCallBack(SettingsCreateAccountPage(), onPop),
        );
      case '/settings/plants':
        return BlocProvider(
          create: (context) => SettingsPlantsBloc(settings.arguments as MainNavigateToSettingsPlants),
          child: addOnPopCallBack(SettingsPlantsPage(), onPop),
        );
      case '/settings/plant':
        return BlocProvider(
          create: (context) => SettingsPlantBloc(settings.arguments as MainNavigateToSettingsPlant),
          child: addOnPopCallBack(SettingsPlantPage(), onPop),
        );
      case '/settings/plant/alerts':
        return BlocProvider(
          create: (context) => SettingsPlantAlertsBloc(settings.arguments as MainNavigateToSettingsPlantAlerts),
          child: addOnPopCallBack(SettingsPlantAlertsPage(), onPop),
        );
      case '/settings/boxes':
        return BlocProvider(
          create: (context) => SettingsBoxesBloc(settings.arguments as MainNavigateToSettingsBoxes),
          child: addOnPopCallBack(SettingsBoxesPage(), onPop),
        );
      case '/settings/box':
        return BlocProvider(
          create: (context) => SettingsBoxBloc(settings.arguments as MainNavigateToSettingsBox),
          child: addOnPopCallBack(SettingsBoxPage(), onPop),
        );
      case '/settings/devices':
        return BlocProvider(
          create: (context) => SettingsDevicesBloc(settings.arguments as MainNavigateToSettingsDevices),
          child: addOnPopCallBack(SettingsDevicesPage(), onPop),
        );
      case '/settings/device':
        return BlocProvider(
          create: (context) => SettingsDeviceBloc(settings.arguments as MainNavigateToSettingsDevice),
          child: addOnPopCallBack(SettingsDevicePage(), onPop),
        );
      case '/settings/device/remote':
        return BlocProvider(
          create: (context) => SettingsRemoteControlBloc(settings.arguments as MainNavigateToSettingsRemoteControl),
          child: addOnPopCallBack(SettingsRemoteControlPage(), onPop),
        );
      case '/settings/device/auth':
        return BlocProvider(
          create: (context) => SettingsDeviceAuthBloc(settings.arguments as MainNavigateToSettingsDeviceAuth),
          child: addOnPopCallBack(SettingsDeviceAuthPage(), onPop),
        );
      case '/settings/device/upgrade':
        return BlocProvider(
          create: (context) => SettingsUpgradeDeviceBloc(settings.arguments as MainNavigateToSettingsUpgradeDevice),
          child: addOnPopCallBack(SettingsUpgradeDevicePage(), onPop),
        );

      case '/public/plant':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PublicPlantBloc(settings.arguments as MainNavigateToPublicPlant)),
          ],
          child: addOnPopCallBack(PublicPlantPage(), onPop),
        );
      case '/bookmarks':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => BookmarksBloc(settings.arguments as MainNavigateToBookmarks)),
          ],
          child: addOnPopCallBack(BookmarksPage(), onPop),
        );
      case '/product/select':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => SelectNewProductBloc(settings.arguments as MainNavigateToSelectNewProductEvent)),
          ],
          child: addOnPopCallBack(SelectNewProductPage(), onPop),
        );
      case '/product/new/infos':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductInfosBloc(settings.arguments as MainNavigateToProductInfosEvent)),
          ],
          child: addOnPopCallBack(ProductInfosPage(), onPop),
        );
      case '/product/new/type':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ProductTypeBloc(settings.arguments as MainNavigateToProductTypeEvent)),
          ],
          child: addOnPopCallBack(ProductTypePage(), onPop),
        );
      case '/plantpicker':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => PlantPickerBloc(settings.arguments as MainNavigateToPlantPickerEvent)),
          ],
          child: addOnPopCallBack(PlantPickerPage(), onPop),
        );
      case '/selectplant':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => SelectPlantBloc(settings.arguments as MainNavigateToSelectPlantEvent)),
          ],
          child: addOnPopCallBack(SelectPlantPage(), onPop),
        );
      case '/product/new/supplier':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => ProductSupplierBloc(settings.arguments as MainNavigateToProductSupplierEvent)),
          ],
          child: addOnPopCallBack(ProductSupplierPage(), onPop),
        );
      case '/public/box':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => RemoteBoxFeedBloc(settings.arguments as MainNavigateToRemoteBoxEvent)),
          ],
          child: addOnPopCallBack(RemoteBoxFeedPage(), onPop),
        );
      case '/public/follows':
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FollowsFeedBloc(settings.arguments as MainNavigateToFollowsFeedEvent)),
          ],
          child: addOnPopCallBack(FollowsFeedPage(), onPop),
        );
    }
    return Text(MainPage.mainNavigatorUnknownRoute);
  }

  Widget addOnPopCallBack(Widget widget, Function onPop) {
    return WillPopScope(
      child: widget,
      onWillPop: () async {
        onPop();
        return true;
      },
    );
  }

  void _requestNotificationPermissions(BuildContext context) async {
    if (_showingNotificationRequest == true) return;
    _showingNotificationRequest = true;
    await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext c) {
        return BlocProvider<NotificationRequestBloc>(
          create: (BuildContext context) => NotificationRequestBloc(onClose: () {
            Navigator.pop(context);
          }),
          child: NotificationRequestPage(),
        );
      },
    );
    _showingNotificationRequest = false;
  }

  void _promptDeviceAuth(BuildContext context, Device device) async {
    if (_showingDeviceAuth == true) return;
    _showingDeviceAuth = true;
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext c) {
        return BlocProvider<AuthModalBloc>(
          create: (BuildContext context) => AuthModalBloc(
              device: device,
              onClose: () {
                _showingDeviceAuth = false;
                Navigator.pop(context);
              }),
          child: AuthModalPage(),
        );
      },
    );
    _showingDeviceAuth = false;
  }
}
