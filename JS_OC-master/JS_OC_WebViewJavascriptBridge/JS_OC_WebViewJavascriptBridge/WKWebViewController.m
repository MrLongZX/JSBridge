//
//  WKWebViewController.m
//  JS_OC_WebViewJavascriptBridge
//
//  Created by Harvey on 16/8/4.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WKWebViewController.h"
#import "WKWebViewJavascriptBridge.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) WKWebViewJavascriptBridge *webViewBridge;

@end

@implementation WKWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"WKWebView--WebViewJavascriptBridge";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化WKWebView 创建交互方式
    [self initWKWebView];
    
    // 初始化进度条
    [self initProgressView];
    
    // 初始化导航右按钮
    [self initRightItem];
    
    // 创建注册原生方法
    [self registerNativeFunctions];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 初始化WKWebView 创建交互方式
- (void)initWKWebView
{
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    configuration.preferences = preferences;
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSString *localHtml = [NSString stringWithContentsOfFile:urlStr encoding:NSUTF8StringEncoding error:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    [self.webView loadHTMLString:localHtml baseURL:fileURL];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewBridge setWebViewDelegate:self];
}

#pragma mark - 初始化进度条
- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, 2)];
    self.progressView.tintColor = [UIColor redColor];
    self.progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.progressView];
}


#pragma mark - 初始化导航右按钮
- (void)initRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 右侧按钮响应事件
- (void)rightClick
{
    // 如果不需要参数，不需要回调，使用这个
    // [_webViewBridge callHandler:@"testJSFunction"];
    // 如果需要参数，不需要回调，使用这个
    // [_webViewBridge callHandler:@"testJSFunction" data:@"一个字符串"];
    // 如果既需要参数，又需要回调，使用这个
    [_webViewBridge callHandler:@"testJSFunction" data:@"传给JS一个字符串" responseCallback:^(id responseData) {
        NSLog(@"调用完JS后的回调：%@",responseData);
    }];
}

#pragma mark - 创建注册原生方法
- (void)registerNativeFunctions
{
    [self registScanFunction];
    
    [self registShareFunction];
    
    [self registLocationFunction];
    
    [self regitstBGColorFunction];
    
    [self registPayFunction];
    
    [self registShakeFunction];
    
    [self registGoBackFunction];
}

#pragma mark - 扫一扫
- (void)registScanFunction
{
    // 注册handler 供JS调用Native使用
    [_webViewBridge registerHandler:@"scanClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"扫一扫");
        NSString *scanResult = @"http://www.baidu.com";
        responseCallback(scanResult);
    }];
}

#pragma mark - 定位
- (void)registLocationFunction
{
    [_webViewBridge registerHandler:@"locationClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        NSString *location = @"广东省深圳市南山区学府路XXXX号";
        // 将结果返回给js
        responseCallback(location);
    }];
}

#pragma mark - 修改背景颜色
- (void)regitstBGColorFunction
{
    __weak typeof(self) weakSelf = self;
    [_webViewBridge registerHandler:@"colorClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 的类型与 JS中传的参数有关
        NSDictionary *tempDic = data;
        CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
        CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
        CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
        CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
        
        weakSelf.webView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }];
}

#pragma mark - 分享
- (void)registShareFunction
{
    [_webViewBridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data类型与JS中传的参数有关
        NSDictionary *tempDic = data;
        // 在这里执行分享的操作
        NSString *title = [tempDic objectForKey:@"title"];
        NSString *content = [tempDic objectForKey:@"content"];
        NSString *url = [tempDic objectForKey:@"url"];
        
        // 将分享的结果返回到JS中
        NSString *result = [NSString stringWithFormat:@"分享成功:%@,%@,%@",title,content,url];
        responseCallback(result);
    }];
}

#pragma mark - 支付
- (void)registPayFunction
{
    [_webViewBridge registerHandler:@"payClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data类型与JS中传的参数有关
        NSDictionary *tempDic = data;
        
        NSString *orderNo = [tempDic objectForKey:@"order_no"];
        // long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
        NSString *subject = [tempDic objectForKey:@"subject"];
        NSString *channel = [tempDic objectForKey:@"channel"];
        // 支付操作...
        
        // 将分享的结果返回到JS中
        NSString *result = [NSString stringWithFormat:@"支付成功:%@,%@,%@",orderNo,subject,channel];
        responseCallback(result);
    }];
}

#pragma mark - 摇一摇
- (void)registShakeFunction
{
    [_webViewBridge registerHandler:@"shakeClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    }];
}

#pragma mark - web网页后退
- (void)registGoBackFunction
{
    __weak typeof(self) weakSelf = self;
    [_webViewBridge registerHandler:@"goback" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf.webView goBack];
    }];
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKNavigationDelegate


#pragma mark - WKUIDelegate
/// 拦截js警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
