//
//  JSWKWebViewViewController.h
//  WebViewJS
//
//  Created by Jakey on 16/4/10.
//  Copyright © 2016年 www.skyfox.org All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface JSWKWebViewViewController : UIViewController<WKUIDelegate,WKScriptMessageHandler,WKDelegate>
@property (strong, nonatomic)  WKWebView *myWebView;

@end
