//
//  ImageUtil.m
//  Kukuri
//
//  Created by  on 11/10/20.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "ImageUtil.h"

@interface ImageUtil()
- (CGImageRef)CGImageFromIplImage:(IplImage*)image;
@end

@implementation ImageUtil

- (GLubyte*)convertToGL:(IplImage *)image{
  int w = image->width;
  int h = image->height;
  int channels = image->nChannels;
  
  GLubyte* conv = (GLubyte*)malloc(w*h*channels);
  IplImage *ret = cvCreateImage(cvGetSize(image), IPL_DEPTH_8U, channels);
  if(channels == 3){
    cvCvtColor(image, ret, CV_BGR2RGB);
  }else{
    cvCvtColor(image, ret, CV_BGRA2RGBA);
  }
	cvReleaseImage(&image);
  
  for(int i = 0; i < w * h * channels; ++i){
    conv[i]     = image->imageData[i];
  }
  return conv;
}

- (IplImage*)convertToCV:(GLubyte *)image 
                   width:(int)width 
                  height:(int)height 
                 channels:(int)channels{
  
  IplImage* conv = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, channels);
  for(int i = 0; i < width * height * channels; ++i){
    conv->imageData[i]     = image[i];
  }
  
  IplImage *ret = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, channels);
  
  if(channels == 3){
    cvCvtColor(conv, ret, CV_RGB2BGR);
  }else{
    cvCvtColor(conv, ret, CV_RGBA2BGRA);
  }
	cvReleaseImage(&conv);
  
  return ret;
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

- (CGImageRef)CGImageFromIplImage:(IplImage *)image {
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  
  NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
  CGDataProviderRef provider =
  CGDataProviderCreateWithCFData((CFDataRef)data);
  
  CGImageRef imageRef = CGImageCreate(
                                      image->width, image->height,
                                      image->depth, image->depth * image->nChannels, image->widthStep,
                                      colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                      provider, NULL, false, kCGRenderingIntentDefault
  );
  
  return imageRef;
}

- (CCSprite*)createSpriteFromIplImage:(IplImage *)image{
  CGImageRef cg = [self CGImageFromIplImage:image];
  return [CCSprite spriteWithCGImage:cg key:@"sprite"];
}

@end
