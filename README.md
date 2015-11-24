# MBTwitterScroll
==========
Faster version of Martin Blampied [MBTwitterScroll](https://github.com/starchand/MBTwitterScroll/).  Remove need to pre-blurring a set of header images.  This is too slow in real world usage.  Accomplished the blur effect by creating one blur image and setting alpha value to zero.  Increase alpha value as header scrolls.

![alt tag](http://i.imgur.com/iz7BIxt.gif?1)


# Installation

## Manually
Copy the source files MBTwitterScroll folder into your project.


# Usage

Import the project

```objective-c
   #import "MBTwitterScroll.h"
```

## UITableView

To show animation on UITableVIew use the following code:

```objective-c
    MBTwitterScroll *myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:[UIImage imageNamed:@"your image"]
                                    avatarImage:[UIImage imageNamed:@"your avatar"]
                                    titleString:@"Main title"
                                    subtitleString:@"Sub title"
                                    buttonTitle:@"Follow"];  // Set nil for no button
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
```

## UIScrollView

To show animation on UIScrollView use the following code:

```objective-c
   MBTwitterScroll *myScrollView = [[MBTwitterScroll alloc]
                                      initScrollViewWithBackgound:nil
                                      avatarImage:[UIImage imageNamed:@"avatar.png"]
                                      titleString:@"Main title"
                                      subtitleString:@"Sub title"
                                      buttonTitle:@"Follow" // // Set nil for no button
                                      contentHeight:2000];
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
```

# License
MBTwitterScroll is free for all use available under the MIT license. See the LICENSE file for more information.

# Feedback or feature request?
Any problems or features contact me at phong@oclef.com
