//
//  UL_ImagePickerManager.m
//  HXLOOP.COM
//
//  Created by Gaurav Keshre on 3/4/13.
//  Copyright (c) 2013 Hexagonal Loop. All rights reserved.
//

#import "UL_ImagePickerManager.h"
@interface UL_ImagePickerManager()<UIActionSheetDelegate>
@property (strong,nonatomic)UIImagePickerController *imagePicker;
@end
@implementation UL_ImagePickerManager

-(void)showImagePickerWithDelegate:(id)delegate onSuccess:(ULImagePickerSuccessBlock)success onFailureOrCancel:(ULImagePickerCancelBlock)cancelBlock{
    self.successCallback = success;
    self.failureCallback = cancelBlock;
    self.delegate = delegate;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        /*
         * Ideally there should be an alert saying this device doesn'r supports camera.
         * For testing in simulator I am faking a capture using hardcoded image
         */
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypePhotoLibrary])
        {
            if (self.imagePicker==nil) {
                self.imagePicker = [UIImagePickerController new];
                self.imagePicker.delegate = self;
                self.imagePicker.navigationBarHidden = YES;
                self.imagePicker.toolbarHidden = YES;
                self.imagePicker.wantsFullScreenLayout = YES;
            }
            // Set source to the Photo Library
            self.imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
            [delegate presentModalViewController:self.imagePicker animated:YES];
        }else{
            [WCAlertView showAlertWithTitle:@"No Source for photo available" message:@"It seems the device do not have the Photogallery configured." customizationBlock:nil completionBlock:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        }
    }else{
        /*
         * show action shet to choose from camera or gallery
         */
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:kMessageChoosePickerControllerSourceType delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Library", nil];
        if ([delegate respondsToSelector:@selector(view)]) {
            [actionsheet showInView:[(UIViewController *)delegate view]];
        }

    }
}
#pragma mark - UIActionSheetDelegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: //Camera Roll
        {
            
            if (self.imagePicker==nil) {
                _imagePicker = [[UIImagePickerController alloc] init];
                self.imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                self.imagePicker.delegate = self;
                [self.imagePicker setShowsCameraControls:YES];
            }
            [self.delegate presentModalViewController:self.imagePicker animated:YES];
        }
            break;
        case 1: //Photo Gallery
        {
            if (self.imagePicker==nil) {
                _imagePicker = [UIImagePickerController new];
                self.imagePicker.delegate = self;
                self.imagePicker.navigationBarHidden = YES;
                self.imagePicker.toolbarHidden = YES;
                self.imagePicker.wantsFullScreenLayout = YES;
            }
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.delegate presentModalViewController:self.imagePicker animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"image is taken");
    UIImage *capturedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
//        self.imagePicker.delegate = nil;
        self.imagePicker = nil;
        self.successCallback(capturedImage);
    }];
}
-(void)imagePickerControllerDidCancel{
      [self.imagePicker dismissModalViewControllerAnimated:YES];
//    self.imagePicker.delegate = nil;
    self.imagePicker = nil;

    self.failureCallback(@"imagePickerControllerDidCancel");

}
#pragma mark - NavigationControllerDelegate Methods
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [viewController.navigationItem setTitle:@""];
    
    UL_Button *cbtn = [UL_Button buttonWithType:UIButtonTypeCustom];
    [cbtn setFrame:CGRectMake(0.f, 0.f, 70.f, 40.f)];
    [cbtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cbtn setTitle:@"Cancel" forState:UIControlStateHighlighted];
    
    [cbtn setTitleColor:kAppGreenColor forState:UIControlStateHighlighted];
    [cbtn setTitleColor:kAppDarkGreyColor  forState:UIControlStateNormal];
    [cbtn addTarget:self action:@selector(imagePickerControllerDidCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cbtn];
    navigationController.navigationBar.topItem.rightBarButtonItem= nil;
    viewController.navigationItem.rightBarButtonItem = cancelButton;
}


@end
