//
//  ViewController.m
//  learnGesture
//
//  Created by chensixin on 2025/9/3.
//

/*
     能自己写出一个视图可以拖动、缩放、旋转的 Demo。
     能解决两个手势冲突的问题（比如 tableView 的滑动和 cell 上的手势）。
     知道什么时候要用手势，什么时候直接用按钮。
 
 写一个图片浏览器：点一下放大，双击缩小，捏合缩放，拖动移动，旋转旋转。
 
 关于手势这块：
 1. 知道有哪些手势就行
 2. 常用的是点击，最好触发
 3. 长按的时候有三个状态，在按中的时候，实现手和图片是一起动的
 4. 手势冲突
 5. 手势穿透
 
 */

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isZoomed; // 是否放大
@property (nonatomic, strong) UIScrollView *scrollView; // 添加scrollView属性
@property (nonatomic, strong) UIImageView *imageView; // 添加imageView属性

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 创建 scrollview 
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(50,
                                                                             100,
                                                                             300,
                                                                             400)];
    self.scrollView.backgroundColor = [UIColor systemGrayColor];
    [self.view addSubview:self.scrollView];
    
    
    // 2. 创建 imageview
    UIImage *image = [UIImage imageNamed:@"image_02"];
    self.imageView = [[UIImageView alloc]initWithImage:image];
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    
    // 设置内容的展示空间和图片一样大
    self.scrollView.contentSize = image.size; 
    
    
    // 3. 创建 tap 点击手势 - 添加到imageView上，而不是整个view
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    // 4. 添加手势到imageView
    [self.imageView addGestureRecognizer:tap];
    
    // 启用imageView的用户交互
    self.imageView.userInteractionEnabled = YES;
    
    self.isZoomed = NO;
    
    self.scrollView.delegate = self; // 设置代理
    
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.maximumZoomScale = 3.0;
    
}


// 返回要缩放的子控件，也就是这个 imageview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}





#pragma mark - 手势的实现方法
- (void)handleTap:(UITapGestureRecognizer *)gesture{
    NSLog(@"点击事件发生");
    // 放大 - 只影响imageView，不影响scrollView
    if(self.isZoomed){ // 当前是放大的状态
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.transform = CGAffineTransformIdentity; // 还原
        } completion:^(BOOL finished) {
            // 缩放完成后，调整scrollView的contentSize
            // 
            self.scrollView.contentSize = self.imageView.image.size;
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        } completion:^(BOOL finished) {
            // 缩放完成后，调整scrollView的contentSize以适应放大后的图片
            CGSize scaledSize = CGSizeMake(self.imageView.image.size.width * 2.0, 
                                         self.imageView.image.size.height * 2.0);
            self.scrollView.contentSize = scaledSize;
        }];
    }
    
    self.isZoomed = !self.isZoomed;
}

/*
    如果在设置了 self.imageView.transform 这个的值
    但是不修改 self.scrollView.contentSize 这个图片的显示区域（也就是scrollview 可以滑动的区域）还是原始的大小
    在图片没有放大的时候没什么视觉上的影响
    但是，在图片放大的时候，显示区域就还是只有原来的 300*400；放大之后本来是有 600*800 的视觉效果的
    不设置的话，就是只能看到放大后的 300*400 的区域了
    
 */

@end
