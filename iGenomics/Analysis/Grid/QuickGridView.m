//
//  GridView.m
//  CompletelyCustomDNAGrid
//
//  Created by Stuckinaboot Inc. on 2/26/13.
//  Copyright (c) 2013 Stuckinaboot Inc. All rights reserved.
//

#import "QuickGridView.h"

@implementation QuickGridView

@synthesize boxHeight, boxWidth, boxWidthDecimal, delegate, refSeq, currOffset, totalRows, totalCols, numOfBoxesPerPixel, scrollingView, kTxtFontSize, kMinTxtFontSize, graphBoxHeight, drawingView, kGridLineWidthCol, shouldUpdateScrollView, maxCoverageVal;

- (void)firstSetUp {
    prevOffset = -1;
    
    dnaColors = [[DNAColors alloc] init];
    [dnaColors setUp];
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    scrollingView = [[UIScrollView alloc] initWithFrame:rect];
    [scrollingView setDelegate:self];
    [scrollingView setBackgroundColor:[UIColor clearColor]];
    scrollingView.bounces = NO;
    [scrollingView setShowsHorizontalScrollIndicator:NO];
    
    drawingView = [[UIImageView alloc] initWithFrame:rect];
    
    maxCovLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMaxCovValLblW, kMaxCovValLblH)];
    [maxCovLbl setBackgroundColor:[UIColor clearColor]];
    [maxCovLbl setTextColor:[UIColor blackColor]];
    
    tickMarkConnectingLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, kPosLblHeight-(kPosLblTickMarkHeight/2), self.frame.size.width, kPosLblTickMarkHeight/4)];
    tickMarkConnectingLine.center = CGPointMake(tickMarkConnectingLine.center.x, kPosLblHeight-kPosLblTickMarkHeight/2);
    [tickMarkConnectingLine setBackgroundColor:[UIColor blackColor]];
    
    kPosLblInterval = kDefPosLblInterval;
}

- (void)setUpWithNumOfRows:(int)rows andCols:(int)cols andGraphBoxHeight:(double)gbHeight {
    totalRows = rows;
    totalCols = cols;
    
    if ([GlobalVars isIpad]) {
        boxWidth = kDefaultIpadBoxWidth;
        kTxtFontSize = kDefaultTxtFontSizeIPad;
        kMinTxtFontSize = kMinTxtFontSizeIPad;
    }
    else {
        boxWidth = kDefaultIphoneBoxWidth;
        kTxtFontSize = kDefaultTxtFontSizeIPhone;
        kMinTxtFontSize = kMinTxtFontSizeIPhone;
    }
    
    kGridLineWidthCol = kGridLineWidthColDefault;
    
    [self resetScrollViewContentSize];
    [self addSubview:drawingView];
    [self addSubview:scrollingView];
    [self addSubview:maxCovLbl];
    [self addSubview:tickMarkConnectingLine];
    //    [self addSubview:pxlOffsetSlider];
    
    graphBoxHeight = gbHeight;
    boxHeight = (double)((self.frame.size.height)-graphBoxHeight-kPosLblHeight-((rows-1)*kGridLineWidthRow))/(rows-1);//Finds the boxHeight for the remaining rows
    
    //For the graph find the maxCoverageVal
    //First find highest value to make the max scale
    
    for (int i = 0; i<totalCols; i++) {//This is totalCols because that is the len of the seq, if this is no longer the len of the seq, then this needs to be changed
        if (coverageArray[i]-posOccArray[kACGTLen+1][i]>maxCoverageVal) {//Don't count insertions
            maxCoverageVal = coverageArray[i];
        }
    }
    
    maxCovLbl.text = [NSString stringWithFormat:@"[0,%i]",maxCoverageVal];
    
    numOfBoxesPerPixel = kPixelWidth;
    [self setUpGridViewForPixelOffset:0];
    [self initialMutationFind];
}

- (void)setUpGridViewForPixelOffset:(double)offSet {

    prevOffset = offSet;
    currOffset = offSet;
    drawingView.image = NULL;
    
    CGSize drawingSize = self.frame.size;
    
    
    //Prevents pixelation of text on retina display
    if (UIGraphicsBeginImageContextWithOptions != NULL)
        UIGraphicsBeginImageContextWithOptions(drawingSize, NO, 0.0);//0.0 sets the scale factor to the scale of the device's main screen
    else
        UIGraphicsBeginImageContext(drawingSize);

    [drawingView.image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    if (kTxtFontSize >= kMinTxtFontSize && boxWidth >= kThresholdBoxWidth)
        [self drawDefaultBoxColors];
    
    int firstPtToDraw = round([self firstPtToDrawForOffset:offSet]/numOfBoxesPerPixel)*numOfBoxesPerPixel;//Rounds to nearest multiple of numOfBoxesPerPixel
    double firstPtOffset = [self firstPtToDrawOffset:offSet];//Will be 0 or negative

    if (kTxtFontSize >= kMinTxtFontSize && boxWidth >= kThresholdBoxWidth) {//If it is 0, there is no need for them
        kGridLineWidthCol = kGridLineWidthColDefault;
        [self drawGridLinesForOffset:firstPtOffset];
    }
    else
        kGridLineWidthCol = kGridLineWidthColDefaultMin;
    
    float x = firstPtOffset+kGridLineWidthCol;//If this passes the self.frame.size.width, stop drawing (break)
    float y = kPosLblHeight;
    
    
    for (int i = 0; i<totalRows; i++) {
        for (int j = firstPtToDraw; j<totalCols && x <= self.frame.size.width; j += numOfBoxesPerPixel, x += kGridLineWidthCol+boxWidth) {
            if (i > 0) {//Not Graph Row
                //Depending on the value of i, draw foundGenome, refGenome, etc.
                if (i == 1) {//ref
                    [self drawText:[NSString stringWithFormat:@"%c",refSeq[j]] atPoint:CGPointMake(x, y) withRGB:(double[3]){dnaColors.white.r, dnaColors.white.g, dnaColors.white.b}];
                }
                else if (i == 2) {//found genome
                    if ((refSeq[j] != foundGenome[0][j]) && boxWidth >= kThresholdBoxWidth) {//Mutation present - highlights the view. If the graph is taking up the whole view, the mutation is checked and dealt with properly when the graph is created
                        RGB *rgb;
                        for (int t = 0; t<kACGTLen; t++) {
                            if (kACGTStr[t] == foundGenome[0][j]) {
                                //v = t;
                                switch (t) {
                                    case 0:
                                        rgb = dnaColors.aLbl;
                                        break;
                                    case 1:
                                        rgb = dnaColors.cLbl;
                                        break;
                                    case 2:
                                        rgb = dnaColors.gLbl;
                                        break;
                                    case 3:
                                        rgb = dnaColors.tLbl;
                                        break;
                                }
                                break;
                            }
                            else if (kDelMarker == foundGenome[0][j]) {
                                //v = kACGTLen;
                                rgb = dnaColors.delLbl;
                                break;
                            }
                            else if (kInsMarker == foundGenome[0][j]) {
                                //v = kACGTLen+1;
                                rgb = dnaColors.insLbl;
                                break;
                            }
                        }
                        double rgbVal[3] = {rgb.r, rgb.g, rgb.b};
                        [self drawText:[NSString stringWithFormat:@"%c",foundGenome[0][j]] atPoint:CGPointMake(x, y) withRGB:rgbVal];
                        float opacity = (boxWidth < kThresholdBoxWidth) ? kMutHighlightOpacityZoomedFarOut : kMutHighlightOpacity;
                        CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), dnaColors.mutHighlight.r, dnaColors.mutHighlight.g, dnaColors.mutHighlight.b, opacity);
                        int highlightWidth = (boxWidth < kMutHighlightMinWidth) ? kMutHighlightMinWidth : boxWidth;

                        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(x+kGridLineWidthCol, kPosLblHeight, highlightWidth, self.frame.size.height-kPosLblHeight));
                        //                        [delegate mutationFoundAtPos:j];
                    }
                    else {//No mutation
                        [self drawText:[NSString stringWithFormat:@"%c",foundGenome[0][j]] atPoint:CGPointMake(x, y) withRGB:(double[3]){dnaColors.black.r,dnaColors.black.g,dnaColors.black.b}];
                    }
                }
                else {//A through insertion
                    if (posOccArray[i-3][j] > 0) {
                        RGB *rgb;
                        switch (i-3) {
                            case 0:
                                rgb = dnaColors.aLbl;
                                break;
                            case 1:
                                rgb = dnaColors.cLbl;
                                break;
                            case 2:
                                rgb = dnaColors.gLbl;
                                break;
                            case 3:
                                rgb = dnaColors.tLbl;
                                break;
                            case 4:
                                rgb = dnaColors.delLbl;
                                break;
                            case 5:
                                rgb = dnaColors.insLbl;
                                break;
                        }
                        [self drawText:[NSString stringWithFormat:@"%i",posOccArray[i-3][j]] atPoint:CGPointMake(x, y) withRGB:(double[3]){rgb.r,rgb.g,rgb.b}];
                    }
                    else
                        [self drawText:[NSString stringWithFormat:@"%i",posOccArray[i-3][j]] atPoint:CGPointMake(x, y) withRGB:(double[3]){dnaColors.defaultLbl.r, dnaColors.defaultLbl.g, dnaColors.defaultLbl.b}];
                }
            }
            else {//Graph Row
                CGRect rect;
                if (kTxtFontSize >= kMinTxtFontSize && boxWidth >= kThresholdBoxWidth) {
                    //Set up the graph
                    rect = CGRectMake(x, y, boxWidth, graphBoxHeight);
                }
                else {
                    rect = CGRectMake(x, y, boxWidth, self.bounds.size.height-kPosLblHeight);
                }

                int currCoverage = coverageArray[j]-posOccArray[kACGTLen+1][j];//Don't count insertions
                float newHeight = (currCoverage*rect.size.height)/maxCoverageVal;
                /* That kinda formula thing comes from this:
                 Coverage                X Height
                 ________       =     _________
                 Max Val		       Max Height
                 
                 X = (Coverage*Max Height)/ Max Val
                 */
                
                CGRect newRect = CGRectMake(x, y+(rect.size.height-newHeight), rect.size.width, newHeight);
                BOOL mutationPresent = [self mutationPresentWithinInterval:j andEndIndex:j+numOfBoxesPerPixel-1];//Highlights the bar of the graph
                RGB *color = (mutationPresent) ? dnaColors.mutHighlight : dnaColors.graph;
                if (mutationPresent)
                    NSLog(@"");
                [self drawRectangle:newRect withRGB:(double[3]){color.r,color.g,color.b}];
                
                //Put a position label above the graph
                int intervalNum = j;
                if (numOfBoxesPerPixel == kPixelWidth)
                    intervalNum++;
                int nearestPosInterval = roundf(intervalNum/kPosLblInterval)*kPosLblInterval;
                if ((numOfBoxesPerPixel == kPixelWidth) ? intervalNum % kPosLblInterval == 0 : (intervalNum-numOfBoxesPerPixel < nearestPosInterval && intervalNum+numOfBoxesPerPixel >= nearestPosInterval)) {//Multiple of kPosLblInterval
                    NSNumberFormatter *num = [[NSNumberFormatter alloc] init];
                    [num setNumberStyle: NSNumberFormatterDecimalStyle];
                    
                    UIFont *font = [UIFont systemFontOfSize:([GlobalVars isOldIPhone]) ? kPosLblFontSizeIPhoneOld : kPosLblFontSize];
                    NSString *numStr = [num stringFromNumber:[NSNumber numberWithInt:(numOfBoxesPerPixel == kPixelWidth) ? intervalNum : nearestPosInterval]];
                    float numStrWidth = [numStr sizeWithFont:font].width;
                    
                    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1.0f);
                    [numStr drawAtPoint:CGPointMake(x+(boxWidth/2)-numStrWidth/2, 0) withFont:font];
                    
                    [self drawRectangle:CGRectMake(x+(boxWidth/2), kPosLblHeight-kPosLblTickMarkHeight, kGridLineWidthColDefault, kPosLblTickMarkHeight) withRGB:(double[]){0,0,0}];
                }
            }
        }
        x = firstPtOffset;

        if (i > 0)
            y += kGridLineWidthRow+boxHeight;
        else
            y += kGridLineWidthRow+graphBoxHeight;
    }
    
    [self drawSegmentDividers];
    
    newDrawingViewImg = UIGraphicsGetImageFromCurrentImageContext();
    [self setNeedsDisplay];
    //    [drawingView performSelectorInBackground:@selector(setImage:) withObject:UIGraphicsGetImageFromCurrentImageContext()];
    //    drawingView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    if (self.currOffset != scrollingView.contentOffset.x)
    //        [scrollingView setContentOffset:CGPointMake(self.currOffset, 0) animated:NO];
    
    [delegate gridFinishedUpdatingWithOffset:currOffset];
}

- (void)drawRect:(CGRect)rect {
    drawingView.image = newDrawingViewImg;
}

- (BOOL)mutationPresentWithinInterval:(int)startIndex andEndIndex:(int)endIndex {
    for (int i = startIndex; i <= endIndex; i++) {
        if (refSeq[i] != foundGenome[0][i])
            return YES;
    }
    return NO;
}

- (void)resetScrollViewContentSize {
    numOfBoxesPerPixel = 1.0f/boxWidthDecimal;
    if (numOfBoxesPerPixel < kPixelWidth)
        numOfBoxesPerPixel = kPixelWidth;
    if (boxWidthDecimal >= kPixelWidth)
        [scrollingView setContentSize:CGSizeMake(totalCols*(kGridLineWidthCol+boxWidth), scrollingView.frame.size.height)];
    else {
        float widthInPixels = ((float)totalCols)/numOfBoxesPerPixel;
        [scrollingView setContentSize:CGSizeMake(widthInPixels, scrollingView.frame.size.height)];
    }
}

- (int)firstPtToDrawForOffset:(double)offset {
    return (offset*numOfBoxesPerPixel)/(kGridLineWidthCol+boxWidth);
}

- (double)firstPtToDrawOffset:(double)offset {
    return -((int)offset*numOfBoxesPerPixel) % ((int)kGridLineWidthCol+(int)boxWidth);
}

- (double)offsetOfPt:(double)point {
    return (point*(kGridLineWidthCol+boxWidth)/numOfBoxesPerPixel);
}

- (void)initialMutationFind {
    for (int i = 0; i<totalCols; i++) {
        if (foundGenome[0][i] != refSeq[i] || (foundGenome[1][i] != refSeq[i] && foundGenome[1][i] != kFoundGenomeDefaultChar)) {//If the found genome doesn't match, then report as a potential mutation, but also if the next possible spot in the found genome doesn't match report it as a potential mutation because it could be heterozygous
            [delegate mutationFoundAtPos:i];
        }
    }
}

//Draw Tick Marks
- (void)drawTickMarksForStartingPos:(int)pos {
    int zeroes = 0;
    int colsOnScreen = (self.frame.size.width/(boxWidth+kGridLineWidthCol));
    double interval = colsOnScreen/kPosLblNum;
    
    for (zeroes = 0; pos>10; zeroes++)
        pos = floorf(pos/10);
    for (int i = 0; i<zeroes; i++)
        pos *= 10;
    
    NSNumberFormatter *num = [[NSNumberFormatter alloc] init];
    [num setNumberStyle: NSNumberFormatterDecimalStyle];
    
    for (int i = 0; i<kPosLblNum; i++) {
        CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), dnaColors.black.r, dnaColors.black.g, dnaColors.black.b, 1.0f);
        
        UIFont *font = [UIFont systemFontOfSize:kPosLblFontSize];
        NSString *numStr = [num stringFromNumber:[NSNumber numberWithInt:pos]];
        float numStrWidth = [numStr sizeWithFont:font].width;
        
        [numStr drawAtPoint:CGPointMake(pos*(boxWidth+kGridLineWidthCol)+(boxWidth/2)-numStrWidth/2, 0) withFont:font];
        
        [self drawRectangle:CGRectMake(pos*(boxWidth+kGridLineWidthCol)+(boxWidth/2), kPosLblHeight-kPosLblTickMarkHeight, kGridLineWidthColDefault, kPosLblTickMarkHeight) withRGB:(double[]){0,0,0}];
        
        pos += interval;
    }
    //FOR THEH INTERVAL ON ZOOM IN/OUT ON THE FLY SHOW FIVE TICK MARKS (THE NUM OF COLUMNS ON THE SCREEN/4) ON THE SCREEN AT ALL TIMES (UNLESS THE FIFTH IS OFF THE SCREEN, THEN DO FOUR). Only show to one sig fig
    /*
     zeros = 0;  do while num>10 zeroes++ num = floorf(num/10), then do for x = 0, x<zeroes x++) num *= 10
     num = 3123;
     */
}

- (void)resetTickMarkInterval {
    //First find num of cols on screen
    int numOfColsOnScreen = 0;//Is modified when numOfBoxesPerPixel > kPixelWidth
//    int actualNumOfColsOnScreen = 0;//Not modified when above occurs
    
    int x = 0;
    for (int i = 0; i<totalCols; i++, x += boxWidth, numOfColsOnScreen++) {
        if (x>self.frame.size.width)
            break;
    }
    
//    actualNumOfColsOnScreen = numOfColsOnScreen;
    numOfColsOnScreen *= numOfBoxesPerPixel;
    kPosLblInterval = numOfColsOnScreen/kPosLblNum;
    
    
    if (kPosLblInterval<5)
        kPosLblInterval = 5;
    else if (kPosLblInterval<10)
        kPosLblInterval = 10;
    

    //Now make the interval nicer
    int zeroes;
    for (zeroes = 0; kPosLblInterval>10; zeroes++)
        kPosLblInterval = floorf(kPosLblInterval/10);
    for (int i = 0; i<zeroes; i++)
        kPosLblInterval *= 10;
    
    while (numOfColsOnScreen/kPosLblInterval > kPosLblNum) {
        kPosLblInterval *= 2;
    }
}

//Create Grid Lines
- (void)drawGridLinesForOffset:(double)offset {
    double rgb[3] = {1,1,1};
    
    float x = offset;
    float y = kPosLblHeight+graphBoxHeight;
    
    for (int i = 1; i<totalRows; i++) {
        [self drawRectangle:CGRectMake(x, y, self.frame.size.width+(abs(offset)), kGridLineWidthRow) withRGB:rgb];
        y += kGridLineWidthRow+boxHeight;
    }
    y = kPosLblHeight;
    
    for (int i = 0; i<totalCols; i++) {
        [self drawRectangle:CGRectMake(x, y, kGridLineWidthCol, self.frame.size.height) withRGB:rgb];
        x += kGridLineWidthCol+boxWidth;
        
        if (x > self.frame.size.width)
            break;
    }
}

- (void)drawSegmentDividers {
    float segOffset = 0;
    NSArray *arr = [delegate getCumulativeSeparateGenomeLenArray];
    NSMutableArray* segOffsetsToDrawAt = [[NSMutableArray alloc] init];
    NSMutableArray* segOffsetindexesToDrawAt = [[NSMutableArray alloc] init];
    int index = 0;
    BOOL alreadyUpdatedGenomeNameLbl = FALSE;
    if ([arr count] > 1) {
        for (int i = [arr count]-1; i >= 0; i--) {
            segOffset = [self offsetOfPt:[[arr objectAtIndex:i] intValue]];//Makes sense because offset is of the start of the block after that genome ends, so it checks if currOffset is before that
            if (segOffset <= currOffset+self.bounds.size.width && segOffset >= currOffset) {
                [segOffsetsToDrawAt addObject:[NSNumber numberWithFloat:segOffset]];
                [segOffsetindexesToDrawAt addObject:[NSNumber numberWithInteger:i]];
            }
            if (currOffset <= segOffset)
                index = i;
            else if (!alreadyUpdatedGenomeNameLbl) {
                [delegate shouldUpdateGenomeNameLabelForIndexInSeparateGenomeLenArray:index];
                alreadyUpdatedGenomeNameLbl = TRUE;
//                break;
            }
            if (!alreadyUpdatedGenomeNameLbl)
                [delegate shouldUpdateGenomeNameLabelForIndexInSeparateGenomeLenArray:index];
            
            //        if (segOffset < currOffset+self.bounds.size.width) {
            //            [self drawRectangle:CGRectMake(segOffset, kPosLblHeight, kSegmentDividerWidth, self.bounds.size.height-kPosLblHeight) withRGB:(double[3]){dnaColors.segmentDivider.r, dnaColors.segmentDivider.g, dnaColors.segmentDivider.b}];
            //        }
            UIFont *font = [UIFont systemFontOfSize:kSegmentDividerFontSize];
            for (int i = 0; i < [segOffsetsToDrawAt count]; i++) {
                int index = [[segOffsetindexesToDrawAt objectAtIndex:i] intValue]+1;//+1 to show the name of the next segment
                if (index <= [arr count]-1) {
                    segOffset = [[segOffsetsToDrawAt objectAtIndex:i] floatValue];
                    CGRect rect = CGRectMake(segOffset-currOffset, kPosLblHeight-kPosLblTickMarkHeight/2, kSegmentDividerWidth, self.bounds.size.height-kPosLblHeight+kPosLblTickMarkHeight/2);
                    [self drawRectangle:rect withRGB:(double[3]){dnaColors.segmentDivider.r, dnaColors.segmentDivider.g, dnaColors.segmentDivider.b}];
                
                    NSString *str = [delegate genomeSegmentNameForIndexInGenomeNameArr:index];
                    CGSize size = [str sizeWithFont:font];
                    
                    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), dnaColors.segmentDividerTxt.r, dnaColors.segmentDividerTxt.g, dnaColors.segmentDividerTxt.b, 1.0f);
                        [str drawAtPoint:CGPointMake(segOffset-currOffset-size.width/2, kPosLblHeight-kPosLblTickMarkHeight/2-size.height) withFont:font];
                }
            }
        }
    }
}

//Create Default Colors
- (void)drawDefaultBoxColors {
    float y = kPosLblHeight+graphBoxHeight+kGridLineWidthRow;
    
    for (int i = 1; i<totalRows; i++) {
        
        if (i == 1) //Ref
            [self drawRectangle:CGRectMake(0, y, self.frame.size.width, boxHeight) withRGB:(double[3]){dnaColors.refLbl.r, dnaColors.refLbl.g, dnaColors.refLbl.b}];
        else if (i == 2) //Found
            [self drawRectangle:CGRectMake(0, y, self.frame.size.width, boxHeight) withRGB:(double[3]){dnaColors.foundLbl.r, dnaColors.foundLbl.g, dnaColors.foundLbl.b}];
        else {
            [self drawRectangle:CGRectMake(0, y, self.frame.size.width, (boxHeight+kGridLineWidthRow)*(kACGTLen+2)) withRGB:(double[3]){dnaColors.defaultBackground.r, dnaColors.defaultBackground.g, dnaColors.defaultBackground.b}];//+2 because of dels and ins
            break;
        }
        y += kGridLineWidthRow+boxHeight;
    }
}

//Scroll To Position
- (void)scrollToPos:(double)p {
    currOffset = p*(boxWidth+kGridLineWidthCol);
    if (currOffset > scrollingView.contentSize.width-self.frame.size.width-1)
        currOffset = scrollingView.contentSize.width-self.frame.size.width-1;//-1 to prevent crash due to drawing where there is nothing
    [self setUpGridViewForPixelOffset:currOffset];
    [scrollingView setContentOffset:CGPointMake(currOffset, 0)];
}

//Actual Drawing Code
- (void)drawText:(NSString*)txt atPoint:(CGPoint)point withRGB:(double[3])rgb {
    //point is the center of where the txt is to be drawn
    if (kTxtFontSize >= kMinTxtFontSize && boxWidth >= kThresholdBoxWidth) {
        CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), rgb[0], rgb[1], rgb[2], 1.0f);
        UIFont *font = [UIFont systemFontOfSize:kTxtFontSize];
        float yOffset = ((boxHeight+font.pointSize)/2.0f)-font.pointSize;
        CGSize txtSize = [txt sizeWithFont:font];
        //    [txt drawAtPoint:point withFont:[UIFont systemFontOfSize:kTxtFontSize]];
        if (txtSize.width > boxWidth) {
            for (int i = kTxtFontSize; i > 0; i--) {
                if (txtSize.width < boxWidth) {
                    yOffset = ((boxHeight+font.pointSize)/2.0f)-font.pointSize;
                    break;
                }
                font = [UIFont systemFontOfSize:i];
                txtSize = [txt sizeWithFont:font];
            }
        }
        [txt drawInRect:CGRectMake(point.x, point.y+yOffset, boxWidth+(2*kGridLineWidthCol), font.pointSize) withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter]; //boxWidth+(2*kGridLineWidthCol) because this centers the text in a larger area, which makes the centering more precise
    }
}

- (void)drawRectangle:(CGRect)rect withRGB:(double[3])rgb {
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), rgb[0], rgb[1], rgb[2], 1.0f);
    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
}

//ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (shouldUpdateScrollView)
        [self setUpGridViewForPixelOffset:scrollingView.contentOffset.x];
    shouldUpdateScrollView = !shouldUpdateScrollView;
}

- (IBAction)pxlOffsetSliderValChanged:(id)sender {
    UISlider* s = (UISlider*)sender;
    shouldUpdateScrollView = TRUE;
    [scrollingView setContentOffset:scrollingView.contentOffset animated:NO];
    [self performSelector:@selector(updateScrollView:) withObject:s afterDelay:kScrollViewSliderUpdateInterval];
    //    [self performSelector:@selector(updateScrollView:) withObject:s afterDelay:kScrollViewSliderUpdateInterval];
    //    [scrollingView setContentOffset:CGPointMake(s.value, 0)];
}

- (void)updateScrollView:(UISlider*)s {
    [scrollingView setContentOffset:CGPointMake(s.value, 0)];
}

- (void)setUpGridViewAfterDelayForPixelOffset:(NSNumber*)offset {
    [self setUpGridViewForPixelOffset:[offset doubleValue]];
}

//Setter for Box Width
- (void)setBoxWidth:(double)width {
    double prevWidth = boxWidth;
    boxWidth = ceilf(width);
    boxWidthDecimal = width;
    if (boxWidth < kMinBoxWidth)
        boxWidth = ceilf(kMinBoxWidth);
    if (boxWidthDecimal < kMinBoxWidth)
        boxWidthDecimal = kMinBoxWidth;
    if (boxWidth < kThresholdBoxWidth && prevWidth >= kThresholdBoxWidth) //Will show with graph view
        kGridLineWidthCol = kGridLineWidthColDefaultMin;
    else if (boxWidth >= kThresholdBoxWidth && prevWidth < kThresholdBoxWidth)
        kGridLineWidthCol = kGridLineWidthColDefault;
}

- (double)getProperBoxWidth {
    if (boxWidthDecimal >= kPixelWidth)
        return boxWidth;
    else
        return kPixelWidth;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end