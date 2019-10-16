// Generated by Apple Swift version 5.1 (swiftlang-1100.0.270.13 clang-1100.0.33.7)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <Foundation/Foundation.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif
#if !defined(SWIFT_RESILIENT_CLASS)
# if __has_attribute(objc_class_stub)
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_class_stub))
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_class_stub)) SWIFT_CLASS_NAMED(SWIFT_NAME)
# else
#  define SWIFT_RESILIENT_CLASS(SWIFT_NAME) SWIFT_CLASS(SWIFT_NAME)
#  define SWIFT_RESILIENT_CLASS_NAMED(SWIFT_NAME) SWIFT_CLASS_NAMED(SWIFT_NAME)
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_WEAK_IMPORT)
# define SWIFT_WEAK_IMPORT __attribute__((weak_import))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if !defined(IBSegueAction)
# define IBSegueAction
#endif
#if __has_feature(modules)
#if __has_warning("-Watimport-in-framework-header")
#pragma clang diagnostic ignored "-Watimport-in-framework-header"
#endif
@import Accelerate;
@import AppKit;
@import AudioKit;
@import CoreGraphics;
@import Foundation;
@import ObjectiveC;
#endif

#import <AudioKitUI/AudioKitUI.h>

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="AudioKitUI",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

@class NSEvent;
@class NSCoder;

SWIFT_CLASS("_TtC10AudioKitUI10AKADSRView")
@interface AKADSRView : NSView
@property (nonatomic, readonly, getter=isFlipped) BOOL flipped;
@property (nonatomic, readonly) BOOL wantsDefaultClipping;
- (void)mouseDown:(NSEvent * _Nonnull)theEvent;
- (void)mouseDragged:(NSEvent * _Nonnull)theEvent;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end

@class NSColor;

SWIFT_CLASS("_TtC10AudioKitUI8AKButton")
@interface AKButton : NSView
/// Text to display on the button
@property (nonatomic, copy) NSString * _Nonnull title;
/// Button fill color
@property (nonatomic, strong) NSColor * _Nonnull color;
/// Button fill color when highlighted
@property (nonatomic, strong) NSColor * _Nullable highlightedColor;
/// Button border color
@property (nonatomic, strong) NSColor * _Nullable borderColor;
@property (nonatomic) CGFloat borderWidth;
/// Text color
@property (nonatomic, strong) NSColor * _Nullable textColor;
- (void)mouseDown:(NSEvent * _Nonnull)event;
- (void)mouseUp:(NSEvent * _Nonnull)event;
/// Initialization with no details
- (nonnull instancetype)initWithFrame:(CGRect)frame OBJC_DESIGNATED_INITIALIZER;
/// Initialization within Interface Builder
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
/// Actions to perform to make sure the view is renderable in Interface Builder
- (void)prepareForInterfaceBuilder;
/// Draw the button
- (void)drawRect:(CGRect)rect;
@end


SWIFT_PROTOCOL("_TtP10AudioKitUI18AKKeyboardDelegate_")
@protocol AKKeyboardDelegate
- (void)noteOnNote:(uint8_t)note;
- (void)noteOffWithNote:(uint8_t)note;
@end


SWIFT_CLASS("_TtC10AudioKitUI14AKKeyboardView")
@interface AKKeyboardView : NSView
@property (nonatomic, readonly, getter=isFlipped) BOOL flipped;
@property (nonatomic) NSInteger octaveCount;
@property (nonatomic) NSInteger firstOctave;
@property (nonatomic) CGFloat topKeyHeightRatio;
@property (nonatomic, strong) NSColor * _Nonnull polyphonicButton;
@property (nonatomic, strong) NSColor * _Nonnull whiteKeyOff;
@property (nonatomic, strong) NSColor * _Nonnull blackKeyOff;
@property (nonatomic, strong) NSColor * _Nonnull keyOnColor;
@property (nonatomic, strong) NSColor * _Nonnull topWhiteKeyOff;
@property (nonatomic) BOOL polyphonicMode;
- (void)drawRect:(NSRect)dirtyRect;
- (nonnull instancetype)initWithWidth:(NSInteger)width height:(NSInteger)height firstOctave:(NSInteger)firstOctave octaveCount:(NSInteger)octaveCount polyphonic:(BOOL)polyphonic OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)prepareForInterfaceBuilder;
@property (nonatomic, readonly) CGSize intrinsicContentSize;
- (void)mouseDown:(NSEvent * _Nonnull)event;
- (void)mouseUp:(NSEvent * _Nonnull)event;
- (void)mouseDragged:(NSEvent * _Nonnull)event;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end

@class NSBundle;

SWIFT_CLASS("_TtC10AudioKitUI20AKLiveViewController")
@interface AKLiveViewController : NSViewController
- (void)loadView;
- (nonnull instancetype)initWithNibName:(NSNibName _Nullable)nibNameOrNil bundle:(NSBundle * _Nullable)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end

@class AKNode;
@class EZAudioFFT;

/// Plot the FFT output from any node in an signal processing graph
SWIFT_CLASS("_TtC10AudioKitUI13AKNodeFFTPlot")
@interface AKNodeFFTPlot : EZAudioPlot <EZAudioFFTDelegate>
- (void)pause;
- (void)resume;
/// The node whose output to graph
@property (nonatomic, strong) AKNode * _Nullable node;
/// Required coder-based initialization (for use with Interface Builder)
/// \param coder NSCoder
///
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// Initialize the plot with the output from a given node and optional plot size
/// \param input AKNode from which to get the plot data
///
/// \param width Width of the view
///
/// \param height Height of the view
///
- (nonnull instancetype)init:(AKNode * _Nullable)input frame:(CGRect)frame bufferSize:(NSInteger)bufferSize OBJC_DESIGNATED_INITIALIZER;
/// Callback function for FFT data:
/// \param fft EZAudioFFT Reference
///
/// \param updatedWithFFTData A pointer to a c-style array of floats
///
/// \param bufferSize Number of elements in the FFT Data array
///
- (void)fft:(EZAudioFFT * _Null_unspecified)fft updatedWithFFTData:(float * _Nonnull)fftData bufferSize:(vDSP_Length)bufferSize;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end


/// Plot the output from any node in an signal processing graph
/// By default this plots the output of AudioKit.output
SWIFT_CLASS("_TtC10AudioKitUI16AKNodeOutputPlot")
@interface AKNodeOutputPlot : EZAudioPlot
- (void)pause;
- (void)resume;
/// The node whose output to graph
/// Defaults to AudioKit.output
@property (nonatomic, strong) AKNode * _Nullable node;
/// Required coder-based initialization (for use with Interface Builder)
/// \param coder NSCoder
///
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
/// Initialize the plot with the output from a given node and optional plot size
/// \param input AKNode from which to get the plot data
///
/// \param width Width of the view
///
/// \param height Height of the view
///
- (nonnull instancetype)init:(AKNode * _Nullable)input frame:(CGRect)frame bufferSize:(NSInteger)bufferSize OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end


/// Wrapper class for plotting audio from the final mix in a waveform plot
SWIFT_CLASS("_TtC10AudioKitUI20AKOutputWaveformPlot")
@interface AKOutputWaveformPlot : AKNodeOutputPlot
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init:(AKNode * _Nullable)input frame:(CGRect)frame bufferSize:(NSInteger)bufferSize OBJC_DESIGNATED_INITIALIZER;
@end


/// Class to handle updating via CADisplayLink
SWIFT_CLASS("_TtC10AudioKitUI16AKPlaygroundLoop")
@interface AKPlaygroundLoop : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_UNAVAILABLE_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC10AudioKitUI18AKPresetLoaderView")
@interface AKPresetLoaderView : NSView
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)mouseDown:(NSEvent * _Nonnull)theEvent;
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC10AudioKitUI17AKPropertyControl")
@interface AKPropertyControl : NSView
- (BOOL)acceptsFirstMouse:(NSEvent * _Nullable)theEvent SWIFT_WARN_UNUSED_RESULT;
/// Current value of the control
@property (nonatomic) double value;
/// Text shown on the control
@property (nonatomic, copy) NSString * _Nonnull property;
/// Format for the number shown on the control
@property (nonatomic, copy) NSString * _Nonnull format;
/// Font size
@property (nonatomic) CGFloat fontSize;
/// Initialization within Interface Builder
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)prepareForInterfaceBuilder;
- (void)mouseDown:(NSEvent * _Nonnull)theEvent;
- (void)mouseDragged:(NSEvent * _Nonnull)theEvent;
- (void)mouseUp:(NSEvent * _Nonnull)theEvent;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC10AudioKitUI30AKResourcesAudioFileLoaderView")
@interface AKResourcesAudioFileLoaderView : NSView
/// Handle click
- (void)mouseDown:(NSEvent * _Nonnull)theEvent;
/// Draw the resource loader
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
@end


/// Wrapper class for plotting audio from the final mix in a rolling plot
SWIFT_CLASS("_TtC10AudioKitUI19AKRollingOutputPlot")
@interface AKRollingOutputPlot : AKNodeOutputPlot
/// Initialize the plot in a frame with a different buffer size
/// \param frame CGRect in which to draw the plot
///
/// \param bufferSize size of the buffer - raise this number if the device struggles with generating the waveform
///
- (nonnull instancetype)initWithFrame:(CGRect)frame bufferSize:(NSInteger)bufferSize OBJC_DESIGNATED_INITIALIZER;
/// Required coder-based initialization (for use with Interface Builder)
/// \param coder NSCoder
///
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init:(AKNode * _Nullable)input frame:(CGRect)frame bufferSize:(NSInteger)bufferSize SWIFT_UNAVAILABLE;
@end


SWIFT_CLASS("_TtC10AudioKitUI12AKRotaryKnob")
@interface AKRotaryKnob : AKPropertyControl
/// Background color
@property (nonatomic, strong) NSColor * _Nullable bgColor;
/// Knob border color
@property (nonatomic, strong) NSColor * _Nullable knobBorderColor;
/// Knob indicator color
@property (nonatomic, strong) NSColor * _Nullable indicatorColor;
/// Knob overlay color
@property (nonatomic, strong) NSColor * _Nonnull knobColor;
/// Text color
@property (nonatomic, strong) NSColor * _Nullable textColor;
/// Bubble font size
@property (nonatomic) CGFloat bubbleFontSize;
@property (nonatomic) CGFloat knobBorderWidth;
@property (nonatomic) CGFloat valueBubbleBorderWidth;
@property (nonatomic) NSInteger numberOfIndicatorPoints;
/// Initialization within Interface Builder
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)mouseDown:(NSEvent * _Nonnull)theEvent;
- (void)mouseDragged:(NSEvent * _Nonnull)theEvent;
- (void)mouseUp:(NSEvent * _Nonnull)theEvent;
- (void)drawRect:(NSRect)rect;
@end


SWIFT_CLASS("_TtC10AudioKitUI8AKSlider")
@interface AKSlider : AKPropertyControl
/// Background color
@property (nonatomic, strong) NSColor * _Nullable bgColor;
/// Slider border color
@property (nonatomic, strong) NSColor * _Nullable sliderBorderColor;
/// Indicator border color
@property (nonatomic, strong) NSColor * _Nullable indicatorBorderColor;
/// Slider overlay color
@property (nonatomic, strong) NSColor * _Nonnull color;
/// Text color
@property (nonatomic, strong) NSColor * _Nullable textColor;
/// Bubble font size
@property (nonatomic) CGFloat bubbleFontSize;
@property (nonatomic) CGFloat sliderBorderWidth;
@property (nonatomic) BOOL showsValueBubble;
@property (nonatomic) CGFloat valueBubbleBorderWidth;
/// Initialization within Interface Builder
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder OBJC_DESIGNATED_INITIALIZER;
- (void)mouseDragged:(NSEvent * _Nonnull)theEvent;
/// Draw the slider
- (void)drawRect:(NSRect)rect;
@end


SWIFT_CLASS("_TtC10AudioKitUI11AKTableView")
@interface AKTableView : NSView
@property (nonatomic, readonly, getter=isFlipped) BOOL flipped;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder OBJC_DESIGNATED_INITIALIZER;
- (void)drawRect:(CGRect)rect;
- (nonnull instancetype)initWithFrame:(NSRect)frameRect SWIFT_UNAVAILABLE;
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop
