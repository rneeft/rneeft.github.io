---
title: Special DateTime value retriever
date: 2023-02-16 18:35:00 +0200
categories: [Testing, Specflow]
tags: [specflow,gherkin,value-retriever,datetime]     # TAG names should always be lowercase
---

# Special DateTime value retriever


```csharp
using TechTalk.SpecFlow.Assist;

namespace TechTalk.SpecFlow.Assist.ValueRetrievers;

public class SpecialDateTimeModel : DateTimeValueRetriever
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
        Service.Instance.ValueRetrievers.Register(new SpecialDateTimeModel());
    }
}
```