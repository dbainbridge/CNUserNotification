//
//  CNAppDelegate.m
//  CNUserNotification Example
//
//  Created by Frank Gregor on 17.05.13.
//  Copyright (c) 2013 cocoa:naut. All rights reserved.
//

#import "CNAppDelegate.h"


@interface CNAppDelegate() {}
@property (assign) NSUInteger dismissDelayTime;
@property (strong) CNUserNotificationCenter *notificationCenter;
@end

@implementation CNAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.dismissDelayTimeSlider.intValue = 6;
    self.dismissDelayTime = [self.dismissDelayTimeSlider intValue];

    self.notificationCenter = [CNUserNotificationCenter defaultUserNotificationCenter];
    self.notificationCenter.delegate = self;
}

- (IBAction)deliverButtonAction:(id)sender
{
    CNUserNotification *notification = [[CNUserNotification alloc] init];
    notification.title = self.title.stringValue;
    notification.subtitle = self.subtitle.stringValue;
    notification.informativeText = self.informativeText.stringValue;
    notification.userInfo = @{
        kCNUserNotificationDismissDelayTimeKey: [NSNumber numberWithInteger:self.dismissDelayTime],
        @"openThisURLBecauseItsAwesome": self.urlToOpen.stringValue
    };

    [self.notificationCenter deliverNotification:notification];
}

- (IBAction)notificationSelectionMatrixAction:(id)sender
{
    switch ([self.notificationSelectionMatrix selectedRow]) {
        case 0: {
            self.notificationCenter = nil;
            self.notificationCenter = [CNUserNotificationCenter defaultUserNotificationCenter];
            self.notificationCenter.delegate = self;
            break;
        }
        case 1: {
            self.notificationCenter = nil;
            self.notificationCenter = [CNUserNotificationCenter customUserNotificationCenter];
            self.notificationCenter.delegate = self;
            break;
        }
    }
}

- (IBAction)dismissDelayTimeSliderAction:(id)sender
{
    self.dismissDelayTime = [self.dismissDelayTimeSlider intValue];
}

- (IBAction)hasActionButtonCheckboxAction:(id)sender
{
    switch ([self.hasActionButtonCheckbox state]) {
        case NSOnState: {
            [self.actionButtonTitleLabel setEnabled:YES];
            [self.actionButtonTitle setEnabled:YES];
            break;
        }
        case NSOffState: {
            [self.actionButtonTitleLabel setEnabled:NO];
            [self.actionButtonTitle setEnabled:NO];
            break;
        }
    }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - CNUserNotification Delegate

- (BOOL)userNotificationCenter:(CNUserNotificationCenter *)center shouldPresentNotification:(CNUserNotification *)notification
{
    return YES;
}

- (void)userNotificationCenter:(CNUserNotificationCenter *)center didActivateNotification:(CNUserNotification *)notification
{
    NSString *urlToOpen = [notification.userInfo objectForKey:@"openThisURLBecauseItsAwesome"];
    if (urlToOpen && ![urlToOpen isEqualToString:@""]) {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlToOpen]];
    }
}

@end


