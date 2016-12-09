//
//  ViewController.m
//  SkiaInGL
//
//  Created by egret0 on 12/6/16.
//  Copyright © 2016 egret. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"
#import "SkiaView.h"

@interface ViewController ()

@property (nonatomic, strong) OpenGLView* glView;
@property (nonatomic, strong) SkiaView* skiaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    float height = screenBounds.size.height / 2;
    CGRect glViewBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y,
                                     screenBounds.size.width, height - 1);
    _glView = [[OpenGLView alloc] initWithFrame:glViewBounds];
    [self.view addSubview:_glView];
    
    CGRect skiaViewBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y + height + 1,
                                       screenBounds.size.width, height - 1);
    _skiaView = [[SkiaView alloc] initWithFrame:skiaViewBounds];
    [_skiaView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_skiaView];
    
    [self.view setBackgroundColor:[UIColor redColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
