//
//  EditTextCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/24.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "EditTextCell.h"

#import "NSString+Addition.h"
#import "NSDate+Addition.h"

@interface EditTextCell ()
{
    BOOL _obserTextField;
}

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
    
    _textField.borderStyle = UITextBorderStyleNone;
    
    if (_obserTextField == NO) {
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _obserTextField = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    if (_model.canEdit) {
        _model.text = _textField.text;
    }
    [super prepareForReuse];
}

- (void)setModel:(EditInfoModel *)model
{
    _model = model;
    
    _editTitleLabel.text = [NSString stringWithFormat:@"%@：", model.title];
    _textField.placeholder = model.placeholder;
    _textField.text = model.text;
    _dateButton.hidden = !model.isDate;
    _percenLabel.hidden = !model.isPercen;
    
    _textField.enabled = model.canEdit;
    if (model.isDate || model.canEdit == NO) {
        _textField.enabled = NO;
    } else {
        _textField.enabled = YES;
    }
        
    if ([_editTitleLabel.text containsString:@"电话"] || [_editTitleLabel.text containsString:@"号码"]) {
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    } else if ([_editTitleLabel.text containsString:@"面积"] || [_editTitleLabel.text containsString:@"价"] || [_editTitleLabel.text containsString:@"金"] || [_editTitleLabel.text containsString:@"百分比"]) {
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }  else if ([_editTitleLabel.text containsString:@"电话"]) {
        _textField.keyboardType = UIKeyboardTypePhonePad;
    } else {
        _textField.keyboardType = UIKeyboardTypeDefault;
    }
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
    if (_model.canEdit == NO) {
        return;
    }
    
    UIResponder* obj = self.superview.nextResponder;
    while (![obj isKindOfClass:[UIViewController class]]) {
        obj = obj.nextResponder;
    }
    
    _textField.text = [NSString dateStr:[NSDate date]];
    _model.text = _textField.text;
    
    self.datePicker.minimumDate = _model.minDate;
    self.datePicker.maximumDate = _model.maxDate;
    
    UIViewController* vc = (UIViewController *)obj;
    [vc.view addSubview:self.dateView];
}

- (void)dateChanged
{
    _textField.text = [NSString dateStr:_datePicker.date];
    _model.text = _textField.text;
}

- (void)dismissDateView
{
    [_dateView removeFromSuperview];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    _model.text = _textField.text;
}

@end
