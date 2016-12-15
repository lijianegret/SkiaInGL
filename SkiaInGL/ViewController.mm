//
//  ViewController.m
//  SkiaInGL
//
//  Created by egret0 on 12/6/16.
//  Copyright © 2016 egret. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"

@interface ViewController ()

@property (nonatomic, strong) OpenGLView* glView;
//@property (nonatomic, strong) SkiaView* skiaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGRect glViewBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y,
                                     screenBounds.size.width, screenBounds.size.height);
    _glView = [[OpenGLView alloc] initWithFrame:glViewBounds];
    [self.view addSubview:_glView];
    
    [self setupDisplayLink];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupDisplayLink
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void) render:(CADisplayLink *)displayLink
{
    [_glView render:displayLink];
//    [self setupDisplayLink];
}


@end
