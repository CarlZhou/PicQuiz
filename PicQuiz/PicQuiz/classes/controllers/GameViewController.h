//
//  iSpyGameViewController.h
//  PhotoSmart
//
//  Created by Zian Zhou on 2014-08-15.
//  Copyright (c) 2014 Zian Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"


@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *gameTitleLabel;
@property (strong, nonatomic) IBOutlet GPUImageView *gameImageView;
@property (strong, nonatomic) IBOutlet UIView *lettersViewContainer;
@property (strong, nonatomic) IBOutlet UIView *answerViewContainer;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *answerCollectionView;

//@property (strong, nonatomic) ISpyGameObject *gameObject;

@end
