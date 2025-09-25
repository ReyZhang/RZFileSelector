//
//  UIToolsManager.m
//  doumiOA_ios
//
//  Created by reyzhang on 2023/10/17.
//

#import "UIToolsManager.h"



@implementation UIToolsManager

#pragma mark - 相册相关 HX -
/*
 *  选择图片
 */
+ (void)OpenPhoto_HXPhotoCount:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void (^)(NSArray<HXPhotoModel *> * weakDropView))completionHandler{
    HXPhotoManager *manager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhoto];
    manager.configuration.photoMaxNum = count;
    [viewController hx_presentSelectPhotoControllerWithManager:manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX block - all - %@",allList);
        NSLog(@"---HX block - photo - %@",photoList);
        NSLog(@"---HX block - video - %@",videoList);
        completionHandler(allList);
        //清空所选
        [manager clearSelectedList];

    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX单选照片block - 取消了");
    }];
}

/**
 *  选择视频
 */
+ (void)OpenVideo_HXPhotoAlbum:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void(^)(NSArray<HXPhotoModel *> *models))completionHandler{
    HXPhotoManager *manager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypeVideo];
    manager.configuration.videoMaxNum = count;
    manager.configuration.videoMaximumSelectDuration = 120 * 60;
    [viewController hx_presentSelectPhotoControllerWithManager:manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX block - all - %@",allList);
        NSLog(@"---HX block - photo - %@",photoList);
        NSLog(@"---HX block - video - %@",videoList);
        completionHandler(allList);
        //清空所选
        [manager clearSelectedList];
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX单选照片block - 取消了");
    }];
}

/**
 *  选择图片、视频
 */
+ (void)OpenAlbum_HXVideoImage:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void(^)(NSArray<HXPhotoModel *> *models))completionHandler{
    HXPhotoManager *manager = [[HXPhotoManager alloc]initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
    manager.configuration.maxNum = count;
    manager.configuration.photoMaxNum = 0;
    manager.configuration.videoMaxNum = 0;
    manager.configuration.selectTogether = YES;
    [viewController hx_presentSelectPhotoControllerWithManager:manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX block - all - %@",allList);
        NSLog(@"---HX block - photo - %@",photoList);
        NSLog(@"---HX block - video - %@",videoList);
        completionHandler(allList);
        //清空所选
        [manager clearSelectedList];
        
    } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
        NSLog(@"---HX单选照片block - 取消了");
        
    }];
}




/**
 *  HXPhoto获取原图
 */
+ (void)HX_TakePhotoImageMaxSizeImage:(HXPhotoModel *)photoModel
                            photoSize:(CGSize)photoSize
                    completionHandler:(void(^)(UIImage *maxImage))completionHandler{
    [photoModel requestPreviewImageWithSize:photoSize startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
        
    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
        
    } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
        completionHandler(image);
    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
        completionHandler([UIImage imageNamed:@"placeholder_small_user"]);
    }];
}







/**
 读取当前控制器
 */
+ (UIViewController *)findCurrentShowingViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc{
    // 递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) {
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    return currentShowingVC;
}




@end
