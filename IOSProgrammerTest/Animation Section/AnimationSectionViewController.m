 

/*
 CLASS SUMMARY:
 - Added CGPoint property to get touch location
 - Added shadow to the logo icon
 - Implemented touches methods to center the icon in the _point location
 - Implemented scaling up and down transform animation using scaleIconup and scaleIconDown methods
 - Implemented spin animation in the spinAction method 
 
 */

#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()

@end

@implementation AnimationSectionViewController

// icon size scale variable
float startScale = 1.0f;


// MARK: ViewController Lifcycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add a shadow to apIcon
    self.apIcon. layer.shadowOpacity = 0.5f;
    self.apIcon. layer.shadowOffset = CGSizeMake( 0.0f, 5.0f);
    self.apIcon. layer.shadowRadius = 5.0f;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// MARK: Touches Methods

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    UITouch *touch = [touches anyObject];
    _point = [touch locationInView:self.view];
    _apIcon.center = _point;
 
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // _apIcon.center = self.view.center;
    
}



// MARK: Animation Methods

-(void)scaleIconUp {
    // Create a basic animation changing the transform.scale value
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:startScale]];
    [animation setToValue:[NSNumber numberWithFloat:1.7f]];
    // Set duration
    [animation setDuration:0.6f];
    // Set animation to be consistent on completion
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    // Add animation to the view's layer
    [[_apIcon layer] addAnimation:animation forKey:@"scale"];
    
}

-(void)scaleIconDown {
    // Create a basic animation changing the transform.scale value
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setFromValue:[NSNumber numberWithFloat:1.7f]];
    [animation setToValue:[NSNumber numberWithFloat:0.5f]];
    startScale = 0.5f;
    // Set duration
    [animation setDuration:1.3f];
    // Set animation to be consistent on completion
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    // Add animation to the view's layer
    [[_apIcon layer] addAnimation:animation forKey:@"scale"];
    
}




// MARK: Actions

-(IBAction)spinAction:(id)sender{
    
    // Scale up the icon with animation
    [self scaleIconUp];
    
    // Rotate animation
    CABasicAnimation *rotate360 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    // From 0 to 360 degrees
    rotate360.fromValue = [NSNumber numberWithFloat:0];;
    rotate360.toValue = [NSNumber numberWithFloat:360*M_PI/180];
    rotate360.duration = 1.0;
    rotate360.repeatCount = 2;
    // Apply the Animation
    [_apIcon.layer addAnimation:rotate360 forKey:@"360"];
    
    // Call scale down method to scale down the icon before rotation finishes
    [self performSelector:@selector(scaleIconDown) withObject: nil afterDelay: 0.7];
 
}


- (IBAction)backAction:(id)sender
{
    startScale = 1.0f;
   // MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
    [self.navigationController popViewControllerAnimated:YES];
}





@end
