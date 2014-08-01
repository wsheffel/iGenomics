//
//  AlignmentGridPosition.h
//  iGenomics
//
//  Created by Stuckinaboot Inc. on 7/11/14.
//
//

#import <Foundation/Foundation.h>

//At every position in the alignment grid, there is an AlignmentGridPosition object

#define kAlignmentGridViewReadStartIndexNone -1

#define kAlignmentGridViewCharColumnNoChar ' '//An arbitrary # to avoid confusion with any base-pair

#define kReadInfoNoAlignment 0 // 0 because that is the default int value...just trying to avoid confusion
#define kReadInfoReadMiddle 2
#define kReadInfoReadStart 3
#define kReadInfoReadEnd 4
#define kReadInfoReadPosAfterStart 5
#define kReadInfoReadPosBeforeEnd 6

#define kAlignmentGridPositionStartEndStrokeBorderWidth 2

@interface AlignmentGridPosition : NSObject {
    
}
@property (nonatomic) int startIndexInreadAlignmentsArr, readLen;
@property (nonatomic) int positionRelativeToReadStart;//0 if is start of the read
//@property (nonatomic) NSMutableString *str;
@property (nonatomic) int highestChar;//AKA set equal to the highest placeToInsertChar for this position
@property (nonatomic) char *str;
@property (nonatomic) int *readInfoStr, *readIndexStr;
//@property (nonatomic) NSMutableString *readInfoStr;
@end
