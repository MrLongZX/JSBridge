//
//  WKWebViewViewController.h
//  WebViewJS
//
//  Created by Jakey on 16/4/10.
//  Copyright © 2016年 www.skyfox.org All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WKWebViewJSViewController : UIViewController<WKUIDelegate>

@property (strong, nonatomic)  WKWebView *myWebView;

@property (strong, nonatomic) NSString  *someString;

/// 刷新
- (IBAction)loadTouched:(id)sender;

/// 执行已经存在的js方法+传值
- (IBAction)exeFuncTouched:(id)sender;

/// 根据getElementsByTagName 自带标签定位元素 插入html
- (IBAction)insertHtmTouched:(id)sender;

/// 根据getElementsByName 标签名称获取定位元素 修改input值
- (IBAction)inputButtonTouched:(id)sender;

/// 根据getElementById 定位元素  插入html
- (IBAction)insertDivHtml:(id)sender;

/// 插入js 并且执行传值
- (IBAction)insertJSTouched:(id)sender;

/// 替换图片地址
- (IBAction)replaceImgSrc:(id)sender;

/// submit
- (IBAction)submitTouched:(id)sender;

/// 修改标签字体
- (IBAction)fontTouched:(id)sender;

/// 定位
- (IBAction)locationTouched:(id)sender;

/// 浏览文件 上传图片
- (IBAction)uploadTouched:(id)sender;
@end
