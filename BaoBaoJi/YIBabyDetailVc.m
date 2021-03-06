//
//  YIBabyDetailVc.m
//  BaoBaoJi
//
//  Created by efeng on 15/12/25.
//  Copyright © 2015年 buerguo. All rights reserved.
//

#import "YIBabyDetailVc.h"
#import "CSStickyHeaderFlowLayout.h"
#import "YIBabyDetailCell.h"
#import "YIBabyHeaderView.h"

//static NSString *const SEX_Pi

const int RESET_COVER_IMAGE = 4001;
const int RESET_AVATAR_IMAGE = 4002;


@interface YIBabyDetailVc () <UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, YIBabyHeaderViewDelegate, UIActionSheetDelegate>
{
	UIPickerView *pickview;
	UIToolbar *toolbar;
	
	UIDatePicker *datePicker;
	UIToolbar *dateToolbar;
	UIAlertView *dialog;
	
	UIImagePickerController *imagePicker;
	
	UIActionSheet *actionSheet;
	
	int curResetImageType;
}

@property(nonatomic, strong) NSArray *babyDetails;
@property(nonatomic, strong) LCBabyEntity *curBaby;

@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *bloodArray;

@property (nonatomic, strong) NSMutableDictionary *headerViewData;

@end


@implementation YIBabyDetailVc

- (instancetype)init {
    self = [super init];
    if (self) {
		self.hidesBottomBarWhenPushed = YES;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	self.hidesBottomBarWhenPushed = YES;

//	self.curBaby = [mGlobalData.user.babies lastObject];
	self.curBaby = mGlobalData.user.curBaby;

	// 初始化collection data
    [self loadCollectionData];
	
	[self loadHeaderViewData];
	
    // 注册 UICollectionView
    [self.baseCollectionView registerNib:[YIBabyDetailCell cellNib]
              forCellWithReuseIdentifier:NSStringFromClass([YIBabyDetailCell class])];
	[self reloadLayout];
    [self.baseCollectionView reloadData];

	// 初始化数据
	NSString *path = [[NSBundle mainBundle] pathForResource:@"common_property" ofType:@"plist"];
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	self.sexArray = dictionary[@"sex"];
	self.bloodArray = dictionary[@"blood"];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wundeclared-selector"
//	method_exchangeImplementations(class_getInstanceMethod(self.baseCollectionView.class, @selector(ar_reloadData)), class_getInstanceMethod(self.baseCollectionView.class, @selector(reloadData)));
//#pragma clang diagnostic pop
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
	NSLog(@"111 %@",NSStringFromCGRect(self.baseCollectionView.frame));
	NSLog(@"222 %@",NSStringFromCGSize(self.baseCollectionView.contentSize));
	
//	self.baseCollectionView.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight-44);
//	self.baseCollectionView.contentSize = CGSizeMake(mScreenWidth, mScreenHeight);
}

- (void)loadHeaderViewData {
	self.headerViewData = [NSMutableDictionary dictionaryWithDictionary:@{
																		  @"cover" : [UIImage imageNamed:@"tmp_bg@2x.jpg"],
																		  @"avatar" : [UIImage imageNamed:@"placeholder"],
																		  @"hint" : @"今天是宝宝一岁的生日"
																		  }];
}

- (void)loadCollectionData {
	self.babyDetails = @[
			@{
                    @"title" : @"小名",
                    @"content" : @"",
					@"detail" : _curBaby.nickName?:@"",
					@"tag" : @(1001)
            },
            @{
                    @"title" : @"性别",
                    @"content" : @"",
                    @"detail" : @(_curBaby.sex)?[@(_curBaby.sex) stringValue]:@"",
					@"tag" : @(1002)
            },
            @{
                    @"title" : @"生日",
                    @"content" : @"",
                    @"detail" : [_curBaby.birthday convertDateToStringWithFormat:@"yyyy年MM月dd日"]?:@"",
					@"tag" : @(1003)
            },
            @{
                    @"title" : @"血型",
                    @"content" : @"",
                    @"detail" : @(_curBaby.blood)? [@(_curBaby.blood) stringValue]:@"",
					@"tag" : @(1004)
            },
            @{
                    @"title" : @"出生时刻",
                    @"content" : @"",
                    @"detail" : _curBaby.birthTime?:@"",
					@"tag" : @(1005)
            },
            @{
                    @"title" : @"身高",
                    @"content" : @"",
                    @"detail" : @(_curBaby.height)?[@(_curBaby.height) stringValue]:@"",
					@"tag" : @(1006)
            },
            @{
                    @"title" : @"体重",
                    @"content" : @"",
                    @"detail" : @(_curBaby.weight)?[@(_curBaby.weight) stringValue]:@"",
					@"tag" : @(1007)
            },
    ];
}

- (void)reloadLayout {
	UINib *headerNib = [YIBabyHeaderView viewNib]; // [UINib nibWithNibName:@"YIBabyHeaderView" bundle:nil];
    [self.baseCollectionView registerNib:headerNib
              forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                     withReuseIdentifier:@"header"];

    CSStickyHeaderFlowLayout *layout = [CSStickyHeaderFlowLayout new];
    layout.parallaxHeaderReferenceSize = CGSizeMake(mScreenWidth, 150);
    layout.itemSize = CGSizeMake(mScreenWidth, 150);
    // If we want to disable the sticky header effect
    layout.disableStickyHeaders = YES;
	
    self.baseCollectionView.collectionViewLayout = layout;
}

#pragma mark -  UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _babyDetails.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YIBabyDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YIBabyDetailCell class])
                                                                       forIndexPath:indexPath];
    NSDictionary *detail = _babyDetails[indexPath.row];
    [cell setupCell:detail];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath; {
    // Check the kind if it's CSStickyHeaderParallaxHeader
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
		YIBabyHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
																	withReuseIdentifier:@"header"
																		   forIndexPath:indexPath];
		[headerView setupView:_headerViewData];
		headerView.delegate = self;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		/*
        YIBabyHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                    withReuseIdentifier:NSStringFromClass([YIBabyHeaderView class])
                                                                           forIndexPath:indexPath];
		view.delegate = self;
		
		
		view.avatarIv.userInteractionEnabled = YES;
		UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetBabyAvatarImage)];
		[view.avatarIv addGestureRecognizer:avatarTap];
		
		view.coverIv.userInteractionEnabled = YES;
		UITapGestureRecognizer *coverTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetBabyCoverImage)];
		[view.coverIv addGestureRecognizer:coverTap];
		
        return view;
		 */
		return nil;
    } else {
        return nil;
    }
}


#pragma mark -  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	int rowTag = [_babyDetails[indexPath.row][@"tag"] intValue];
	switch (rowTag) {
		case 1001:{
			RIButtonItem *confirmItem = [RIButtonItem itemWithLabel:@"确认" action:^{
				_curBaby.nickName = [[dialog textFieldAtIndex:0] text];
				[_curBaby saveInBackground];
				[self loadCollectionData];
				[self.baseCollectionView reloadData];
			}];
			RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"取消"];
			dialog = [[UIAlertView alloc] initWithTitle:@"请输入你的小名" message:nil cancelButtonItem:cancelItem otherButtonItems:confirmItem, nil];
			[dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
			[dialog show];
			break;
		}
		case 1002: {
			[self showPickerViewWithTag:1002];
			break;
		}
		case 1003:{
			[self showDatePickerWithTag:1003];
			break;
		}
		case 1004:
			[self showPickerViewWithTag:1004];
			break;
		case 1005:{
			[self showDatePickerWithTag:1005];
			break;
		}
		case 1006:
			
			break;
		case 1007:
			
			break;
		default:
			break;
	}
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section; {
//	return CGSizeMake(mScreenWidth, 20.f);
//}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(mScreenWidth, 44);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark -

- (void)showDatePickerWithTag:(int)tag {
	datePicker = [[UIDatePicker alloc] init];
	if (tag == 1003) {
		datePicker.datePickerMode = UIDatePickerModeDate;
	} else {
		datePicker.datePickerMode = UIDatePickerModeTime;
	}
	datePicker.tag = tag;
	[self.view addSubview:datePicker];
	[datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(self.view);
		//		make.height.equalTo(@216);
	}];
	
	
	// add toolbar
	dateToolbar = [[UIToolbar alloc] init];
	[dateToolbar setBackgroundColor:kAppWhiteColor];
	
	NSMutableArray *items = [NSMutableArray array];
	
	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dateCancelAction:)];
	[cancelItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								  [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
								  kAppMainColor, NSForegroundColorAttributeName,
								  [UIColor blackColor], NSBackgroundColorAttributeName,
								  nil]
							  forState:UIControlStateNormal];
	cancelItem.tag = tag;
	[items addObject:cancelItem];
	
	UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:spacer3];
	
	UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(dateCancelAction:)];
	[okItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
									[UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
									kAppMainColor, NSForegroundColorAttributeName,
									[UIColor blackColor], NSBackgroundColorAttributeName,
									nil]
						  forState:UIControlStateNormal];
	okItem.tag = tag;
	[items addObject:okItem];
	
	[dateToolbar setItems:items animated:YES];
	[self.view addSubview:dateToolbar];
	
	[dateToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(datePicker.mas_top);
		make.height.equalTo(@44);
	}];
	
	[self.baseCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.width.equalTo(self.view);
		make.bottom.equalTo(dateToolbar.mas_top);
	}];
	

}

- (void)showPickerViewWithTag:(int)tag {
	[self hideKeyboard:nil];
	
	if (pickview) {
	 if (pickview.tag == tag) {
		 return;
	 } else {
		 [self removePickerView];
	 }
	}
	
	pickview = [[UIPickerView alloc] init];
	pickview.delegate = self;
	pickview.tag = tag;
	pickview.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:pickview];
	[pickview mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(self.view);
//		make.height.equalTo(@216);
	}];
	
	[pickview selectRow:0 inComponent:0 animated:YES];
	[self pickerView:pickview didSelectRow:0 inComponent:0];
	
	// add toolbar
	toolbar = [[UIToolbar alloc] init];
	[toolbar setBackgroundColor:kAppWhiteColor];
	
	NSMutableArray *items = [NSMutableArray array];

	UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction:)];
	[cancelItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								  [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
								  kAppMainColor, NSForegroundColorAttributeName,
								  [UIColor blackColor], NSBackgroundColorAttributeName,
								  nil]
						forState:UIControlStateNormal];
	cancelItem.tag = tag;
	[items addObject:cancelItem];

	UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:spacer3];
	
	UIBarButtonItem *okItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(completeAction:)];
	[okItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								  [UIFont fontWithName:@"Helvetica" size:15.0], NSFontAttributeName,
								  kAppMainColor, NSForegroundColorAttributeName,
								  [UIColor blackColor], NSBackgroundColorAttributeName,
								  nil]
						forState:UIControlStateNormal];
	okItem.tag = tag;
	[items addObject:okItem];
	
	[toolbar setItems:items animated:YES];
	[self.view addSubview:toolbar];
	
	[toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.bottom.equalTo(pickview.mas_top);
		make.height.equalTo(@44);
	}];
	
//	float hh = self.view.height - 216 - 44;
	[self.baseCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.width.equalTo(self.view);
		make.bottom.equalTo(toolbar.mas_top);
	}];
}

- (void)dateCancelAction:(UIBarButtonItem *)item {
	[self removeDatePickerView];
}

- (void)dateCompleteAction:(UIBarButtonItem *)item {
	
	
	[self removeDatePickerView];
}

- (void)removePickerView {
	[pickview removeFromSuperview];
	[toolbar removeFromSuperview];
	[self.baseCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.width.equalTo(self.view);
		make.bottom.equalTo(self.view);
	}];
	
	pickview = nil;
	toolbar = nil;
}

- (void)cancelAction:(UIBarButtonItem *)item {
	[self removePickerView];
}

- (void)completeAction:(UIBarButtonItem *)item {
	if (item.tag == 1002) {
		int selectedRow = [pickview selectedRowInComponent:0];
		int sexIndex = [self.sexArray[selectedRow][@"index"] intValue];
		_curBaby.sex = sexIndex;
	}
	if (item.tag == 1004) {
		int selectedRow = [pickview selectedRowInComponent:0];
		int bloodIndex = [self.bloodArray[selectedRow][@"index"] intValue];
		_curBaby.blood = bloodIndex;
	}
	[_curBaby saveInBackground];
	[self loadCollectionData];
	[self.baseCollectionView reloadData];
	
	[self removePickerView];
}

- (void)removeDatePickerView {
	[datePicker removeFromSuperview];
	[dateToolbar removeFromSuperview];
	[self.baseCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view);
		make.left.equalTo(self.view);
		make.right.equalTo(self.view);
		make.width.equalTo(self.view);
		make.bottom.equalTo(self.view);
	}];
	
	datePicker = nil;
	dateToolbar = nil;
}

#pragma mark -

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView; {
	if (pickerView.tag == 1002) {
		return 1;
	}
	if (pickerView.tag == 1004) {
		return 1;
	}
	
	return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component; {
	if (pickerView.tag == 1002) {
		return _sexArray.count;
	}
	if (pickerView.tag == 1004) {
		return _bloodArray.count;
	}
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component; {
	if (pickerView.tag == 1002) {
		return _sexArray[row][@"text"];
	}
	if (pickerView.tag == 1004) {
		return _bloodArray[row][@"text"];
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component; {
	if (pickerView.tag == 1002) {
		
	}
	if (pickerView.tag == 1004) {
		
	}
}

#pragma mark - UIImagePickerControllerDelegate

//当选择一张图片后进入这里
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// 获取图片
	UIImage *image = info[UIImagePickerControllerEditedImage];

	if (curResetImageType == RESET_AVATAR_IMAGE) {
		self.headerViewData[@"avatar"] = image;
	} else if (curResetImageType == RESET_COVER_IMAGE) {
		self.headerViewData[@"cover"] = image;
	}
//	[self.baseCollectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]];
//	[self.baseCollectionView reloadItemsAtIndexPaths:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)]]];
	[self.baseCollectionView reloadData];
	
	// 保存头像
	NSData *imageData = UIImagePNGRepresentation(image);
	AVFile *imageFile = [AVFile fileWithName:@"baby_avatar.png" data:imageData];
	[imageFile saveInBackground];
	
	mGlobalData.user.curBaby.avatar = imageFile;
	
	[picker dismissViewControllerAnimated:YES completion:NULL];	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	//	[picker dismissViewControllerAnimated:YES completion:NULL];
	//	[picker.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
	[picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - YIBabyHeaderViewDelegate

- (void)resetBabyAvatarImage {
	curResetImageType = RESET_AVATAR_IMAGE;
	[self showActionSheet];
}

- (void)resetBabyCoverImage {
	curResetImageType = RESET_COVER_IMAGE;
	[self showActionSheet];
}

- (void)showActionSheet {
	if (actionSheet == nil) {
		actionSheet = [[UIActionSheet alloc] initWithTitle:NULL
												  delegate:self
										 cancelButtonTitle:@"取消"
									destructiveButtonTitle:NULL
										 otherButtonTitles:@"拍照", @"从手机相册选择", nil];
	}
	
	[actionSheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
	if (buttonIndex == 0) {			// 拍照
		[self loadPickerVc:UIImagePickerControllerSourceTypeCamera];
	} else if (buttonIndex == 1) {  // 从手机相册选择
		[self loadPickerVc:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
	}
}

- (void)loadPickerVc:(UIImagePickerControllerSourceType)type{
	// 用系统的.
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = type;
	imagePicker.delegate = self;
	// 设置选择后的图片可被编辑
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark -

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
