//
//  RZFileSelector.m
//  doumiOA_ios
//
//  Created by reyzhang on 2023/10/17.
//

#import "RZFileSelector.h"
#import "iCloudManager.h"
#import "Document.h"
#import "UIToolsManager.h"



typedef NS_ENUM(NSInteger, FileSelectorType) {
    FileSelectorImage = 0, //图片
    FileSelectorVideo = 1, //视频
    FileSelectorFile = 2, //文件
};


@interface RZFileSelector ()<UIDocumentPickerDelegate>
@property (nonatomic, assign) FileSelectorType type;
@property (nonatomic, strong) NSMutableArray<UIImage *> *imageArray;
@property (nonatomic, strong) NSMutableArray<NSURL *> *videoArray;

@property (nonatomic, strong) NSArray<HXPhotoModel *> *modelArray;
@end

@implementation RZFileSelector

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    self.photoMaxCnt = 6;
    self.videoMaxCnt = 1;
}




#pragma mark - Public Method -

/**
 选择图片
 */
- (void)chooseImage {
    self.type = FileSelectorImage;
    UIViewController *vc = [UIToolsManager findCurrentShowingViewController];
    
    [UIToolsManager OpenPhoto_HXPhotoCount:self.photoMaxCnt
                            viewController:vc
                         completionHandler:^(NSArray<HXPhotoModel *> * _Nonnull models) {
        NSMutableArray *blockArray = @[].mutableCopy;
        self.imageArray = @[].mutableCopy;
        self.modelArray = models;
        //1.遍历
        for (int i = 0; i < models.count; i++) {
            HXPhotoModel *photoModel = models[i];
            
            NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //默认创建的信号为0
                
                //2.获取图片
                [UIToolsManager HX_TakePhotoImageMaxSizeImage:photoModel photoSize:CGSizeMake(500, 500) completionHandler:^(UIImage * _Nonnull maxImage) {
                    [self.imageArray addObject:maxImage];
                    dispatch_semaphore_signal(semaphore); //这里请求成功信号量 +1 为1
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //走到这里如果信号量为0 则不再执行下面的代码 一直等待 信号量不是0 出现 才会执行下面代码,然后信号量为 - 1
            }];
            
            
            [blockArray addObject:block];
        } //end for
    
        
        //添加依赖关系
        for (int i = 0; i < blockArray.count; i++) {
            if (i > 0) {
                [blockArray[i] addDependency:blockArray[i - 1]];
            }
        }
        
        //加入异步对列，并开始执行
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue addOperations:blockArray waitUntilFinished:NO];
        
        [operationQueue addObserver:self forKeyPath:@"operationCount" options:0 context:nil];
    
    }];//end manager
}


//KVO监听队列是否执行完毕
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    WEAKSELF
    if ([keyPath isEqualToString:@"operationCount"]) {
        NSOperationQueue *queue = (NSOperationQueue *)object;
        if (queue.operationCount == 0) {
            //主线程刷新界面
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.type == FileSelectorImage) {
                    !self.selectedImageArray ?: self.selectedImageArray(self.imageArray,self.modelArray);
                }else if (self.type == FileSelectorVideo) {
                    !self.selectedVideoArray ?: self.selectedVideoArray(self.videoArray, self.modelArray);
                }
            });
        }
    }
}


/**
 选择视频
 */
- (void)chooseVideo {
    self.type = FileSelectorVideo;
    UIViewController *vc = [UIToolsManager findCurrentShowingViewController];
    [UIToolsManager OpenVideo_HXPhotoAlbum:self.videoMaxCnt 
                            viewController:vc
                         completionHandler:^(NSArray<HXPhotoModel *> * _Nonnull models) {
       
        NSMutableArray *blockArray = @[].mutableCopy;
        self.videoArray = @[].mutableCopy;
        self.modelArray = models;
        //1.遍历
        for (int i = 0; i < models.count; i++) {
            HXPhotoModel *photoModel = models[i];
            
            NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); //默认创建的信号为0
                
                //2.导出视频
                [photoModel getAssetURLWithSuccess:^(NSURL * _Nullable URL, HXPhotoModelMediaSubType mediaType, BOOL isNetwork, HXPhotoModel * _Nullable model) {
                    [self.videoArray addObject:URL];
                    dispatch_semaphore_signal(semaphore); //这里请求成功信号量 +1 为1
                } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                    dispatch_semaphore_signal(semaphore); //这里请求成功信号量 +1 为1
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //走到这里如果信号量为0 则不再执行下面的代码 一直等待 信号量不是0 出现 才会执行下面代码,然后信号量为 - 1
            }];
            
            
            [blockArray addObject:block];
        } //end for
        
        
        //添加依赖关系
        for (int i = 0; i < blockArray.count; i++) {
            if (i > 0) {
                [blockArray[i] addDependency:blockArray[i - 1]];
            }
        }
    
        //加入异步对列，并开始执行
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue addOperations:blockArray waitUntilFinished:NO];
        
        [operationQueue addObserver:self forKeyPath:@"operationCount" options:0 context:nil];
        
        
    }]; //end manager
}




/**
 选择文件
 */
- (void)chooseFile {
    self.type = FileSelectorFile;
    NSArray *documentTypes = @[@"public.content",
                               @"public.text",
                               @"public.source-code ",
                               @"public.image",
                               @"public.audiovisual-content",
                               @"com.adobe.pdf",
                               @"com.apple.keynote.key",
                               @"com.microsoft.word.doc",
                               @"com.microsoft.excel.xls",
                               @"com.microsoft.powerpoint.ppt"];
//    UIDocumentInteractionController
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
    documentPickerViewController.delegate = self;
    documentPickerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    //present方式弹出
    UIViewController *vc = [UIToolsManager findCurrentShowingViewController];
    [vc presentViewController:documentPickerViewController animated:YES completion:nil];
}



#pragma mark - UIDocumentPickerViewControllerDelegate -
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
    fileName = [fileName stringByRemovingPercentEncoding]; //解码
    NSLog(@"--->>>>file name %@",fileName);
    if ([iCloudManager iCloudEnable:self.iCloudID]) {
        [iCloudManager downloadWithDocumentURL:url callBack:^(id obj) {
            NSData *data = obj;
            //写入沙盒Documents
            NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",fileName]];
            [data writeToFile:path atomically:YES];
            NSLog(@"-----文件写入地址------：%@",path);
            NSURL *url = [NSURL fileURLWithPath:path];
            
            !self.selectedFile ?: self.selectedFile(url);
            [controller dismissViewControllerAnimated:YES completion:nil]; //关闭弹出
        }];
    }
}



@end

