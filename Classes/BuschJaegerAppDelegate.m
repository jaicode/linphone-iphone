/* BuschJaegerAppDelegate.m
 *
 * Copyright (C) 2011  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or   
 *  (at your option) any later version.                                 
 *                                                                      
 *  This program is distributed in the hope that it will be useful,     
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of      
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       
 *  GNU General Public License for more details.                
 *                                                                      
 *  You should have received a copy of the GNU General Public License   
 *  along with this program; if not, write to the Free Software         
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */    
#import "BuschJaegerAppDelegate.h"

@implementation BuschJaegerAppDelegate
@synthesize window;
@synthesize buschJaegerMainView;

- (void) loadDefaultSettings {
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSMutableDictionary *rootSettings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSMutableArray *preferences = [rootSettings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"YES", @"debugenable_preference",
                                 @"YES", @"enable_video_preference",
                                 @"YES", @"start_video_preference",
                                 @"YES", @"h264_preference",
                                 @"YES", @"vp8_preference",
                                 @"NO", @"mpeg4_preference",
                                 @"YES", @"pcmu_preference",
                                 @"YES", @"pcma_preference",
                                 @"tcp", @"transport_preference",
                                 @"NO", @"enable_srtp_preference",
                                 @"YES", @"backgroundmode_preference",
                                 nil];
    
    [defaultsToRegister addEntriesFromDictionary:appDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    [defaultsToRegister release];
    [[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self loadDefaultSettings];
    
	[window addSubview:buschJaegerMainView.view];
	
	[window makeKeyAndVisible];
	
	[[LinphoneManager instance] setCallDelegate:buschJaegerMainView];
	[[LinphoneManager instance]	startLibLinphone];
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    linphone_core_set_native_video_window_id([LinphoneManager getLc],(unsigned long)buschJaegerMainView.videoView);	
    linphone_core_set_device_rotation([LinphoneManager getLc], 0);
    linphone_core_set_capture_device([LinphoneManager getLc], "Static picture");
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[LinphoneManager instance] enterBackgroundMode];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[LinphoneManager instance] becomeActive];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    ms_message("Kikoo");
}

@end
