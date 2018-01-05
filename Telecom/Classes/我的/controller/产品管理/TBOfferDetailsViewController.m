//
//  TBOfferDetailsViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/4/12.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBOfferDetailsViewController.h"
#import "TBDiscountsMode.h"
@interface TBOfferDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *storesLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulesLabel;
@property (weak, nonatomic) IBOutlet UILabel *effectiveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation TBOfferDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"查看详情";
    [self updataLabelText];

}
- (void)updataLabelText
{

    self.storesLabel.text = [NSString stringWithFormat:@"1.%@",self.mode.shopname];
    NSString *unitString = @"";
    NSString *numberUnit = @"";
    if ([self.mode.type isEqualToString:@"ka"])
    {
        self.cardTypeLabel.text = @"打折卡";
        self.cardStateLabel.text = @"卡券折扣：";
        unitString = @"折";
        numberUnit = @"份";
    }
    else
    {
        self.cardTypeLabel.text = @"抵用券";
        self.cardStateLabel.text = @"卡券额度：";
        unitString = @"元";
        numberUnit = @"张";
    }
    if (self.mode.info.length >0)
    {
        self.infoLabel.text = [NSString stringWithFormat:@"3.%@",self.mode.info];
    }
    self.cardNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.mode.money1.integerValue == 0?self.mode.money:self.mode.money1,unitString];
    
    self.issueNumberLabel.text = [NSString stringWithFormat:@"%@%@",self.mode.num,numberUnit];
    if (self.mode.con.integerValue == 0||self.mode.con.integerValue == 99999)
    {
       self.rulesLabel.text = @"2.不限定金额可使用";
    }
    else
    {
        self.rulesLabel.text = [NSString stringWithFormat:@"2.订单金额满%@元可以使用",self.mode.con];
    }

    self.effectiveTimeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",self.mode.sdate,self.mode.edate];
    self.onlineLabel.text = self.mode.online;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
