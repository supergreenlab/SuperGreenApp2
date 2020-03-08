#import "FlutterMatomoPlugin.h"
#import <flutter_matomo/flutter_matomo-Swift.h>

@implementation FlutterMatomoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterMatomoPlugin registerWithRegistrar:registrar];
}
@end
