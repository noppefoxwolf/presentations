

Hello, My name is Tomoya Hirano.
Today is my first time giving a presentation in English.
I'm an iOS app developer at DeNA in Tokyo.

---

Today I want to talk about import, which is a function of Swift.
I think many of us use import without really thinking about it.
But did you know that there are a few options?

---

In fact, there are three syntaxes for import.
These syntaxes can be found in swift documents.
Some tokens add to the import syntax we usually use.
Let's look at each tokens.

---

First, I will introduce attributes.
Attributes are an option for specifying how to import symbols.
You don't have to write this.
Today there are two symbols in Swift, @testable and @)exported.

---

Testable is an attribute to use for test.
If you write it before the import, you can access internal methods.
Since it is a test, there is no need to change the original code.

---

@_exported is used to import symbols as though they were your own code.
For example, it can be used to make an UmbrellaFramework.
The underscore stands for private.
But it is not recommended, and you should use it in the development phase only.
What's more, there is some possibility of having an impact on Swift ABI stability.

---

Next, let's look at how to specify a submodule.
When a submodule is specified, if becomes possible to import the submodule implementation.
There is a good example of submodule usage in SceneKit.
SceneKit has extensions that allow it to create scenes from the ModelIO class, and make models from scenes.
However, the SceneKit depends on the ModelIO when the extensions are included, even if it doesn't actually use ModelIO.
So the SceneKit declares the ModelIO as a submodule.
You can see that by designated and implementing the submodule, the number of contractors in SCNScene increases.

---

Lastly, I will introduce the third syntax.
If you specify the kind, it will import the specified element.
If you have specified the kind, then what you specify after the module is not the submodule name. Rather, you specify the implementation name of the element.
For example, if you want to only import the User class, you would write User after the module name.

---

kind can specify  struct, class,  enum, protocol, typealias, func, let and var.
These are the same elements as you see in Swift.

---

But, please note two things.
Firstly, about import class or struct.
swift will import all accessible methods and properties in class or struct.
You can import methods and properties using `kind` limitedly what implemented in top-level.
Secondly, about overloaded functions.
You cannot import them separately. 

---

Now, I introduced some import options using kinds.
When you are declaring different modules using functions of the same name, you will need to use the following notation.
For example, the Cat module and Fox module have the printEmoji function.
The printEmoji outputs the module name animal.
If you import both these modules, you will get an error.
Imports using kind prioritize finding methods.

---

Now I've covered the import options.
Using them can be challenging, but let's look at some clear benefits.

---

Let's measure the build time.  
I made 100,000(a hundred thousand) methods using the gyb which is a template engine.
and then compared the build time when declaring the kind and not declaring it.

---

The result is that it was almost same.

---

So, how about the binary size?

---

This was also same.
And the md5 of the binary files was the same too.
What this means, is that no matter your notation, the Swift compiler optimizes so that the result is the same.

---

These are the Pros and Cons.
According to this table, there is no need to write import in detail, unless there are any problem with the namespace.

---

So in conclusion, you should write your code the same as you always have.
Thank you for listening. 

---
