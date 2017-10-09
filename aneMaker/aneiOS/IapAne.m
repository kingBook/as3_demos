#import "IapAne.h"
/*
 *  utils function
 */
/*--------------------------------string------------------------------------*/
NSString * getStringFromFREObject(FREObject obj)
{
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(obj, &length, &value);
    return [NSString stringWithUTF8String:(const char *)value];
}

FREObject createFREString(NSString * string)
{
    const char *str = [string UTF8String];
    FREObject obj;

    FRENewObjectFromUTF8(strlen(str)+1, (const uint8_t*)str, &obj);
    return obj;
}
/*-------------------------------double-----------------------------------*/
double getDoubleFromFREObject(FREObject obj)
{
    double number;
    FREGetObjectAsDouble(obj, &number);
    return number;
}
FREObject createFREDouble(double value)
{
    FREObject obj = nil;
    FRENewObjectFromDouble(value, &obj);
    return obj;
}
/*---------------------------------int---------------------------------*/
int getIntFromFREObject(FREObject obj)
{
    int32_t number;
    FREGetObjectAsInt32(obj, &number);
    return number;
}
FREObject createFREInt(int value)
{
    FREObject obj = nil;
    FRENewObjectFromInt32(value, &obj);
    return obj;
}
/*------------------------------bool----------------------------------------*/
BOOL getBoolFromFREObject(FREObject obj)
{
    uint32_t boolean;
    FREGetObjectAsBool(obj, &boolean);
    return boolean;
}

FREObject createFREBool(BOOL value)
{
    FREObject obj = nil;
    FRENewObjectFromBool(value, &obj);
    return obj;
}
/*--------------------------------------------------------------------------*/
/***********************event dispatcher***************************/
void dispatchStatusEventAsync(NSString * code, NSString * level){
	if(context!= nil){
        FREDispatchStatusEventAsync(context, (const uint8_t *) [code UTF8String], (const uint8_t *) [level UTF8String]);
    }else{
        NSLog(@"===dispatchStatusEventAsync error FREContext is null");
    }
}
/**************************************************/

void ExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) {
    NSLog(@"===Entering ExtensionInitializer()");
    *extDataToSet = NULL;
    *ctxInitializerToSet = &ContextInitializer; //传入Context初始化方法
    *ctxFinalizerToSet = &ContextFinalizer; //传入Context结束方法

    NSLog(@"===Exiting ExtensionInitializer()");}

void ExtensionFinalizer(void* extData) {
    NSLog(@"===Entering ExtensionFinalizer()");
    // 可以做清理工作.
    NSLog(@"===Exiting ExtensionFinalizer()");
}

void ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet) {

    static FRENamedFunction func[] =
    {
        MAP_FUNCTION(initialize, NULL)
    };

    *numFunctionsToSet = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
}

void ContextFinalizer(FREContext ctx) {
    NSLog(@"===Entering ContextFinalizer()");
    // 可以做清理工作
    NSLog(@"===Exiting ContextFinalizer()");
}


ANE_FUNCTION(initialize){
	context=ctx;
	dispatchStatusEventAsync(@"initialized",@"by kingBook");
    return NULL;
}

