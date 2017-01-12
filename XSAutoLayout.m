//
//  UIView+Constraint.m
//  Refactor7
//
//  Created by xisi on 14-8-29.
//  Copyright (c) 2014年 xisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XSAutoLayout.h"
#import <objc/runtime.h>
#import <objc/message.h>

NSLayoutConstraint* lay(XSAutoLayout *lay1, XSAutoLayout *lay2, CGFloat multiplier, CGFloat constant) {
    //  方法调用:  [lay1 equal:lay2 multiplier:multiplier constant:constant];
    SEL sel = sel_registerName("equal:multiplier:constant:");
    return ((NSLayoutConstraint* (*)(XSAutoLayout*, SEL, XSAutoLayout*, CGFloat, CGFloat))objc_msgSend)(lay1, sel, lay2, multiplier, constant);
}



#pragma mark -  XSAutoLayout
//###############################################################################################################

@interface XSAutoLayout()               //  不可声明为没有@property

@property (nonatomic) UIView *view;
@property (nonatomic) NSLayoutAttribute attr;

@end


@implementation XSAutoLayout

/*! 
     为UIView添加12个实例方法。例如: -[UIView left] 方法
     @code
         - (XSAutoLayout *)left {
             XSAutoLayout *autoLayout = [XSAutoLayout new];
             autoLayout.view = self;
             autoLayout.attr = NSLayoutAttributeLeft;
             return autoLayout;
         }
     @endcode
 */
+ (void)load {
    char *s[12] = {"left", "right", "top", "bottom", "leading", "trailing",
        "width", "height", "centerX", "centerY", "baseline", "notAnAttribute"};
    
    Class cls = [UIView class];
    for (int i = 0; i < 12; i++) {
        SEL sel = sel_registerName(s[i]);
        IMP imp = imp_implementationWithBlock(^XSAutoLayout *(UIView *view) {
            XSAutoLayout *autoLayout = [XSAutoLayout new];
            autoLayout.view = view;
            autoLayout.attr = (i + 1) % 12;
            return autoLayout;
        });
        BOOL success = class_addMethod(cls, sel, imp, "@16@0:8");
        NSAssert1(success, @"-[UIView %s]方法已经存在", s[i]);
    }
}

- (NSLayoutConstraint *)equal:(XSAutoLayout *)autoLayout multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    if (self.view.translatesAutoresizingMaskIntoConstraints == YES) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    UIView *view1 = self.view, *view2 = autoLayout.view, *ancestorView;
    NSLayoutAttribute attr1 = self.attr, attr2 = autoLayout.attr;
    if (autoLayout == nil) {
        view2 = view1.superview;
        attr2 = attr1;
    }
    NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:view1
                                                                        attribute:attr1
                                                                        relatedBy:0
                                                                           toItem:view2
                                                                        attribute:attr2
                                                                       multiplier:multiplier
                                                                         constant:constant];
    ancestorView = [self ancestorViewForView1:view1 view2:view2];
    [ancestorView addConstraint:layoutConstraint];
    return layoutConstraint;
}

/*!
    在[ aView, bView, aView.superView, bView.superView ]四个视图中找到aView、bView的公有父视图。
    如果没有则默认为aView.superView
 */
- (UIView *)ancestorViewForView1:(UIView *)view1 view2:(UIView *)view2 {
    UIView *ancestorView;
    if ([view1 isDescendantOfView:view2]) {
        ancestorView = view2;
    } else if ([view2 isDescendantOfView:view1]) {
        ancestorView = view1;
    } else if ([view1 isDescendantOfView:view2.superview]) {
        ancestorView = view2.superview;
    } else if ([view2 isDescendantOfView:view1.superview]) {
        ancestorView = view1.superview;
    } else {
        ancestorView = view1.superview;
    }
    return ancestorView;
}

@end



#pragma mark -  UIView (XSAutoLayout)
//###############################################################################################################

@implementation UIView (XSAutoLayout)

@dynamic left;
@dynamic right;
@dynamic top;
@dynamic bottom;
@dynamic leading;
@dynamic trailing;

@dynamic width;
@dynamic height;
@dynamic centerX;
@dynamic centerY;
@dynamic baseline;
@dynamic notAnAttribute;

@end
