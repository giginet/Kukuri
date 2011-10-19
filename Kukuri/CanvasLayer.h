//
//  CanvasLayer.h
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "CCLayer.h"
#import "kwing.h"
#import "MagicCircle.h"

@interface CanvasLayer : CCLayer{
  MagicCircle* currentCircle_;
  NSMutableArray* circles_;
}

@property(readwrite, retain) MagicCircle* currentCircle;
@end
