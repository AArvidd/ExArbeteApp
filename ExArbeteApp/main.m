//
//  main.m
//  ExArbeteMVP
//
//  Created by Arvid.Oscarsson on 2024-11-28.
//

#import <Foundation/Foundation.h>
#import "Metal/Metal.h"
#import "MetalSetupp.h"
#import "UiController.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        
        MetalSetupp* adder = [[MetalSetupp alloc] initWithDevice:device];
        
        [adder prepareData];
        
        [adder SendComputeCommand];
        
        UIcontroller* ui = [[UIcontroller alloc] init:adder];
        
        [ui creatWindow];
        
    }
    return 0;
}
