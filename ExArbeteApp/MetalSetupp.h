//
//  MetalSetupp.h
//  ExArbeteMVP
//
//  Created by Arvid.Oscarsson on 2024-11-28.
//

#import <Foundation/Foundation.h>
#import "Metal/Metal.h"
#import "CoreGraphics/CoreGraphics.h"
#import "CoreServices/CoreServices.h"
#import "ImageIO/ImageIO.h"
#import "Cocoa/Cocoa.h"


NS_ASSUME_NONNULL_BEGIN

@interface MetalSetupp : NSObject
- (instancetype) initWithDevice: (id<MTLDevice>) device;
- (void) prepareData;
- (void) SendComputeCommand;
- (void) prepareImage;
- (void) saveImage: (NSString*) filePath;
- (void) uppdateData;

@property (readonly) NSImage* nsImage;

@property (readwrite) float X;
@property (readwrite) float Y;
@property (readwrite) float width;

@property (readwrite) unsigned int pWidth;
@property (readwrite) unsigned int pHeight;
@property (readwrite) unsigned int colorMode;

@end

NS_ASSUME_NONNULL_END
