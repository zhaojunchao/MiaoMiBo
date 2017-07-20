//
//  JcLiveHotModel.h
//  MiaoMibo
//
//  Created by 赵俊超 on 2017/6/28.
//  Copyright © 2017年 zjc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JcLiveHotModel : NSObject
/** 用户ID */
@property (nonatomic , copy) NSString              * userId;
/** 家族名称 */
@property (nonatomic , copy) NSString              * familyName;
@property (nonatomic , copy) NSString              * nationFlag;
/** 主播个性签名 */
@property (nonatomic , copy) NSString              * signatures;
/** 直播星级 */
@property (nonatomic , assign) NSInteger              starlevel;
/** 喵喵号 */
@property (nonatomic , assign) NSInteger              useridx;
/** 是否签约 */
@property (nonatomic , assign) BOOL              isSign;
/** 主播头像URL大图 */
@property (nonatomic , copy) NSString              * bigpic;
/** 主播头像URL小图 */
@property (nonatomic , copy) NSString              * smallpic;
@property (nonatomic , assign) NSInteger              realuidx;
/** 主播昵称 */
@property (nonatomic , copy) NSString              * myname;
/** 直播流地址 */
@property (nonatomic , copy) NSString              * flv;
@property (nonatomic , copy) NSString              * nation;
/** 直播所在的房间号码 */
@property (nonatomic , assign) NSInteger              roomid;
@property (nonatomic , assign) NSInteger              gameid;
@property (nonatomic , assign) NSInteger              curexp;
/** 观看直播的用户数量 */
@property (nonatomic , assign) NSInteger              allnum;
/** 最热直播排行 */
@property (nonatomic , assign) NSInteger              pos;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              level;
/** 级别 */
@property (nonatomic , assign) NSInteger              grade;
@property (nonatomic , assign) NSInteger              distance;
@property (nonatomic , assign) NSInteger              logintype;
/** 直播所在的服务器 */
@property (nonatomic , assign) NSInteger              serverid;
/** 所在城市 */
@property (nonatomic , copy) NSString              * gps;


//额外添加
@property(nonatomic,strong)UIImage *starImage;
@end

