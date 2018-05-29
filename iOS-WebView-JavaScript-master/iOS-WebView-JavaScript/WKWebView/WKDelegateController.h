//
//  WKDelegateControllerViewController.h
//  iOS-WebView-JavaScript
//
//  Created by 苏友龙 on 2017/9/22.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@interface WKDelegateController : UIViewController<WKScriptMessageHandler>

@property (weak , nonatomic) id<WKDelegate> delegate;

@end
