/*
 * The MIT License
 *
 *  Created by Jasin Alili on 09.04.13.
 *  Copyright (c) 2013 Jasin Alili. All rights reserved.
 *  Email: jasin@aon.at
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "PIM_ViewController.h"

@implementation PIM_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self onCreate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onCreate
{
    
    NSString *name = @"_TEST_?";
    NSString *phone = @"0123456789";
    //NSString *gruppe = @"_NEUE_GRUPPE_?";
    
    ABAddressBookRef addressBook;
    CFErrorRef error = NULL;
    
    // create adressbook
    addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    // ABRecordRef group = ABGroupCreate();
	ABRecordRef person = ABPersonCreate();
    
    // Phone number is a list of phone numbers, because one contact can have more numbers
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue , (__bridge CFTypeRef)(phone),kABPersonPhoneMobileLabel, NULL);

    // Insert Name and Number to Record
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
	ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), nil);
	// ABRecordSetValue(group, kABGroupNameProperty, (__bridge CFTypeRef)(gruppe), nil);
    // ABRecordSetValue(person, kABPersonLastNameProperty, @"_LASTNAME_", nil);
    
    // add the person to the Group and than save to the Addressbook
    ABAddressBookAddRecord(addressBook, person, &error);
	// ABGroupAddMember(group, person, nil);
    // ABAddressBookAddRecord(addressBook, group, nil);
	ABAddressBookSave(addressBook, nil);
    
    // CFRelease(person);
    // CFRelease(group);
    // CFRelease(addressBook);
    
    /*
    bool wantToSaveChanges = YES;
    bool didSave;
    
    if (ABAddressBookHasUnsavedChanges(addressBook)) {
        if (wantToSaveChanges) {
            didSave = ABAddressBookSave(addressBook, &error);
            if (!didSave)
            {
                // error occured
            }
        } else {
            ABAddressBookRevert(addressBook);
        }
    }
    */
}

/* Delegate Methods, to be implemented, to get the Nav.controller work
- (void)peoplePickerNavigationControllerDidCancel: (ABPeoplePickerNavigationController *) peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL)peoplePickerNavigationController: (ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
   // [self displayPersonOnView:person];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}
*/

@end






