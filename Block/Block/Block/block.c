//
//  block.c
//  Block
//
//  Created by D on 2019/5/3.
//  Copyright © 2019 D. All rights reserved.


#include <stdio.h>

int main() {

    void (^block)(void) = ^ {
        printf("Hello world\n");
    };
    block();

    return 1;
}
