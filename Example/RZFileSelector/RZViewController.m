//
//  RZViewController.m
//  RZFileSelector
//
//  Created by Reyzhang2010 on 03/05/2024.
//  Copyright (c) 2024 Reyzhang2010. All rights reserved.
//

#import "RZViewController.h"
#import <RZFileSelector.h>



@interface RZViewController ()

@end

@implementation RZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)selectImage:(id)sender {
    
    RZFileSelector *selector = [[RZFileSelector alloc] init];
    selector.selectedImageArray = ^(NSArray<UIImage *> * _Nonnull imageArray, NSArray<HXPhotoModel *> * _Nonnull modelArray) {
        NSLog(@"选择图片数:%ld",imageArray.count);
    };
    [selector chooseImage];
    
}


- (IBAction)selectVideo:(id)sender {
    RZFileSelector *selector = [[RZFileSelector alloc] init];
    selector.selectedVideoArray = ^(NSArray<NSURL *> * _Nonnull videoArray, NSArray<HXPhotoModel *> * _Nonnull modelArray) {
        NSLog(@"选择视频数:%ld",videoArray.count);
    };
    [selector chooseVideo];
    
}


- (IBAction)selectFile:(id)sender {
    RZFileSelector *selector = [[RZFileSelector alloc] init];
    selector.selectedFile = ^(NSURL * _Nonnull fileURL) {
        NSLog(@"文件地址：%@",fileURL.absoluteString);
    };
    [selector chooseFile];
}


@end
