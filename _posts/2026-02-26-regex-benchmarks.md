---
title: Benchmark regex
date: 2026-02-26 07:44:00 +0100
categories: [dotnet, benchmark]
tags: [dotnet, benchmark, regex, regular expressions]     # TAG names should always be lowercase
---

Regular expressions (regex) are patterns used to match character combinations in strings. In .NET, there are several ways to use regex for matching. The simplest form is:

```csharp
System.Text.RegularExpressions.Regex.IsMatch("my text", "[a]");
```

It's important to note that using `Regex.IsMatch(input, pattern)` directly is not performant and should generally be avoided. A slightly better approach is to create an instance of the `Regex` class with the pattern:

```csharp
var pattern = new Regex("[a]");
pattern.IsMatch("my text");
```

This approach caches the pattern, but it can still be slow for repeated use. To improve performance, you can compile the pattern:

```csharp
var pattern = new Regex("[a]", RegexOptions.Compiled);
pattern.IsMatch("my text");
```
With `RegexOptions.Compiled`, the compiler generates dynamic code to speed up matching. This reduces the overhead of interpreting the regex pattern at runtime, resulting in faster execution, especially for patterns used frequently.

For a long time, this was the fastest way to use regular expressions in .NET. However, since .NET 7, a fourth option was introduced: source-generated regex using a source generator. You can use it as follows:

```csharp
partial class MyClass
{
    public static void MyMethod()
    {
        var pattern = MyRegex();
        pattern.IsMatch("my text");
    }

    [GeneratedRegex("[a]", RegexOptions.Compiled)]
    private static partial Regex MyRegex();
}
```

The generated code can be found under Dependencies → Analyzers → System.Text.RegularExpressions. The source generator essentially creates the same code as the compiled approach, but at compile time, so there is no runtime overhead. This method also benefits ahead-of-time (AOT) compilation in .NET 10 and later, since it avoids generating dynamic code at runtime.

## The benchmark

The benchmarks were created using [BenchmarkDotNet](https://www.nuget.org/packages/BenchmarkDotNet) (version 0.15.8).

### Benchmark code

```csharp
using BenchmarkDotNet.Attributes;
using System.Text.RegularExpressions;

_ = BenchmarkDotNet.Running.BenchmarkRunner.Run<RegexBenchmark>();

public partial class RegexBenchmark
{
    [Params(
        "first.lastname@outlook.com"
        , "invalid-email"
        , "another.invalid-email@"
        , "test@"
        , "user@domain"
        , "a@b.c"
        , "very.long.email.address.with.many.dots@subdomain.example.com"
        )]
    public string input;

    private readonly string pattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
    private readonly Regex regex = new("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
    private readonly Regex regexCompiled = new("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", RegexOptions.Compiled);

    [Benchmark]
    public bool RegexWithStringPattern() => Regex.IsMatch(input, pattern);

    [Benchmark]
    public bool RegexWithNewRegexString() => regex.IsMatch(input);

    [Benchmark(Baseline = true)]
    public bool RegexWithNewRegexStringCompiled() => regexCompiled.IsMatch(input);

    [Benchmark]
    public bool RegexWithStaticPartialMethod() => EmailPartialRegex().IsMatch(input);

    [GeneratedRegex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")]
    private static partial Regex EmailPartialRegex();
}
```

### Overall benchmark results

| Method                          | input                | Mean      | Error    | StdDev   | Ratio | RatioSD |
|-------------------------------- |--------------------- |----------:|---------:|---------:|------:|--------:|
| RegexWithStringPattern          | a@b.c                | 142.86 ns | 1.514 ns | 1.416 ns |  3.10 |    0.04 |
| RegexWithNewRegexString         | a@b.c                | 134.36 ns | 0.647 ns | 0.505 ns |  2.91 |    0.02 |
| RegexWithNewRegexStringCompiled | a@b.c                |  46.14 ns | 0.381 ns | 0.357 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | a@b.c                |  43.44 ns | 0.318 ns | 0.282 ns |  0.94 |    0.01 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | anoth(...)mail@ [22] |  95.44 ns | 0.654 ns | 0.511 ns |  3.12 |    0.06 |
| RegexWithNewRegexString         | anoth(...)mail@ [22] |  95.70 ns | 0.518 ns | 0.459 ns |  3.13 |    0.06 |
| RegexWithNewRegexStringCompiled | anoth(...)mail@ [22] |  30.60 ns | 0.623 ns | 0.583 ns |  1.00 |    0.03 |
| RegexWithStaticPartialMethod    | anoth(...)mail@ [22] |  30.02 ns | 0.152 ns | 0.142 ns |  0.98 |    0.02 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | first(...)k.com [26] | 196.91 ns | 2.896 ns | 2.418 ns |  2.96 |    0.04 |
| RegexWithNewRegexString         | first(...)k.com [26] | 191.30 ns | 2.154 ns | 2.015 ns |  2.88 |    0.03 |
| RegexWithNewRegexStringCompiled | first(...)k.com [26] |  66.47 ns | 0.463 ns | 0.411 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | first(...)k.com [26] |  64.68 ns | 0.502 ns | 0.470 ns |  0.97 |    0.01 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | invalid-email        |  71.57 ns | 0.490 ns | 0.434 ns |  2.62 |    0.02 |
| RegexWithNewRegexString         | invalid-email        |  69.20 ns | 0.600 ns | 0.501 ns |  2.53 |    0.02 |
| RegexWithNewRegexStringCompiled | invalid-email        |  27.32 ns | 0.182 ns | 0.161 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | invalid-email        |  26.40 ns | 0.080 ns | 0.071 ns |  0.97 |    0.01 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | test@                |  65.96 ns | 0.679 ns | 0.567 ns |  2.60 |    0.02 |
| RegexWithNewRegexString         | test@                |  57.34 ns | 0.635 ns | 0.594 ns |  2.26 |    0.02 |
| RegexWithNewRegexStringCompiled | test@                |  25.39 ns | 0.091 ns | 0.081 ns |  1.00 |    0.00 |
| RegexWithStaticPartialMethod    | test@                |  24.95 ns | 0.157 ns | 0.146 ns |  0.98 |    0.01 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | user@domain          | 119.30 ns | 0.742 ns | 0.658 ns |  2.27 |    0.02 |
| RegexWithNewRegexString         | user@domain          | 115.68 ns | 1.357 ns | 1.269 ns |  2.20 |    0.03 |
| RegexWithNewRegexStringCompiled | user@domain          |  52.62 ns | 0.322 ns | 0.301 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | user@domain          |  45.81 ns | 0.315 ns | 0.263 ns |  0.87 |    0.01 |
|                                 |                      |           |          |          |       |         |
| RegexWithStringPattern          | very.(...)e.com [60] | 312.25 ns | 2.419 ns | 2.145 ns |  3.44 |    0.03 |
| RegexWithNewRegexString         | very.(...)e.com [60] | 300.72 ns | 2.023 ns | 1.793 ns |  3.31 |    0.03 |
| RegexWithNewRegexStringCompiled | very.(...)e.com [60] |  90.85 ns | 0.506 ns | 0.474 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | very.(...)e.com [60] |  86.00 ns | 0.726 ns | 0.679 ns |  0.95 |    0.01 |


**Conclusion:** Source-generated regex (`[GeneratedRegex]`) is consistently 3–13% faster than compiled regex and up to 3.4× faster than creating regex instances from string patterns, making it the clear winner for modern .NET applications.


### Results for cold start (JIT impact)
For these results, update the code to use only the two fastest options for better visibility:
```csharp
[SimpleJob(runStrategy:RunStrategy.ColdStart)]
```
This uses `RunStrategy.ColdStart` to highlight JIT compilation impact.

| Method                          | input                | Mean     | Error     | StdDev    | Median   | Ratio | RatioSD |
|-------------------------------- |--------------------- |---------:|----------:|----------:|---------:|------:|--------:|
| RegexWithNewRegexStringCompiled | a@b.c                | 57.66 us | 181.22 us | 534.34 us | 3.200 us | 18.12 |  183.58 |
| RegexWithStaticPartialMethod    | a@b.c                | 25.86 us |  76.15 us | 224.52 us | 2.750 us |  8.12 |   77.15 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | anoth(...)mail@ [22] | 66.36 us | 211.66 us | 624.07 us | 2.600 us | 25.61 |  261.19 |
| RegexWithStaticPartialMethod    | anoth(...)mail@ [22] | 24.67 us |  68.12 us | 200.86 us | 4.150 us |  9.52 |   84.09 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | first(...)k.com [26] | 67.96 us | 218.74 us | 644.97 us | 2.800 us | 24.11 |  241.20 |
| RegexWithStaticPartialMethod    | first(...)k.com [26] | 37.99 us |  98.01 us | 288.99 us | 7.700 us | 13.48 |  108.11 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | invalid-email        | 61.08 us | 197.36 us | 581.92 us | 2.400 us | 24.27 |  239.67 |
| RegexWithStaticPartialMethod    | invalid-email        | 24.28 us |  71.96 us | 212.17 us | 2.550 us |  9.65 |   87.39 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | test@                | 57.73 us | 185.14 us | 545.88 us | 2.000 us | 27.12 |  274.84 |
| RegexWithStaticPartialMethod    | test@                | 23.39 us |  67.96 us | 200.37 us | 2.400 us | 10.99 |  100.90 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | user@domain          | 64.72 us | 206.86 us | 609.94 us | 2.300 us | 25.15 |  257.44 |
| RegexWithStaticPartialMethod    | user@domain          | 34.03 us | 102.84 us | 303.22 us | 2.900 us | 13.23 |  128.00 |
|                                 |                      |          |           |           |          |       |         |
| RegexWithNewRegexStringCompiled | very.(...)e.com [60] | 63.45 us | 203.23 us | 599.24 us | 2.950 us | 20.72 |  203.79 |
| RegexWithStaticPartialMethod    | very.(...)e.com [60] | 45.92 us | 136.02 us | 401.05 us | 4.100 us | 15.00 |  136.40 |


### Results with AOT compilation
With AOT compilation enabled:

| Method                          | input                | Mean      | Error    | StdDev   | Median    | Ratio | RatioSD |
|-------------------------------- |--------------------- |----------:|---------:|---------:|----------:|------:|--------:|
| RegexWithNewRegexStringCompiled | a@b.c                | 174.94 ns | 1.267 ns | 1.058 ns | 175.21 ns |  1.00 |    0.01 |
| RegexWithStaticPartialMethod    | a@b.c                |  55.04 ns | 0.246 ns | 0.218 ns |  55.04 ns |  0.31 |    0.00 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | anoth(...)mail@ [22] | 110.63 ns | 1.908 ns | 1.784 ns | 109.74 ns |  1.00 |    0.02 |
| RegexWithStaticPartialMethod    | anoth(...)mail@ [22] |  41.26 ns | 0.668 ns | 0.592 ns |  41.15 ns |  0.37 |    0.01 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | first(...)k.com [26] | 241.25 ns | 3.879 ns | 3.439 ns | 240.85 ns |  1.00 |    0.02 |
| RegexWithStaticPartialMethod    | first(...)k.com [26] |  78.50 ns | 1.152 ns | 1.077 ns |  78.35 ns |  0.33 |    0.01 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | invalid-email        |  87.19 ns | 1.743 ns | 3.188 ns |  85.76 ns |  1.00 |    0.05 |
| RegexWithStaticPartialMethod    | invalid-email        |  40.07 ns | 0.740 ns | 0.692 ns |  39.96 ns |  0.46 |    0.02 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | test@                |  75.39 ns | 1.193 ns | 0.996 ns |  75.13 ns |  1.00 |    0.02 |
| RegexWithStaticPartialMethod    | test@                |  42.26 ns | 0.333 ns | 0.295 ns |  42.28 ns |  0.56 |    0.01 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | user@domain          | 146.84 ns | 2.241 ns | 1.987 ns | 146.20 ns |  1.00 |    0.02 |
| RegexWithStaticPartialMethod    | user@domain          |  60.37 ns | 0.656 ns | 0.548 ns |  60.36 ns |  0.41 |    0.01 |
|                                 |                      |           |          |          |           |       |         |
| RegexWithNewRegexStringCompiled | very.(...)e.com [60] | 363.17 ns | 4.685 ns | 6.255 ns | 360.38 ns |  1.00 |    0.02 |
| RegexWithStaticPartialMethod    | very.(...)e.com [60] | 104.79 ns | 1.623 ns | 1.356 ns | 104.35 ns |  0.29 |    0.01 |

Source-generated regex with `[GeneratedRegex]` consistently outperforms `RegexOptions.Compiled` by 2–3.5× in AOT-compiled scenarios, making it the clear choice for modern .NET applications where both performance and native compilation matter.