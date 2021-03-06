//
//  ViewController.m
//  ImageViewer
//
//  Created by 吴皓翔 on 15/11/5.
//  Copyright © 2015年 吴皓翔. All rights reserved.
//

#import "ViewController.h"

/**
 用纯代码开发的过程
 
 1. 确定界面元素，要有什么内容
 2. 用代码来搭建界面
 3. 编写代码
 */
@interface ViewController ()
/**
 @proerty
 1. 创建了getter & setter方法
 2. 生成一个带_的成员变量，直接读取成员变量不会经过getter方法&setter方法
 */
@property (nonatomic, strong) UILabel *noLabel;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

/** 当前显示的照片索引 */
@property (nonatomic, assign) long index;

/** 记录图片信息数组 */
@property (nonatomic, strong) NSArray *imageList;
@end

@implementation ViewController

/**
    懒加载，通过getter方法实现
    在最需要时候才加载,在此方法中不要使用self语法不然会死循环
 */
- (NSArray *)imageList {
    NSLog(@"读取图像信息");
    if(_imageList == nil) {
        NSLog(@"实力化数组");
        //Bundle "包"
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ImageList" ofType:@"plist"];
        NSLog(@"%@", path);
        //OC中出现ContentsOfFile，通常需要完整路径
        _imageList = [NSArray arrayWithContentsOfFile:path];
//        NSDictionary *dict1 = @{@"name": @"biaoqingdi", @"desc": @"表情"};
//        NSDictionary *dict2 = @{@"name": @"bingli", @"desc": @"病例"};
//        NSDictionary *dict3 = @{@"name": @"chiniupa", @"desc": @"吃牛扒"};
//        NSDictionary *dict4 = @{@"name": @"danteng", @"desc": @"蛋疼"};
//        NSDictionary *dict5 = @{@"name": @"wangba", @"desc": @"王八"};
//        _imageList = @[dict1, dict2, dict3, dict4, dict5];
    }
    return _imageList;
}

#pragma mark - 控件懒加载
- (UILabel *)noLabel {
    if (_noLabel == nil) {
        _noLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
        //    _noLabel.text = @"1/5";
        _noLabel.textAlignment  = NSTextAlignmentCenter;
        [self.view addSubview:_noLabel];
    }
    return _noLabel;
}

- (UIImageView *)iconImage {
    if (_iconImage == nil) {
        CGFloat imageW = 200;
        CGFloat imageH = 200;
        CGFloat imageX = (self.view.bounds.size.width - imageW) * 0.5;
        CGFloat imageY = CGRectGetMaxY(self.noLabel.frame) + 20;
        
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        //    _iconImage.image = [UIImage imageNamed:@"biaoqingdi"];
        [self.view addSubview:_iconImage];
    }
    return _iconImage;
}

- (UILabel *)descLabel {
    if (_descLabel == nil) {
        CGFloat descY = CGRectGetMaxY(self.iconImage.frame);
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, descY, self.view.bounds.size.width, 100)];
        //    _descLabel.text = @"神马表情";
        _descLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_descLabel];
    }
    return _descLabel;
}

- (UIButton *)leftButton {
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        CGFloat centerY = self.iconImage.center.y;
        CGFloat centerX = self.iconImage.frame.origin.x * 0.5;
        _leftButton.center = CGPointMake(centerX, centerY);
        
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_normal"] forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"left_highlighted"] forState:UIControlStateHighlighted];
        [self.view addSubview:_leftButton];
        
        _leftButton.tag = -1;
        
        [_leftButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        CGFloat centerY = self.iconImage.center.y;
        CGFloat centerX = self.iconImage.frame.origin.x * 0.5;
        _rightButton.center = CGPointMake(self.view.bounds.size.width - centerX, centerY);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_normal"] forState:UIControlStateNormal];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"right_highlighted"] forState:UIControlStateHighlighted];
        [self.view addSubview:_rightButton];
        
        _rightButton.tag = 1;
        
        [_rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

/** 在viewDidLoad创建界面 */
- (void)viewDidLoad {
    [super viewDidLoad];

    [self showPhotoInfo];
}

/**
 重构的目的：让相同的代码只出现一次
 */
- (void)showPhotoInfo {
//    NSLog(@"%s",__func__);
    // 设置序号
    self.noLabel.text = [NSString stringWithFormat:@"%ld/%d", self.index + 1, 5];
    
    //每次调用方法都会生成，效率不高
    /*
    NSDictionary *dict1 = @{@"name": @"biaoqingdi", @"desc": @"表情"};
    NSDictionary *dict2 = @{@"name": @"bingli", @"desc": @"病例"};
    NSDictionary *dict3 = @{@"name": @"chiniupa", @"desc": @"吃牛扒"};
    NSDictionary *dict4 = @{@"name": @"danteng", @"desc": @"蛋疼"};
    NSDictionary *dict5 = @{@"name": @"wangba", @"desc": @"王八"};
    
    NSArray *array = @[dict1, dict2, dict3, dict4, dict5];
    */
    self.iconImage.image = [UIImage imageNamed:self.imageList[self.index][@"name"]];
    self.descLabel.text = self.imageList[self.index][@"desc"];
    // 设置图像和描述
    /*
     switch (self.index) {
        case 0:
            self.iconImage.image = [UIImage imageNamed:@"biaoqingdi"];
            self.descLabel.text = @"表情";
            break;
        case 1:
            self.iconImage.image = [UIImage imageNamed:@"bingli"];
            self.descLabel.text = @"病例";
            break;
        case 2:
            self.iconImage.image = [UIImage imageNamed:@"chiniupa"];
            self.descLabel.text = @"吃牛扒";
            break;
        case 3:
            self.iconImage.image = [UIImage imageNamed:@"danteng"];
            self.descLabel.text = @"蛋疼";
            break;
        case 4:
            self.iconImage.image = [UIImage imageNamed:@"wangba"];
            self.descLabel.text = @"王八";
            break;
     
    }
    */
                             
    // 控制按钮状态
    //    if (self.index == 4) {
    //        self.rightButton.enabled = NO;
    //    } else {
    //        self.rightButton.enabled = YES;
    //    }
    
    self.rightButton.enabled = (self.index != 4);
    self.leftButton.enabled = (self.index != 0);
}

// 在OC中，很多方法的第一个参数，都是触发该方法的对象！
- (void)clickButton:(UIButton *)button {
    // 根据按钮调整当前显示图片的索引?
    self.index += button.tag;
    
    [self showPhotoInfo];
}

///** 上一张照片 */
//- (void)prePhoto
//{
//    NSLog(@"%s", __func__);
//    self.index--;
//
//    [self showPhotoInfo];
//}
//
///** 下一张照片 */
//- (void)nextPhoto
//{
//    NSLog(@"%s", __func__);
//    self.index++;
//
//    [self showPhotoInfo];
//}

@end

