//
//  CustomColoredAccessory.h
//  Expanding and Collapsing TableView Sections
//
//  Created by Fabrice Masachs on 22/03/16.
//  Copyright © 2016 Fabrice Masachs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, CustomColoredAccessoryType) {
    CustomColoredAccessoryTypeTriangleRight = 0,
    CustomColoredAccessoryTypeTriangleLeft,
    CustomColoredAccessoryTypeTriangleDown,
    CustomColoredAccessoryTypeTriangleUp
};

@interface CustomColoredAccessory : UIControl {
    UIColor *_accessoryColor;
    UIColor *_highlightedColor;
    
    CustomColoredAccessoryType _type;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;
@property (nonatomic, assign)  CustomColoredAccessoryType type;

+ (CustomColoredAccessory *)accessoryWithColor:(UIColor *)color;
+ (CustomColoredAccessory *)accessoryWithColor:(UIColor *)color type:(CustomColoredAccessoryType)type;

@end