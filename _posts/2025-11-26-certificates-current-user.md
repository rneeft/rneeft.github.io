---
title: View all certificates in User store
date: 2025-11-26 17:04:00 +0100
categories: [dotnet, certificates]
tags: [dotnet, certificates, thumbprints]     # TAG names should always be lowercase
---

This short post shows how to list certificates from the Current User (Personal) certificate store using C#. The code below prints a table with certificate thumbprints and the certificate common name (CN). It uses `Spectre.Console` to render a friendly table but the certificate logic itself does not depend on that library.

Usage notes:

- The snippet reads from the Current User personal store (`StoreName.My`, `StoreLocation.CurrentUser`).
- Thumbprints are printed in-dim to make them easy to copy; CN is truncated to 40 characters for readability.

```charp
#: package Spectre.Console@0.49.1

using System;
using System.Security.Cryptography.X509Certificates;
using Spectre.Console;
using System.Text.RegularExpressions;
using System.Linq;

// Query the Current User - Personal certificate store
var store = new X509Store(StoreName.My, StoreLocation.CurrentUser);

try
{
    // Open the certificate store in read-only mode
    store.Open(OpenFlags.ReadOnly);
    
    // Get all certificates from the store
    var certificates = store.Certificates;
    
    if (certificates.Count == 0)
    {
        AnsiConsole.MarkupLine("[yellow]No certificates found in the Current User - Personal store.[/]");
        return;
    }
    
    // Create a table to display the certificates
    var table = new Table();
    table.AddColumn("[bold]Thumbprint[/]");
    table.AddColumn("[bold]Common Name (CN)[/]");
    
    // Sort certificates alphabetically by thumbprint and add to table
    foreach (X509Certificate2 cert in certificates.Cast<X509Certificate2>().OrderBy(c => c.Thumbprint))
    {
        // Extract CN from subject using regex
        var subject = cert.Subject ?? "";
        var cnMatch = Regex.Match(subject, @"CN=([^,]+)");
        var commonName = cnMatch.Success ? cnMatch.Groups[1].Value.Trim() : "N/A";
        
        // Trim CN to 40 characters
        if (commonName.Length > 40)
        {
            commonName = commonName.Substring(0, 40) + "...";
        }
        
        var thumbprint = cert.Thumbprint ?? "N/A";
        
        table.AddRow(
            $"[dim]{thumbprint}[/]",
            commonName.EscapeMarkup()
        );
    }
    
    // Display header
    AnsiConsole.MarkupLine($"[green]Found {certificates.Count} certificate(s) in Current User - Personal store:[/]");
    AnsiConsole.WriteLine();
    
    // Render the table
    AnsiConsole.Write(table);
}
catch (Exception ex)
{
    AnsiConsole.MarkupLine($"[red]Error accessing certificate store: {ex.Message}[/]");
}
finally
{
    // Always close the store
    store.Close();
}
```

Run with the new single-file `dotnet run` feature (example assumes the file is named `list-certs.cs`):

```pwsh
dotnet run .\list-certs.cs
```