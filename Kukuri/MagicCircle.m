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
    width_ = 0;
    height_ = 0;
    origin_ = nil;
  }
  return self;
}

+ (id)circle{
  return [[[MagicCircle alloc] init] autorelease];
}

- (void)addPoint:(CGPoint)point{
  KWVector* vector = [KWVector vectorWithPoint:point];
  [drawPoints_ addObject:vector];
  if(!origin_){
    origin_ = [vector clone];
    width_ = 0;
    height_ = 0;
  }else if([drawPoints_ count] == 2){
    KWVector* first = [drawPoints_ objectAtIndex:0];
    KWVector* second = [drawPoints_ objectAtIndex:1];
    width_ = abs(first.x -second.x);
    height_ = abs(first.y = second.y);
  }else{
    double xMin = origin_.x;
    double yMin = origin_.y;
    double xMax = origin_.x + width_;
    double yMax = origin_.y + height_;
    if(vector.x < xMin){
      origin_.x = vector.x;
    }else if(vector.x > xMax){
      width_ = vector.x - origin_.x;
    }
    if(vector.y < yMin){
      origin_.y = vector.y;
    }else if(vector.y > yMax){
      height_ = vector.y - origin_.y;
    }
  }
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
  NSLog(@"width:%d, height:%d", width_, height_);
  if(width_ <= 0 || height_ <= 0) return;
  ImageUtil* util = [ImageUtil instance];
  NSInteger myDataLength = width_ * height_ * 4;
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  IplImage* canvas;
  
  glReadPixels(origin_.x, origin_.y, width_, height_, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  canvas = [util convertToCV:buffer width:width_ height:height_ channels:4];
  IplImage *ret = cvCreateImage(cvGetSize(canvas), IPL_DEPTH_8U, 1);
	cvCvtColor(canvas, ret, CV_RGBA2GRAY);
	cvReleaseImage(&canvas);
  
  
  // loading template file.
  NSString* path = [[NSBundle mainBundle] pathForResource:@"type4" ofType:@"jpg"];
  UIImage* test = [UIImage imageWithContentsOfFile:path];
  IplImage* template = [util createIplImageFromUIImage:test];
  
  NSLog(@"%f", cvMatchShapes(ret, template, CV_CONTOURS_MATCH_I1, 0));
  NSLog(@"%f", cvMatchShapes(ret, template, CV_CONTOURS_MATCH_I2, 0));
  NSLog(@"%f", cvMatchShapes(ret, template, CV_CONTOURS_MATCH_I3, 0));
  
  cvReleaseImage(&ret);
  cvReleaseImage(&template);
}

- (CCSprite*)createSprite{
  if(width_ <= 0 || height_ <= 0) return nil;
  ImageUtil* util = [ImageUtil instance];
  NSInteger myDataLength = width_ * height_ * 4;
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  IplImage* canvas;
  
  glReadPixels(origin_.x, origin_.y, width_, height_, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  canvas = [util convertToCV:buffer width:width_ height:height_ channels:4];
  /*IplImage *ret = cvCreateImage(cvGetSize(canvas), IPL_DEPTH_8U, 1);
	cvCvtColor(canvas, ret, CV_RGBA2GRAY);
	cvReleaseImage(&canvas);*/
  
  return [util createSpriteFromIplImage:canvas];
}

@end
