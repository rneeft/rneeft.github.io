---
title: Special DateTime value retriever
date: 2023-02-16 18:35:00 +0200
categories: [Testing, Specflow]
tags: [specflow,gherkin,value-retriever,datetime]     # TAG names should always be lowercase
---

I use Specflow a lot. It is a simple way to describe specifications for a software system. 
Working with days, however, never look nice in Gherkin style. Consider the following `given`:

```gherkin
Given a user created '16-02-2023'.
```

It just needs to read nicer, something like:

```gherkin
Given a user created 'yesterday'.
```

By default, the string ‘yesterday’ is not a DateTime value. It is possible to overwrite existing value retrievers of Specflow (or to create your own). To commentate the use of ‘yesterday’ or ‘tomorrow’, I have made an overwrite of the default DateTimeValueRetriever. A binding (or Hook) is needed to unregister the default one and register the SpecialDateTimeValueRetriever. The complete code is displayed below:


```csharp
using TechTalk.SpecFlow.Assist;

namespace TechTalk.SpecFlow.Assist.ValueRetrievers;

public class SpecialDateTimeValueRetriever : DateTimeValueRetriever
{
    public static readonly DateTime Today = DateTime.UtcNow;

    private readonly Dictionary<string, DateTime> specialDates = new Dictionary<string, DateTime>
    {
        { "TODAY", Today },
        { "TOMORROW", Today.AddDays(1) },
        { "YESTERDAY", Today.AddDays(-1) },
        { "DAY AFTER TOMORROW", Today.AddDays(2) },
        { "DAY BEFORE YESTERDAY", Today.AddDays(-2) },
        { "IN AN HOUR", Today.AddHours(1) },
        { "AN HOUR AGO", Today.AddHours(-1) }
    };

    protected override DateTime GetNonEmptyValue(string value)
    {
        return specialDates.TryGetValue(value.ToUpper(), out DateTime dateTime)
            ? dateTime
            : base.GetNonEmptyValue(value);
    }
}

[Binding]
public static class SpecialDateTimeModelHook
{
    [BeforeTestRun]
    public static void BeforeTestRun()
    {
        Service.Instance.ValueRetrievers.Unregister<DateTimeValueRetriever>();
        Service.Instance.ValueRetrievers.Register(new SpecialDateTimeValueRetriever());
    }
}
```


Specflow itself describes how to create your own custom IValueRetriever [here](https://docs.specflow.org/projects/specflow/en/latest/Extend/Value-Retriever.html#extending-with-your-own-value-retrievers]) and the location of their own ValueRetrieves are in [Github](https://github.com/SpecFlowOSS/SpecFlow/tree/master/TechTalk.SpecFlow/Assist/ValueRetrievers).