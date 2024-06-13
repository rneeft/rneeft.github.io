---
title: Using Moq's Callback for Better Test Verification
date: 2024-06-13 13:47:00 +0200
categories: [Programming, test]
tags: [programming,test,moq,mock]
---

In unit testing, it's common to verify that certain methods are called with specific parameters. Moq provides a convenient way to do this with the `Verify` method. However, relying solely on `Verify` can sometimes lead to less informative error messages. This is where Moq's `Callback` method can be very useful.

Let's see an example to illustrate this. First, we set up our classes and interfaces:

```csharp
using FluentAssertions;
using Moq;

namespace MoqCallBackExample;

public class User
{
    public Guid Id { get; set; }
    public string LastName { get; set; }
    public string FirstName { get; set; }
}

public interface IUserDatabase
{
    void Add(User user);
}

public class UserManager
{
    private readonly IUserDatabase userDatabase;

    public UserManager(IUserDatabase userDatabase)
    {
        this.userDatabase = userDatabase;
    }

    public void CreateUser(Guid id, string firstName, string lastName)
    {
        // do some work
        this.userDatabase.Add(new User
        {
            FirstName = firstName, // lets create a bug here
            LastName = firstName,
            Id = id,
        });
    }
}
```

We have a `User` class, an `IUserDatabase` interface, and a `UserManager` class that uses `IUserDatabase`. The `UserManager` has a method `CreateUser` which creates a `User` and adds it to the database. Note that we intentionally introduced a bug: the `LastName` property is incorrectly set to `firstName`.

### Traditional Verification

A traditional approach to verify if the `Add` method was called with the correct parameters looks like this:

```csharp
[TestMethod]
public void UserManagerAddsUserToTheDatabase_CouldBe()
{
    var id  = Guid.NewGuid();
    var firstName = "Hello";
    var lastName = "World";

    sut.CreateUser(id, firstName, lastName);

    databaseMock.Verify(x => x.Add(It.Is<User>(y =>
        y.Id == id &&
        y.LastName == lastName &&
        y.FirstName == firstName)
    ), Times.Once);
}
```

This test fails with the following error:

```
Test method TestProject1.MoqCallBackExampleTest.UserManagerAddsUserToTheDatabase_CouldBe threw exception:
Moq.MockException:
Expected invocation on the mock once, but was 0 times: x => x.Add(It.Is<User>(y => (y.Id == id && y.LastName == lastName) && y.FirstName == firstName))

Performed invocations:

Mock<IUserDatabase:2> (x):
    IUserDatabase.Add(User)
```

The error message indicates that the expected invocation did not occur, but it doesn't provide specific details about what went wrong with the `User` object.

### Using Moq's Callback

To improve the test's clarity, we can use Moq's `Callback` to capture the `User` object passed to the `Add` method and then perform assertions on it:

```csharp
[TestMethod]
public void UserManagerAddsUserToTheDatabase_Better()
{
    var id = Guid.NewGuid();
    var firstName = "Hello";
    var lastName = "World";

    User createdUser = null;
    databaseMock.Setup(x => x.Add(It.IsAny<User>()))
        .Callback<User>(x => createdUser = x);

    sut.CreateUser(id, firstName, lastName);

    createdUser.Should().NotBeNull();
    createdUser.FirstName.Should().Be(firstName);
    createdUser.LastName.Should().Be(lastName);
    createdUser.Id.Should().Be(id);
}
```

With this approach, if the test fails, the error message will be more informative:

```
Message: 
Expected createdUser.LastName to be "World", but "Hello" differs near "Hel" (index 0).
```

This message clearly indicates that the `LastName` was incorrectly set to "Hello" instead of "World", pinpointing the exact issue in the `CreateUser` method.

### Conclusion

Using Moq's `Callback` method allows you to capture and inspect arguments passed to mocked methods, providing more detailed and helpful error messages when tests fail. This can make debugging much easier and faster. In our example, `Callback` helped us identify that the `LastName` was incorrectly assigned, something that was less clear with the traditional `Verify` approach.

By incorporating `Callback` into your testing strategy, you can improve the robustness and clarity of your unit tests, making your test suite more effective at catching bugs and easier to maintain. 