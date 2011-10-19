//
//  ImageUtil.h
//  Kukuri
//
//  Created by  on 11/10/20.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "KWSingleton.h"
#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/objdetect/objdetect.hpp>

@interface ImageUtil : KWSingleton

// convert IplImage(OpenCV) to GLubyte(OpenGL).
- (GLubyte*)convertToGL:(IplImage*)image 
                     to:(GLubyte*)conv;

- (IplImage*)convertToCV:(GLubyte*)image
                      to:(IplImage*)conv
                   width:(int)width 
                  height:(int)height 
                 channels:(int)channels;

- (IplImage*)createIplImageFromUIImage:(UIImage*)image;

@end
