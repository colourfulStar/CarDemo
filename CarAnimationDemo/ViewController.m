//
//  ViewController.m
//  CarAnimationDemo
//
//  Created by zhangqq on 2018/1/9.
//  Copyright © 2018年 zhangqq. All rights reserved.
//

#import "ViewController.h"

#define MAINSCREEN             ([UIScreen mainScreen].bounds)

@interface ViewController ()
{
    UIImageView         *_bgImgView;
    UIView              *_carMoveView;
    UIView              *_carContainer;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createSubviews];
    [self startCarMoveAnimation];
}

-(void)createSubviews {
    CGFloat bgImgHeight = CGRectGetWidth(MAINSCREEN)*98/683;
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(MAINSCREEN) - bgImgHeight, CGRectGetWidth(MAINSCREEN), bgImgHeight)];
    [_bgImgView setImage:[UIImage imageNamed:@"bg_home"]];
    _bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgImgView];
    
    CGFloat carMoveViewWidth = 100;
    CGFloat carMoveViewHeight = 60;
    CGFloat carBodyWidth = 57.f;
    CGFloat carBodyHeight = 50.f;
    CGFloat carBodyX = 10.f;
    CGFloat carBodyY = 9.f;
    CGFloat carShadowWidth = 70.f;
    CGFloat carShadowHeight = 11.f;
    CGFloat carShadowX = 75.f;
    CGFloat carShadowY = 15.f;
    CGFloat carWheelSize = 13.f;
    
    _carMoveView = [[UIView alloc] init];
    _carMoveView.frame = CGRectMake(0, CGRectGetHeight(MAINSCREEN) - carMoveViewHeight, CGRectGetWidth(MAINSCREEN), carMoveViewHeight);
    _carMoveView.backgroundColor = [UIColor clearColor];
    _carMoveView.clipsToBounds = YES;
    [self.view addSubview:_carMoveView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_carMoveView addGestureRecognizer:tapGesture];
    
    _carContainer = [[UIView alloc] initWithFrame:CGRectMake(-carMoveViewWidth, 0, carMoveViewWidth, carMoveViewHeight)];
    _carContainer.backgroundColor = [UIColor clearColor];
    [_carMoveView addSubview:_carContainer];
    
    UIImageView *carShadow = [[UIImageView alloc] init];
    carShadow.image = [UIImage imageNamed:@"car_shadow"];
    carShadow.frame = CGRectMake(CGRectGetWidth(_carContainer.frame) - carShadowX, CGRectGetHeight(_carContainer.frame) - carShadowY, carShadowWidth, carShadowHeight);
    [_carContainer addSubview:carShadow];
    
    UIImageView *carBody = [[UIImageView alloc] init];
    carBody.image = [UIImage imageNamed:@"car_body"];
    carBody.tag = 100;
    carBody.frame = CGRectMake(CGRectGetWidth(_carContainer.frame) - carBodyX - carBodyWidth, 0, carBodyWidth, carBodyHeight);
    [_carContainer addSubview:carBody];
    
    UIImageView *carWheel1 = [[UIImageView alloc] init];
    carWheel1.image = [UIImage imageNamed:@"car_wheel"];
    carWheel1.frame = CGRectMake(CGRectGetMinX(carBody.frame) + carBodyX, CGRectGetMaxY(carBody.frame) - carBodyY, carWheelSize, carWheelSize);
    carWheel1.tag = 101;
    [_carContainer addSubview:carWheel1];
    
    UIImageView *carWheel2 = [[UIImageView alloc] init];
    carWheel2.image = [UIImage imageNamed:@"car_wheel"];
    carWheel2.frame = CGRectMake(CGRectGetMaxX(carBody.frame) - carBodyX - carBodyX, CGRectGetMaxY(carBody.frame) - carBodyY, carWheelSize, carWheelSize);
    carWheel2.tag = 102;
    [_carContainer addSubview:carWheel2];
}

#pragma mark - animation
- (void)startCarMoveAnimation {
    //车身上下颠簸动画
    UIImageView *carBody = [_carContainer viewWithTag:100];
    CGPoint point = CGPointMake(carBody.center.x, carBody.center.y+0.5);
    CABasicAnimation *joltAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    joltAnimation.toValue        = [NSValue valueWithCGPoint:point];
    joltAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    joltAnimation.duration       = 0.85;
    joltAnimation.repeatCount = HUGE_VALF;
    joltAnimation.removedOnCompletion = NO;
    joltAnimation.autoreverses = YES;
    [carBody.layer addAnimation:joltAnimation forKey:@"carShake"];
    
    //车轮动画
    UIImageView *carWheel1 = [_carContainer viewWithTag:101];
    UIImageView *carWheel2 = [_carContainer viewWithTag:102];
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.toValue = @(M_PI*2);
    rotation.removedOnCompletion = NO;
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation.duration = 1;
    rotation.fillMode = kCAFillModeForwards;
    rotation.repeatCount = HUGE_VALF;
    [carWheel1.layer addAnimation:rotation forKey:@"wheelRotation"];
    [carWheel2.layer addAnimation:rotation forKey:@"wheelRotation"];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self makeCarSmokeAnimationWithTag:1001];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            [self makeCarSmokeAnimationWithTag:1002];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                [self makeCarSmokeAnimationWithTag:1003];
            } completion:nil];
        }];
    }];
    
    CGFloat carMoveViewWidth = 100;
    CGPoint moveEndPoint = CGPointMake(CGRectGetWidth(MAINSCREEN) - carMoveViewWidth/2.0 - 20, _carContainer.center.y);
    CABasicAnimation *carMoveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    carMoveAnimation.toValue        = [NSValue valueWithCGPoint:moveEndPoint];
    carMoveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    carMoveAnimation.duration       = 10;
    carMoveAnimation.removedOnCompletion = NO;
    carMoveAnimation.fillMode = kCAFillModeForwards;
    [_carContainer.layer addAnimation:carMoveAnimation forKey:@"carMove"];
}

- (void)makeCarSmokeAnimationWithTag:(NSInteger)viewTag {
    UIImageView *carBody = [_carContainer viewWithTag:100];
    UIImageView *carSmoke = [_carContainer viewWithTag:viewTag];
    if (carSmoke) {
        return;
    } else {
        CGFloat carSmokeWidth = 5.f;
        CGFloat carSmokeHeight = 4.f;
        carSmoke = [[UIImageView alloc] init];
        carSmoke.image = [UIImage imageNamed:@"car_smoke"];
        carSmoke.frame = CGRectMake(CGRectGetMinX(carBody.frame), CGRectGetMaxY(carBody.frame) - carSmokeHeight, carSmokeWidth, carSmokeHeight);
        carSmoke.tag = viewTag;
        [_carContainer addSubview:carSmoke];
    }
    
    //汽车尾气动画
    //路径
    CAKeyframeAnimation *smokePathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CGPoint point1 = carSmoke.center;
    CGPoint point2 = CGPointMake(5, CGRectGetMaxY(carBody.frame) - 10);
    CGPoint cp = CGPointMake(10, CGRectGetMaxY(carBody.frame) - 6);
    [movePath moveToPoint:point1];
    [movePath addQuadCurveToPoint:point2 controlPoint:cp];
    smokePathAnimation.path = movePath.CGPath;
    //透明度
    CABasicAnimation *smokeOpacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    smokeOpacityAnimation.toValue = @(0);
    //大小
    CABasicAnimation *smokeScaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    smokeScaleAnimation.toValue = @(2);
    
    CAAnimationGroup *smokeGroupAnimation = [CAAnimationGroup animation];
    smokeGroupAnimation.animations = @[smokePathAnimation,smokeScaleAnimation,smokeOpacityAnimation];
    smokeGroupAnimation.duration = 2;
    smokeGroupAnimation.removedOnCompletion = NO;
    smokeGroupAnimation.repeatCount = HUGE_VALF;
    smokeGroupAnimation.fillMode = kCAFillModeForwards;
    [carSmoke.layer addAnimation:smokeGroupAnimation forKey:@"smokeGroupAnimation"];
    [movePath closePath];
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    CGPoint touchPoint = [tapGesture locationInView:_carMoveView];
    if ([_carContainer.layer.presentationLayer hitTest:touchPoint]) {
        NSLog(@"press car");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
