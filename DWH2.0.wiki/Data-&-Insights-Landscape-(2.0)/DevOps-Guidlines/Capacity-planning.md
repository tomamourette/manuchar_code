Sprint capacity in Azure DevOps

Capacity takes into consideration the variation in work hours by team members. It also considers holidays, vacation days, and nonworking days. Because days off and time available for each team member might vary from sprint to sprint, set capacity for each sprint. The capacity tool helps you make sure your team isn't over or under-committed for the sprint.

Capacity planning:
Open a sprint backlog for a team
•	From web browser, open your product backlog : (1) select Boards (2) Sprints (3) select the correct sprint and choose Capacity (4).
![image.png](/.attachments/image-646e6b5c-7b28-43b5-96bf-f0163e7980eb.png)
 
•	Add team members: If you don't see your team members listed, add them. Choose the   action icon and select Add all team members. For this feature to work, [team members must be added to the team](https://learn.microsoft.com/en-us/azure/devops/organizations/settings/add-teams?view=azure-devops&tabs=preview-page#add-team-members). You can also Copy from last sprint is team was added earlier. If you need to add other contributors to your project, choose the   Add user.
 ![image.png](/.attachments/image-7d8ef143-4f14-4dae-97b2-53bc0a98f55c.png)

•	To remove a user, choose the option from the users   action menu. This action doesn't remove the user from the team.
![image.png](/.attachments/image-8f159f5b-8231-41ba-9bc1-fa49d046911d.png)
 
•	Set team member time off. For the entire team days off, choose the 0 days link as shown. In the Days off for dialog, select the start and end days during the sprint for the team member or team days off. Your sprint planning and tracking tools automatically consider days off when calculating capacity and sprint burndown. You only have to indicate planned days off for the team.
![image.png](/.attachments/image-25414ebc-b510-49e1-8980-2c6066a2b68c.png)
 

Capacity planning doesn't support half days off; to mitigate this problem we use 7.6 hours capacity per day instead of 8 hours whenever a user is taking half days. Below is an example calculation for this workaround:
![image.png](/.attachments/image-620b0c1f-91c6-4f3f-97df-63c2cdae3935.png)

•	Now, set the Activity/Discipline(optional) and Capacity per day for each team member. If you track capacity simply by team member, you can leave the Activity or Discipline selection unassigned.
For example, Siegfried's capacity is 5 hours/day for requirement work.
![image.png](/.attachments/image-241ce0bc-884c-4098-b95f-af277915fc14.png)
 
•	Multiple activities can be added for users from   action menu.
![image.png](/.attachments/image-024030ec-b49f-42a0-9257-a1a6292202f6.png)
 
•	Copy capacity planning from the previous sprint. Notice that only the capacity-per-day value and activity value are copied over. Individual and team days off remain unset.
![image.png](/.attachments/image-b0b33a84-a6de-415d-aebc-0bc730ad3205.png)


Track capacity when working on more than one team:
If you work on more than one team, specify your sprint capacity for each team. For example, both Siegfried and Shraddha split their time between the BI and I&O teams. As such, give 3 hours a day to the BI team, and 3 hours a day to the I&O team.

Once capacity has been set for the team, users need to add activity types (from the drop down) and remaining hours to their tasks so work details with 'work by activity' can be reflected on the sprint boards:
![image.png](/.attachments/image-45c9aac2-12c3-47fd-aafd-149dc08ad187.png)

![image.png](/.attachments/image-32c8e680-0295-4ab2-8193-5171bc2229ac.png)