; XFAIL: *
; RUN: llc %s --mattr=+complxnum -o - | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-ni:1-p2:32:8:8:32-ni:2"
target triple = "aarch64-none-linux-gnu"

; Check that deinterleaving pass doesn't generate broken IR
define void @check_deinterleave_crash() #0 {
bb:
  br label %bb173

bb173:                                            ; preds = %bb173, %bb
  %phi177 = phi <2 x i32> [ %add190, %bb173 ], [ zeroinitializer, %bb ]
  %phi178 = phi <2 x i32> [ %add187, %bb173 ], [ zeroinitializer, %bb ]
  %add185 = add <2 x i32> %phi178, <i32 1, i32 1>
  %add186 = add <2 x i32> %phi177, <i32 1, i32 1>
  %shufflevector = shufflevector <2 x i32> zeroinitializer, <2 x i32> zeroinitializer, <2 x i32> zeroinitializer
  %add187 = add <2 x i32> %add185, %shufflevector
  %shufflevector189 = shufflevector <2 x i32> zeroinitializer, <2 x i32> zeroinitializer, <2 x i32> zeroinitializer
  %add190 = add <2 x i32> %add186, %shufflevector189
  br i1 poison, label %bb193, label %bb173

bb193:                                            ; preds = %bb173
  %add194 = or <2 x i32> %add190, %add187
  store volatile i32 0, ptr null, align 4
  unreachable
}
