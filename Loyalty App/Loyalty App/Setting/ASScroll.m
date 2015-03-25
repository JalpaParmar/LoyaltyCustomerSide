//
//  ASScroll.m
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import "ASScroll.h"
#import "Singleton.h"

@implementation ASScroll
@synthesize arrOfImages, btnSkip, pageControl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        // Initialization code
    }
    return self;
}

-(void)setArrOfImages:(NSMutableArray *)arr{
    [arrOfImages release];
    arrOfImages = [arr retain];
    
    scrollview = [[UIScrollView alloc]initWithFrame:self.frame];
    scrollview.contentSize = CGSizeMake(scrollview.frame.size.width * arrOfImages.count,scrollview.frame.size.height);
    [scrollview setDelegate:self];
    scrollview.showsVerticalScrollIndicator = NO;
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.pagingEnabled = YES;

    UIImage *img;
    for (int i =0; i<arrOfImages.count ; i++) {
        
        img = [UIImage imageNamed:[arrOfImages objectAtIndex:i]];
         if(img == nil)
         {
            img =  [[Singleton sharedSingleton] getImageFromCache:[[arrOfImages objectAtIndex:i] lastPathComponent]];
         }

        //  UIImage *img = [UIImage imageNamed:@"a.png"];
        UIImageView * imageview = [[UIImageView alloc]initWithImage:img];
        [imageview setContentMode:UIViewContentModeScaleAspectFill];
        imageview.clipsToBounds=YES;
//        imageview.autoresizingMask =
//        ( UIViewAutoresizingFlexibleBottomMargin
//         | UIViewAutoresizingFlexibleHeight
//         | UIViewAutoresizingFlexibleLeftMargin
//         | UIViewAutoresizingFlexibleRightMargin
//         | UIViewAutoresizingFlexibleTopMargin
//         | UIViewAutoresizingFlexibleWidth );
        
        imageview.frame = CGRectMake(0.0, 0.0,scrollview.frame.size.width , scrollview.frame.size.height);
        [imageview setTag:i+1];
        if (i !=0) {
            imageview.alpha = 0;
        }
        [self addSubview:imageview];
        [imageview release];
    }
    
    pageControl = [[UIPageControl alloc] init];
    //    pageControl.frame = CGRectMake((98/[[UIScreen mainScreen] bounds].size.width)*self.frame.size.width,(400/[[UIScreen mainScreen] bounds].size.height)*self.frame.size.height, 22, 36);
    //    pageControl.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-72, (([[UIScreen mainScreen] bounds].size.height)-110)-100, 142, 36);
    
    if(IS_IPAD)
    {
        pageControl.frame =CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-72, scrollview.frame.origin.y+scrollview.frame.size.height, 300, 40);        
        //CGRectMake(0, scrollview.frame.origin.y+scrollview.frame.size.height, [[UIScreen mainScreen] bounds].size.width, 40);//
    }
    else
    {
//        pageControl.frame = CGRectMake((98/[[UIScreen mainScreen] bounds].size.width)*self.frame.size.width,(400/[[UIScreen mainScreen] bounds].size.height)*self.frame.size.height, 22, 36);
       pageControl.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-102, scrollview.frame.origin.y+scrollview.frame.size.height, 200, 30);
    }

    pageControl.numberOfPages = arrOfImages.count;
    pageControl.currentPage = 0;
    [pageControl setBackgroundColor:[UIColor blackColor]];
    pageControl.hidden = NO;

    [pageControl addTarget:self action:@selector(pgCntlChanged:)forControlEvents:UIControlEventValueChanged];
//    [self performSelector:@selector(startAnimatingScrl) withObject:nil afterDelay:3.0];

    [self addSubview:scrollview];
    [self addSubview:pageControl];
    [self bringSubviewToFront:pageControl];
    
    btnSkip = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSkip.frame = CGRectMake (self.frame.size.width - 100, self.frame.size.height - 40, 100, 30); // CGRectMake (0, 5, 100, 40); //
    //self.frame.size.height - 40
//    [btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
    if(IS_IPAD)
    {
        btnSkip.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:25.0];
    }
    else
    {
          btnSkip.titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20.0];
    }
    [btnSkip setBackgroundColor:[UIColor clearColor]];
  
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Skip"];
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    // Or for adding Colored text use----------
    UIColor* textColor = [UIColor whiteColor];
    [commentString setAttributes:@{NSForegroundColorAttributeName:textColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(0,[commentString length])];
    // Or for adding Colored text use----------
    [btnSkip setAttributedTitle:commentString forState:UIControlStateNormal];
    [self addSubview:btnSkip];
    [self bringSubviewToFront:btnSkip];
}

- (void)startAnimatingScrl
{
    if (arrOfImages.count) {
        [scrollview scrollRectToVisible:CGRectMake(((pageControl.currentPage +1)%arrOfImages.count)*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
        [pageControl setCurrentPage:((pageControl.currentPage +1)%arrOfImages.count)];
        [self performSelector:@selector(startAnimatingScrl) withObject:nil  afterDelay:3.0];
    }
}
-(void) cancelScrollAnimation{
    didEndAnimate =YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAnimatingScrl) object:nil];
}


- (IBAction)pgCntlChanged:(UIPageControl *)sender {
    [scrollview scrollRectToVisible:CGRectMake(sender.currentPage*scrollview.frame.size.width, 0, scrollview.frame.size.width, scrollview.frame.size.height) animated:YES];
    [self cancelScrollAnimation];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [pageControl setCurrentPage:scrollview.bounds.origin.x/scrollview.frame.size.width];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self cancelScrollAnimation];
    previousTouchPoint = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    
    int w =scrollview.frame.size.width;
    int page = floor((scrollView.contentOffset.x -w) / w) + 1;
    float OldMin = w*page;
    int Value = scrollView.contentOffset.x -OldMin;
    float alpha = (Value% w) / (float)w;
    
    if (previousTouchPoint > scrollView.contentOffset.x)
        page = page+2;
    else
        page = page+1;

    UIView *nextPage = [scrollView.superview viewWithTag:page+1];
    UIView *previousPage = [scrollView.superview viewWithTag:page-1];
    UIView *currentPage = [scrollView.superview viewWithTag:page];
    
    if(previousTouchPoint <= scrollView.contentOffset.x){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = 1-alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = alpha;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 0;
    }else if(page != 0){
        if ([currentPage isKindOfClass:[UIImageView class]])
            currentPage.alpha = alpha;
        if ([nextPage isKindOfClass:[UIImageView class]])
            nextPage.alpha = 0;
        if ([previousPage isKindOfClass:[UIImageView class]])
            previousPage.alpha = 1-alpha;
    }
    if (!didEndAnimate && pageControl.currentPage == 0) {
        for (UIView * imageView in self.subviews){
            if (imageView.tag !=1 && [imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 0;
            else if([imageView isKindOfClass:[UIImageView class]])
                imageView.alpha = 1 ;
        }
    }
    
}

-(void)dealloc{
    [self cancelScrollAnimation];
    [arrOfImages release];
    [pageControl release];
    [scrollview release];
    [super dealloc];
}

@end
