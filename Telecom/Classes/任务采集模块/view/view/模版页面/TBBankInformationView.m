//
//  TBBankInformationView.m
//  Telecom
//
//  Created by 王小腊 on 2018/1/3.
//  Copyright © 2018年 王小腊. All rights reserved.
//

#import "TBBankInformationView.h"
#import "TBBankListCellView.h"
#import "ZKPickDataView.h"
#import "TBBasicDataTool.h"
#import "ZKUtil.h"
@interface TBBankInformationView()<TBBankListCellViewDelegate,ZKPickDataViewDelegate>

@property (nonatomic, strong) NSArray <TBBankMerchantsTypeData *>*typeArray;

@end

@implementation TBBankInformationView
{
    TBBankListCellView *_cardNameView;//身份证姓名
    TBBankListCellView *_cardPhoneView;//身份证号码
    TBBankListCellView *_bankCardView;//农业银行卡号
    TBBankListCellView *_businessTypeView;//商家经营类型
    TBBankListCellView *_socialCodingView;//社会信用编码
    NSString           *_shop_class_id;// 商家经营类型id
    TBBankMerchantsTypeData *_typeMode;
    
}
- (instancetype)init;
{
    self = [super init];
    
    if (self) {
        
        
        [self createTableView];
        [self setBankData];
    }
    
    return self;
    
}
#pragma mark  ----数据设置----
- (void)setBankData
{
    TBWeakSelf
    [TBBasicDataTool initBankMerchantsTypeData:^(NSArray<TBBankMerchantsTypeData *> * data) {
        weakSelf.typeArray = data;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf updataMerchantsType];
        }];
    }];
}
#pragma mark  ----视图创建----
-(void)createTableView
{
    CGFloat cellHeight = 44.0f;
    
    UIView *listView = [[UIView alloc] init];
    listView.backgroundColor = [UIColor whiteColor];
    [self.contenView addSubview:listView];
    
    UIButton *promptTagView = [UIButton buttonWithType:UIButtonTypeCustom];
    [promptTagView setTitle:@" 农业银行一码付资料填写" forState:UIControlStateNormal];
    [promptTagView setImage:[UIImage imageNamed:@"task_bt"] forState:UIControlStateNormal];
    [promptTagView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    promptTagView.titleLabel.font = [UIFont systemFontOfSize:15];
    [listView addSubview:promptTagView];
    
    _cardNameView = [[TBBankListCellView alloc] initTextFieldType:UIKeyboardTypeDefault fieldPlaceholder:@"请填写真实姓名" cellLeftText:@"身份证姓名"];
    _cardNameView.delegate = self;
    [listView addSubview:_cardNameView];
    
    _cardPhoneView = [[TBBankListCellView alloc] initTextFieldType:UIKeyboardTypePhonePad fieldPlaceholder:@"请填写身份证号码" cellLeftText:@"身份证号码"];
    _cardPhoneView.delegate = self;
    [listView addSubview:_cardPhoneView];
    
    _bankCardView = [[TBBankListCellView alloc] initTextFieldType:UIKeyboardTypeNumberPad fieldPlaceholder:@"请填写银行卡号" cellLeftText:@"农业银行卡号"];
    _bankCardView.delegate = self;
    [listView addSubview:_bankCardView];
    
    _businessTypeView = [[TBBankListCellView alloc] initTextFieldType:UIKeyboardTypeDefault fieldPlaceholder:@"请选择类型" cellLeftText:@"商家经营类型"];
    _businessTypeView.delegate = self;
    [_businessTypeView addClickCoveringView];
    [listView addSubview:_businessTypeView];
    
    UIView *dividerW = [self createDividerView];
    [listView addSubview:dividerW];
    
    UIView *dividerT = [self createDividerView];
    [listView addSubview:dividerT];
    
    UIView *dividerS = [self createDividerView];
    [listView addSubview:dividerS];
    
    UIView *dividerF = [self createDividerView];
    [listView addSubview:dividerF];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contenView addSubview:bottomView];
    
    _socialCodingView = [[TBBankListCellView alloc] initTextFieldType:UIKeyboardTypeNamePhonePad fieldPlaceholder:@"选填" cellLeftText:@"社会信用编码"];
    [bottomView addSubview:_socialCodingView];
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.text = @"提示：如果需要增加额度需要填写社会信用编码验证";
    [bottomView addSubview:promptLabel];
    
    TBWeakSelf
    
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(weakSelf.contenView);
        make.height.mas_equalTo(cellHeight*5);
    }];
    [promptTagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(listView.mas_left).offset(10);
        make.top.equalTo(listView.mas_top);
        make.height.mas_equalTo(cellHeight);
    }];
    
    [_cardNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(listView);
        make.height.mas_equalTo(cellHeight);
        make.top.equalTo(listView.mas_top).offset(cellHeight *1);
    }];
    [_cardPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(listView);
        make.height.mas_equalTo(cellHeight);
        make.top.equalTo(listView.mas_top).offset(cellHeight *2);
    }];
    [_bankCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(listView);
        make.height.mas_equalTo(cellHeight);
        make.top.equalTo(listView.mas_top).offset(cellHeight *3);
    }];
    [_businessTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(listView);
        make.height.mas_equalTo(cellHeight);
        make.top.equalTo(listView.mas_top).offset(cellHeight *4);
    }];
    
    [dividerW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(listView);
        make.height.equalTo(@0.5);
        make.top.equalTo(listView.mas_top).offset(cellHeight *1);
    }];
    [dividerT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(listView);
        make.left.equalTo(listView.mas_left).offset(10);
        make.height.equalTo(@0.5);
        make.top.equalTo(listView.mas_top).offset(cellHeight *2);
    }];
    [dividerS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(listView);
        make.left.equalTo(listView.mas_left).offset(10);
        make.height.equalTo(@0.5);
        make.top.equalTo(listView.mas_top).offset(cellHeight *3);
    }];
    [dividerF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(listView);
        make.left.equalTo(listView.mas_left).offset(10);
        make.height.equalTo(@0.5);
        make.top.equalTo(listView.mas_top).offset(cellHeight *4);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.contenView);
        make.bottom.equalTo(weakSelf.contenView.mas_bottom).offset(-1);
        make.top.equalTo(listView.mas_bottom).offset(10);
    }];
    [_socialCodingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bottomView);
        make.height.mas_equalTo(cellHeight);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(20);
        make.top.equalTo(_socialCodingView.mas_bottom).offset(20);
    }];
}

/**
 分割线创建
 
 @return view
 */
- (UIView *)createDividerView
{
    UIView *dividerView = [[UIView alloc] init];
    dividerView.backgroundColor = BODER_COLOR;
    return dividerView;
}

#pragma mark  ----TBBankListCellViewDelegate----
/**
 输入框编辑结束
 */
- (void)textFieldEditEnd;
{
    [self checkWhetherTheUploadIsPrompt:YES];
}
/**
 覆盖视图被点击
 */
- (void)coveringViewClick;
{
    [self endEditing:YES];
    if (self.typeArray.count == 0) {
        [UIView addMJNotifierWithText:@"数据暂未加载" dismissAutomatically:YES];
    }
    else
    {
        ZKPickDataView *view = [[ZKPickDataView alloc] initData:self.typeArray typeName:@"商家经营类型" type:(PickDataViewTypeBank)];
        view.delegate = self;
        [view showSelectedData:_typeMode.ID];
    }
}
#pragma mark  ----ZKPickDataViewDelegate----
- (void)selectedData:(TBBankMerchantsTypeData *)data;
{
    _typeMode = data;
    _businessTypeView.textField.text = data.shop_class_name;
    _shop_class_id = data.shop_class_id;
    [self checkWhetherTheUploadIsPrompt:YES];
}
#pragma mark  ----fun----
/**
 更新商家类型
 */
- (void)updataMerchantsType
{
    if (_shop_class_id.length == 0) {
        return;
    }
    [self.typeArray enumerateObjectsUsingBlock:^(TBBankMerchantsTypeData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.shop_class_id isEqualToString:_shop_class_id]) {
            
            _typeMode = obj;
            _businessTypeView.textField.text = _typeMode.shop_class_name;
            _shop_class_id = _typeMode.shop_class_id;
        }
    }];
}

/**
 检查是否上传
 */
- (void)checkWhetherTheUploadIsPrompt:(BOOL)prompt
{
    if (_cardNameView.textField.text.length >0 &&
        _cardPhoneView.textField.text.length >0 &&
        _bankCardView.textField.text.length >0 &&
        _businessTypeView.textField.text.length >0) {
        
        if (![ZKUtil checkIsIdentityCard:_cardPhoneView.textField.text]) {
            self.makingList.bankMeg = @"error";
            prompt == NO ? :[ZKUtil shakeAnimationForView:_cardPhoneView];
            prompt == NO ? :[UIView addMJNotifierWithText:@"身份证填写有误" dismissAutomatically:YES];
        }
        else if (![ZKUtil checkCardNo:_bankCardView.textField.text])
        {
            self.makingList.bankMeg = @"error";
           prompt == NO ? : [ZKUtil shakeAnimationForView:_bankCardView];
            prompt == NO ? :[UIView addMJNotifierWithText:@"银行卡填写有误" dismissAutomatically:YES];
        }
        else
        {
          self.makingList.bankMeg = @"";
        }
    }
    else
    {
          self.makingList.bankMeg = @"no";
    }
}
- (NSString *)validationNull:(NSString *)str
{
    return str.length == 0?@"":str;
}
#pragma mark  ----父类方法----
/**
 数据更新
 
 @param makingList 数据
 @return 标题字典
 */
- (NSDictionary *)updataData:(TBMakingListMode *)makingList;
{
    self.makingList = makingList;
    NSDictionary *dic = makingList.bankDic;
    if (makingList.bankDic.count > 0)
    {
        _cardNameView.textField.text = [dic valueForKey:@"idcard"];//身份证姓名
        _cardPhoneView.textField.text = [dic valueForKey:@"idcardname"];//身份证号码
        _bankCardView.textField.text = [dic valueForKey:@"abcbanknum"];//农业银行卡号
        _socialCodingView.textField.text = [dic valueForKey:@"abcbankcredit"];//社会信用编码
        _shop_class_id = [dic valueForKey:@"abcbanktype"];// 商家经营类型id
        
        [self updataMerchantsType];
    }
     return @{@"name":@"农行资料",@"prompt":@""};
}
/**
 数据提交
 
 @param prompt 是否提示
 @return yes 可以进行下一步
 */
- (BOOL)updataMakingIsPrompt:(BOOL)prompt;
{
    NSDictionary *dic = @{@"idcard":[self validationNull:_cardNameView.textField.text],
                          @"idcardname":[self validationNull:_cardPhoneView.textField.text],
                          @"abcbanknum":[self validationNull:_bankCardView.textField.text],
                          @"abcbanktype":[self validationNull:_shop_class_id],
                          @"abcbankcredit":[self validationNull:_socialCodingView.textField.text],
                          };
    self.makingList.bankDic = dic;
    
    self.makingList.bankMeg = @"";
    [self checkWhetherTheUploadIsPrompt:prompt];
    
    return ![self.makingList.bankMeg isEqualToString:@"error"];
}

@end
