//
//  APISectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

/*
 CLASS SUMMARY:
 - Added method createLeftMargins to add left margins the the text fields' text as in wireframe
 - Implemented the POST request functionality in loginAction method.
   I implemented the POST request based on the apple docs in https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html#//apple_ref/doc/uid/20001836-BAJEAIEE
 
 - Implemented Asynchronous request and parsed the response to get code and message data.
 - Showed the message and the code in an alert view in showAlert method
 - Implemented textFieldShouldReturn method for next and done functionality in the keyboard
 
 */


#import "LoginSectionViewController.h"
#import "MainMenuViewController.h"

@interface LoginSectionViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginSectionViewController

// Create bool variable to test whether pasword was successful
BOOL success = false;




// MARK: ViewController Lifcycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add margins to text fields texts
    [self createLeftMargins];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// MARK: Alert view methods

-(void) showAlert:(NSString *)title : (NSString *)message{
    
    UIAlertView *alrtView = [[UIAlertView alloc] initWithTitle:title
                                                 message:message
                                                 delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil ];
    [alrtView show];
    
    if([title  isEqual: @"Success"]){
        success = true;
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        // do something here...
        if(success){
            success = false;
            [self backAction:nil];
        }
        else{// if it's a wrong password, fields become active again
            [_usernameField becomeFirstResponder];
        }
        
    }
}




// MARK: Class Methods

// To add the desired left margin to the text fields texts
-(void) createLeftMargins{
    
    // Create a view to be added to the left of text field to create desired left margin
    UIView *leftViewUsr = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, _usernameField.frame.size.height)];
    leftViewUsr.backgroundColor = [UIColor whiteColor];
    _usernameField.leftView = leftViewUsr;
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    // Set delegate to self for keyboard return functionality
    _usernameField.delegate = self;
    
    // Create a view to be added to the left of text field to create desired left margin
    UIView *leftviewPsw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, _passwordField.frame.size.height)];
    leftviewPsw.backgroundColor = [UIColor whiteColor];
    _passwordField.leftView = leftviewPsw;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    // Set delegate to self for keyboard return functionality
    _passwordField.delegate = self;

}




// MARK: UITextFieldDelegate

-(BOOL) textFieldShouldReturn:(UITextField*) textField {
    if (textField == _usernameField) {
        [_usernameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }
    else{
        [self loginAction:textField];
        [_passwordField resignFirstResponder];
    }
    
    return true;
}

-(void) textFieldDidEndEditing:(UITextField*) textField {
    
}




// MARK: Actions

- (IBAction)loginAction:(id)sender {
    
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    
// Create the url
    NSURL *url = [NSURL URLWithString: @"http://dev.apppartner.com/AppPartnerProgrammerTest/scripts/login.php"];
    
// Create request based on the url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
// Set the request's content type to application/x-www-form-urlencoded
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
// Designate the request a POST request
    [request setHTTPMethod:@"POST"];
    
// In body data for the 'application/x-www-form-urlencoded' content type,
// form fields are separated by an ampersand.
    NSString *bodyData = [NSString stringWithFormat:@"username=%@&password=%@", _usernameField.text, _passwordField.text];
    
// Specify the request body data
    [request setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
  
// Start time
    NSDate *startTime = [NSDate date];
    
// Send Asynchronous request and get response
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
        completionHandler:^(NSURLResponse *response, NSData *data, NSError *err){
        if(err == nil){
        // Get time interval since start time
            NSTimeInterval callTime = -[startTime timeIntervalSinceNow];
        // Parse the data
            id JSONdata = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if([JSONdata isKindOfClass:[NSDictionary class]]){
            // Store data in a dictionary
             NSDictionary *jsonDict = (NSDictionary *) JSONdata;
            // Get dictionary values based on kies
             [self showAlert:[jsonDict objectForKey:@"code"]: [NSString stringWithFormat:@"%@ \nTime: %f",[jsonDict objectForKey:@"message"], callTime]];
            }
        }// err != nil
        else{
            [self showAlert:@"Error" : err.localizedDescription];
        }
    }];
    
    
}



- (IBAction)backAction:(id)sender
{
//    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
//    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
