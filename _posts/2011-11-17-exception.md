---
title: Don't step into that exception
date: 2011-11-17 09:29:00 +0100
categories: [Programming, Debugging]
tags: [exception,dotnet,debuggerstepthrough,diagnostics]     # TAG names should always be lowercase
---

While debugging your .NET code, you might want your debugger to step over some code instead of into it. This can be very useful while (user interface) testing. This code snippet throws an exception when a user doesn't fill in the inspector's country.

```csharp
public string Country
{
  get { return Inspector.Country; }
  set
  {
    if (string.IsNullOrWhiteSpace(value))
    {
      throw new ArgumentNullException("Country is a required field");
    }
    Inspector.Country = value;
  }
}
```

While debugging, the debugger will stop when the value is empty or null. I want the debugger to avoid drawing my attention to the code because I want to see a validation error as part of a (user interface) test result.

The `DebuggerStepThrough` attribute in the `System.Diagnostics` namespace can help. Applying the `DebuggerStepThrough` to your code ensures the debugger will not step into your code. One little remark is that it will also skip any breakpoints you may have set. 

Please check this [MSDN](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.debuggerstepthroughattribute?view=net-7.0) page for more information.