#import "PushNotificationPlugin.h"

#define DENIED_PUSH_NOTIFICATION_COUNT      @"USRUN_DENIED_PUSH_NOTIFICATION_COUNT"

@interface PushNotificationPlugin() <UNUserNotificationCenterDelegate>

@property (strong, nonatomic) FlutterMethodChannel *channel;

@end


@implementation PushNotificationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/push_notification" binaryMessenger:[registrar messenger]];
    PushNotificationPlugin *instance = [[PushNotificationPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"registerForPushNotification" isEqualToString:call.method]) {
#if TARGET_OS_SIMULATOR
        [self.channel invokeMethod:@"onDeviceToken" arguments:nil];
#else
        [self registerForPushNotification];
#endif
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)registerForPushNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions: UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
            else {
                [self countDeniedPushNotification];
            }
        }];
    }
    else {
        BOOL firstTimeInstall = NO;
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            firstTimeInstall = YES;
        }
        
        UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (currentSettings.types == UIUserNotificationTypeNone && !firstTimeInstall) {
            [self countDeniedPushNotification];
        }
        else {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }
}

- (void)countDeniedPushNotification {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger count = [userDefaults integerForKey:DENIED_PUSH_NOTIFICATION_COUNT];
    count++;
    
    if (count == 5) {
        count = 0;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Usrun needs to use push notification to update your activities. Please enable push notification in your settings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        
        [alert addAction:okAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
    [userDefaults setInteger:count forKey:DENIED_PUSH_NOTIFICATION_COUNT];
    [userDefaults synchronize];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *sDeviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
                                                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                                                            stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.channel invokeMethod:@"onDeviceToken" arguments:sDeviceToken];
}

- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [self.channel invokeMethod:@"onPushNotification" arguments:userInfo];
    return YES;
}

@end
