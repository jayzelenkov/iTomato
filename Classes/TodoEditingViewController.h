//
//  TodoEditingViewController.h
//  iTomato
//
//  Created by mac on 4/9/10.
//  Copyright 2010 Jevgeni Zelenkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoEditingViewController : UIViewController {
	IBOutlet UITextField *titleText;
	IBOutlet UISlider *pomsSlider;
	IBOutlet UILabel *pomsLabel;
	IBOutlet UIDatePicker *datePicker;
	IBOutlet UINavigationItem *navTitle;
}

@property (nonatomic, retain) IBOutlet UITextField *titleText;
@property (nonatomic, retain) IBOutlet UISlider *pomsSlider;
@property (nonatomic, retain) IBOutlet UILabel *pomsLabel;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) IBOutlet UINavigationItem *navTitle;

-(IBAction) hideKeyboard:(id)sender;
-(IBAction) sliderChanged:(id)sender;

-(IBAction) save:(id)sender;
-(IBAction) cancel:(id)sender;
@end
