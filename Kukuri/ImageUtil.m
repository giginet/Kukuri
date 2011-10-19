//
//  ImageUtil.m
//  Kukuri
//
//  Created by  on 11/10/20.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

- (GLubyte*)convertToGL:(IplImage *)image{
  int w = image->width;
  int h = image->height;
  int channels = image->nChannels;
  
  GLubyte* imageData = (GLubyte*)malloc(w*h*channels);
  
  for(int i = 0; i < w * h * channels; i += channels){
    // IplImage contains pixelData as BGR order.
    imageData[i]     = image->imageData[i+2];   // R
    imageData[i+1]   = image->imageData[i+1];   // G
    imageData[i+2]   = image->imageData[i];     // B
    if(channels > 3){
      imageData[i+3] = image->imageData[i+3]; // A
    }
  }
  return imageData;
}

- (IplImage*)convertToCV:(GLubyte *)image 
                      to:(IplImage*)conv
                   width:(int)width 
                  height:(int)height 
                 channels:(int)channels{
  conv = cvCreateImage(cvSize(width, height), IPL_DEPTH_8S, 3);
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

@end
