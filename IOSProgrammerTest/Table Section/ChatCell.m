
/*
 CLASS SUMMARY:
 - Added UIImageView in the xib file, and connected it to imgView property
 
 In loadWithData Method:
 
   - Used SDWebImage library from github https://github.com/rs/SDWebImage to achieve image caching and downloading in the background for smoth table view scroling
 
   - Used SDWebImageManager's method downloadImageWithURL to download images. I got the url from chatData object using the key avatar_url.
 
   - In download completed block, I call resizedImg method to resize the image, and then made the imageView  a circle by modifying its layer.
 */


#import "ChatCell.h"
#import "UIImageView+WebCache.h"

@interface ChatCell ()

@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;
@property (nonatomic, weak) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}


- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;
    
// Download image from url
    NSURL *url = [NSURL URLWithString:chatData.avatar_url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:url  options:0  progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // progression tracking code
                                     }
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,NSURL*imageURL)
         { // Download completed
             
           if(error == nil){ // Check Errors
               
              if (image) { // Do something with image
                  
                      // Set the image to imageView after resizing
                       self.imageView.image = [self resizeImg:image];
                      // Make the imageView a circle
                       self.imageView.layer.cornerRadius = 30;
                       self.imageView.layer.masksToBounds = YES;
               }
           }// error != nil
           else{
               // Call Alert View method with the error message
               [self showAlert:@"Error" : error.localizedDescription];
           }
         }
     ];
 
}



// MARK: Custom Methods

// Image Resising Method
-(UIImage *)resizeImg :(UIImage*)img
{
    // Place image size here
    CGFloat width = 60.0f;
    CGFloat height = 60.0f;
    CGSize newSize = CGSizeMake(width, height);
    /*
     We can remove the below comment if we dont want to scale the image in retina devices, and comment UIGraphicsBeginImageContextWithOptions
    */
    //UIGraphicsBeginImageContext(imageSize);
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    // Draw the receved image based on new size
    [img drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* resizedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImg;
}



// Call this alert method when there is an error loading images from the internet
-(void) showAlert:(NSString *)title : (NSString *)message{
    
    UIAlertView *alrtView = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil ];
    [alrtView show];
    
}


@end
