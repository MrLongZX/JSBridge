//
//  ViewController.h
//  WebViewJS
//
//  Created by jakey on 14-5-27.
//  Copyright (c) 2014年 www.skyfox.org All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewJSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *myWeb;

@property (strong, nonatomic) NSString  *someString;
//刷新
- (IBAction)loadTouched:(id)sender;
//执行已经存在的js方法+传值
- (IBAction)exeFuncTouched:(id)sender;
//自带标签getElementsByTagName插入html
- (IBAction)insertHtmTouched:(id)sender;
//getElementsByName 填input
- (IBAction)inputButtonTouched:(id)sender;
//插入JS并且执行
- (IBAction)insertJSTouched:(id)sender;
//getElementById插入html
- (IBAction)insertDivHtml:(id)sender;
//submit
- (IBAction)submitTouched:(id)sender;
//替换图片地址
- (IBAction)replaceImgSrc:(id)sender;
//修改标签字体
- (IBAction)fontTouched:(id)sender;
//定位
- (IBAction)locationTouched:(id)sender;
//上传图片
- (IBAction)uploadTouched:(id)sender;
@end
