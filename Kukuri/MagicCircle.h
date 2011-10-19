//
//  MagicCircle.h
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kwing.h"

@interface MagicCircle : NSObject{
  NSMutableArray* drawPoints_;
}

+ (id)circle;
- (void)addPoint:(CGPoint)point;
- (void)draw;
- (void)match;

@property(readwrite, retain) NSMutableArray* drawPoints;
@end