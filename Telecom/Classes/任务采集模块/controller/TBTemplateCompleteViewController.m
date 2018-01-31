//
//  TBTemplateCompleteViewController.m
//  Telecom
//
//  Created by 王小腊 on 2017/3/18.
//  Copyright © 2017年 王小腊. All rights reserved.
//

#import "TBTemplateCompleteViewController.h"
#import "UIBarButtonItem+Custom.h"
#import "TBManagementTypeViewController.h"
#import "TBFinancialActivateViewController.h"
#import "TBMoreReminderView.h"
#import "TBChoosePhotosTool.h"
#import "TBWebViewController.h"
#import "TBMakingListMode.h"
#import "TBTaskListMode.h"
#import "LBXScanWrapper.h"
#import "TBBasicDataTool.h"
#import "TBChoosePhotosTool.h"
@interface TBTemplateCompleteViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;

@property (weak, nonatomic) IBOutlet UILabel *adderssLabel;
// 二维码
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

@property (weak, nonatomic) IBOutlet UIButton *priceTagButton;

@property (strong, nonatomic) NSString *ID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptHeight;
@property (weak, nonatomic) IBOutlet UIView *lefView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *productButton;
@property (weak, nonatomic) IBOutlet UILabel *productLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrCodeViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrCodeViewHeight;
@property (assign ,nonatomic) CGFloat qrCodeViewSize;
@property (strong, nonatomic) TBTaskListRoot *list;
@end

@implementation TBTemplateCompleteViewController
{
    TBChoosePhotosTool * _tool;
}
- (TBTaskListRoot *)list
{
    if (!_list) {
        _list = [[TBTaskListRoot alloc] init];
    }
    return _list;
}
- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"制作完成";
    [self financialActivate];
    [self updateUI];
    [self postQrCodeImage];
    
}
#pragma mark  ----去云金融激活----
- (void)financialActivate
{ // 贵州无激活页面
    if (![[UserInfo account].code isEqualToString:GZ_CODE])
    {
        if (![self.makingModel.isbind isEqualToString:@"1"] && self.makingModel.modelsID != 5)
        {
            TBFinancialActivateViewController *vc = [[TBFinancialActivateViewController alloc] initMerchantsPhone:[self.makingModel.infoDic valueForKey:@"phone"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
#pragma mark  ---- 赋值 ---
- (void)updateUI
{
    if (_SCREEN_WIDTH <330)
    {
        self.qrCodeViewSize = _SCREEN_WIDTH*0.24;
    }
    else
    {
      self.qrCodeViewSize = _SCREEN_WIDTH*0.34;
    }

    //  价格为0则隐藏
    self.priceTagButton.hidden = YES;
    [TBBasicDataTool initPackageData:^(NSArray<TBPackageData *> *array) {

        TBWeakSelf
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            __block  NSString *strName = @"";
            [array enumerateObjectsUsingBlock:^(TBPackageData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if (weakSelf.makingModel.modelsID == obj.ID)
                {
                    strName = [NSString stringWithFormat:@"  %@元套餐    ",obj.price];
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (strName.length > 0)
                {
                    [self.priceTagButton setTitle:strName forState:UIControlStateNormal];
                    weakSelf.priceTagButton.hidden = NO;
                }

            });
        });
 
        
    }];

    self.qrCodeViewHeight.constant = self.qrCodeViewWidth.constant = self.qrCodeViewSize;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem setRitWithTitel:@"返回" itemWithIcon:@"nav_back" target:self action:@selector(goBack)];
     NSString *image = @"";
     NSString *name = @"";
     NSString *type = @"";
     NSString *phone = @"";
     NSString *address = @"";

     BOOL isService = [self.makingModel.type isEqualToString:@"service"];
    // 服务场所
    if (isService == YES)
    {
        image = self.makingModel.images.firstObject;
        name = [self.makingModel.infoDic valueForKey:@"name"];
        type = @"服务场所";
        phone = [self.makingModel.infoDic valueForKey:@"tel"];
        address = [self.makingModel.infoDic valueForKey:@"address"];
        [self showProduct:NO];
    }
    else
    {
        image = self.makingModel.bossHeaderImageUrl.length>0?self.makingModel.bossHeaderImageUrl:self.makingModel.coverPhotoUrl;
        
        name = [self.makingModel.infoDic valueForKey:@"name"];
        type = [self.makingModel.infoDic valueForKey:@"taskType"];
        phone = [self.makingModel.infoDic valueForKey:@"tel"];
        address = [self.makingModel.infoDic valueForKey:@"address"];
        // 其它类型
        self.ID = [NSString stringWithFormat:@"%ld",(long)self.makingModel.merchantsID];
        
        self.list.name = name;
        self.list.logo = image;
        self.list.logo2 = image;
        self.list.ID = self.makingModel.merchantsID;
        self.list.address = address;
        self.list.tel = phone;
        [self showProduct:YES];
    }
   
    
    self.promptHeight.constant = isService?0.001f:30.0f;
    self.lefView.hidden = self.rightView.hidden = isService;
    [ZKUtil downloadImage:self.backImageView imageUrl:image duImageName:@"homeDefault"];
    
    self.typeLabel.text = type;
    self.nameLabel.text = name;
    self.telLabel.text = phone;
    self.adderssLabel.text = address;

    _tool = [[TBChoosePhotosTool alloc] init];
    // 二维码添加手势
    self.qrCodeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *zer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeImageViewTapGesture)];
    zer.numberOfTapsRequired = 1;
    [self.qrCodeImageView addGestureRecognizer:zer];
    

}

/**
 产品管理是否打开

 @param type bool
 */
- (void)showProduct:(BOOL)type
{
    [self.productButton setImage:[UIImage imageNamed:type?@"icon_card_manager":@"over_kq_hidden"] forState:UIControlStateNormal];
    self.productButton.userInteractionEnabled = type;
    self.productLabel.textColor = type?[UIColor grayColor]:[UIColor lightGrayColor];
}
/**
 请求微信二维码
 */
- (void)postQrCodeImage
{

    hudShowLoading(@"二维码加载中...");
    NSString *codeUrl = [NSString stringWithFormat:@"http://myshop.weixin.geeker.com.cn/focusus.do?shopid=%ld",(long)self.makingModel.merchantsID];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *serviceImage = [LBXScanWrapper createQRWithString:codeUrl size:CGSizeMake(_SCREEN_WIDTH, _SCREEN_WIDTH)];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (serviceImage)
            {
                hudDismiss();

                self.qrCodeImageView.image = serviceImage;
            }else {
                hudShowError(@"请重试");
            }
        });
    });
//    qrCode

}
#pragma mark --- 点击事件 ---

- (IBAction)previewClick:(id)sender
{
    if (self.list)
    {
        TBWebViewController *vc = [[TBWebViewController alloc] init];
        [vc loadWebURLSring:HTML_URL(self.ID.integerValue)];
        vc.root = self.list;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)editorClick:(id)sender
{
    TBWeakSelf
    TBMoreReminderView *more = [[TBMoreReminderView alloc] initShowPrompt:@"亲，是否重新编辑当前模板?"];
    [more showHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
}
//卡券
- (IBAction)voucherClick:(id)sender
{
    TBManagementTypeViewController *vc = [[TBManagementTypeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)qrCodeImageViewTapGesture
{
    [_tool showPreviewPhotosArray:@[self.qrCodeImageView.image] baseView:self.qrCodeImageView selected:0];
}
- (void)goBack
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
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
