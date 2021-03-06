//
//  YIModuleItemView.m
//  BaoBaoJi
//
//  Created by efeng on 11/24/15.
//  Copyright © 2015 buerguo. All rights reserved.
//

#import "YIModuleItemView.h"
#import "YIConfigAttributedString.h"
#import "NSString+YIAttributed.h"
#import "NSDate+Additional.h"

@implementation YIModuleItemView

+ (instancetype)viewWithTitle:(NSString *)title content:(NSString *)content customView:(UIView *)customView {
    return [[self alloc] initWithTitle:title subTitle:nil content:content customView:customView images:nil];
}

+ (instancetype)viewWithTitle:(NSString *)title subTitle:(NSString *)subTitle content:(NSString *)content images:(NSArray *)images {
    return [[self alloc] initWithTitle:title subTitle:subTitle content:content customView:nil images:images];
}

- (instancetype)initWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                      content:(NSString *)content
                   customView:(UIView *)customView
                       images:(NSArray *)images {
    self = [super init];
    if (self) {
        self.title = title;
        self.subTitle = subTitle;
        self.content = content;
        self.images = images;
        self.customView = customView;
        self.backgroundColor = [UIColor whiteColor];
        [self loadSubviews];
    }
    
    return self;
}

+ (instancetype)viewWithTimeline:(LCTimelineEntity *)timeline {
	return [[self alloc] initWithTimeline:timeline];
}

- (instancetype)initWithTimeline:(LCTimelineEntity *)timeline {
	self = [super init];
	if (self) {
		self.timeline = timeline;
		[self setupUI];
	}
	return self;
}

- (void)setupUI {
	UIView *lastView = nil;
	
	if (_timeline.happenTime) {
		NSString *timeString = [_timeline.happenTime convertDateToStringWithFormat:@"ddMM月"];
		NSInteger weekday = _timeline.happenTime.weekday;
		NSString *weekdayString = [NSString stringWithFormat:@"星期%ld",(long)weekday-1];
		NSArray *array = @[
						   // 全局设置
						   [YIConfigAttributedString font:kAppSmlFont range:[timeString range]],
						   [YIConfigAttributedString foregroundColor:kAppTextMidColor range:[timeString range]],
						   // 局部设置
						   [YIConfigAttributedString foregroundColor:kAppTextDeepColor range:NSMakeRange(0, 2)],
						   [YIConfigAttributedString font:kAppBigFont range:NSMakeRange(0, 2)]
						   ];
		UILabel *timeLbl = [[UILabel alloc] init];
		timeLbl.numberOfLines = 1;
		timeLbl.attributedText = [timeString createAttributedStringAndConfig:array];
		[self addSubview:timeLbl];
		
		[timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.left.equalTo(self);
			make.right.mas_lessThanOrEqualTo(self);
			make.width.equalTo(@50);
		}];
		
		UIButton *dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[dayBtn setTitle:weekdayString forState:UIControlStateNormal];
		[dayBtn setBackgroundImage:[UIImage imageNamed:@"ic_tl_day_sepatate"] forState:UIControlStateNormal];
		dayBtn.titleLabel.font = kAppMiniFont;
		[self addSubview:dayBtn];
		[dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(timeLbl.mas_bottom).with.offset(10);
			make.left.equalTo(self);
			make.width.equalTo(@50);
			make.height.equalTo(@16);
		}];
	}
	
	if (_timeline.firstDo) {
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.image = [UIImage imageNamed:_timeline.firstDo[@"icon"]];
		[self addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(lastView ? lastView.mas_bottom : @0).with.offset(5);
			make.left.mas_equalTo(self).with.offset(50);
			make.width.equalTo(@30);
			make.height.equalTo(@30);
		}];
		
		UILabel *contentLbl = [[UILabel alloc] init];
		contentLbl.numberOfLines = 0;
		contentLbl.font = kAppMidFont;
		contentLbl.textColor = kAppTextDeepColor;
		NSString *string = [NSString stringWithFormat:@"第一次%@",_timeline.firstDo[@"present"]];
		[contentLbl setText:string];
		[self addSubview:contentLbl];
		[contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(imageView.mas_right).with.offset(3);
			make.centerY.equalTo(imageView);
		}];
		
		lastView = contentLbl;
	}
	
	if (_timeline.sharedText) {
		UILabel *titleLbl = [[UILabel alloc] init];
		titleLbl.numberOfLines = 0;
		titleLbl.font = kAppMidFont;
		titleLbl.textColor = kAppTextDeepColor;
		[titleLbl setText:_timeline.sharedText];
		[self addSubview:titleLbl];
		
		[titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(lastView ? lastView.mas_bottom : @0).with.offset(3);
			make.left.equalTo(self).with.offset(50);
			make.right.mas_lessThanOrEqualTo(self);
		}];
		
		lastView = titleLbl;
	}
	
	if (_timeline.author) {
		UILabel *subTitleLbl = [[UILabel alloc] init];
		subTitleLbl.numberOfLines = 0;
		subTitleLbl.font = kAppMidFont;
		subTitleLbl.textColor = [UIColor dangerColor];
		[subTitleLbl setText:_timeline.author.nickName];
		subTitleLbl.font = [UIFont systemFontOfSize:10];
		[self addSubview:subTitleLbl];
		
		[subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(lastView ? lastView.mas_right : @0).with.offset(50);
			make.right.mas_lessThanOrEqualTo(self); // 这个会导致主title过长的话，会使subTitle看不到啦。
			make.bottom.equalTo(lastView ? lastView : @0);
		}];
		
		lastView = subTitleLbl;
	}
	
	if (_timeline.sharedItem && _timeline.sharedItem.type == 1 && _timeline.sharedItem.data.count) {
		int numbers = 3;
		int separate = 1.f;
		CGFloat width = (mScreenWidth - 50.f - 20.f - (numbers-1)*separate) / numbers;
		CGFloat height = width;
		
		int curLine = 0;
		UIView *lastImageView;
		UIView *mostRightView;
		for (int i = 0; i < _timeline.sharedItem.data.count; i++) {
			AVFile *imageFile = _timeline.sharedItem.data[i];
			if (imageFile == nil || [imageFile isEqual:[NSNull null]]) {
				break;
			}
			
			UIImageView *imageView = [[UIImageView alloc] init];
			[imageView setContentMode:UIViewContentModeScaleAspectFill];
			[imageView setClipsToBounds:YES];
			[self addSubview:imageView];
			
			if (imageFile && ![imageFile isKindOfClass:[NSNull class]]) {
				NSString *thumbnail = [imageFile getThumbnailURLWithScaleToFit:YES width:200 height:200];
				[imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail]
							 placeholderImage:kAppPlaceHolderImage];
			}
			
			if (i / numbers == curLine) {
				[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
					if (lastImageView) {
						make.top.equalTo(lastImageView.mas_top);
						make.left.equalTo(lastImageView.mas_right).offset(separate);
					} else {
						make.top.equalTo(lastView.mas_bottom).with.offset(5);
						make.left.equalTo(self).with.offset(50);
					}
					make.width.mas_equalTo(lastImageView ? lastImageView.mas_width : @(width));
					make.height.mas_equalTo(lastImageView ? lastImageView.mas_width : @(height));
				}];
				if (i == (numbers - 1)) {
					mostRightView = imageView;
				}
			} else {
				curLine = i / numbers;
				[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.top.equalTo(lastImageView ? lastImageView.mas_bottom : lastView.mas_bottom).offset(separate);
					make.left.equalTo(self).with.offset(50);
					make.width.equalTo(lastImageView ? lastImageView.mas_width : @(width));
					make.height.equalTo(lastImageView ? lastImageView.mas_width : @(height));
				}];
			}			
			lastImageView = imageView;
		}
		
		if (lastImageView) {
			lastView = lastImageView;
		}
	}
	
	if (_timeline.location) {
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.image = [UIImage imageNamed:@"ic_newactivity_local_tag"];
		[self addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(lastView ? lastView.mas_bottom : @0).with.offset(5);
			make.left.mas_equalTo(self).with.offset(50);
//			make.width.equalTo(@30);
//			make.height.equalTo(@30);
		}];
		
		UILabel *label = [[UILabel alloc] init];
		label.numberOfLines = 0;
		label.font = kAppMidFont;
		label.textColor = kAppTextDeepColor;
		[label setText:_timeline.location.name];
		[self addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(imageView.mas_right).with.offset(3);
			make.centerY.equalTo(imageView);
		}];
		
		lastView = label;
	}

	// 布局收尾
	[self mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(lastView ? lastView : @0);
	}];
}

- (void)loadSubviews {
    UIView *lastView = nil;

	NSString *timeString = @"3012月";
	// 设置组
	NSArray *array = @[
					   // 全局设置
					   [YIConfigAttributedString font:kAppSmlFont range:[timeString range]],
					   [YIConfigAttributedString foregroundColor:kAppTextMidColor range:[timeString range]],
					   // 局部设置
					   [YIConfigAttributedString foregroundColor:kAppTextDeepColor range:NSMakeRange(0, 2)],
					   [YIConfigAttributedString font:kAppBigFont range:NSMakeRange(0, 2)]
					   ];
	UILabel *timeLbl = [[UILabel alloc] init];
	timeLbl.numberOfLines = 1;
	timeLbl.attributedText = [timeString createAttributedStringAndConfig:array];
	[self addSubview:timeLbl];
	
	[timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.right.mas_lessThanOrEqualTo(self);
		make.width.equalTo(@50);
	}];
	
	UIButton *dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[dayBtn setTitle:@"星期日" forState:UIControlStateNormal];
	[dayBtn setBackgroundImage:[UIImage imageNamed:@"ic_tl_day_sepatate"] forState:UIControlStateNormal];
	dayBtn.titleLabel.font = kAppMiniFont;
	[self addSubview:dayBtn];
	[dayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(timeLbl.mas_bottom).with.offset(10);
		make.left.equalTo(self);
		make.width.equalTo(@50);
		make.height.equalTo(@16);
	}];
	
    if (self.title) {
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.numberOfLines = 0;
        titleLbl.font = kAppMidFont;
        titleLbl.textColor = kAppTextDeepColor;
        [titleLbl setText:_title];
        [self addSubview:titleLbl];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).with.offset(50);
            make.right.mas_lessThanOrEqualTo(self);
        }];
        
        lastView = titleLbl;
    }
    
    if (self.subTitle) {
        UILabel *subTitleLbl = [[UILabel alloc] init];
        subTitleLbl.numberOfLines = 0;
        subTitleLbl.font = kAppMidFont;
        subTitleLbl.textColor = [UIColor dangerColor];
        [subTitleLbl setText:_subTitle];
        subTitleLbl.font = [UIFont systemFontOfSize:10];
        [self addSubview:subTitleLbl];
        
        [subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastView ? lastView.mas_right : @0).with.offset(50);
            make.right.mas_lessThanOrEqualTo(self); // 这个会导致主title过长的话，会使subTitle看不到啦。
            make.bottom.equalTo(lastView ? lastView : @0);
        }];
        
        lastView = subTitleLbl;
    }
    
    if (self.content) {
        UILabel *contentLbl = [[UILabel alloc] init];
        contentLbl.numberOfLines = 0;
        contentLbl.font = kAppMidFont;
        contentLbl.textColor = kAppTextDeepColor;
        [contentLbl setText:_content];
        [self addSubview:contentLbl];
        
        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastView ? lastView.mas_bottom : @0);
            make.left.mas_equalTo(self).with.offset(50);
            make.right.mas_equalTo(self);
        }];
        
        lastView = contentLbl;
    }
    
    if (self.customView) {
        [self addSubview:_customView];
        [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastView ? lastView.mas_bottom : @0);
            make.left.mas_equalTo(self).with.offset(50);
            make.right.mas_equalTo(self);
        }];
        
        lastView = _customView;
    }
    
    if (self.images) {
        int numbers = 3;
        int separate = 1.f;
        CGFloat width = (mScreenWidth - 50.f - 20.f - (numbers-1)*separate) / numbers;
        CGFloat height = width;
        
        int curLine = 0;
        UIView *lastImageView;
        UIView *mostRightView;
        for (int i = 0; i < self.images.count; i++) {
            AVFile *imageFile = self.images[i];
            if (imageFile == nil || [imageFile isEqual:[NSNull null]]) {
                break;
            }
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            [self addSubview:imageView];
            
            if (imageFile && ![imageFile isKindOfClass:[NSNull class]]) {
                NSString *thumbnail = [imageFile getThumbnailURLWithScaleToFit:YES width:200 height:200];
                [imageView sd_setImageWithURL:[NSURL URLWithString:thumbnail]
                             placeholderImage:kAppPlaceHolderImage];
            }
            
            if (i / numbers == curLine) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastImageView ? lastImageView.mas_top : lastView.mas_bottom);
                    if (lastImageView) {
                        make.left.equalTo(lastImageView.mas_right).offset(separate);
                    } else {
                        make.left.equalTo(self).with.offset(50);
                    }
                    make.width.mas_equalTo(lastImageView ? lastImageView.mas_width : @(width));
                    make.height.mas_equalTo(lastImageView ? lastImageView.mas_width : @(height));
                }];
                if (i == (numbers - 1)) {
                    mostRightView = imageView;
                }
            } else {
                curLine = i / numbers;
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastImageView ? lastImageView.mas_bottom : lastView.mas_bottom).offset(separate);
                    make.left.equalTo(self).with.offset(50);
                    make.width.equalTo(lastImageView ? lastImageView.mas_width : @(width));
                    make.height.equalTo(lastImageView ? lastImageView.mas_width : @(height));
                }];
            }
            
            lastImageView = imageView;
        }
        
        if (lastImageView) {
            lastView = lastImageView;
        }
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastView ? lastView : @0);
    }];
}

@end
