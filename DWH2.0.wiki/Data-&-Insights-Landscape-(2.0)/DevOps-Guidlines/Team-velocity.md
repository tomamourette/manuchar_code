In Azure DevOps, we can measure velocity by tracking the amount of work our team completes within a sprint. The most common metric for measuring velocity is story points, but other work items, such as tasks or bugs, can also be used. In Manuchar we measure velocity based on story points. Velocity metrics provide useful information, so teams can plan and forecast sprints and determine how well they estimate and meet planned commitments. Here's how we can measure velocity in Azure DevOps:
**1. Estimate work:**
*   **Story points:** A relative size estimation technique where each user story is assigned a point value (e.g., 1, 2, 3, 5, 8, 13, 20) based on its complexity, risk and a mount of work.  Additional details on story points are available here [Story points estimation - Overview](https://dev.azure.com/manuchar/Manuchar%20Service%20Delivery/_wiki/wikis/Manuchar%20Service%20Delivery/5196/Story-points-estimation).
*   **Assign estimates:** During sprint planning, assign estimates to each user story in the sprint backlog.
**2. Track completed work:**
*   **Mark completed stories:** In the sprint boards, track the work items that are completed during the sprint. Make sure that story points are assigned to the user stories, and mark them as done once completed.
**3. Calculate velocity:**
*   **Sum completed points:** Add up the story points of all the user stories completed during the sprint.  
*   **Record velocity:** Note down the calculated velocity for the sprint.
**4. Analyses and adjust:**
*   **Review velocity trends:** We track our team's velocity over multiple sprints to identify patterns, trends, and potential bottlenecks.
    *   **Review velocity using dashboards or reports**: Azure DevOps provides several built-in charts and reports to monitor progress and measure velocity.

    *   **To view velocity through the Azure DevOps UI**: ADO UI offers two velocity charts: “in-context velocity chart” from the Backlogs page and “Velocity widget” for dashboards to get an overview of the work completed during the sprint. You can choose between two velocity charts as per your team’s preference. Both the charts will visualize your team's velocity over time, helping you understand your team's capacity and predict future sprint outcomes.

        1.  **Open velocity in-context report:** [View and configure team velocity - Azure DevOps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/team-velocity?view=azure-devops&tabs=in-context#velocity-chart)
![image.png](/.attachments/image-4d94b7c4-7fdd-44e0-bd81-71e44a4060ca.png)



2.      **Configuring Velocity widget:** [View and configure team velocity - Azure DevOps | Microsoft Learn](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/team-velocity?view=azure-devops&tabs=in-context#configure-the-velocity-widget)
![image.png](/.attachments/image-a0833a40-7656-4796-8622-257369ea87e1.png)


*   **To use a Query for Velocity**: We can also create a work item query that filters for work items completed within a sprint/iteration. We can include columns like story points and then aggregate the sum of points completed after extraction.  

*   **Adjust estimates:** Based on our velocity, we need to adjust our sprint planning and story point estimates for future sprints.

**5. Measure velocity over multiple iterations**

   *   Velocity is most useful when measured over multiple iterations. By comparing the number of story points completed in consecutive sprints, you can assess your team's average velocity.
   *   It’s important to track velocity over time to get a more accurate estimate for future sprints.

**Key considerations:**
*   **Consistency:** Use the same estimation technique and units(story points) consistently across sprints for accurate comparisons.
*   **Team factors:** Consider factors that can influence velocity, such as team capacity, skill levels, distractions, and unplanned work.
*   **Average velocity:** Focus on velocity trends to realize your team’s average velocity.

**Forecast velocity:**
Once we have measure and figured out teams’ average velocity with full capacity, it becomes easier to calculate teams’ velocity with changing capacity. To know more about capacity planning navigate to [Capacity planning - Overview](https://dev.azure.com/manuchar/Manuchar%20Service%20Delivery/_wiki/wikis/Manuchar%20Service%20Delivery/5194/Capacity-planning).
Here is the how we can calculate teams’ velocity according to the capacity:
Let's say:
*   The team's average velocity is 30 story points.
*   The team capacity is 325 hours a sprint (from the availability of all team members in the sprint= full capacity).
*   The team capacity for sprint xyz is 260.
Now, to calculate the **total story points** the team is likely to complete for sprint xyz:
Total story points =    Average velocity / Full capacity  * Sprint capacity

i.e.    30/325 * 260  = **24**

So the team’s projected velocity for sprint xyz is 24 story points.
Velocity helps to predict future workload and capacity, aiding in sprint planning and forecasting. Hence by regularly measuring and analyzing our team's velocity, we can improve our sprint planning, predict future work, and ultimately increase our team's productivity and efficiency.
Explore more about velocity here [https://learn.microsoft.com/en-us/azure/devops/report/dashboards/team-velocity?view=azure-devops&tabs=in-context](https://learn.microsoft.com/en-us/azure/devops/report/dashboards/team-velocity?view=azure-devops&tabs=in-context).