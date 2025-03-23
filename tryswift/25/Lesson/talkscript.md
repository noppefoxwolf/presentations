Hello everyone, let's get started.
In 1999, NTT Docomo made 176 types of emojis.
These can add feelings to messages.
In 2019, Unicode emojis exceeded 3,000 types.
This allows for more expressions.
And last year, Genmoji was introduced.
Genmoji is made by Apple Intelligence.
The types are… infinity.
This means we can express ourselves in many ways.
But as you know, infinity does not mean all.
Yes, we also use meme emojis.
On Slack and Mastodon, users can register their own emojis.
Custom emojis are not just memes.
Many emoji creators are active in Japan.
My wife is also an emoji creator.
This is her character. It is called fox-newt.
Custom emojis can show the personality of users.
Now, emojis are useless if not sent.
So, for today's talk, I made a messaging app.
This app can send Fox-Newt emojis.
Let's try sending a message.
A cute fox-newt! Send!
♪
Nice! My wife got the notification.
Oh no!
The cute fox-newt is gone from the notification.
Instead, it says (Heart).
This is not good.
Can't we show custom emojis in notifications?
OK, let's remember last year's WWDC.
This! Can you see it?
Genmoji can be shown in notifications.
Oh, I have a good idea.
Can we spoof a custom emoji is a Genmoji?
Let's try it!
First, type a Genmoji into the UITextView.
And then, let's check the Genmoji in the attributedString.
Genmoji is an NSAdaptiveImageGlyph.
It has data called imageContent.
We will export this data.
The exported data can be seen as a heic image.
This means Genmoji is a heic image.
Next, let's look at the metadata of this data.
There are some keys.
I will give you the answer since we are short on time.
tiff:DocumentName, this is the key piece.
With this, it will be recognized as a Genmoji.
We will create a heic file by combining image data and tiff:DocumentName.
Set a random UUID for tiff:DocumentName.
Now, let's create an NSAdaptiveImageGlyph with this data.
Now, let's send it again.
Awesome! The cute fox-newt appears in the notification.
My wife will be happy.
The source code for this talk is open-source and called Zenmoji.
My name is Tomoya. I develop a Mastodon app.
Enjoy the rest of try!Swift!
Thank you!