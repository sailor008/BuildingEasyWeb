//
//  SampleEditTxtCell.m
//  BuildingEasyWeb
//
//  Created by SeekMac on 2017/7/1.
//  Copyright © 2017年 zhenghongyi. All rights reserved.
//

#import "SampleEditTxtCell.h"

@interface SampleEditTxtCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *txtField;

@end

@implementation SampleEditTxtCell

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

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


- (void)setModel:(EditTxtModel *)model
{
    _model = model;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@：", model.title];
    _txtField.placeholder = model.placeholder;
    if (model.text.length) {
        _txtField.text = model.text;
    }
}

- (IBAction)onTxtFieldChanged:(id)sender {
    _model.text = _txtField.text;
}


@end
