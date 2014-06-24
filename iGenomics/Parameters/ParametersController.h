//
//  ParametersController.h
//  iGenomics
//
//  Created by Stuckinaboot Inc. on 1/4/13.
//
//

#import <UIKit/UIKit.h>
#import "ComputingController.h"
#import "APTimer.h"
#import "Read.h"

//------------Max ED is 10-----------------

/*
 SET OF PARAMETERS:
 
 0-Exact match (0), substitution (1), subs + indels (2) | TYPE: int (exact,sub,subs+indels), 1-int (ED)
      +Max ED
 
 2-Forward alignment(0), forward and reverse alignments (1) | TYPE: int
 
 3-Mutation support (num of disagreements before a position is reported as a mutation): (inputted by user) | TYPE: int
 
 4-Trimming (if selected, chop off last x (user is allowed to chose num) bases) | TYPE: int
 
 -Seed (chunk) length: automatic, manual (user inputs seed length)  | TYPE: int
     +(Advanced feature)       -------NOT IMPLEMENTED YET
 
 5-Ref File Name
 6-Read File Name
 
 */

#define kFaInterval 2
#define kFqInterval 4
//Special File Types End

#define kLastUsedParamsSaveKey @"LastUsedParamsKey"
#define kMaxEDLblTxt @"Max Edit Distance: %i"
#define kMutSupportLblTxt @"Mutation Coverage: %i"

#define kStartSeqDelay 0.2

#define kTrimmingStprLblTxt @"Trimming Value: %i"

@interface ParametersController : UIViewController {
    
    //Parameters
    IBOutlet UISegmentedControl *matchTypeCtrl;
    IBOutlet UILabel *maxEDLbl;
    IBOutlet UITextField *maxEDTxtFld;
    IBOutlet UIStepper *maxEDStpr;
    
    IBOutlet UISegmentedControl *alignmentTypeCtrl;
    
    IBOutlet UITextField *mutationSupportTxtFld;//call it "Minimum Mutation Coverage"
    IBOutlet UIStepper *mutationSupportStpr;
    IBOutlet UILabel *mutationSupportLbl;
    
    IBOutlet UIStepper *trimmingStpr;
    IBOutlet UILabel *trimmingLbl;
    IBOutlet UILabel *trimmingRefCharLbl;
    IBOutlet UISegmentedControl *trimmingRefCharCtrl;
    IBOutlet UISwitch *trimmingSwitch;
    IBOutlet UILabel *trimmingEnabledLbl;
    //Parameters end
    
    ComputingController *computingController;
}
@property (nonatomic) ComputingController *computingController;
@property (nonatomic) NSString *seq, *reads, *refFileName, *readFileName;
- (IBAction)matchTypeChanged:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)mutationSupportValueChanged:(id)sender;
- (IBAction)trimmingValueChanged:(id)sender;
- (IBAction)trimmingSwitchValueChanged:(id)sender;
- (IBAction)maxEDValueChanged:(id)sender;

- (IBAction)startSequencingPressed:(id)sender;
- (void)beginActualSequencing;
- (void)passInSeq:(NSString*)mySeq andReads:(NSString*)myReads andRefFileName:(NSString*)refN andReadFileName:(NSString*)readN;
- (IBAction)backPressed:(id)sender;

- (void)setTrimmingAllowed:(BOOL)allowed;

- (NSString*)fixReadsForReadsFileName:(NSString*)name;//Checks for .fa and .fq,returns types NSString so it can be accessed from FilePickerController
- (NSString*)fixGenomeForGenomeFileName:(NSString*)name;//Checks for .fq
- (NSString*)readsByRemovingQualityValFromReads:(NSString*)r;
- (NSString*)extFromFileName:(NSString*)name;
@end
