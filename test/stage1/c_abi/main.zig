const std = @import("std");
const assertOrPanic = std.debug.assertOrPanic;

extern fn run_c_tests() void;

export fn zig_panic() noreturn {
    @panic("zig_panic called from C");
}

test "C importing Zig ABI Tests" {
    run_c_tests();
}

extern fn c_u8(u8) void;
extern fn c_u16(u16) void;
extern fn c_u32(u32) void;
extern fn c_u64(u64) void;
extern fn c_i8(i8) void;
extern fn c_i16(i16) void;
extern fn c_i32(i32) void;
extern fn c_i64(i64) void;

test "C ABI integers" {
    c_u8(0xff);
    c_u16(0xfffe);
    c_u32(0xfffffffd);
    c_u64(0xfffffffffffffffc);

    c_i8(-1);
    c_i16(-2);
    c_i32(-3);
    c_i64(-4);
}

export fn zig_u8(x: u8) void {
    assertOrPanic(x == 0xff);
}
export fn zig_u16(x: u16) void {
    assertOrPanic(x == 0xfffe);
}
export fn zig_u32(x: u32) void {
    assertOrPanic(x == 0xfffffffd);
}
export fn zig_u64(x: u64) void {
    assertOrPanic(x == 0xfffffffffffffffc);
}
export fn zig_i8(x: i8) void {
    assertOrPanic(x == -1);
}
export fn zig_i16(x: i16) void {
    assertOrPanic(x == -2);
}
export fn zig_i32(x: i32) void {
    assertOrPanic(x == -3);
}
export fn zig_i64(x: i64) void {
    assertOrPanic(x == -4);
}

extern fn c_f32(f32) void;
extern fn c_f64(f64) void;

test "C ABI floats" {
    c_f32(12.34);
    c_f64(56.78);
}

export fn zig_f32(x: f32) void {
    assertOrPanic(x == 12.34);
}
export fn zig_f64(x: f64) void {
    assertOrPanic(x == 56.78);
}

extern fn c_ptr(*c_void) void;

test "C ABI pointer" {
    c_ptr(@intToPtr(*c_void, 0xdeadbeef));
}

export fn zig_ptr(x: *c_void) void {
    assertOrPanic(@ptrToInt(x) == 0xdeadbeef);
}

extern fn c_bool(bool) void;

test "C ABI bool" {
    c_bool(true);
}

export fn zig_bool(x: bool) void {
    assertOrPanic(x);
}

extern fn c_array([10]u8) void;

test "C ABI array" {
    var array: [10]u8 = "1234567890";
    c_array(array);
}

export fn zig_array(x: [10]u8) void {
    assertOrPanic(std.mem.eql(u8, x, "1234567890"));
}

const BigStruct = extern struct {
    a: u64,
    b: u64,
    c: u64,
    d: u64,
    e: u8,
};
extern fn c_big_struct(BigStruct) void;

test "C ABI big struct" {
    var s = BigStruct{
        .a = 1,
        .b = 2,
        .c = 3,
        .d = 4,
        .e = 5,
    };
    c_big_struct(s);
}

export fn zig_big_struct(x: BigStruct) void {
    assertOrPanic(x.a == 1);
    assertOrPanic(x.b == 2);
    assertOrPanic(x.c == 3);
    assertOrPanic(x.d == 4);
    assertOrPanic(x.e == 5);
}
