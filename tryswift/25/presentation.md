slidenumber: true

# Spice up your notifications

## noppe (Tomoya Hirano)

^ Hello everyone, let's get started!

---

# 176 Emojis Started in Japan

^ Emojis were born in Japan in 1999.
^ At first, there were only 176 types.

---

# 2025: Unicode Emojis Over 3000+

^ Now, Unicode alone has over 3000 emojis.

---

# Genmoji

^ And this year, Genmoji arrived.
^ These are AI-generated emojis from Apple Intelligence.

---

# Custom Emojis

^ Moreover, we also use unique emojis.
^ In platforms like Slack, Mastodon, and Discord, users can register their own emojis.
^ Meme emojis—I love them too!

---

# "Hello, try!Swift 😻"

^ OK, let's send a message.
^ "A cat meme message 😻"
^ This yellow lizard is a character drawn by my wife.

---

# "Hello, try!Swift (OK)"

^ (Pause...)
^ "A cat meme message (OK)"
^ Oh no...
^ The adorable lizard is gone from the notification, replaced by "(OK)."

---

# Are Notifications Silent?

^ Can't we display custom emojis in notifications?
^ Let's recall WWDC this year.

---

# WWDC

^ Here it is! Genmoji can be displayed in notifications.

---

# Can Custom Emojis Spoof Genmoji?

^ Can custom emojis pretend to be Genmoji?
^ Let's try it out.

---

# Extracting Genmoji

![Screenshot of UITextView]()

^ First, let's analyze Genmoji.
^ Type a Genmoji into a UITextView.

---

![Screenshot of attributedString runs]()

^ Check the attributes.
^ Genmoji is represented as NSAdaptiveImageGlyph.

---

![Screenshot of NSAdaptiveImageGlyph documents]()

^ NSAdaptiveImageGlyph can be initialized with imageContent data.
^ This means we might be able to create a custom NSAdaptiveImageGlyph.

---

![Screenshot of look Data header]()

^ Let's extract the imageContent data from NSAdaptiveImageGlyph.
^ Looking at the header, we see it is in HEIC format.

---

![Screenshot of metadata]()

^ Now, let's check the metadata of this data.
^ There are several keys. To save time, I'll give you the answer.
^ The key is tiff:DocumentName.

---

![Screenshot of create own Data]()

^ We create an HEIC file by combining our image data with tiff:DocumentName.
^ Now, let's try creating an NSAdaptiveImageGlyph with this data.

---

![gif of work with custom emoji as Genmoji]()

^ Bingo! It works!
^ It even appears in notifications.
^ My wife is happy too.

---

# See More

https://github.com/noppefoxwolf/Zenmoji

^ The code is open-source.
^ My name is Tomoya. I develop a Mastodon app.
^ Enjoy the rest of try!Swift!

