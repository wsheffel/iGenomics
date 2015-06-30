//
//  ComputingController.h
//  iGenomics
//
//  Created by Stuckinaboot Inc. on 1/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AnalysisController.h"
#import "BWT.h"
#import "APTimer.h"

#define kPrintReadProcessedInConsole 0
#define kReadProcessedLblTxt @"%i/%i Reads Processed"

#define kComputingTimeRemainingPreCalculatedTxt @"Calculating Time Remaining"
#define kComputingTimeRaminingCalculatedTxt @"%02d:%02d:%02d remaining"

#define kComputingTimeRemainingUpdateInterval 1.0f
#define kComputingTimeRemainingNumOfReadsToBaseTimeOffOf 100
#define kComputingTimeRemainingFracOfReadsToBeginFreqUpdatingAt .5
#define kComputingTimeRemainingNumOfSDsToAddToMeanTimeRemaining 1

#define kShowAnalysisControllerDelay 1.0f // Wait for viewDidAppear/viewDidDisappear to know the current transition has completed' (error from console), this should fix it

#define kFirstQualValueIndexInReadsToTrim 2
#define kTrimmingOffVal -1
#define kTrimmingRefChar0 '!'
#define kTrimmingRefChar0Index 0
#define kTrimmingRefChar1 '@'
#define kTrimmingRefChar1Index 1

@interface ComputingController : UIViewController <BWT_Delegate> {
    IBOutlet UIProgressView *readProgressView;
    IBOutlet UILabel *readsProcessedLbl;
    IBOutlet UILabel *timeRemainingLbl;
    int readsProcessed;
    int timeRemaining;
    double timesToProcessComputingReads[kComputingTimeRemainingNumOfReadsToBaseTimeOffOf];
    
    BWT *bwt;
    AnalysisController *analysisController;
    NSMutableString *exportDataStr;
    
    APTimer *readTimer;
    NSTimer *timeRemainingUpdateTimer;
    
}
- (void)setUpWithReads:(NSString*)myReads andSeq:(NSString*)mySeq andParameters:(NSArray*)myParameterArray andRefFilePath:(NSString*)path andImptMutsFileContents:(NSString*)imptMutsContents;//path is empty if not dropbox
- (NSString*)readsAfterTrimmingForReads:(NSString*)reads andTrimValue:(int)trimValue andReferenceQualityChar:(char)refChar;
- (void)showAnalysisController;
- (void)updateReadsProcessedLblTimeRemaining;

- (void)computeInitialTimeRemaining;
@end
