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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_green_app/deep_link/deep_link.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/local_notification/local_notification.dart';
import 'package:super_green_app/main/main_navigator_bloc.dart';
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
import 'package:super_green_app/pages/feeds/plant_feeds/remote/public_plant_bloc.dart';
import 'package:super_green_app/pages/feeds/plant_feeds/remote/public_plant_page.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_bloc.dart';
import 'package:super_green_app/pages/fullscreen_media/fullscreen_media_page.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_page.dart';
import 'package:super_green_app/pages/fullscreen_picture/fullscreen_picture_bloc.dart';
import 'package:super_green_app/pages/graphs/metrics_bloc.dart';
import 'package:super_green_app/pages/graphs/metrics_page.dart';
import 'package:super_green_app/pages/home/home_bloc.dart';
import 'package:super_green_app/pages/home/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/home_page.dart';
import 'package:super_green_app/pages/image_capture/capture/capture_bloc.dart';
import 'package:super_green_app/pages/image_capture/capture/capture_page.dart';
import 'package:super_green_app/pages/image_capture/playback/playback_bloc.dart';
import 'package:super_green_app/pages/image_capture/playback/playback_page.dart';
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
import 'package:super_green_app/pages/settings/devices/edit_config/settings_device_bloc.dart';
import 'package:super_green_app/pages/settings/devices/edit_config/settings_device_page.dart';
import 'package:super_green_app/pages/settings/devices/settings_devices_bloc.dart';
import 'package:super_green_app/pages/settings/devices/settings_devices_page.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_bloc.dart';
import 'package:super_green_app/pages/settings/plants/edit_config/settings_plant_page.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_bloc.dart';
import 'package:super_green_app/pages/settings/plants/settings_plants_page.dart';
import 'package:super_green_app/pages/timelapse/timelapse_connect/timelapse_connect_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_connect/timelapse_connect_page.dart';
import 'package:super_green_app/pages/timelapse/timelapse_howto/timelapse_howto_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_howto/timelapse_howto_page.dart';
import 'package:super_green_app/pages/timelapse/timelapse_setup/timelapse_setup_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_setup/timelapse_setup_page.dart';
import 'package:super_green_app/pages/timelapse/timelapse_viewer/timelapse_viewer_bloc.dart';
import 'package:super_green_app/pages/timelapse/timelapse_viewer/timelapse_viewer_page.dart';
import 'package:super_green_app/pages/tip/tip_bloc.dart';
import 'package:super_green_app/pages/tip/tip_page.dart';
import 'package:super_green_app/syncer/syncer_bloc.dart';
import 'package:super_green_app/towelie/towelie_bloc.dart';
import 'package:super_green_app/towelie/towelie_helper.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey();

//final RouteObserver<PageRoute> _analyticsObserver = AnalyticsObserver();

class MainPage extends StatefulWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  MainPage(this._navigatorKey);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          FocusScope.of(context).requestFocus(FocusNode());
          // currentFocus.unfocus();
        }
      },
      child: BlocListener<LocalNotificationBloc, LocalNotificationBlocState>(
        listener: (BuildContext context, LocalNotificationBlocState state) {
          if (state is LocalNotificationBlocStateMainNavigation) {
            BlocProvider.of<MainNavigatorBloc>(context)
                .add(state.mainNavigatorEvent);
          }
        },
        child: BlocListener<TowelieBloc, TowelieBlocState>(
          listener: (BuildContext context, state) {
            if (state is TowelieBlocStateMainNavigation) {
              BlocProvider.of<MainNavigatorBloc>(context)
                  .add(state.mainNavigatorEvent);
            } else if (state is TowelieBlocStateLocalNotification) {
              BlocProvider.of<LocalNotificationBloc>(context)
                  .add(state.localNotificationBlocEventReminder);
            }
          },
          child: BlocListener<DeepLinkBloc, DeepLinkBlocState>(
            listener: (BuildContext context, state) {
              if (state is DeepLinkBlocStateMainNavigation) {
                BlocProvider.of<MainNavigatorBloc>(context)
                    .add(state.mainNavigatorEvent);
              }
            },
            child: MaterialApp(
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
              onGenerateTitle: (BuildContext context) =>
                  SGLLocalizations.of(context).title,
              onGenerateRoute: (settings) => CupertinoPageRoute(
                  settings: settings,
                  builder: (context) => wrapSyncIndicator(
                      TowelieHelper.wrapWidget(settings, context,
                          _onGenerateRoute(context, settings)))),
              theme: ThemeData(
                fontFamily: 'Roboto',
              ),
              home: BlocProvider<AppInitBloc>(
                create: (context) => AppInitBloc(),
                child: AppInitPage(),
              ),
            ),
          ),
        ),
      ),
    );
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Center(
                          child: Text('Syncing - ${state.text}',
                              style: TextStyle(color: Colors.white))),
                    )),
              )));
        }
        return Stack(
          children: content,
        );
      },
    );
  }

  Widget _onGenerateRoute(BuildContext context, RouteSettings settings) {
    Timer(Duration(milliseconds: 100), () {
      BlocProvider.of<TowelieBloc>(context)
          .add(TowelieBlocEventRoute(settings));
    });
    switch (settings.name) {
      case '/home':
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeNavigatorBloc>(
                create: (context) =>
                    HomeNavigatorBloc(settings.arguments, _homeNavigatorKey)),
            BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(),
            )
          ],
          child: HomePage(_homeNavigatorKey),
        );
      case '/plant/new':
        return BlocProvider(
          create: (context) => CreatePlantBloc(),
          child: CreatePlantPage(),
        );
      case '/plant/box':
        return BlocProvider(
          create: (context) => SelectBoxBloc(settings.arguments),
          child: SelectBoxPage(),
        );
      case '/plant/box/new':
        return BlocProvider(
          create: (context) => CreateBoxBloc(settings.arguments),
          child: CreateBoxPage(),
        );
      case '/box/device':
        return BlocProvider(
          create: (context) => SelectDeviceBloc(settings.arguments),
          child: SelectDevicePage(),
        );
      case '/box/device/box':
        return BlocProvider(
          create: (context) => SelectDeviceBoxBloc(settings.arguments),
          child: SelectDeviceBoxPage(),
        );
      case '/box/device/box/new':
        return BlocProvider(
          create: (context) => SelectDeviceNewBoxBloc(settings.arguments),
          child: SelectDeviceNewBoxPage(),
        );
      case '/device/add':
        return BlocProvider(
          create: (context) => AddDeviceBloc(settings.arguments),
          child: AddDevicePage(),
        );
      case '/device/new':
        return BlocProvider(
          create: (context) => NewDeviceBloc(settings.arguments),
          child: NewDevicePage(),
        );
      case '/device/existing':
        return BlocProvider(
          create: (context) => ExistingDeviceBloc(settings.arguments),
          child: ExistingDevicePage(),
        );
      case '/device/load':
        return BlocProvider(
          create: (context) => DeviceSetupBloc(settings.arguments),
          child: DeviceSetupPage(),
        );
      case '/device/name':
        return BlocProvider(
          create: (context) => DeviceNameBloc(settings.arguments),
          child: DeviceNamePage(),
        );
      case '/device/test':
        return BlocProvider(
          create: (context) => DeviceTestBloc(settings.arguments),
          child: DeviceTestPage(),
        );
      case '/device/wifi':
        return BlocProvider(
          create: (context) => DeviceWifiBloc(settings.arguments),
          child: DeviceWifiPage(),
        );
      case '/feed/form/light':
        return BlocProvider(
          create: (context) => FeedLightFormBloc(settings.arguments),
          child: FeedLightFormPage(),
        );
      case '/feed/form/media':
        return BlocProvider(
          create: (context) => FeedMediaFormBloc(settings.arguments),
          child: FeedMediaFormPage(),
        );
      case '/feed/form/measure':
        return BlocProvider(
          create: (context) => FeedMeasureFormBloc(settings.arguments),
          child: FeedMeasureFormPage(),
        );
      case '/feed/form/schedule':
        return BlocProvider(
          create: (context) => FeedScheduleFormBloc(settings.arguments),
          child: FeedScheduleFormPage(),
        );
      case '/feed/form/defoliation':
        return BlocProvider(
          create: (context) => FeedDefoliationFormBloc(settings.arguments),
          child: FeedDefoliationFormPage(),
        );
      case '/feed/form/topping':
        return BlocProvider(
          create: (context) => FeedToppingFormBloc(settings.arguments),
          child: FeedToppingFormPage(),
        );
      case '/feed/form/fimming':
        return BlocProvider(
          create: (context) => FeedFimmingFormBloc(settings.arguments),
          child: FeedFimmingFormPage(),
        );
      case '/feed/form/bending':
        return BlocProvider(
          create: (context) => FeedBendingFormBloc(settings.arguments),
          child: FeedBendingFormPage(),
        );
      case '/feed/form/transplant':
        return BlocProvider(
          create: (context) => FeedTransplantFormBloc(settings.arguments),
          child: FeedTransplantFormPage(),
        );
      case '/feed/form/ventilation':
        return BlocProvider(
          create: (context) => FeedVentilationFormBloc(settings.arguments),
          child: FeedVentilationFormPage(),
        );
      case '/feed/form/water':
        return BlocProvider(
          create: (context) => FeedWaterFormBloc(settings.arguments),
          child: FeedWaterFormPage(),
        );
      case '/feed/form/lifeevents':
        return BlocProvider(
          create: (context) => FeedLifeEventFormBloc(settings.arguments),
          child: FeedLifeEventFormPage(),
        );
      case '/feed/form/nutrient':
        return BlocProvider(
          create: (context) => FeedNutrientMixFormBloc(settings.arguments),
          child: FeedNutrientMixFormPage(),
        );
      case '/tip':
        return BlocProvider(
          create: (context) => TipBloc(settings.arguments),
          child: TipPage(),
        );
      case '/capture':
        return BlocProvider(
          create: (context) => CaptureBloc(settings.arguments),
          child: CapturePage(),
        );
      case '/capture/playback':
        return BlocProvider(
          create: (context) => PlaybackBloc(settings.arguments),
          child: PlaybackPage(),
        );
      case '/media':
        return BlocProvider(
          create: (context) => FullscreenMediaBloc(settings.arguments),
          child: FullscreenMediaPage(),
        );
      case '/picture':
        return BlocProvider(
          create: (context) => FullscreenPictureBloc(settings.arguments),
          child: FullscreenPicturePage(),
        );
      case '/timelapse/howto':
        return BlocProvider(
          create: (context) => TimelapseHowtoBloc(settings.arguments),
          child: TimelapseHowtoPage(),
        );
      case '/timelapse/setup':
        return BlocProvider(
          create: (context) => TimelapseSetupBloc(settings.arguments),
          child: TimelapseSetupPage(),
        );
      case '/timelapse/connect':
        return BlocProvider(
          create: (context) => TimelapseConnectBloc(settings.arguments),
          child: TimelapseConnectPage(),
        );
      case '/timelapse/viewer':
        return BlocProvider(
          create: (context) => TimelapseViewerBloc(settings.arguments),
          child: TimelapseViewerPage(),
        );
      case '/metrics':
        return BlocProvider(
          create: (context) => MetricsBloc(settings.arguments),
          child: MetricsPage(),
        );
      case '/settings/auth':
        return BlocProvider(
          create: (context) => SettingsAuthBloc(settings.arguments),
          child: SettingsAuthPage(),
        );
      case '/settings/login':
        return BlocProvider(
          create: (context) => SettingsLoginBloc(settings.arguments),
          child: SettingsLoginPage(),
        );
      case '/settings/createaccount':
        return BlocProvider(
          create: (context) => SettingsCreateAccountBloc(settings.arguments),
          child: SettingsCreateAccountPage(),
        );
      case '/settings/plants':
        return BlocProvider(
          create: (context) => SettingsPlantsBloc(settings.arguments),
          child: SettingsPlantsPage(),
        );
      case '/settings/plant':
        return BlocProvider(
          create: (context) => SettingsPlantBloc(settings.arguments),
          child: SettingsPlantPage(),
        );
      case '/settings/boxes':
        return BlocProvider(
          create: (context) => SettingsBoxesBloc(settings.arguments),
          child: SettingsBoxesPage(),
        );
      case '/settings/box':
        return BlocProvider(
          create: (context) => SettingsBoxBloc(settings.arguments),
          child: SettingsBoxPage(),
        );
      case '/settings/devices':
        return BlocProvider(
          create: (context) => SettingsDevicesBloc(settings.arguments),
          child: SettingsDevicesPage(),
        );
      case '/settings/device':
        return BlocProvider(
          create: (context) => SettingsDeviceBloc(settings.arguments),
          child: SettingsDevicePage(),
        );
      case '/public/plant':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => PublicPlantBloc(settings.arguments)),
          ],
          child: PublicPlantPage(),
        );
      case '/product/select':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => SelectNewProductBloc(settings.arguments)),
          ],
          child: SelectNewProductPage(),
        );
      case '/product/new/infos':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => ProductInfosBloc(settings.arguments)),
          ],
          child: ProductInfosPage(),
        );
      case '/product/new/type':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => ProductTypeBloc(settings.arguments)),
          ],
          child: ProductTypePage(),
        );
      case '/plantpicker':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => PlantPickerBloc(settings.arguments)),
          ],
          child: PlantPickerPage(),
        );
      case '/product/new/supplier':
        return MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => ProductSupplierBloc(settings.arguments)),
          ],
          child: ProductSupplierPage(),
        );
    }
    return Text('Unknown route');
  }
}
