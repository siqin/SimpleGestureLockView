//
//  ViewController.m
//  SimpleGestureLockView
//
//  Created by Jason Lee on 14-9-26.
//  Copyright (c) 2014年 Jason Lee. All rights reserved.
//

#import "ViewController.h"
#import "SimpleGestureLockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SimpleGestureLockView *lockView = [[SimpleGestureLockView alloc] init];
    lockView.frame = self.view.bounds;
    [self.view addSubview:lockView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
