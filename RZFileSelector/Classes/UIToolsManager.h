//
//  UIToolsManager.h
//  doumiOA_ios
//
//  Created by reyzhang on 2023/10/17.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HXPhotoPicker/HXPhotoPicker.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIToolsManager : NSObject


#pragma mark - 相册相关 HXPhotoPicker -
/**
 *  选择图片
 */
+ (void)OpenPhoto_HXPhotoCount:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void(^)(NSArray<HXPhotoModel *> *models))completionHandler;
/**
 *  选择视频
 */
+ (void)OpenVideo_HXPhotoAlbum:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void(^)(NSArray<HXPhotoModel *> *models))completionHandler;
/**
 *  选择图片、视频
 */
+ (void)OpenAlbum_HXVideoImage:(NSInteger)count
                viewController:(UIViewController *)viewController
             completionHandler:(void(^)(NSArray<HXPhotoModel *> *models))completionHandler;

/**
 *  获取图片原图
 */
+ (void)HX_TakePhotoImageMaxSizeImage:(HXPhotoModel *)photoModel
                            photoSize:(CGSize)photoSize
                         completionHandler:(void(^)(UIImage *maxImage))completionHandler;;





/**
 读取当前控制器
 */
+ (UIViewController *)findCurrentShowingViewController;





@end

NS_ASSUME_NONNULL_END
