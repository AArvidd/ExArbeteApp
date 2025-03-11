//
//  mandelbrotKalk.metal
//  ExArbeteMVP
//
//  Created by Arvid.Oscarsson on 2024-11-28.
//

#include <metal_stdlib>
using namespace metal;

kernel void calculate_madelbrot(
                                device int* iConst,
                                device int* FPConst,
                                device int* out,
                                uint index [[thread_position_in_grid]])
{
    
    // iConst[0] == image width
    // iConst[1] == image height
    // iConst[2] == color mode
    // fConst[0] == x position of the upper left pixle;
    // fConst[1] == y position of the upper left pixle;
    // fConst[2] == distens between two pixles in x and y direction
    // the FP prefix means thet the varible is desimal number in the fixt point system where 268435456 (10) / 10000000 (16) is one
    
    uint px = index % iConst[0]; // x position of the pixle in image
    uint py = index / iConst[0]; // y position of the pixle in image
   
    int FPx = 0;
    int FPy = 0;
    
    int FPCx = FPConst[0] + (px * FPConst[2]); // x position of the pixle in mandelbrot set
    int FPCy = FPConst[1] - (py * FPConst[2]); // y position of the pixle in mandelbrot set
   
    int maxItiration = 5000;

    for(int i = 0; i < maxItiration; i++){
        
        int xtemp = (int)((((long)FPx * FPx) - ((long)FPy * FPy)) >> 28) + FPCx;
        FPy = (int)(((long)FPx * FPy) >> 27) + FPCy;
        FPx = xtemp;
        
        if(FPx > 0x20000000 || FPy > 0x20000000 || FPx < (int)0xe0000000 || FPy < (int)0xe0000000 || (unsigned int)((((long)FPx * FPx) + ((long)FPy * FPy)) >> 28) > 0x40000000){
            float pros = (float)i / maxItiration;
            switch(iConst[2]){
                case 0:{
                    int red = pros * 255;
                    int green = (red * 10) % 255;
                    int blue = (green * 10) % 255;
                    green <<= 8;
                    blue <<= 16;
                    out[index] = 0xff000000 | blue | green | red;
                    return;
                }
                case 1:{
                    out[index] = 0xffffffff;
                    return;
                }
                
            }
        }
    }
    out[index] = 0xff000000;
    
}
