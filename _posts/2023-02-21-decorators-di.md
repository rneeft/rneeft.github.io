---
title: Decorators DotNet Dependency Injector
date: 2023-02-21 10:23:00 +0100
categories: [Programming, Patterns]
tags: [decorator,di,dependency-injector]     # TAG names should always be lowercase
---

### What is the decorator pattern

Using [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) is a great way to add responsibilities to a set of classes or to a specific classes without the need to modify the class itself. The decorator implements to same interface as the original class and adds it own behaviour after (or before) the behaviour of the original class is being executed. An example:$

```csharp
public interface IService
{
    void DoSomething();
}

public class ConcreteService : IService
{
    public void DoSomething()
    {
        // something to do here
    }
}

public class Decorator : IService
{
    private readonly IService component;

    public Decorator(IService component)
    {
        this.component = component;
    }

    public void DoSomething()
    {
        // add functionality before here

        // add concrete object
        component.DoSomething();

        // add functionality after here
    }
}
```

### Registering the decorator to DI

Registering a decorator in the dotnet Dependency injector is not supported out-of-the-box. Greatrex shows in [his blog in 2018](https://greatrexpectations.com/2018/10/25/decorators-in-net-core-with-dependency-injection) a couple of strategies in how to register a decorator to the DI of dotnet. However, his approach only involves a one to one relation between the decorator one concrete implementation. Adding  decorator

 If you want to add a decorator to a set of classes of the same interface 