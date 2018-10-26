//
//  UIView+Constraint.h
//  Refactor7
//
//  Created by xisi on 14-8-29.
//  Copyright (c) 2014年 xisi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XSAutoLayout;


/**
 *  自动布局，公式: view1.attr1 = view2.attr2 * multiplier + constant; 不支持 >= 、 <=
 *
 *  1.  会关闭 view1.translatesAutoresizingMaskIntoConstraints 属性
 *  2.  如果 lay2 = nil，那么view2 = view1.superView; attr2 = attr1
 *  3.  约束线会添加在view1、view2的公共父视图
 *
 *  @warning    崩溃时检查 multiplier = 0，表示与父视图无关，仅支持width、height，这是NSLayoutConstraint自身的问题。
 */
NSLayoutConstraint* lay(XSAutoLayout *lay1, XSAutoLayout *lay2, CGFloat multiplier, CGFloat constant);


@protocol XSAutoLayout

@property (readonly, nonatomic) XSAutoLayout *left;
@property (readonly, nonatomic) XSAutoLayout *right;
@property (readonly, nonatomic) XSAutoLayout *top;
@property (readonly, nonatomic) XSAutoLayout *bottom;
@property (readonly, nonatomic) XSAutoLayout *leading;
@property (readonly, nonatomic) XSAutoLayout *trailing;

@property (readonly, nonatomic) XSAutoLayout *width;
@property (readonly, nonatomic) XSAutoLayout *height;
@property (readonly, nonatomic) XSAutoLayout *centerX;
@property (readonly, nonatomic) XSAutoLayout *centerY;
@property (readonly, nonatomic) XSAutoLayout *baseline;
@property (readonly, nonatomic) XSAutoLayout *notAnAttribute;

@end


@interface XSAutoLayout: NSObject
@end


@interface UIView (XSAutoLayout) <XSAutoLayout>
@end
