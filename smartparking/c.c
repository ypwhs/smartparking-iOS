//
//  c.cpp
//  smartparking
//
//  Created by 杨培文 on 15/5/21.
//  Copyright (c) 2015年 杨培文. All rights reserved.
//

#include "c.h"

int getNum(unsigned char* a){
    int n;
    sscanf((char*)a, "[%d]", &n);
    return n;
}
double getCm(unsigned char* a){
    double n;
    int q;
    sscanf((char*)a, "[%d]%lf", &q, &n);
    return n;
}