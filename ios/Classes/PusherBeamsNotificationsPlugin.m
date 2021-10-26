#import "PusherBeamsNotificationsPlugin.h"
#if __has_include(<pusher_beams_notifications/pusher_beams_notifications-Swift.h>)
#import <pusher_beams_notifications/pusher_beams_notifications-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pusher_beams_notifications-Swift.h"
#endif

@implementation PusherBeamsNotificationsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPusherBeamsNotificationsPlugin registerWithRegistrar:registrar];
}
@end
