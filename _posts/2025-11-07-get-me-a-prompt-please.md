---
title: How to generate prompts for Copilot by Copilot
date: 2025-11-07 14:55:00 +0100
categories: [AI, Copilot]
tags: [copilot, prompts, ai, logging, sourcegenerator]     # TAG names should always be lowercase
---

When I'm coding and Copilot is trying to help me, creating a good prompt can sometimes be very challenging. But did you know you can let Copilot create a prompt for you?

### Context
I'm replacing all ILogger messages by moving them into a separate `partial class` and making use of the source generator `ILoggerMessage` to prevent boxing when the LogLevel is not logged anyway. Nick Chapsas has a whole [Youtube Video](https://youtu.be/a26zu-pyEyg?t=676) explaining this topic in detail, but the 'why' is out-of-scope for this blog. 

This refactoring work is repetitive and tedious, so how can Copilot help me with this? I had no clue what kind of prompt I should give it. So how about asking Copilot for help? 

### Getting Copilot to Create a Prompt

I created two files: the original version and a second one with the changes applied. Then I simply asked Copilot for a prompt: 

```
I have these two C# files showing a before and after refactoring where I moved all ILogger calls into a separate static partial class using the LoggerMessage source generator pattern. Please analyze the changes and create a clear, copy-and-paste prompt that I can use with Copilot to apply this same refactoring pattern to other classes in the future. The prompt should specify the ILoggerMessage approach and include concrete examples.
```

Copilot will now return a prompt that I can use later in other classes. 

```
Refactor this class to move all logging statements into a separate static partial class using the LoggerMessage attribute pattern.
Instructions:
•	Create a static partial class named [ClassName]Log (replace [ClassName] with the main class name).
•	Add the newly created class into the same file as [ClassName]
•	For each log statement, define a corresponding static partial method in the log class, decorated with [LoggerMessage] and the appropriate log level, message, and parameters.
•	Replace direct calls to _logger.LogInformation, _logger.LogError, etc., in the main class with calls to the new static partial methods.
•	Ensure the main class only calls these new logging methods, passing the logger instance as this ILogger<[ClassName]> logger.
•	Do not change the logic or structure of the main class, except for replacing the logging calls.
Example:
// Before: _logger.LogInformation("Starting scheduled {HttpMethod} call to {RequestPath}", method, url);
// After: _logger.StartingScheduledHttpCall(method, url);
// In the static partial log class: [LoggerMessage(Level = LogLevel.Information, Message = "Starting scheduled {HttpMethod} call to {RequestPath}")] public static partial void StartingScheduledHttpCall(this ILogger<MitzHttpJob> logger, HttpMethod httpMethod, string? requestPath);
```