import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:super_green_app/l10n.dart';
import 'package:super_green_app/pages/add_box/box_infos/bloc/box_infos_bloc.dart';
import 'package:super_green_app/pages/add_box/box_infos/ui/box_infos_page.dart';
import 'package:super_green_app/pages/add_box/select_device/bloc/select_device_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device/ui/select_device_page.dart';
import 'package:super_green_app/pages/add_box/select_device_box/bloc/select_device_box_bloc.dart';
import 'package:super_green_app/pages/add_box/select_device_box/ui/select_device_box_page.dart';
import 'package:super_green_app/pages/add_device/device_done/bloc/device_done_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/ui/device_done_page.dart';
import 'package:super_green_app/pages/add_device/device_name/bloc/device_name_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/ui/device_name_page.dart';
import 'package:super_green_app/pages/add_device/device_setup/bloc/device_setup_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/ui/device_setup_page.dart';
import 'package:super_green_app/pages/add_device/existing_device/bloc/existing_device_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/ui/existing_device_page.dart';
import 'package:super_green_app/pages/add_device/new_device/bloc/new_device_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/ui/new_device_page.dart';
import 'package:super_green_app/pages/app_init/bloc/app_init_bloc.dart';
import 'package:super_green_app/pages/app_init/ui/app_init_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/form/bloc/feed_defoliation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_defoliation/form/ui/feed_defoliation_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/bloc/feed_light_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_light/form/ui/feed_light_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/bloc/feed_media_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_media/form/ui/feed_media_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/bloc/feed_schedule_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_schedule/form/ui/feed_schedule_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/form/bloc/feed_topping_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_topping/form/ui/feed_topping_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/bloc/feed_ventilation_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_ventilation/form/ui/feed_ventilation_form_page.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/bloc/feed_water_form_bloc.dart';
import 'package:super_green_app/pages/feed_entries/feed_water/form/ui/feed_water_form_page.dart';
import 'package:super_green_app/pages/home/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home/bloc/home_navigator_bloc.dart';
import 'package:super_green_app/pages/home/ui/home_page.dart';
import 'package:super_green_app/pages/image_capture/capture/bloc/capture_bloc.dart';
import 'package:super_green_app/pages/image_capture/capture/ui/capture_page.dart';
import 'package:super_green_app/pages/image_capture/playback/bloc/playback_bloc.dart';
import 'package:super_green_app/pages/image_capture/playback/ui/playback_page.dart';
import 'package:super_green_app/pages/tip/bloc/tip_bloc.dart';
import 'package:super_green_app/pages/tip/ui/tip_page.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey();

class MainPage extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey;

  MainPage(this._navigatorKey);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
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
        navigatorKey: _navigatorKey,
        onGenerateTitle: (BuildContext context) => SGLLocalizations.of(context).title,
        onGenerateRoute: (settings) => this._onGenerateRoute(context, settings),
        theme: ThemeData(
          fontFamily: 'Roboto',
        ),
        home: BlocProvider<AppInitBloc>(
          create: (context) => AppInitBloc(),
          child: AppInitPage(),
        ),
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(
      BuildContext context, RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeNavigatorBloc>(
                        create: (context) => HomeNavigatorBloc(
                            settings.arguments, _homeNavigatorKey)),
                    BlocProvider<HomeBloc>(
                      create: (context) => HomeBloc(),
                    )
                  ],
                  child: HomePage(_homeNavigatorKey),
                ));
      case '/box/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => BoxInfosBloc(),
                  child: BoxInfosPage(),
                ));
      case '/box/device':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SelectDeviceBloc(settings.arguments),
                  child: SelectDevicePage(),
                ));
      case '/box/device/box':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => SelectDeviceBoxBloc(settings.arguments),
                  child: SelectDeviceBoxPage(),
                ));
      case '/device/new':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NewDeviceBloc(settings.arguments),
                  child: NewDevicePage(),
                ));
      case '/device/add':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ExistingDeviceBloc(settings.arguments),
                  child: ExistingDevicePage(),
                ));
      case '/device/load':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceSetupBloc(settings.arguments),
                  child: DeviceSetupPage(),
                ));
      case '/device/name':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceNameBloc(settings.arguments),
                  child: DeviceNamePage(),
                ));
      case '/device/done':
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => DeviceDoneBloc(settings.arguments),
                  child: DeviceDonePage(),
                ));
      case '/feed/form/defoliation':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedDefoliationFormBloc(settings.arguments),
            child: FeedDefoliationFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/light':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedLightFormBloc(settings.arguments),
            child: FeedLightFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/media':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedMediaFormBloc(settings.arguments),
            child: FeedMediaFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/schedule':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedScheduleFormBloc(settings.arguments),
            child: FeedScheduleFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/topping':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedToppingFormBloc(settings.arguments),
            child: FeedToppingFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/ventilation':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedVentilationFormBloc(settings.arguments),
            child: FeedVentilationFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/feed/form/water':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => FeedWaterFormBloc(settings.arguments),
            child: FeedWaterFormPage(),
          ),
          fullscreenDialog: true,
        );
      case '/tip':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => TipBloc(settings.arguments),
            child: TipPage(),
          ),
          fullscreenDialog: true,
        );
      case '/capture':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => CaptureBloc(settings.arguments),
            child: CapturePage(),
          ),
          fullscreenDialog: true,
        );
      case '/capture/playback':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => PlaybackBloc(settings.arguments),
            child: PlaybackPage(),
          ),
          fullscreenDialog: true,
        );
    }
    return MaterialPageRoute(builder: (context) => Text('Unknown route'));
  }
}
