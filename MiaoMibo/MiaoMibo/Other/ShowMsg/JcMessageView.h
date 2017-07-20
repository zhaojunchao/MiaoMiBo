//
//  JcMessageView.h
//  TheCountdownButton
//
//  Created by zjc on 2017/6/20.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JcMessageView : UIView
+ (JcMessageView *)sharedInstance;
- (void)ShowMessage:(NSString *)msg;
@end
