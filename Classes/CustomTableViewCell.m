//
//  CustomTableViewCell.m
//  EveTrader
//
//  Created by jrk on 08.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "CustomTableViewCell.h"


@implementation CustomTableViewCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
		NSLog(@"CUSTOM!");
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
