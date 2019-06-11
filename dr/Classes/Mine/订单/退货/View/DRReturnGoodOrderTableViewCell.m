//
//  DRReturnGoodOrderTableViewCell.m
//  dr
//
//  Created by 毛文豪 on 2017/7/5.
//  Copyright © 2017年 JG. All rights reserved.
//

#import "DRReturnGoodOrderTableViewCell.h"

@interface DRReturnGoodOrderTableViewCell ()

@property (nonatomic, weak) UIImageView *goodImageView;//商品图片
@property (nonatomic, weak) UILabel *goodNameLabel;//商品名称
@property (nonatomic,weak) UILabel * goodPriceLabel;
@property (nonatomic,weak) UIButton *returnGoodButton;

@end

@implementation DRReturnGoodOrderTableViewCell

+ (DRReturnGoodOrderTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ReturnGoodOrderTableViewCellId";
    DRReturnGoodOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[DRReturnGoodOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return  cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    self.line = line;
    line.backgroundColor = DRWhiteLineColor;
    [self addSubview:line];
    
    //商品图片
    UIImageView * goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DRMargin, 12, 76, 76)];
    self.goodImageView = goodImageView;
    goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    goodImageView.layer.masksToBounds = YES;
    [self addSubview:goodImageView];
    
    //商品名称
    UILabel * goodNameLabel = [[UILabel alloc] init];
    self.goodNameLabel = goodNameLabel;
    goodNameLabel.textColor = DRBlackTextColor;
    goodNameLabel.numberOfLines = 0;
    goodNameLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    [self addSubview:goodNameLabel];
    
    //商品价格
    UILabel * goodPriceLabel = [[UILabel alloc] init];
    self.goodPriceLabel = goodPriceLabel;
    goodPriceLabel.textColor = DRRedTextColor;
    goodPriceLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    [self addSubview:goodPriceLabel];
    
    //退款
    UIButton *returnGoodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.returnGoodButton = returnGoodButton;
    CGFloat returnGoodButtonW = 70;
    CGFloat returnGoodButtonH = 26;
    self.returnGoodButton.frame = CGRectMake(screenWidth - DRMargin - returnGoodButtonW, CGRectGetMaxY(self.goodImageView.frame) - returnGoodButtonH, returnGoodButtonW, returnGoodButtonH);
    returnGoodButton.backgroundColor = DRDefaultColor;
    [returnGoodButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [returnGoodButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    returnGoodButton.titleLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    [returnGoodButton addTarget:self action:@selector(returnGoodButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    returnGoodButton.layer.masksToBounds = YES;
    returnGoodButton.layer.cornerRadius = 4;
    [self addSubview:returnGoodButton];
}
- (void)returnGoodButtonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(returnGoodOrderTableViewCell:returnGoodButtonDidClick:)]) {
        [_delegate returnGoodOrderTableViewCell:self returnGoodButtonDidClick:button];
    }
}
- (void)setCommentGoodModel:(DRCommentGoodModel *)commentGoodModel
{
    _commentGoodModel = commentGoodModel;
    
    NSString * urlStr = [NSString stringWithFormat:@"%@%@%@",baseUrl,_commentGoodModel.goods.spreadPics,smallPicUrl];
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    CGFloat goodNameLabelX = CGRectGetMaxX(self.goodImageView.frame) + 10;
    if (DRStringIsEmpty(_commentGoodModel.goods.description_)) {
        self.goodNameLabel.text = _commentGoodModel.goods.name;
        
        CGSize goodNameLabelSize = [self.goodNameLabel.text sizeWithFont:self.goodNameLabel.font maxSize:CGSizeMake(screenWidth - goodNameLabelX - 2 * DRMargin, MAXFLOAT)];
        self.goodNameLabel.frame = CGRectMake(goodNameLabelX, self.goodImageView.y + 3, goodNameLabelSize.width, goodNameLabelSize.height);
    }else
    {
        NSMutableAttributedString * nameAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _commentGoodModel.goods.name, _commentGoodModel.goods.description_]];
        [nameAttStr addAttribute:NSFontAttributeName value:self.goodNameLabel.font range:NSMakeRange(0, nameAttStr.length)];
        [nameAttStr addAttribute:NSForegroundColorAttributeName value:DRBlackTextColor range:NSMakeRange(0, _commentGoodModel.goods.name.length)];
        [nameAttStr addAttribute:NSForegroundColorAttributeName value:DRGrayTextColor range:NSMakeRange( _commentGoodModel.goods.name.length, nameAttStr.length - _commentGoodModel.goods.name.length)];
        self.goodNameLabel.attributedText = nameAttStr;
        
        CGSize goodNameLabelSize = [self.goodNameLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - goodNameLabelX - 2 * DRMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.goodNameLabel.frame = CGRectMake(goodNameLabelX, self.goodImageView.y + 3, goodNameLabelSize.width, goodNameLabelSize.height);
    }
    
    self.goodPriceLabel.text = [NSString stringWithFormat:@"¥%@", [DRTool formatFloat:[_commentGoodModel.priceCount doubleValue] / 100]];

    if ([_commentGoodModel.refundStatus intValue] == 0) {
        self.returnGoodButton.backgroundColor = DRDefaultColor;
        self.returnGoodButton.enabled = YES;
        [self.returnGoodButton setTitle:@"申请退款" forState:UIControlStateNormal];
    }else
    {
        self.returnGoodButton.backgroundColor = [UIColor lightGrayColor];
        self.returnGoodButton.enabled = NO;
        if ([_commentGoodModel.refundStatus intValue] == 10) {
            [self.returnGoodButton setTitle:@"待审核退款" forState:UIControlStateNormal];
        }else if ([_commentGoodModel.refundStatus intValue] == 20) {
            [self.returnGoodButton setTitle:@"审核通过" forState:UIControlStateNormal];
        }else if ([_commentGoodModel.refundStatus intValue] == -1) {
            [self.returnGoodButton setTitle:@"驳回" forState:UIControlStateNormal];
        }else if ([_commentGoodModel.refundStatus intValue] == 100) {
            [self.returnGoodButton setTitle:@"已退款" forState:UIControlStateNormal];
        }else
        {
            [self.returnGoodButton setTitle:@"未知状态" forState:UIControlStateNormal];
            [self.returnGoodButton setTitleColor:DRGrayTextColor forState:UIControlStateNormal];
        }
    }
    
    CGSize goodPriceLabelSize = [self.goodPriceLabel.text sizeWithLabelFont:self.goodPriceLabel.font];
    CGFloat goodPriceLabelX = self.goodNameLabel.x;
    self.goodPriceLabel.frame = CGRectMake(goodPriceLabelX, CGRectGetMaxY(self.goodImageView.frame) - 3 - goodPriceLabelSize.height, goodPriceLabelSize.width, goodPriceLabelSize.height);
}

@end
