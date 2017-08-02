//
//  BuyerCell.m
//  BuildingEasyWeb
//
//  Created by zhenghongyi on 2017/6/30.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "BuyerCell.h"

@interface BuyerCell ()
{
    BOOL _obserTextField;
}

@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *clientTextField;
@property (weak, nonatomic) IBOutlet UITextField *clientIdcardTextField;


@property (weak, nonatomic) IBOutlet UIButton *showHideButton;

@end

@implementation BuyerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _idCardTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _phoneTextField.borderStyle = UITextBorderStyleNone;
    _clientTextField.borderStyle = UITextBorderStyleNone;
    _clientIdcardTextField.borderStyle = UITextBorderStyleNone;
    
    if (_obserTextField == NO) {
        [_idCardTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_clientTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [_clientIdcardTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _obserTextField = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EditInfoModel *)model
{
    _model = model;
    
    _idCardTextField.text = model.idCard;
    _nameTextField.text = model.name;
    _phoneTextField.text = model.mobile;
    _clientTextField.text = model.client;
    _clientIdcardTextField.text = model.clientIdcard;
    
    _idCardTextField.enabled = model.canEdit;
    _nameTextField.enabled = model.canEdit;
    _phoneTextField.enabled = model.canEdit;
    _clientTextField.enabled = model.canEdit;
    _clientIdcardTextField.enabled = model.canEdit;
    
    _showHideButton.selected = _model.isShow;
}

#pragma mark Action
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _idCardTextField) {
        _model.idCard = _idCardTextField.text;
    } else if (textField == _nameTextField) {
        _model.name = _nameTextField.text;
    } else if (textField == _phoneTextField) {
        _model.mobile = _phoneTextField.text;
    } else if (textField == _clientTextField) {
        _model.client = _clientTextField.text;
    } else if (textField == _clientIdcardTextField) {
        _model.clientIdcard = _clientIdcardTextField.text;
    }
}

- (IBAction)showHideTap:(UIButton *)sender
{
//    if (_model.isShow == YES) {
//        return;
//    }
//    sender.selected = YES;
//    _model.isShow = YES;
    sender.selected = !sender.isSelected;
    _model.isShow = sender.isSelected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(buyerCellShowHide:withModel:)]) {
        [_delegate buyerCellShowHide:sender.isSelected withModel:_model];
    }
}

@end
