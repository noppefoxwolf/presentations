slidenumbers: true
slidecount: true
slide-transition: false
slide-dividers: #, ##, ###, ####

# How to access hidden iOS APIs and enhance development efficacy.

2024/08/23 10:50〜
Track B
Regular talk（20 min）

# noppe

- DeNA Co., Ltd.
- Indie app developer

# Agenda

- What's a private api?
- What's the best usecase?
- How to find it?

# What's a private api?

- What's a private api?
- What's kind of it?
- Why are they private?

## What's a private api?

- We're usually using frameworks.
- framework has many non-public apis.
- They are called private-api or undocumented api.

## What's kind of it?

- ObjC and Swift both has private api.
- ObjC is easy, because it under dynamic method call.
- Swift is not easy. but there are way.

## Why are they private?

- Not prepared
    - Public isn't only code. HIG, multiple-platform and api design more.
- specific

# What's the best usecase?

- What's the best usecase?
- What's the best situation?

## What's the best usecase?

- The private apis are evil?
    - No. 

- Production app
    - No. Uncompliance in review guildeline 2.5.1

- Development usage
    - Yes, but with risk.
    - Mocking, design

- Testing
    - Yes, but with risk.

## What's the best situation?

- Design case
- Mocking case
- Development case
- Testing case

### Design case

- figma, Sketch cannot build real material.
- For example, progressive blur.

### Mocking case


- private api has some UI.
- before writing difficult code.
- speedup to mocking
- For example
    - navigation subtitles.
    - device corner raidus
    - _UIHostingView
    - placeholder

### Development case 

- api design
- For example
    - UITextView
- reject risk

### Testing case

- UITesting?
- For example
    - XCUIElement

# How to find it?

- Digging
- Sharing

## Digging

- ObjC headers
- swiftinterface
- Stacktrace

### ObjC headers

- perform _methodDescription

### swiftinterface

- /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/Frameworks/

- Digging private api is hard and waste time.

### Stacktrace

- breakpoint

## Sharing

- Survey in SNS, gist and more.

# Recap

- Learn API design from APIs (include private)
- It doesn't mean it'll be there tomorrow
- If you known api, you can develop faster.
- If you want to public.
    - Send your feedback to Apple

# References

- Vibrency Effect


--- 

# Idea

