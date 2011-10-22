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

@interface MagicCircle()
- (IplImage*)drawOnIplImage:(NSMutableArray*)points 
                     origin:(KWVector*)origin
                      width:(int)width 
                     height:(int)height 
                   channels:(int)channels;
@end

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
    width_ = abs(first.x - second.x);
    height_ = abs(first.y - second.y);
  }else{
    double xMin = origin_.x;
    double yMin = origin_.y;
    double xMax = origin_.x + width_;
    double yMax = origin_.y + height_;
    if(vector.x < xMin){
      origin_.x = vector.x;
      width_ = xMax - vector.x;
    }else if(vector.x > xMax){
      width_ = vector.x - origin_.x;
    }
    if(vector.y < yMin){
      origin_.y = vector.y;
      height_ = yMax - vector.y;
    }else if(vector.y > yMax){
      height_ = vector.y - origin_.y;
    }
  }
}

- (void)draw{
  glColor4f(0.0, 1.0, 0.0, 1.0);
  glLineWidth(4.0f);
  int count = [drawPoints_ count];
  if(count > 1){
    for(int i = 0; i < count-1; ++i){
      KWVector* begin = (KWVector*)[drawPoints_ objectAtIndex:i];
      KWVector* end   = (KWVector*)[drawPoints_ objectAtIndex:i+1];
      ccDrawLine(begin.point, end.point);
    }
  }
  glColor4f(1.0, 0.0, 0.0, 1.0);
  glLineWidth(4.0f);
  ccDrawLine(origin_.point, ccp(origin_.x, origin_.y + height_));
  ccDrawLine(ccp(origin_.x, origin_.y + height_), ccp(origin_.x + width_, origin_.y + height_));
  ccDrawLine(origin_.point, ccp(origin_.x + width_, origin_.y));
  ccDrawLine(ccp(origin_.x + width_, origin_.y), ccp(origin_.x + width_, origin_.y + height_));
}

- (void)match{
  NSLog(@"width:%d, height:%d", width_, height_);
  if(width_ <= 30 || height_ <= 30) return;
  ImageUtil* util = [ImageUtil instance];
  
  IplImage* canvas = [self drawOnIplImage:drawPoints_ origin:origin_ width:width_ height:height_ channels:1];
  
  // loading template file.
  NSString* path = [[NSBundle mainBundle] pathForResource:@"type6" ofType:@"png"];
  UIImage* test = [UIImage imageWithContentsOfFile:path];
  IplImage* template = [util createIplImageFromUIImage:test];
  
  NSLog(@"%f", cvMatchShapes(canvas, template, CV_CONTOURS_MATCH_I1, 0));
  NSLog(@"%f", cvMatchShapes(canvas, template, CV_CONTOURS_MATCH_I2, 0));
  NSLog(@"%f", cvMatchShapes(canvas, template, CV_CONTOURS_MATCH_I3, 0));
  
  cvReleaseImage(&canvas);
  cvReleaseImage(&template);
}

- (CCSprite*)createSprite{
  if(width_ <= 0 || height_ <= 0) return nil;
  ImageUtil* util = [ImageUtil instance];
  IplImage* canvas = [self drawOnIplImage:drawPoints_ origin:origin_ width:width_ height:height_ channels:3];
  
  return [util createSpriteFromIplImage:canvas];
}

- (IplImage*)drawOnIplImage:(NSMutableArray *)points 
                     origin:(KWVector*)origin
                      width:(int)width 
                     height:(int)height 
                   channels:(int)channels{
  IplImage* surface = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, channels);
  CvPoint o, end;
  o.x = 0;
  o.y = 0;
  end.x = width;
  end.y = height;
  cvRectangle(surface, o, end, CV_RGB(255, 255, 255), CV_FILLED, 8, 0);
  int count = [drawPoints_ count];
  if(count > 1){
    for(int i = 0; i < count-1; ++i){
      KWVector* begin = (KWVector*)[drawPoints_ objectAtIndex:i];
      KWVector* end   = (KWVector*)[drawPoints_ objectAtIndex:i+1];
      CvPoint b, e;
      b.x = begin.x - origin.x;
      b.y = begin.y - origin.y;
      e.x = end.x - origin.x;
      e.y = end.y - origin.y;
      cvLine(surface, b, e, CV_RGB(0.0, 0.0, 0.0), channels, 8, 0);
    }
  }
  cvFlip(surface, surface, 0);
  return surface;
}

@end
