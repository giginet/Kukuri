//
//  MagicCircle.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import <opencv2/imgproc/imgproc_c.h>
#import <opencv2/objdetect/objdetect.hpp>
#import "MagicCircle.h"
#import "ImageUtil.h"

@implementation MagicCircle
@synthesize drawPoints=drawPoints_;

- (id)init{
  if(self = [super init]){
    self.drawPoints = [NSMutableArray array];
  }
  return self;
}

+ (id)circle{
  return [[[MagicCircle alloc] init] autorelease];
}

- (void)addPoint:(CGPoint)point{
  KWVector* vector = [KWVector vectorWithPoint:point];
  [drawPoints_ addObject:vector];
}

- (void)draw{
  int count = [drawPoints_ count];
  if(count > 1){
    for(int i = 0; i < count-1; ++i){
      KWVector* begin = (KWVector*)[drawPoints_ objectAtIndex:i];
      KWVector* end   = (KWVector*)[drawPoints_ objectAtIndex:i+1];
      ccDrawLine(begin.point, end.point);
    }
  }
}

- (void)match{
  ImageUtil* util = [ImageUtil instance];
  /*int backingWidth = 1024;   // OpenGLのバッファの幅
  int backingHeight = 768;   // OpenGLのバッファの高さ
  NSInteger myDataLength = backingWidth * backingHeight * 4;
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  IplImage* canvas;
  glReadPixels(0, 0, backingWidth, backingHeight, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  [util convertToCV:buffer to:canvas width:backingWidth height:backingHeight channels:4];
  
  */
  
  // loading template file.
  NSString* path = [[NSBundle mainBundle] pathForResource:@"type1" ofType:@"png"];
  UIImage* test = [UIImage imageWithContentsOfFile:path];
  NSLog(@"%f", test.size.width);
  IplImage* template = [util createIplImageFromUIImage:test];
  IplImage* canvas = [util createIplImageFromUIImage:test];
  
  const double result = cvMatchShapes(canvas, template, CV_CONTOURS_MATCH_I1, 0);
  
  NSLog(@"%f", result);
  
  cvReleaseImage(&canvas);
  cvReleaseImage(&template);
}

@end
