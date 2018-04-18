//
//  ViewController.m
//  RACDemo
//
//  Created by Loren on 2018/4/18.
//  Copyright © 2018年 Loren. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoaLayout.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (nonatomic, strong)NSTimer * timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollerView.contentSize = CGSizeMake(1000, 1000);
    [self observeScrollerViewContentOffset];
    [self receiveNotification];
    [self viewCreatTapClick];
    [self textFiledChange];

}
- (IBAction)action:(id)sender {
    [self postNotification];
}

//textfiled text change
- (void)textFiledChange{
    [[self.textFiled rac_textSignal] subscribeNext:^(NSString * textFiledString) {
        NSLog(@"%@",textFiledString);
    }];
}
//点击事件
- (void)viewCreatTapClick{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer * t) {
        NSLog(@"啊~啊~啊~%@被点击了",t.view);
        [self.textFiled resignFirstResponder];
    }];
    [self.view setUserInteractionEnabled:YES];
    [self.view addGestureRecognizer:tap];
}
//通知的简单实用 无需手动移除
//收
- (void)receiveNotification{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"receiveNotification" object:nil] subscribeNext:^(NSNotification * x) {
        NSLog(@"%@",x.name);
        NSLog(@"%@",x.userInfo);
        NSLog(@"%@",x.object);
    }];
}
//发
- (void)postNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveNotification" object:@[@"1",@"2"]];
}

- (void)alertDelegateAndProtrocol{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"title" message:@"message" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    alert.delegate = alert;
    //不能用self，不然self多次调的话 会执行多次
//    [[alert rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple * tuple) {
//        NSLog(@"\n对象：%@\n点击了第%ld个",tuple.first,[tuple.second integerValue]);
//    }];
    [[alert rac_buttonClickedSignal] subscribeNext:^(id index) {
        NSLog(@"点击了第%ld个",[index integerValue]);
    }];
    [alert show];

}
- (void)observeImageViewProperty{
    UIImageView * imageV = [[UIImageView alloc] init];
    [[imageV rac_signalForSelector:@selector(setImage:)] subscribeNext:^(RACTuple * tuple) {
        NSLog(@"%@",tuple.allObjects);
    }];
    imageV.image = [UIImage imageNamed:@"1.jpeg"];
    [self.view addSubview:imageV];
}


- (void)observeScrollerViewContentOffset{
//    [[self.scrollerView rac_valuesForKeyPath:@"" observer:self] subscribeNext:^(id x) {
//        
//    }];
    [RACObserve(self.scrollerView, contentOffset) subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
