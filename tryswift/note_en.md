

Hello, My name is noppe.
Today is the first time for me to give a presentation in English. 
I'm an iOS app developer at DeNA in Tokyo

---

Today, I'll talk about import which is a function of Swift.
I guess here is no developer who haven't seen an import declaration.
Because a file is made by xcode automatically that imported an UIKit when we make a Swift file.

---

Let's review what is import.
If you use import declarate, you can be access outside symbol.
For example, such as UILabel and UIViewController are component of UIKit.
So, write `import UIKit` in file. then, can use there components.

---

Can not build file without import decrelate. offcause.

---

We write import with no attention.
Then, do you know what consist of it?

---

Look. These are three syntax of import. 
You can find the syntax in every swift documents.
Some tokens add to the import syntax we usually use.
Let's look at each tokens.

---

At first, I introduce attributes.
Attributes is an option that specifying how to import symbols.
You don't have to write this.
Today, There is two symbols in Swift, @testable and @_exported.

---

Testable is an attributes to use for test.  
If you write it before the import, you can access some internal methods. 
So it makes the original cords not have to change for testing.

---

@_exported is import as own code.
For example, it can be used to make a UmbrellaFramework.
The underscore stands for private.
But it is not recommended and you should use in developing phase only.
What's more, there is some possibility of having an impact on Swift ABI stability.

---

Next, look at how to specify a submodule.
It becomes to import a submodule declaration when submodule is specified.  
For instance, submodule is used well in the SceneKit.
The SceneKit has extensions that making a scene from the ModelIO class, and making a Model from scene. 
However, the SeneKit depends on the ModelIO when the extensions are included. 
So the SceneKit declarates the ModelIO as a submodule.
You can check the adding SCNScene's contractor then you specify and import a submodule.

---
<!-- 
To make a submodule, you should declare with using a explict in the modulemap.
Because the Swift is declared as a single module, there is only framework that can decelerate a submodule. It is the Objective-C. 
But you may not use this technique in your library because everyone write a submodule by the Swift, don't?  -->

---

Lastly, I introduce an another syntax.
If you specified the kind, it imports an element. 
It's not the submodule name that you specify after the module.
For example, If you want to import a User class, Write a User to the back of the module.

---

kind can specify  struct, class,  enum, protocol, typealias, func, let and var.
They are stand for same as in Swift.

---

But, please attention two things.
Firstly, about import class or struct.
if you choice class or struct as kind, swift import all accessable methods and property in class or struct.
kind can only limit top-level kind.

---

Secondly, about overloaded functions.
In Swift, it can declare overloaded functions but it can not import separately.
Each functions are imported together.

---

Now, I introduced some import options.
It is difficult to use.
Then, is there any other good point easily.

---

I tried measure the build time.  
I made 100,000(hundred thousand) methods by using the gyb which is a template engine.
and compared the build time declaring the kind with not doing.

---

The result is it. It was almost same.

---

Then, how about  the binary size?

---

Yes, It was also same.
And the each md5 of binary files ware same too.
Because the Swift compiler optimized.

---

This is ProsCons.
According to this table, there is no necessary to write import in detail, unless it has any problem about namespace.

---

What I’m trying to say is, you should write cords the same as always.
Thank you for listening.

---
