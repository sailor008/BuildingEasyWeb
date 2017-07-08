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

@end

@implementation BuyerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

@end
