slidenumbers: true
slidecount: true
slide-transition: false
slide-dividers: #, ##, ###, ####

# iOSの隠されたAPIを解明し、開発効率を向上させる方法

2024/08/23 10:50〜
Track B
レギュラートーク（20分）

# Agenda

- What's a private api?
- Why are they private?
- What's the best usage?
    - What's risk using private api.
    - Testing
    - Mocking
- Recap

# What's a private api?

- What's a private api?
- What's kind of it?
    - ObjC api
    - Swift api
- How to use it?
- How to find it?

# Why are they private?

- Not prepared
    - Public isn't only code. HIG, multiple-platform and api design more.
- specific
    - 

# What's the best usage?

- The private apis are evil?
    - No. 

- Production app
    - No. Uncompliance in review guildeline 2.5.1

- Development usage
    - Yes, but with risk.
    - Mocking, design

- Testing
    - Yes, but with risk.

# How to use it?

- Design case
- Mocking case
- Development case
- Testing case

## Design case

- figma, Sketch cannot build real material.
- For example, progressive blur.

## Mocking case

- private api has some UI.
- speedup to mocking
- For example, navigation subtitles.

## Development case 

- before writing difficult code.
- You can write code without private api! getup!
- For example, scrolling handler

## Testing case

- UITesting?
- For example, _UIHostingView

# How to find it?

- read stacktrace
- dump ObjC headers
- read swiftinterface

# Recap

- Send your feedback to Apple

# References


- Vibrency Effect