//
//  ViewController.h
//  MTLSeminar201303
//
//  Created by Kasajima Yasuo on 2013/03/05.
//  Copyright (c) 2013年 kasajei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)pressFilterBtn:(id)sender;
- (IBAction)pressSaveBtn:(id)sender;

@end
