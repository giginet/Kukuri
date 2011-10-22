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
  int width_;
  int height_;
  BOOL active_;
  NSMutableArray* lines;
  KWVector* origin_;
}

+ (id)circle;
- (void)addPoint:(CGPoint)point;
- (void)draw;
- (NSString*)matchWithTemplates:(NSArray*)templates;
- (void)addLine;
- (CCSprite*)createSprite;

@property(readonly, retain) KWVector* origin;
@property(readwrite, retain) NSMutableArray* lines;
@property(readwrite) BOOL active;
@end