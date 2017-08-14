//
//  UIViewController+ModuleWebView.m
//  news
//
//  Created by lanjing on 16/9/26.
//  Copyright © 2016年 lanjing. All rights reserved.
//

#import "UIViewController+ModuleWebView.h"
#import "news-Swift.h"

@implementation UIViewController (ModuleWebView)

- (TKModuleWebViewController *)moduleWebViewWithUrl:(NSString *)url
{
//    let viewController = TKModuleWebViewController()
//    viewController.backImage = UIInitManager.defaultNavBackImage()
//    
//    viewController.backByStep = true;
//    viewController.loadRequestWithUrl(urlString)
//    viewController.hidesBottomBarWhenPushed = true
//    
//    weak var webVC = viewController
//    
//    viewController.loadWebViewStateHandle = { (controller, state, error) in
//        if state == .Start {
//            if (webVC?.isShowedGif == false) {
//                controller.showLoadingGif()
//                webVC?.isShowedGif = true
//            }
//            
//        } else if state == .Finish || state == .Error {
//            let subviews = controller.view.subviews
//            for view in subviews {
//                if view.isKindOfClass(MBProgressHUD.self) {
//                    let hub = view as! MBProgressHUD
//                    hub.hideAnimated(true)
//                }
//            }
//        }
//        
//    }
//    
//    // viewController.rightImage = UIImage.init(named: "newsdetail_share")
//    viewController.rightImages = [UIImage.init(named: "about_us_close")!, UIImage.init(named: "about_us_share")!]
//    viewController.style = .Image
//    viewController.type = .Other
//    
//    viewController.rightBarButtonItemAction = {
//        (controller , title, content) in
//        controller.navigationController?.popViewControllerAnimated(true)
//    }
//    viewController.otherRightBarButtonItemAction = {
//        (controller , title, content) in
//        var shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
//        // 关于我们 web分享 只向外分享
//        if AccountManager.sharedInstance.verified() == "1"{
//            shareView = ShareView(delegate: nil, shareObj: nil, hideLanjing: true)
//        }
//        
//        
//        weak var vc = controller
//        shareView.shareTapAction = {(type, shareView, shareObj) in
//            //分享内容，PM确定
//            var shareContent : String = ""
//            if urlString!.hasPrefix("http://static.lanjinger.com/data/page/aboutUs") {
//                shareContent = "提供中国最专业的财经记者工作平台，以及基于平台交互产生的原创财经新闻。"
//            } else {
//                if type != .SinaWeibo {
//                    let shareString = "_isshare=yes"
//                    let index = urlString?.startIndex.advancedBy((urlString?.length())! - shareString.length() - 1)
//                    if urlString!.hasSuffix(shareString) {
//                        shareContent = urlString!.substringToIndex(index!)
//                    }
//                }
//            }
//            
//            ShareAnalyseManager.sharedInstance().shareWeb(type, presentController: controller, shareUrl: urlString!, shareTitle: title, shareContent: shareContent,  completion: { (success, error) in
//                if success {
//                    vc!.showToastHidenDefault("分享成功")
//                } else {
//                    vc!.showToastHidenDefault("分享失败")
//                }
//            })
//        }
//        
//        let window = UIApplication.sharedApplication().keyWindow
//        shareView.show(window, animated: true)
//    }
    
    TKModuleWebViewController *vc = [[TKModuleWebViewController alloc] init];
    vc.backImage = [UIImage imageNamed:@"navi_back"];
    vc.backByStep = true;
    [vc loadRequestWithUrl:url];
    vc.hidesBottomBarWhenPushed = true;
    
    __weak typeof (vc) webVc = vc;
    vc.loadWebViewStateHandle = ^(UIViewController *viewController, TKWebViewLoadState state, NSError* error){
        if (state == TKWebViewLoadStateStart) {
            if (!webVc.isShowedGif) {
                [viewController showLoadingGif:nil];
                webVc.isShowedGif = true;
            }
        } else if(state == TKWebViewLoadStateFinish || state == TKWebViewLoadStateError) {
            NSArray *subviews = [viewController.view subviews];
            for (UIView *view in subviews) {
                if ([view isKindOfClass:[MBProgressHUD class]]) {
                    MBProgressHUD *hud = (MBProgressHUD *)view;
                    [hud hideAnimated:true];
                }
            }
        }
    };
    
    vc.rightImages = @[[UIImage imageNamed:@"about_us_close"], [UIImage imageNamed:@"about_us_share"] ];
    vc.style = TKWebViewRightBarButtonItemStyleImage;
    vc.type = TKWebViewRightBarButtonItemTypeOther;
    
    vc.rightBarButtonItemAction = ^(TKModuleWebViewController *webViewController , NSString *title , NSString *content) {
        [webViewController.navigationController popViewControllerAnimated:YES];
    };
    vc.otherRightBarButtonItemAction = ^(TKModuleWebViewController *webViewController , NSString *title , NSString *content) {
        ShareView *shareView = [[ShareView alloc] initWithDelegate:nil shareObj:nil hideLanjing:YES];
        shareView.shareTapAction = ^(ShareType type, ShareView * shareView, id shareObj) {
            NSString *shareContent = @"";
            if([url containsString:@"static.lanjinger.com/data/page/aboutUs"]) {
                shareContent = @"提供中国最专业的财经记者工作平台，以及基于平台交互产生的原创财经新闻。";
            } else {
                if (type != ShareTypeSinaWeibo) {
                    shareContent = url;
                }
            }
            
            [[ShareAnalyseManager sharedInstance] shareWeb:type presentController:webViewController shareUrl:url shareTitle:title shareContent:shareContent completion:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [webVc showToastHidenDefault:@"分享成功"];
                } else {
                    [webVc showToastHidenDefault:@"分享失败"];
                }
                    
            }];
        };
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [shareView show:window animated:true];
    };
    
    return vc;
}
@end
