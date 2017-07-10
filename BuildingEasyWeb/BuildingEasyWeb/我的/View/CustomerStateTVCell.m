//
//  CustomerStateTVCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/8.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "CustomerStateTVCell.h"
#import "NSDate+Addition.h"

#import "Global.h"


static NSArray* StatisticStateDescArr;

@interface CustomerStateTVCell()
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UIImageView *imgIntention;
@property (weak, nonatomic) IBOutlet UILabel *intentBuilding;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnSendMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;

@end

@implementation CustomerStateTVCell

- (void)setFrame:(CGRect)frame
{
    //修改cell的左右边距为10;
    //修改cell的Y值下移10;
    //修改cell的高度减少10;
    static CGFloat margin = 12;
    frame.origin.x = margin;
    frame.size.width -= 2 * frame.origin.x;
    frame.origin.y += margin;
    frame.size.height -= 1.5 * margin;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BaobeiInfoModel *)model
{
    if(model.intention == kIntentionLevelWeak) {
        _imgIntention.image = GetIMAGE(@"弱");
    } else if(model.intention == kIntentionLevelMiddle) {
        _imgIntention.image = GetIMAGE(@"中");
    } else {
        _imgIntention.image = GetIMAGE(@"强");
    }
    _customerName.text = model.customerName;
    _intentBuilding.text = model.buildName;
    if(model.invalidDay > 0) {
        _daysLabel.text = [NSString stringWithFormat:@"%li天", (long)model.invalidDay];
    } else {
        _daysLabel.text = @"";
    }
    _dateLabel.text = [NSDate dateStrWithTimeInterval:model.createTime/1000];
    _nowStateLabel.text = model.stateDesc;
}

@end





//    StatisticStateDescArr[kStatisticStateBaobeiBegin    ] = @"发起报备";
//    StatisticStateDescArr[kStatisticStateBaobeiVerify   ] = @"接受审核";
//    StatisticStateDescArr[kStatisticStateBaobeiSucces   ] = @"接受成功";
//    StatisticStateDescArr[kStatisticStateWaitVisit      ] = @"待上门";
//    StatisticStateDescArr[kStatisticStateVisiting       ] = @"系统已确认带看";
//    StatisticStateDescArr[kStatisticStateVisitedVerify  ] = @"上传凭证带看后台审核";
//    StatisticStateDescArr[kStatisticStateVisitedSuccess ] = @"已上门";
//    StatisticStateDescArr[kStatisticStateWaitSubscribe  ] = @"待认购";
//    StatisticStateDescArr[kStatisticStateInSubscribe    ] = @"系统已确认认购";
//    StatisticStateDescArr[kStatisticStateSubscribeVerify] = @"上传凭证后台审核";
//    StatisticStateDescArr[kStatisticStateSubscribed     ] = @"已认购";
//    StatisticStateDescArr[kStatisticStateWaitBuy        ] = @"待签约";
//    StatisticStateDescArr[kStatisticStateBuying         ] = @"系统已确认签约";
//    StatisticStateDescArr[kStatisticStateBuyVerify      ] = @"上传凭证后台审核";
//    StatisticStateDescArr[kStatisticStateBought         ] = @"已签约";
//    StatisticStateDescArr[kStatisticStateWaitPay        ] = @"待回款";
//    StatisticStateDescArr[kStatisticStatePaying         ] = @"系统已确认回款";
//    StatisticStateDescArr[kStatisticStatePayVerify      ] = @"上传凭证回款";
//    StatisticStateDescArr[kStatisticStatePaid           ] = @"已回款";
//    StatisticStateDescArr[kStatisticStateWaitCheckBill  ] = @"待结清";
//    StatisticStateDescArr[kStatisticStateCheckingBill   ] = @"系统已确认结清";
//    StatisticStateDescArr[kStatisticStateCheckBillVerify] = @"上传凭证确认结清";
//    StatisticStateDescArr[kStatisticStateCheckedBill    ] = @"已结清";
//    StatisticStateDescArr[kStatisticStateInvaild        ] = @"失效";



