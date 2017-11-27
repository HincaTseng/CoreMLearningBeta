//
//  main.m
//  CoreMLearning
//
//  Created by 曾宪杰 on 2017/11/25.
//  Copyright © 2017年 曾宪杰. All rights reserved.
//
/*
 iPhone真实的运行环境是没有sys/ptrace.h抛出。ptrace 方法没有被抛出, 可以通过dlopen拿到它。
 dlopen：
 当path 参数为0是,他会自动查找 $LD_LIBRARY_PATH,
 $DYLD_LIBRARY_PATH, $DYLD_FALLBACK_LIBRARY_PATH 和 当前工作目录中的动态链接库.
 */
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import <sys/types.h>
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)

void disable_gdb() {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}

int main(int argc, char * argv[]) {
#ifdef DEBUG
    disable_gdb();
#endif
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
