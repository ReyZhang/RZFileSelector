//
//  Document.h
//  fileOpen
//
//  Created by zzg on 2018/11/6.
//  Copyright © 2018年 zzg. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 UIDocument 我们不能够直接使用， 还需要实现两个方法
 */

@interface Document : UIDocument
@property (nonatomic, strong) NSData *data;
@end
