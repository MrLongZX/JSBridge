//
//  WKWebViewViewController.m
//  WebViewJS
//
//  Created by Jakey on 16/4/10.
//  Copyright © 2016年 www.skyfox.org All rights reserved.
//

#import "WKWebViewJSViewController.h"

@interface WKWebViewJSViewController ()

@end

@implementation WKWebViewJSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"WKWebView调用JS";
    self.view.backgroundColor = [UIColor grayColor];
    
    self.someString = @"iOS 8引入了一个新的框架——WebKit，之后变得好起来了。在WebKit框架中，有WKWebView可以替换UIKit的UIWebView和AppKit的WebView，而且提供了在两个平台可以一致使用的接口。WebKit框架使得开发者可以在原生App中使用Nitro来提高网页的性能和表现，Nitro就是Safari的JavaScript引擎 WKWebView 不支持JavaScriptCore的方式但提供message handler的方式为JavaScript与Native通信";
    
    self.myWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 221) configuration:[[WKWebViewConfiguration alloc] init]];
    self.myWebView.UIDelegate = self;
    [self.view addSubview:self.myWebView];
    
    [self loadTouched:nil];
}

#pragma mark - 刷新 重新加载本地网页
- (IBAction)loadTouched:(id)sender
{
    [self loadHtml:@"WKWebViewJS"];
}

-(void)loadHtml:(NSString*)name
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.myWebView loadRequest:request];
}

#pragma mark - 执行已经存在的js方法+传值
- (IBAction)exeFuncTouched:(id)sender
{
    [self.myWebView evaluateJavaScript:@"showAlert('执行已经存在的js方法+传值')" completionHandler:^(id item, NSError * _Nullable error) {
        NSLog(@"看参数:%@",item);
    }];
}

#pragma mark - 根据getElementsByTagName 自带标签定位元素 插入html
- (IBAction)insertHtmTouched:(id)sender
{
    //插入整个页面内容
    // document.getElementsByTagName('body')[0];"
    //替换第一个P元素内容
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByTagName('p')[0].innerHTML ='%@';",self.someString];
    [self.myWebView evaluateJavaScript:tempString  completionHandler:^(id item, NSError * _Nullable error) {
    }];
}

#pragma mark - 根据getElementsByName 标签名称获取定位元素 修改input值
- (IBAction)inputButtonTouched:(id)sender {
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByName('wd')[0].value='%@';",self.someString];
    [self.myWebView evaluateJavaScript:tempString  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 根据getElementById 定位元素  插入html
- (IBAction)insertDivHtml:(id)sender
{
    //替换第id为idtest的DIV元素内容
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementById('idTest').innerHTML ='%@';",self.someString];
    [self.myWebView evaluateJavaScript:tempString2  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 插入js 并且执行传值
- (IBAction)insertJSTouched:(id)sender
{
    NSString *insertString = [NSString stringWithFormat:
                              @"var script = document.createElement('script');"
                              "script.type = 'text/javascript';"
                              "script.text = \"function jsFunc() { "
                              "var a=document.getElementsByTagName('body')[0];"
                              "alert('%@');"
                              "}\";"
                              "document.getElementsByTagName('head')[0].appendChild(script);", self.someString];
    
    NSLog(@"insert string %@",insertString);
    [self.myWebView evaluateJavaScript:insertString  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
    
    [self.myWebView evaluateJavaScript:@"jsFunc();"  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 替换图片地址
- (IBAction)replaceImgSrc:(id)sender
{
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementsByTagName('img')[0].src ='%@';",@"light_advice.png"];
    [self.myWebView evaluateJavaScript:tempString2  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - submit
- (IBAction)submitTouched:(id)sender
{
    [self.myWebView evaluateJavaScript:@"document.forms[0].submit(); "  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 修改标签字体
- (IBAction)fontTouched:(id)sender
{
    NSString *tempString2 = [NSString stringWithFormat:@"document.getElementsByTagName('p')[0].style.fontSize='%@';",@"19px"];
    [self.myWebView evaluateJavaScript:tempString2  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 定位
- (IBAction)locationTouched:(id)sender
{
    [self loadHtml:@"UIWebViewJS_location"];
}

#pragma mark - 浏览文件 上传图片
- (IBAction)uploadTouched:(id)sender
{
    [self loadHtml:@"UIWebViewJS_file"];
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView
{
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - uiwebview中这个方法是私有方法 通过category拦截网页端的alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
