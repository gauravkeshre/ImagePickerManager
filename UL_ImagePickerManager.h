//
//  UL_ImagePickerManager.h
//  HXLOOP.com
//
//  Created by Gaurav Keshre on 3/4/13.
//  Copyright (c) 2013 Hexagonal Loop. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ULImagePickerSuccessBlock)(UIImage *image);
typedef void(^ULImagePickerCancelBlock)(id info);

@interface UL_ImagePickerManager : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, copy)ULImagePickerSuccessBlock successCallback;
@property(nonatomic, copy)ULImagePickerCancelBlock  failureCallback;
@property(nonatomic, weak)id delegate;

-(void)showImagePickerWithDelegate:(id)delegate onSuccess:(ULImagePickerSuccessBlock)success onFailureOrCancel:(ULImagePickerCancelBlock)cancelBlock;

@end
