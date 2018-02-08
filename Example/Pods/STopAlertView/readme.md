pod 'STopAlertView', :git => 'https://10.159.46.130/iOS_pods/STopAlertView.git'

example:
       <!-- content里可以进行图文混编，图片名称放入[]里：[图片名称] -->
	STopAlertView *alertView = [[STopAlertView alloc] initWithTitle:@"Alert" contents:@[@"[icon]图文测试"] buttonTitlesArray:@[@"cancel",@"YES",@"NO"]];
        [alertView showWithClickedButton:^(STopAlertView *topAlertView, UIButton *button) {
            [topAlertView disappear];
        } clickedBackground:^(STopAlertView *topAlertView) {
            [topAlertView disappear];
        }];
