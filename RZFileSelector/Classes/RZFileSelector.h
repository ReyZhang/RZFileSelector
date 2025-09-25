//
//  RZFileSelector.h
//  doumiOA_ios
//
//  Created by reyzhang on 2023/10/17.
//  多途径上传组件，支持图片，视频，文件上传

#import <HXPhotoPicker/HXPhotoPicker.h>
NS_ASSUME_NONNULL_BEGIN


@interface RZFileSelector : NSObject
@property (nonatomic, assign) NSInteger photoMaxCnt; //图片最大选取数量
@property (nonatomic, assign) NSInteger videoMaxCnt; //视频最大选取数量
@property (nonatomic, strong) NSString *iCloudID; //选择文件时使用

/**
 选择的图片回调
 */
@property (nonatomic, copy) void(^selectedImageArray)(NSArray<UIImage *> *imageArray, NSArray<HXPhotoModel *> *modelArray);
/**
 选择的视频回调
 */
@property (nonatomic, copy) void(^selectedVideoArray)(NSArray<NSURL *> *videoArray, NSArray<HXPhotoModel *> *modelArray);

/**
 选择的文件回调
 */
@property (nonatomic, copy) void(^selectedFile)(NSURL *fileURL);



//公开事件
/**
 选择图片
 */
- (void)chooseImage;


/**
 选择视频
 */
- (void)chooseVideo;


/**
 选择文件
 */
- (void)chooseFile;


@end

NS_ASSUME_NONNULL_END
