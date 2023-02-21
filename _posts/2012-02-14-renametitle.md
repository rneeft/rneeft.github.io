---
title: Rename the 'Title' in SharePoint list
date: 2011-11-28 15:02:00 +0100
categories: [Programming, Sharepoint]
tags: [sharepoint,title,rename]     # TAG names should always be lowercase
---
Sometimes you would like to rename the Title field in a SharePoint List. For example: in a list of Countries where the title should be named Country Code. In SharePoint, this is easy to change:

- access the settings for a particular list;
- in the columns section, click on the Title column;
- change the name of the column and save.

While doing this, you only change the display name for the title column for this particular list. Never change the parent Title column!

It works all fine, but when you want to package your "Countries" list, you face a new challenge. You create a new List Definition and List Instance in Visual Studio to package the countries list.

When the List Definition is created, look at the Schema.xml file. The schema file contains content types, fields, views and other information about this list. To change the Title column's display name, you need to include the Title field information in the schema file.

Add the following XML snippet between the Fields section of the Schema file.

```xml
<Field Type="Text" 
       DisplayName="Country Code"
       StaticName="Title"
       Name="Title"
       ID="{fa564e0f-0c70-4ab9-b863-0177e6ddd247}" />
```

You have now changed the Display Name of the Title column. When you deploy the solution to your SharePoint environment, you will see that not every "Title" has changed to Country Code.

![ListInstance](/assets/img/2012/list-instance.png)

This is because SharePoint uses other (hidden) fields to render its view: `LinkTitle` and `LinkTitleNoMenu`. Add the following XML to the Fields section of the Schema file:

```xml
<Field Type="Computed" 
       DisplayName="Country Code"
       StaticName="LinkTitle" 
       Name="LinkTitle" 
       ID="{82642ec8-ef9b-478f-acf9-31f7d45fbc31}" />

<Field Type="Computed"
       DisplayName="Country Code" 
       StaticName="LinkTitleNoMenu" 
       Name="LinkTitleNoMenu" 
       ID="{bc91a437-52e7-49e1-8c4e-4698904b2b6d}" />
```

When you redeploy the solution, you will see that the Display Name of every Title column has changed.

![ListInstance](/assets/img/2012/list-instance-correct.png)
