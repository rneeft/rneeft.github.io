---
title: Filter Active Tasks by [Me] And [Me] as Group Member
date: 2011-11-28 15:02:00 +0200
categories: [Programming, Sharepoint]
tags: [sharepoint,me,tasks]     # TAG names should always be lowercase
---

When you want an overview of your active tasks in a SharePoint task list, you can create a view where you set a filter to the Assigned To property to [Me] and the Status property to Not Equals to "Completed".

All the active tasks assigned to you are displayed in the view. But when a task is assigned to a group you are a member of, it will not be shown in the view. When filtering, SharePoint doesn't look into the group and checks whenever you are a member. It simply says: [Me] is not equal to that specific group.

To achieve that, SharePoint looks into the group and gives you an overview of all the active tasks assigned to you and to groups that you are a member of. The need to open the page in SharePoint Designer and replace the Query section of the CAML with the following code:

```xml
<Query>
   <Where>
    <And>
     <Neq>
      <FieldRef Name="Status"/>
      <Value Type="Text">Completed</Value>
     </Neq>
     <Or>
      <Membership Type="CurrentUserGroups">
        <FieldRef Name= "AssignedTo"/>
      </Membership>
      <Eq>
       <FieldRef Name= "AssignedTo"/>
       <Value Type="Integer">
         <UserID Type= "Integer"/>
       </Value>
      </Eq>
     </Or>
    </And>
   </Where>
</Query>
```
It will now give you an overview of all the active tasks assigned to you and to the groups you are a member of.