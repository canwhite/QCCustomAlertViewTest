//
//  ViewController.m
//  QCCustomAlertView
//
//  Created by EricZhang on 2018/8/20.
//  Copyright © 2018年 BYX. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIButton *btn;
@property(nonatomic,strong) void (^isClickSure)(BOOL isClick);
@property(nonatomic,strong) void (^isClickCancel)(BOOL isClick);
@property(nonatomic,strong) void(^isClickBg)(BOOL isClick);
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width /2 - 50, 200, 100, 35)];
    [self.view addSubview:self.btn];
    self.btn.backgroundColor = RGBA(32, 169, 242, 1);
    [self.btn setTitle:@"自定义弹出框" forState:0];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.btn addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)topClick{
    
    [self showCustomAlertView];
    
}



//颜色，放在宏定义文件中全局可用
static inline UIColor *RGBA(int R, int G, int B, double A) {
    return [UIColor colorWithRed: R/255.0 green: G/255.0 blue: B/255.0 alpha: A];
}

#pragma mark - 此为纯原生弹出方法
-(void)showCustomAlertView{
    
    CGFloat QCWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat QCHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset = 50;//弹出框两边边距
    CGFloat width = QCWidth -offset*2;//弹出框宽
    CGFloat height = 300;//弹出框高
    
    
    //实现弹出方法
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    window.windowLevel = UIWindowLevelNormal;
    
    //背景图
    UIView * backview = [[UIView alloc]initWithFrame:CGRectMake(0, -64, QCWidth, QCHeight+64)];
    backview.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.3f];
    
    [window addSubview:backview];
    
    
    //显示弹窗视图
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(offset,(QCHeight-height)/2,width,height)];
    view.backgroundColor =[UIColor whiteColor];
    view.layer.cornerRadius = 8;
    [backview addSubview:view];
    //    view.layer.borderColor = [UIColor grayColor].CGColor;
    //    view.layer.borderWidth = 1;
    
    //背景点击移除
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    
    tap.cancelsTouchesInView=NO;//YES，系统会识别手势，并取消触摸事件；为NO的时候，手势识别之后，系统将触发触摸事件。
    
    [backview addGestureRecognizer:tap];
    
    self.isClickBg = ^(BOOL isClick) {
        if (isClick) {
            [view removeFromSuperview];
            [backview removeFromSuperview];
        }
    };
    
    
    //=========================自定义部分开始区域，可以在下边加入你想要自定义的内容，视图添加到view上======================
    
    UILabel *egLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, width, 13)];
    [view addSubview:egLabel];
    egLabel.font = [UIFont systemFontOfSize:13];
    egLabel.textColor = RGBA(32, 169, 242, 1);
    egLabel.textAlignment = NSTextAlignmentCenter;
    egLabel.text = @"以下为自定义部分， 确认取消按钮可以删除哦";
    
    
    
    
    //==================================================自定义部分截止区==========================================
    
    
    
    
    //下边为确定和取消按钮，不想要了也可以移除
    UIView *hoLine = [UIView new];
    [view addSubview:hoLine];
    hoLine.frame = CGRectMake(0, height - 36, width ,1 );
    hoLine.backgroundColor = RGBA(242, 242, 242, 1);//浅灰
    
    //verticaLine
    UIView *verticalLine = [UIView new];
    [view addSubview:verticalLine];
    verticalLine.frame = CGRectMake(width/2, height - 35, 1, 35);
    verticalLine.backgroundColor = RGBA(242, 242, 242, 1);//浅灰
    
    //取消按钮
    UIButton *cancelBtn = [UIButton new];
    [view addSubview:cancelBtn];
    cancelBtn.frame = CGRectMake(0, height - 35, width/2, 35);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 200;
    [view addSubview:cancelBtn];
    //取消操作放到此处
    self.isClickCancel = ^(BOOL isClick) {
        if (isClick) {
            [view removeFromSuperview];
            [backview removeFromSuperview];
        }
    };
    
    
    
    
    //确定按钮
    UIButton *sureBtn = [UIButton new];
    [view addSubview:sureBtn];
    sureBtn.tag = 201;
    sureBtn.frame = CGRectMake(width/2 +1, height - 35, width/2-1, 35);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal ];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view addSubview:sureBtn];
    //确认按钮的操作放在此处
    self.isClickSure = ^(BOOL isClick) {
        if (isClick) {
            [view removeFromSuperview];
            [backview removeFromSuperview];
        }
    };
    
    
}

#pragma mark - 用block充当事件点击协议，确认按钮或视图被点击
//背景图点击
-(void)viewTap:(UITapGestureRecognizer *)tap
{
    if (self.isClickBg) {
        self.isClickBg(YES);
    }
}

-(void)clickBtn:(UIButton *)btn{
    
    switch (btn.tag) {
            //取消按钮
        case 200:
            if (self.isClickCancel){
                self.isClickCancel(YES);
            }
            break;
            //确定按钮
        case 201:
            if (self.isClickSure) {
                self.isClickSure(YES);
            }
            break;
            
        default:
            break;
    }
    
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
