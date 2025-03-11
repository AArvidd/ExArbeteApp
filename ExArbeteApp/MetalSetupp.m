//
//  MetalAdder.m
//  metalTest2
//
//  Created by Arvid.Oscarsson on 2024-11-22.
//

#import "MetalSetupp.h"


@implementation MetalSetupp{
    id<MTLDevice> _mDevice;
    
    id<MTLComputePipelineState> _mComputeFunctionPSO;
    
    id<MTLCommandQueue> _mCommandQueue;
    
    id<MTLBuffer> _mBufferConstI;
    id<MTLBuffer> _mBufferConstF;
    
    id<MTLBuffer> _mBufferOut;
    
    CGImageRef cgImage;
    
    unsigned long arrayLength;
    unsigned long bufferSize;
    
}

- (instancetype _Nonnull ) initWithDevice: (id<MTLDevice>_Nonnull)device {
    self = [super init];
    if(self){
        
        _pWidth = 1000;
        _pHeight = 1000;
        _colorMode = 0;
        
        arrayLength = _pWidth * _pHeight;
        bufferSize = arrayLength * sizeof(int);
        	
        _FPX = 0;
        _FPY = 0;
        _FPwidth = 2 << NUM_FRAC_BITS;
        
        _mDevice = device;
        
        NSError* error = nil;
        
        id<MTLLibrary> deafultLibrary = [_mDevice newDefaultLibrary];
        if(deafultLibrary == nil){
            NSLog(@"Faild to find the default library");
            return nil;
        }
        
        id<MTLFunction> computFunction = [deafultLibrary newFunctionWithName:@"calculate_madelbrot"];
        if(computFunction == nil){
            NSLog(@"Faild to find the adder function");
            return nil;
        }
        
        _mComputeFunctionPSO = [_mDevice newComputePipelineStateWithFunction:computFunction error:&error];
        if(_mComputeFunctionPSO == nil){
            NSLog(@"Faild to create pipeline state object, error %@", error);
            return nil;
        }
        
        _mCommandQueue = [_mDevice newCommandQueue];
        if(_mCommandQueue == nil){
            NSLog(@"Faild to find comand queue");
            return nil;
        }
    }
    return self;
}

- (void) prepareData{
    
    int deltaPixle = (int)(_FPwidth / _pWidth);
    
    int upperLeftX = _FPX - ((_pWidth * deltaPixle) / 2);
    int upperLeftY = _FPY + ((_pHeight * deltaPixle) / 2);
    
    _mBufferConstI = [_mDevice newBufferWithLength:3 * sizeof(int) options:MTLResourceStorageModeShared];
    _mBufferConstF = [_mDevice newBufferWithLength:3 * sizeof(float) options:MTLResourceStorageModeShared];
    _mBufferOut = [_mDevice newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    
    
    int* constIP = _mBufferConstI.contents;
    int* constFPP = _mBufferConstF.contents;
    constIP[0] = _pWidth;
    constIP[1] = _pHeight;
    constIP[2] = _colorMode;
    
    constFPP[0] = upperLeftX;
    constFPP[1] = upperLeftY;
    constFPP[2] = deltaPixle;
    
}

- (void) SendComputeCommand {
    
    id<MTLCommandBuffer> commandBuffer = [_mCommandQueue commandBuffer];
    assert(commandBuffer != nil);
    
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    assert(computeEncoder != nil);
    
    [self encodeAddCommand:computeEncoder];
    
    [computeEncoder endEncoding];
    
    [commandBuffer commit];
    
    [commandBuffer waitUntilCompleted];
    
    [self prepareImage];
}

- (void)encodeAddCommand:(id<MTLComputeCommandEncoder>_Nonnull)computeEncoder {
    [computeEncoder setComputePipelineState:_mComputeFunctionPSO];
    [computeEncoder setBuffer:_mBufferConstI offset:0 atIndex:0];
    [computeEncoder setBuffer:_mBufferConstF offset:0 atIndex:1];
    [computeEncoder setBuffer:_mBufferOut offset:0 atIndex:2];
    
    MTLSize gridSize = MTLSizeMake(arrayLength, 1, 1);
    
    NSUInteger thredGroupSize = _mComputeFunctionPSO.maxTotalThreadsPerThreadgroup;
    if(thredGroupSize > arrayLength){
        thredGroupSize = arrayLength;
    }
    MTLSize thredgroupSize = MTLSizeMake(thredGroupSize, 1, 1);
    
    [computeEncoder dispatchThreads:gridSize threadsPerThreadgroup:thredgroupSize];
}


- (void) prepareImage{
    int* data = _mBufferOut.contents;
    
    if(!data){
        NSLog(@"faild to allocate memory");
        return;
    }
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(data, _pWidth, _pHeight, 8, _pWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colorSpace);
    
    if(!context){
        NSLog(@"faild context");
        free(data);
        return;
    }
    
    cgImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    if(!cgImage){
        NSLog(@"faild cgImage");
        return;
    }
    
    _nsImage = [[NSImage alloc] initWithCGImage:cgImage size:NSZeroSize];
}


- (void) saveImage: (NSString*) filePath{
    
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:filePath];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL(url, kUTTypePNG, 1, NULL);
    
    if(destination == nil){
        NSLog(@"no destination");
        return;
    }
    
    CGImageDestinationAddImage(destination, cgImage, nil);
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
}

- (void) uppdateData{
    
    unsigned long oldBSize = bufferSize;
    
    arrayLength = _pWidth * _pHeight;
    bufferSize = arrayLength * sizeof(int);
    
    if(bufferSize != oldBSize){
        _mBufferOut = [_mDevice newBufferWithLength:bufferSize options:MTLResourceStorageModeShared];
    }
    
    int FPdeltaPixle = (int)(_FPwidth / _pWidth);
    
    int FPupperLeftX = _FPX - ((_pWidth * FPdeltaPixle) / 2);
    int FPupperLeftY = _FPY + ((_pHeight * FPdeltaPixle) / 2);
    
    int* constIP = _mBufferConstI.contents;
    int* constFPP = _mBufferConstF.contents;
    
    constIP[0] = _pWidth;
    constIP[1] = _pHeight;
    constIP[2] = _colorMode;
    
    constFPP[0] = FPupperLeftX;
    constFPP[1] = FPupperLeftY;
    constFPP[2] = FPdeltaPixle;
    
}

@end
