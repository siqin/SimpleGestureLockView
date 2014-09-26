//
//  SimpleGestureLockView.m
//  SimpleGestureLockView
//
//  Created by Jason Lee on 14-9-26.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "SimpleGestureLockView.h"

@interface SimpleGestureLockView ()

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) NSUInteger numberOfColumns;

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation SimpleGestureLockView

- (id)init
{
    self = [super init];
    if (self) {
        [self initWithDefaultConfiguration];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithDefaultConfiguration];
    }
    return self;
}

- (void)initWithDefaultConfiguration
{
    self.numberOfRows = 5;
    self.numberOfColumns = 4;
    
    NSUInteger buttonsCount = self.numberOfRows * self.numberOfColumns;
    if (!self.buttons) self.buttons = [[NSMutableArray alloc] initWithCapacity:buttonsCount];
    if (!self.selectedButtons) self.selectedButtons = [[NSMutableArray alloc] initWithCapacity:buttonsCount];
}

#pragma mark - 

#define kLockPointImageNormal           @"gestureLockPoint"
#define kLockPointImageSelected         @"gestureLockPointHighlighted"

- (void)layoutButtons
{
    if (self.buttons.count > 0) [self.buttons removeAllObjects];
    if (self.selectedButtons.count > 0) [self.selectedButtons removeAllObjects];
    
    CGSize screenSize = self.frame.size;
    
    UIImage *normalImage = [UIImage imageNamed:kLockPointImageNormal];
    UIImage *selectedImage = [UIImage imageNamed:kLockPointImageSelected];
    CGSize buttonSize = normalImage.size;
    
    CGFloat hMargin = ceil((screenSize.width - self.numberOfColumns * buttonSize.width) / (self.numberOfColumns + 1));
    CGFloat vMargin = ceil((screenSize.height - self.numberOfRows * buttonSize.height) / (self.numberOfRows + 1));
    
    for (NSUInteger i = 0; i < self.numberOfRows; ++i) {
        CGFloat y = vMargin + i * (vMargin + buttonSize.height);
        for (NSUInteger j = 0; j < self.numberOfColumns; ++j) {
            CGFloat x = hMargin + j * (hMargin + buttonSize.width);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = (CGRect){x, y, buttonSize};
            [button setImage:normalImage forState:UIControlStateNormal];
            [button setImage:selectedImage forState:UIControlStateSelected];
            
            [self addSubview:button];
            [self.buttons addObject:button];
            
            button.tag = i * self.numberOfRows + j;
            button.userInteractionEnabled = NO;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutButtons];
}

#pragma mark -

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self drawWithBezierPath];
    //[self drawOnCurrentGraphicsContext];
}

- (void)drawWithBezierPath
{
    if (self.selectedButtons.count > 0) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        
        for (int i = 0; i < self.selectedButtons.count; i++) {
            if (i == 0) {
                UIButton *firstButton = [self.selectedButtons objectAtIndex:0];
                [bezierPath moveToPoint:firstButton.center];
            } else {
                UIButton *button = [self.selectedButtons objectAtIndex:i];
                [bezierPath addLineToPoint:button.center];
            }
        }
        
        [bezierPath addLineToPoint:self.currentPoint];
        [bezierPath setLineWidth:5.0f];
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [[UIColor yellowColor] setStroke];
        [bezierPath stroke];
    }
}

- (void)drawOnCurrentGraphicsContext
{
    if (self.selectedButtons.count > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClearRect(context, self.bounds);
        
        for (NSUInteger i = 0; i < self.selectedButtons.count; ++i) {
            UIButton *button = self.selectedButtons[i];
            CGPoint point = button.center;
            
            if (i == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            } else {
                CGContextAddLineToPoint(context, point.x, point.y);
                CGContextMoveToPoint(context, point.x, point.y);
            }
        }
        
        CGContextAddLineToPoint(context, self.currentPoint.x, self.currentPoint.y);
        
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        CGContextSetLineWidth(context, 5.0f);
        
        CGContextStrokePath(context);
    }
}

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint point = [touch locationInView:self];
        self.currentPoint = point;
        
        UIButton *button = [self buttonContainsPoint:point];
        if (button && ![self.selectedButtons containsObject:button]) {
            [self.selectedButtons addObject:button];
            button.selected = YES;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        CGPoint point = [touch locationInView:self];
        self.currentPoint = point;
        
        UIButton *button = [self buttonContainsPoint:point];
        if (button && ![self.selectedButtons containsObject:button]) {
            [self.selectedButtons addObject:button];
            button.selected = YES;
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self onTouchCancel];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self onTouchCancel];
}

#pragma mark - 

- (void)onTouchCancel
{
    if (self.selectedButtons.count > 0) {
        for (UIButton *button in self.selectedButtons) {
            button.selected = NO;
        }
        [self.selectedButtons removeAllObjects];
    }
    
    [self setNeedsDisplay];
}

#pragma mark -

- (UIButton *)buttonContainsPoint:(CGPoint)point
{
    UIButton *button = nil;
    
    for (UIButton *btn in self.buttons) {
        CGRect frame = btn.frame;
        if (CGRectContainsPoint(frame, point)) {
            button = btn;
            break;
        }
    }
    
    return button;
}

#pragma mark -

@end
