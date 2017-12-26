ImagePickerManager
==================

![Language](https://img.shields.io/badge/LANGUAGE-Objective--C-blue.svg?style=for-the-badge)


reduces the lines of Code required to show and choose image picker. This uses blocks so is super handy. Its raw so the modifications and improvements are welcome.


• in Your controllers `.m` file

    #import "UL_ImagePickerManager.h"



    @interface MyViewController (){
    UL_ImagePickerManager *imagePickerManager;
    }
    @end
    
    
    @implementation MyViewController
    
    ...
    ...
    
    - (IBAction)handleCameraTap:(id)sender {
    
         imagePickerManager = [UL_ImagePickerManager new];
    
    [imagePickerManager showImagePickerWithDelegate:self onSuccess:^(UIImage *image){
        NSLog(@"showImagePickerWithDelegate");
         [self performSegueWithIdentifier:sPushNewCreatePost sender:@{kPostImageKey:image, @"openWithLimited": @NO,kIsPushed:@YES}];
    }onFailureOrCancel:^(id info){
    
        [self.imagePicker dismissModalViewControllerAnimated:YES];
        }
     ];   
    }
    
    ...
    ...
    @end
