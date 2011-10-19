//
//  ImageUtil.m
//  Kukuri
//
//  Created by  on 11/10/20.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

- (GLubyte*)convertToGL:(IplImage *)image to:(GLubyte *)conv{
  int w = image->width;
  int h = image->height;
  int channels = image->nChannels;
  
  conv = (GLubyte*)malloc(w*h*channels);
  
  for(int i = 0; i < w * h * channels; i += channels){
    // IplImage contains pixelData as BGR order.
    conv[i]     = image->imageData[i+2];   // R
    conv[i+1]   = image->imageData[i+1];   // G
    conv[i+2]   = image->imageData[i];     // B
    if(channels > 3){
      conv[i+3] = image->imageData[i+3]; // A
    }
  }
  return conv;
}

- (IplImage*)convertToCV:(GLubyte *)image 
                      to:(IplImage*)conv
                   width:(int)width 
                  height:(int)height 
                 channels:(int)channels{
  conv = cvCreateImage(cvSize(width, height), IPL_DEPTH_8S, channels);
  NSLog(@"%d", conv->imageData[0]);
  for(int i = 0; i < width * height * channels; i += channels){
    conv->imageData[i]     = image[i+2];
    conv->imageData[i+1]   = image[i+1];
    conv->imageData[i+2]   = image[i];
    if(channels > 3){
      conv->imageData[i+3] = image[i+3];
    }
  }
  return conv;
}

- (IplImage *)createIplImageFromUIImage:(UIImage *)image {
	CGImageRef imageRef = image.CGImage;
  
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	IplImage *iplimage = cvCreateImage(cvSize(image.size.width, image.size.height), IPL_DEPTH_8U, 4);
	CGContextRef contextRef = CGBitmapContextCreate(iplimage->imageData, iplimage->width, iplimage->height,
                                                  iplimage->depth, iplimage->widthStep,
                                                  colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
	CGContextDrawImage(contextRef, CGRectMake(0, 0, image.size.width, image.size.height), imageRef);
	CGContextRelease(contextRef);
	CGColorSpaceRelease(colorSpace);
  
	IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 1);
	cvCvtColor(iplimage, ret, CV_RGBA2GRAY);
	cvReleaseImage(&iplimage);
  
	return ret;
}

@end
