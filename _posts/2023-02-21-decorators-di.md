---
title: Decorators DotNet Dependency Injector
date: 2023-02-21 10:23:00 +0100
categories: [Programming, Patterns]
tags: [decorator,di,dependency-injector]     # TAG names should always be lowercase
---

### What is the decorator pattern

Using [decorator](https://en.wikipedia.org/wiki/Decorator_pattern) is a great way to add responsibilities to a set of classes or specific classes without needing to modify the class itself. The decorator implements the same interface as the original class and adds its own behaviour after (or before) the behaviour of the original class is executed. An example:$

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

Registering a decorator in the dotnet dependency injector is not supported out of the box. Greatrex shows in [his blog in 2018](https://greatrexpectations.com/2018/10/25/decorators-in-net-core-with-dependency-injection) a couple of strategies of how to register a decorator to the DI of dotnet. His proposed solution works great, but only when you want to decorate one class. When you wish to decorate more than one class with the same interface Greatrex solution needs to be adjusted. The code for this is the following:

```csharp
using System;
using System.Linq;

namespace Microsoft.Extensions.DependencyInjection.Extensions;

public static class ServiceCollectionDecorate
{
    public static IServiceCollection Decorate<TInterface, TDecorator>(this IServiceCollection services)
        where TInterface : class
        where TDecorator : class, TInterface
    {
        // grab the existing registrations
        var wrappedDescriptors = services
            .Where(s => s.ServiceType == typeof(TInterface))
            .ToList();

        if (wrappedDescriptors.IsEmpty())
        {
            throw new InvalidOperationException($"{typeof(TInterface).Name} is not registered");
        }

        foreach (var wrappedDescriptor in wrappedDescriptors)
        {
            // create the object factory for our decorator type,
            // specifying that we will supply TInterface explicitly
            var objectFactory = ActivatorUtilities.CreateFactory(typeof(TDecorator), new[] { typeof(TInterface) });

            // replace the existing registration with one
            // that passes an instance of the existing registration
            // to the object factory for the decorator
            services.Replace(
                ServiceDescriptor.Describe(typeof(TInterface),
                s => (TInterface)objectFactory(s, new[] { s.CreateInstance(wrappedDescriptor) }),
                wrappedDescriptor.Lifetime)
            );
        }

        return services;
    }

    private static object CreateInstance(this IServiceProvider services, ServiceDescriptor descriptor)
    {
        if (descriptor.ImplementationInstance != null)
        {
            return descriptor.ImplementationInstance;
        }

        if (descriptor.ImplementationFactory != null)
        {
            return descriptor.ImplementationFactory(services);
        }

        if (descriptor.ImplementationType != null)
        {
            return ActivatorUtilities.GetServiceOrCreateInstance(services, descriptor.ImplementationType);
        }

        return new object();
    }
}
```

The code example below demonstrates how to register the services and how to decorate and shows that it is still possible to add a service without the decorator. 

Registering a decorate happens during startup. The code example below 

```csharp
public static IServiceCollection AddServices(this IServiceCollection services)
{
    return services
        .AddTransient<IService, ConcreteService>()
        .AddTransient<IService, AnotherConcreteService>()
            .Decorate<IService, Decorator>()
        .AddTransient<IService, ConcreteServiceWithoutDecorator>()
        ;
}

```