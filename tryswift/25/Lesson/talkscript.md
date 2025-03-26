Hello everyone, let’s get started.
In 1999, NTT Docomo made 176 types of emojis.
These can add feelings to messages.
In 2019, Unicode emojis exceeded 3,000 types.
This allows for more expressions.
And last year, Genmoji was introduced.
Genmoji is generated emoji by Apple Intelligence.
The number of types is… infinite.
This means we can express ourselves in many ways.
But infinity doesn’t cover everything.
Yes, we also use meme emojis.
On Slack and Mastodon, Users can register their own emojis.
Custom emojis are not just memes.
A lot of emoji creators are active in Japan.
My wife is also an emoji creator.
This is her character. It’s called fox-newt.
Custom emojis can show the personality of users.
Now, emojis are useless if not sent.
So, for today’s talk, I made a messaging app.
This app can send Fox-Newt emojis.
Let’s try sending a message.
A cute fox-newt! Send!
♪
Nice! My wife got the notification.
Oh no!
The cute fox-newt is gone from the notification.
Instead, it says (Heart).
This is not good.
Is it possible to show custom emojis in notifications?
OK, let’s remember last year’s WWDC.
This! Can you see it?
Genmoji can be shown in notifications.
Wait, I have an idea!
Can custom emoji spoof as a Genmoji?
Let’s try it!
First, type a Genmoji character into the UITextView.
And then, let’s check that attributedString.
You can find an NSAdaptiveImageGlyph.
And, It has a data property called imageContent.
Let’s export this data.
The exported data can be seen as a heic image.
This means Genmoji is a heic image.
Next, let’s look at the metadata of this HEIC image.
There are a few keys inside.
So, which one makes it a Genmoji?
It’s tiff:DocumentName.
That’s the key that tells the system it’s a Genmoji.
We will create a heic file by combining UIImage and tiff:DocumentName key.
Set a random UUID for tiff:DocumentName.
Now, let’s create an NSAdaptiveImageGlyph with this data.
Now, let’s send it again.
Awesome! The cute fox-newt appears in the notification.
She’ll be so happy!
The source code for this talk is open-source and called Zenmoji.
You can try it out!
My name is Tomoya.
I develop a 3rd party Mastodon app called DAWN.
Enjoy the rest of try!Swift!
Thank you!