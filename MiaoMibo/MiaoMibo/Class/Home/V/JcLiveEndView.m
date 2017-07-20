//
//  JcLiveEndView.m
//  MiaoMibo
//
//  Created by zjc on 2017/7/7.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import "JcLiveEndView.h"
#import "UIView+JcRadius.h"
@interface JcLiveEndView()

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherBtn;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@end

@implementation JcLiveEndView

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.careBtn Jc_setAllCornerWithCornerRadius:20];
    
    self.quitBtn.layer.borderWidth = 1;
    self.quitBtn.layer.borderColor = KeyColor.CGColor;
    
    self.lookOtherBtn.layer.borderWidth = 1;
    self.lookOtherBtn.layer.borderColor = KeyColor.CGColor;
}

+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)care:(UIButton *)sender {
   [self quitAndRemoveView];
}
- (IBAction)lookOther {
    [self quitAndRemoveView];
}
- (IBAction)quit {
    [self quitAndRemoveView];
}
-(void)quitAndRemoveView{
    [self removeFromSuperview];
    if (self.quitBlock) {
        self.quitBlock();
    }
}
@end
