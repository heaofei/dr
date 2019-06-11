//
//  DRGoodCommentTableViewCell.m
//  dr
//
//  Created by 毛文豪 on 2017/7/16.
//  Copyright © 2017年 JG. All rights reserved.
//

#import "DRGoodCommentTableViewCell.h"

@interface DRGoodCommentTableViewCell ()

@property (nonatomic, weak) UIImageView * avatarImageView;
@property (nonatomic, weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * floorLabel;
@property (nonatomic, weak) UILabel * commentLabel;

@end

@implementation DRGoodCommentTableViewCell

+ (DRGoodCommentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GoodCommentTableViewCellId";
    DRGoodCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[DRGoodCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(self.nickNameLabel.x, 0, screenWidth - self.nickNameLabel.x, 1)];
    self.line = line;
    line.backgroundColor = DRWhiteLineColor;
    [self addSubview:line];
    
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DRMargin, 10, 36, 36)];
    self.avatarImageView = avatarImageView;
    avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [self addSubview:avatarImageView];
    
    //店名
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.font = [UIFont systemFontOfSize:DRGetFontSize(26)];
    nickNameLabel.textColor = DRBlackTextColor;
    [self addSubview:nickNameLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:DRGetFontSize(22)];
    timeLabel.textColor = DRGrayTextColor;
    [self addSubview:timeLabel];
    
    //楼
    UILabel * floorLabel = [[UILabel alloc] init];
    self.floorLabel = floorLabel;
    floorLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    floorLabel.textColor = DRGrayTextColor;
    floorLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:floorLabel];
    
    //评论
    UILabel * commentLabel = [[UILabel alloc] init];
    self.commentLabel = commentLabel;
    commentLabel.font = [UIFont systemFontOfSize:DRGetFontSize(24)];
    commentLabel.textColor = DRBlackTextColor;
    commentLabel.numberOfLines = 0;
    [self addSubview:commentLabel];
}
- (void)setModel:(DRGoodCommentModel *)model
{
    _model = model;
    
    NSString * avatarUrlStr = [NSString stringWithFormat:@"%@%@",baseUrl,_model.userHeadImg];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarUrlStr] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.nickNameLabel.text = _model.userNickName;
    
    self.timeLabel.text = _model.timeStr;
    
    self.floorLabel.text = [NSString stringWithFormat:@"%ld楼",_model.floor];
    
    self.commentLabel.text = _model.content;
    
    //frame
    self.nickNameLabel.frame = _model.nickNameLabelF;
    self.timeLabel.frame = _model.timeLabelF;
    self.floorLabel.frame = _model.floorLabelF;
    self.commentLabel.frame = _model.commentLabelF;
}

@end
