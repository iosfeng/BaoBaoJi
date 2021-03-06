//
//  YIBaseViewController.m
//  Dobby
//
//  Created by efeng on 14-5-17.
//  Copyright (c) 2014年 weiboyi. All rights reserved.
//

//#import "UMFeedbackViewController.h"
//#import "DemoMessagesViewController.h"


@interface YIBaseViewController ()

@end

@implementation YIBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"宝宝记";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
    // register for keyboard notifications
    [mNotificationCenter addObserver:self
                            selector:@selector(keyboardWillShow:)
                                name:UIKeyboardWillShowNotification
                              object:self.view.window];
    // register for keyboard notifications
    [mNotificationCenter addObserver:self
                            selector:@selector(keyboardWillHide:)
                                name:UIKeyboardWillHideNotification
                              object:self.view.window];

#if DEBUG
	if (self.rdv_tabBarController) {
		self.rdv_tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FLEX" style:UIBarButtonItemStylePlain target:self action:@selector(flexButtonTapped:)];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"FLEX" style:UIBarButtonItemStylePlain target:self action:@selector(flexButtonTapped:)];
	}
#endif
	
	
}

#if DEBUG
- (void)flexButtonTapped:(id)sender {
    [[FLEXManager sharedManager] showExplorer];
}
#endif

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass(self.class)];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideKeyboard:nil];
}

#pragma mark - keyboard selector
/**
 *  隐藏键盘
 */
- (void)hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)n {
    _keyboardIsShown = YES;
}

- (void)keyboardWillHide:(NSNotification *)n {
    _keyboardIsShown = NO;
}

#pragma mark -

#pragma mark - MBProgressHUD 相关方法

- (void)showLoadingView {
    [self hideKeyboard:nil];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)showLoadingViewToWindow {
    [self hideKeyboard:nil];
    HUD = [MBProgressHUD showHUDAddedTo:[mAppDelegate window] animated:YES];
}

- (void)showLoadingViewNoInteraction {
    [self hideKeyboard:nil];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.userInteractionEnabled = NO;
}

- (void)hideLoadingView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)hideLoadingViewToWindow {
    [MBProgressHUD hideHUDForView:self.view.window animated:YES];
}

- (void)showLoadingViewWithText:(NSString *)text {
    [self hideKeyboard:nil];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = text;
}

- (void)showLoadingViewDefaultText {
    [self hideKeyboard:nil];
    [self showLoadingViewWithText:@"正在加载中..."];
}

#pragma mark -

- (void)feedbackAction:(id)sender {
//    [MobClick event:CLICK_FEEDBACK_ENTER];

}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}

@end
