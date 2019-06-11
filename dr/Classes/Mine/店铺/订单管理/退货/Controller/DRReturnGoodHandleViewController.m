//
//  DRReturnGoodHandleViewController.m
//  dr
//
//  Created by 毛文豪 on 2017/6/27.
//  Copyright © 2017年 JG. All rights reserved.
//

#import "DRReturnGoodHandleViewController.h"
#import "DRShowMultipleImageView.h"
#import "DRTextView.h"
#import "DRReturnGoodModel.h"
#import "XLPhotoBrowser.h"

@interface DRReturnGoodHandleViewController ()<ShowMultipleImageViewDelegate, XLPhotoBrowserDatasource>

@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UILabel * statusLabel;
@property (nonatomic,weak) UIImageView * goodImageView;
@property (nonatomic,weak) UILabel * goodNameLabel;
@property (nonatomic,weak) UILabel * goodPriceLabel;
@property (nonatomic, weak) UITextField * countTF;
@property (nonatomic, weak) UITextField * moneyTF;
@property (nonatomic, weak) DRTextView *detailTV;
@property (nonatomic,weak) DRShowMultipleImageView * showImageView;
@property (nonatomic,weak) UIView *memoView;
@property (nonatomic, weak) DRTextView *memoTV;
@property (nonatomic,strong) DRReturnGoodModel * returnGoodModel;

@end

@implementation DRReturnGoodHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"退款处理";
    [self getData];
    [self setupChilds];
}
- (void)getData
{
    if (DRStringIsEmpty(self.returnGoodId)) {
        return;
    }
    
    NSDictionary *bodyDic = @{
                              @"id":self.returnGoodId,
                              };
    
    NSDictionary *headDic = @{
                              @"digest":[DRTool getDigestByBodyDic:bodyDic],
                              @"cmd":@"S28",
                              @"userId":UserId,
                              };
    [[DRHttpTool shareInstance] postWithTarget:self headDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        if (SUCCESS) {
            DRReturnGoodModel * returnGoodModel = [DRReturnGoodModel mj_objectWithKeyValues:json[@"orderGoodsRefund"]];
            self.returnGoodModel = returnGoodModel;
            [self setData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
    }];
}
- (void)setupChilds
{
    //contentView
    UIScrollView * contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - 45)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    //订单状态
    UIView * statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 67)];
    statusView.backgroundColor = DRDefaultColor;
    [contentView addSubview:statusView];
    
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(DRMargin, 0, screenWidth - 2 * DRMargin, statusView.height)];
    self.statusLabel = statusLabel;
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont systemFontOfSize:DRGetFontSize(30)];
    [statusView addSubview:statusLabel];
    
    //商品详情
    //商品图片
    UIImageView * goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DRMargin, CGRectGetMaxY(statusView.frame) + 7, 76, 76)];
    self.goodImageView = goodImageView;
    goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    goodImageView.layer.masksToBounds = YES;
    [contentView addSubview:goodImageView];
    
    //商品名称
    UILabel * goodNameLabel = [[UILabel alloc] init];
    self.goodNameLabel = goodNameLabel;
    goodNameLabel.textColor = DRBlackTextColor;
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    [contentView addSubview:goodNameLabel];
    
    //商品价格
    UILabel * goodPriceLabel = [[UILabel alloc] init];
    self.goodPriceLabel = goodPriceLabel;
    goodPriceLabel.textColor = DRBlackTextColor;
    goodPriceLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    [contentView addSubview:goodPriceLabel];
    
    //分割线
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(goodImageView.frame) + 7, screenWidth, 1)];
    line1.backgroundColor = DRWhiteLineColor;
    [contentView addSubview:line1];
    
    NSArray * labelTitles = @[@"退款数量", @"退款总额"];
    for (int i = 0; i < labelTitles.count; i++) {
        //选择退款原因
        UILabel * label = [[UILabel alloc] init];
        label.text = labelTitles[i];
        label.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
        label.textColor=DRBlackTextColor;
        CGSize labelSize = [label.text sizeWithLabelFont:label.font];
        label.frame = CGRectMake(DRMargin, CGRectGetMaxY(line1.frame) + DRCellH * i, labelSize.width, DRCellH);
        [contentView addSubview:label];
        
        UITextField * textField = [[UITextField alloc] init];
        if (i == 0) {
            self.countTF = textField;
        }else
        {
            self.moneyTF = textField;
        }
        CGFloat textFieldX = CGRectGetMaxX(label.frame) + DRMargin;
        textField.frame = CGRectMake(textFieldX, CGRectGetMaxY(line1.frame) + DRCellH * i, screenWidth - textFieldX - DRMargin, DRCellH);
        textField.textColor = DRBlackTextColor;
        textField.textAlignment = NSTextAlignmentRight;
        textField.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
        textField.tintColor = DRDefaultColor;
        textField.userInteractionEnabled = NO;
        [contentView addSubview:textField];
        
        //分割线
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame) + (DRCellH - 1) * (i + 1), screenWidth, 1)];
        line2.backgroundColor = DRWhiteLineColor;
        [contentView addSubview:line2];
    }
    
    //退款说明
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"退款说明";
    detailLabel.textColor = DRBlackTextColor;
    detailLabel.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
    CGSize detailLabelSize = [detailLabel.text sizeWithLabelFont:detailLabel.font];
    detailLabel.frame = CGRectMake(DRMargin, 9 + CGRectGetMaxY(line1.frame) + 2 * DRCellH, detailLabelSize.width, detailLabelSize.height);
    [contentView addSubview:detailLabel];
    
    //退款描述
    DRTextView *detailTV = [[DRTextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(detailLabel.frame) + 1, screenWidth - 2 * 5, 100)];
    self.detailTV = detailTV;
    detailTV.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
    detailTV.textColor = DRBlackTextColor;
    detailTV.tintColor = DRDefaultColor;
    detailTV.userInteractionEnabled = NO;
    [contentView addSubview:detailTV];
    
    //添加图片
    DRShowMultipleImageView * showImageView = [[DRShowMultipleImageView alloc] init];
    self.showImageView = showImageView;
    showImageView.frame = CGRectMake(0, CGRectGetMaxY(detailTV.frame), screenWidth, [showImageView getViewHeight]);
    showImageView.titleLabel.text = @"退款截图";
    showImageView.delegate = self;
    showImageView.height = [showImageView getViewHeight];
    [contentView addSubview:showImageView];
    
    //分割线
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line3.backgroundColor = DRWhiteLineColor;
    [showImageView addSubview:line3];
    
    //卖家备注
    UIView * memoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(showImageView.frame), screenWidth, 0)];
    self.memoView = memoView;
    memoView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:memoView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView.backgroundColor = DRBackgroundColor;
    [memoView addSubview:lineView];
    
    //备注
    UILabel * memoLabel = [[UILabel alloc] init];
    memoLabel.text = @"备注";
    memoLabel.textColor = DRBlackTextColor;
    memoLabel.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
    CGSize memoLabelSize = [memoLabel.text sizeWithLabelFont:memoLabel.font];
    memoLabel.frame = CGRectMake(DRMargin, CGRectGetMaxY(lineView.frame), memoLabelSize.width, 9 + memoLabelSize.height);
    [memoView addSubview:memoLabel];
    
    //备注
    DRTextView *memoTV = [[DRTextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(memoLabel.frame) + 1, screenWidth - 2 * 5, 100)];
    self.memoTV = memoTV;
    memoTV.font = [UIFont systemFontOfSize:DRGetFontSize(28)];
    memoTV.textColor = DRBlackTextColor;
    memoTV.tintColor = DRDefaultColor;
    memoTV.myPlaceholder = @"备注";
    memoTV.maxLimitNums = 100;
    [memoView addSubview:memoTV];
    memoView.height = CGRectGetMaxY(memoTV.frame);
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(0, memoView.height - 1, screenWidth, 1)];
    line4.backgroundColor = DRWhiteLineColor;
    [memoView addSubview:line4];
    
    contentView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(memoView.frame));    
    //底部按钮
    NSArray * buttonTitles = @[@"不同意",@"同意"];
    for (int i = 0; i < buttonTitles.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(screenWidth / 2 * i, CGRectGetMaxY(contentView.frame), screenWidth / 2, 45);
        button.adjustsImageWhenHighlighted = NO;
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:DRBlackTextColor forState:UIControlStateNormal];
        }else
        {
            button.backgroundColor = DRDefaultColor;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:DRGetFontSize(30)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    UIView * line5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame), screenWidth, 1)];
    line5.backgroundColor = DRWhiteLineColor;
    [self.view addSubview:line5];
}
- (void)setData
{
    if ([self.returnGoodModel.status intValue] == 0) {
        self.statusLabel.text = @"未申请退款";
    }else if ([self.returnGoodModel.status intValue] == 10) {
        self.statusLabel.text = @"待审核退款";
    }else if ([self.returnGoodModel.status intValue] == 20) {
        self.statusLabel.text = @"审核通过";
    }else if ([self.returnGoodModel.status intValue] == -1) {
        self.statusLabel.text = @"驳回";
    }else if ([self.returnGoodModel.status intValue] == 100) {
        self.statusLabel.text = @"已退款";
    }else
    {
        self.statusLabel.text = @"未知状态";
    }
    
    NSString * imageUrlStr = [NSString stringWithFormat:@"%@%@%@",baseUrl,self.returnGoodModel.goods.spreadPics,smallPicUrl];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.goodNameLabel.text = [NSString stringWithFormat:@"%@", self.returnGoodModel.goods.name];
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%@",[DRTool formatFloat:[self.returnGoodModel.goods.price doubleValue] / 100]];
    self.countTF.text = [NSString stringWithFormat:@"%@", self.returnGoodModel.count];
    self.moneyTF.text = [NSString stringWithFormat:@"¥%@",[DRTool formatFloat:[self.returnGoodModel.priceCount doubleValue] / 100]];
    self.detailTV.text = self.returnGoodModel.description_;
    if (!DRArrayIsEmpty(self.returnGoodModel.pictures)) {
        [self.showImageView setImagesWithImageUrlStrs:self.returnGoodModel.pictures];
    }else
    {
        self.showImageView.hidden = YES;
        self.showImageView.height = 0;
    }
    
    //frame
    CGSize goodNameLabelSize = [self.goodNameLabel.text sizeWithLabelFont:self.goodNameLabel.font];
    CGFloat goodNameLabelX = CGRectGetMaxX(self.goodImageView.frame) + 10;
    self.goodNameLabel.frame = CGRectMake(goodNameLabelX, self.goodImageView.y + 3, goodNameLabelSize.width, goodNameLabelSize.height);
    
    CGSize goodPriceLabelSize = [self.goodPriceLabel.text sizeWithLabelFont:self.goodPriceLabel.font];
    CGFloat goodPriceLabelX = goodNameLabelX;
    self.goodPriceLabel.frame = CGRectMake(goodPriceLabelX, CGRectGetMaxY(self.goodImageView.frame) - 3 - goodPriceLabelSize.height, goodPriceLabelSize.width, goodPriceLabelSize.height);
    
    CGSize detailTVSize = [self.detailTV.text sizeWithFont:self.detailTV.font maxSize:CGSizeMake(self.detailTV.width, MAXFLOAT)];
    self.detailTV.height = detailTVSize.height + 2 * 9;
    
    self.showImageView.y = CGRectGetMaxY(self.detailTV.frame);
    self.memoView.y = CGRectGetMaxY(self.showImageView.frame) + 9;
    self.contentView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(self.memoView.frame));
}
- (void)buttonDidClick:(UIButton *)button
{
    if (DRStringIsEmpty(self.memoTV.text) && button.tag == 0)
    {
        [MBProgressHUD showError:@"您还输入备注"];
        return;
    }
    
    NSString * status;
    if (button.tag == 0) {//不同意
        status = @"-1";
    }else//同意
    {
        status = @"20";
    }
    
    NSDictionary * orderGoodsRefund_ = @{
                                        @"id":self.returnGoodModel.id,
                                        @"status":status
                                        };
    NSMutableDictionary *orderGoodsRefund = [NSMutableDictionary dictionaryWithDictionary:orderGoodsRefund_];
    if (!DRStringIsEmpty(self.memoTV.text)) {
        [orderGoodsRefund setObject:self.memoTV.text forKey:@"memo"];
    }
    NSDictionary *bodyDic = @{
                              @"orderGoodsRefund":orderGoodsRefund
                              };
    
    NSDictionary *headDic = @{
                              @"digest":[DRTool getDigestByBodyDic:bodyDic],
                              @"cmd":@"S27",
                              @"userId":UserId,
                              };
    [[DRHttpTool shareInstance] postWithHeadDic:headDic bodyDic:bodyDic success:^(id json) {
        DRLog(@"%@",json);
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"处理退款成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReturnGoodHandleSuccess" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
            
        }
    } failure:^(NSError *error) {
        DRLog(@"error:%@",error);
    }];
}
- (void)imageViewDidClickWithIndex:(NSInteger)index
{
    XLPhotoBrowser * photoBrowser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:self.returnGoodModel.pictures.count datasource:self];
    photoBrowser.browserStyle = XLPhotoBrowserStyleSimple;
}
#pragma mark - XLPhotoBrowserDatasource
- (UIImage *)photoBrowser:(XLPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:@"placeholder"];
}
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSMutableArray *URLArray = [NSMutableArray array];
    NSArray * imageUrls = self.returnGoodModel.pictures;
    for (NSString * imageUrl in imageUrls) {
        NSString * urlStr = [NSString stringWithFormat:@"%@%@",baseUrl, imageUrl];
        [URLArray addObject:[NSURL URLWithString:urlStr]];
    }
    return URLArray[index];
}
- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return self.showImageView.imageViews[index];
}

@end
