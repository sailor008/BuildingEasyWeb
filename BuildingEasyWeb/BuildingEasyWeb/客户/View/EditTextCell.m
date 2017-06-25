//
//  EditTextCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditTextCell.h"

#import "NSString+Addition.h"

@interface EditTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *editTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *percenLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;

@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) UIView* dateView;

@end

@implementation EditTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUIWithData:(NSDictionary *)dic
{
    _editTitleLabel.text = [NSString stringWithFormat:@"%@：", dic.allKeys[0]];
    _textField.placeholder = dic.allValues[0];
    
    _dateButton.hidden = YES;
    _percenLabel.hidden = YES;
    if ([_textField.placeholder rangeOfString:@"日期"].location != NSNotFound) {
        _dateButton.hidden = NO;
    }
    if ([_textField.placeholder rangeOfString:@"百分数"].location != NSNotFound) {
        _percenLabel.hidden = NO;
    }
}

- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.frame = CGRectMake(0, 44, ScreenWidth, 200);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (UIView *)dateView
{
    if (_dateView == nil) {
        _dateView = [[UIView alloc] init];
        _dateView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _dateView.frame = CGRectMake(0, ScreenHeight - 64 - 200 - 44, ScreenWidth, 244);
        
        UIToolbar* toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(dismissDateView)];
        [toolBar setItems:@[doneItem]];
        [_dateView addSubview:toolBar];
        
        [_dateView addSubview:self.datePicker];
    }
    return _dateView;
}

#pragma mark Action
- (IBAction)selectDate:(id)sender
{
    UIResponder* obj = self.superview.nextResponder;
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = obj.nextResponder;
    }
    
    _textField.text = [NSString dateStr:[NSDate date]];
    
    UIViewController* vc = (UIViewController *)obj;
    [vc.view addSubview:self.dateView];
}

- (void)dateChanged
{
    _textField.text = [NSString dateStr:_datePicker.date];
}

- (void)dismissDateView
{
    [_dateView removeFromSuperview];
}

@end
