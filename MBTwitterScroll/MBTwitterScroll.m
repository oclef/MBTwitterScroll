//
//  MBTwitterScroll.m
//  TwitterScroll
//
//  Created by Martin Blampied on 07/02/2015.
//  Copyright (c) 2015 MartinBlampied. All rights reserved.
//

#import "MBTwitterScroll.h"
#import "UIScrollView+TwitterCover.h"
#import "UIImage+ImageEffects.h"


CGFloat const offset_HeaderStop = 40.0;
CGFloat const offset_B_LabelHeader = 95.0;
CGFloat const distance_W_LabelHeader = 35.0;


@implementation MBTwitterScroll

- (MBTwitterScroll *)initScrollViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle contentHeight:(CGFloat)height {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[MBTwitterScroll alloc] initWithFrame:bounds];
    [self setupView:backgroundImage avatarImage:avatarImage titleString:titleString subtitleString:subtitleString buttonTitle:buttonTitle scrollHeight:height type:MBScroll];
    
    return self;
}


- (MBTwitterScroll *)initTableViewWithBackgound:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self = [[MBTwitterScroll alloc] initWithFrame:bounds];
    
    [self setupView:backgroundImage avatarImage:avatarImage titleString:titleString subtitleString:subtitleString buttonTitle:buttonTitle scrollHeight:0 type:MBTable];
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
    
}



- (void) setupView:(UIImage*)backgroundImage avatarImage:(UIImage *)avatarImage titleString:(NSString *)titleString subtitleString:(NSString *)subtitleString buttonTitle:(NSString *)buttonTitle scrollHeight:(CGFloat)height type:(MBType)type {
    
    
    // Header
    self.header = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 107)];
    [self addSubview:self.header];
    self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.header.frame.size.height - 5, self.frame.size.width, 25)];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = titleString;
    self.headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    self.headerLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:self.headerLabel];
    
    if (type == MBTable) {
        // TableView
        self.tableView = [[UITableView alloc] initWithFrame:self.frame];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        // TableView Header
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.header.frame.size.height + 100)];
        [self addSubview:self.tableView];
        
    } else {
        
        // Scroll
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        CGSize newSize = CGSizeMake(self.frame.size.width, height);
        self.scrollView.contentSize = newSize;
        self.scrollView.delegate = self;
    }
    
    
    self.avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 79, 69, 69)];
    self.avatarImage.backgroundColor = [UIColor lightGrayColor];
    if (avatarImage != nil) {
        self.avatarImage.image = avatarImage;
    }
    self.avatarImage.layer.cornerRadius = 10;
    self.avatarImage.layer.borderWidth = 3;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 156, 250, 25)];
    self.titleLabel.text = titleString;
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 177, 250, 25)];
    self.subtitleLabel.text = subtitleString;
    self.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    self.subtitleLabel.textColor = [UIColor lightGrayColor];
    
    
    if (buttonTitle.length > 0) {
        self.headerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 100, 120, 80, 35)];
        [self.headerButton setTitle:buttonTitle forState:UIControlStateNormal];
        [self.headerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.headerButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
        self.headerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.headerButton.layer.borderWidth = 1;
        self.headerButton.layer.cornerRadius = 8;
        [self.headerButton addTarget:self action:@selector(recievedMBTwitterScrollButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (type == MBTable) {
        [self.tableView addSubview:self.avatarImage];
        [self.tableView addSubview:self.titleLabel];
        [self.tableView addSubview:self.subtitleLabel];
        if (buttonTitle.length > 0) {
            [self.tableView addSubview:self.headerButton];
        }
    } else {
        [self.scrollView addSubview:self.avatarImage];
        [self.scrollView addSubview:self.titleLabel];
        [self.scrollView addSubview:self.subtitleLabel];
        if (buttonTitle.length > 0) {
            [self.scrollView addSubview:self.headerButton];
        }
    }
    
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:self.header.frame];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.header.clipsToBounds = YES;
    [self.header insertSubview:self.headerImageView aboveSubview:self.headerLabel];
    
    self.headerBlurImageView = [[UIImageView alloc] initWithFrame:self.header.bounds];
    self.headerBlurImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerBlurImageView.alpha = 0.0;
    [self.header insertSubview:self.headerBlurImageView aboveSubview:self.headerImageView];
    
    if (backgroundImage != nil){
        self.headerImageView.image = backgroundImage;
        [self resetBlurImages:backgroundImage];
    } else {
        self.headerImageView.backgroundColor = [UIColor lightGrayColor];
    }
    
    self.avatarImage.layer.cornerRadius = 10;
    self.avatarImage.layer.borderWidth = 3;
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.tableView.contentOffset.y;
    [self animationForScroll:offset];
}


- (void) animationForScroll:(CGFloat) offset {
    
    CATransform3D headerTransform = CATransform3DIdentity;
    CATransform3D avatarTransform = CATransform3DIdentity;
    
    // DOWN -----------------
    
    if (offset < 0) {
        
        CGFloat headerScaleFactor = -(offset) / self.header.bounds.size.height;
        CGFloat headerSizevariation = ((self.header.bounds.size.height * (1.0 + headerScaleFactor)) - self.header.bounds.size.height)/2.0;
        headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0);
        headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0);
        
        self.header.layer.transform = headerTransform;
        
        if (offset < -self.frame.size.height/3.5) {
            [self recievedMBTwitterScrollEvent];
        }
        
    }
    
    // SCROLL UP/DOWN ------------
    
    else {
        
        // Header -----------
        headerTransform = CATransform3DTranslate(headerTransform, 0, MAX(-offset_HeaderStop, -offset), 0);
        
        //  ------------ Label
        CATransform3D labelTransform = CATransform3DMakeTranslation(0, MAX(-distance_W_LabelHeader, offset_B_LabelHeader - offset), 0);
        self.headerLabel.layer.transform = labelTransform;
        self.headerLabel.layer.zPosition = 2;
        
        // Avatar -----------
        CGFloat avatarScaleFactor = (MIN(offset_HeaderStop, offset)) / self.avatarImage.bounds.size.height / 1.4; // Slow down the animation
        CGFloat avatarSizeVariation = ((self.avatarImage.bounds.size.height * (1.0 + avatarScaleFactor)) - self.avatarImage.bounds.size.height) / 2.0;
        avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0);
        avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0);
        
        if (offset <= offset_HeaderStop) {
            
            if (self.avatarImage.layer.zPosition <= self.headerImageView.layer.zPosition) {
                self.header.layer.zPosition = 0;
            }
            
        }else {
            if (self.avatarImage.layer.zPosition >= self.headerImageView.layer.zPosition) {
                self.header.layer.zPosition = 2;
            }
        }
        
    }
    if (self.headerImageView.image != nil) {
        // Change transparency of blur subview
        self.headerBlurImageView.alpha = MIN(1.0, (offset - offset_B_LabelHeader)/distance_W_LabelHeader);
    }
    self.header.layer.transform = headerTransform;
    self.avatarImage.layer.transform = avatarTransform;
    
    
}

- (void) recievedMBTwitterScrollButtonClicked {
    [self.delegate recievedMBTwitterScrollButtonClicked];
}



- (void) recievedMBTwitterScrollEvent {
    [self.delegate recievedMBTwitterScrollEvent];
}


// Function to blur the header image (used if the header image is replaced with updateHeaderImage)
-(void)resetBlurImages:(UIImage*)newImage {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //blur the image in a second thread
        UIImage *blurredImage = [newImage applyBlurWithRadius:10 tintColor:[UIColor clearColor] saturationDeltaFactor:1.5 maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //set the blurred image to your imageView in the main thread
            self.headerBlurImageView.image = blurredImage;
        });
    });
}


// Function to update the header image and blur it out appropriately
-(void)updateHeaderImage:(UIImage*)newImage {
    self.headerImageView.image = newImage;
    
    [self resetBlurImages:newImage];
    
}

@end
