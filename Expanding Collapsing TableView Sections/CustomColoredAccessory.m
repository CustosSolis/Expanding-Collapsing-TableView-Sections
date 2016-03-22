//
//  CustomColoredAccessory.m
//  Expanding and Collapsing TableView Sections
//
//  Created by Fabrice Masachs on 22/03/16.
//  Copyright © 2016 Fabrice Masachs. All rights reserved.
//

#import "CustomColoredAccessory.h"

@implementation CustomColoredAccessory

@synthesize accessoryColor = _accessoryColor;
@synthesize highlightedColor = _highlightedColor;
@synthesize type = _type;

#pragma mark - Creating A Custom-Colored Accessory

+ (CustomColoredAccessory *)accessoryWithColor:(UIColor *)color {
    return [self accessoryWithColor:color type:CustomColoredAccessoryTypeTriangleRight];
}

+ (CustomColoredAccessory *)accessoryWithColor:(UIColor *)color type:(CustomColoredAccessoryType)type {
    CustomColoredAccessory *ret = [[CustomColoredAccessory alloc] initWithFrame:CGRectMake(0, 0, 15.0, 15.0)];
    ret.accessoryColor = color;
    ret.type = type;
    
    return ret;
}

#pragma mark - Internal Methods

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    switch (_type) {
        case CustomColoredAccessoryTypeTriangleRight:
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint   (contextRef, CGRectGetMinX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMaxX(rect), CGRectGetMidX(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMinX(rect), CGRectGetMaxY(rect));
            CGContextClosePath(contextRef);
            break;
        case CustomColoredAccessoryTypeTriangleLeft:
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint   (contextRef, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMaxX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMinX(rect), CGRectGetMidY(rect));
            CGContextClosePath(contextRef);
            break;
        case CustomColoredAccessoryTypeTriangleDown:
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint   (contextRef, CGRectGetMaxX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMinY(rect), CGRectGetMinX(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMidY(rect), CGRectGetMaxX(rect));
            CGContextClosePath(contextRef);
            break;
        case CustomColoredAccessoryTypeTriangleUp:
            // have to do it
            CGContextBeginPath(contextRef);
            CGContextMoveToPoint   (contextRef, CGRectGetMaxX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMinY(rect), CGRectGetMinX(rect));
            CGContextAddLineToPoint(contextRef, CGRectGetMidY(rect), CGRectGetMaxX(rect));
            CGContextClosePath(contextRef);
            break;
        default:
            break;
    }
    
    if (self.highlighted) {
        [self.highlightedColor setStroke];
        [self.highlightedColor setFill];
    } else {
        [self.accessoryColor setStroke];
        [self.accessoryColor setFill];
    }
    
    CGContextFillPath(contextRef);
    CGContextStrokePath(contextRef);
}

#pragma mark - Properties

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

- (UIColor *)accessoryColor {
    if (!_accessoryColor) {
        return [UIColor blackColor];
    }
    
    return _accessoryColor;
}

- (UIColor *)highlightedColor {
    if (!_highlightedColor) {
        return [UIColor whiteColor];
    }
    
    return _highlightedColor;
}

@end