Story Points Estimation
Story points are a unit of measurement that estimates the overall effort that goes into completing a user story. They are not a measure of time, but rather a gauge of the relative size of a user story compared to other user stories.
The points are typically calculated in refinement meeting. Estimating story points at this stage helps the whole team make informed decisions about which stories to prioritize in the sprint backlog. Involving everyone (developers, testers, deployers... everyone) on the team is key. Each team member brings a different perspective on the product and the work required to deliver a user story. Each participant is then given a set of cards. The cards typically display a sequence of numbers (e.g., Fibonacci sequence: 1, 2, 3, 5, 8, 13, 21, etc.), which represent the story points.
 ![image.png](/.attachments/image-911e37d4-c63a-4b20-a83f-25fa129079f0.png)

3 key criteria for estimating Agile story points
When it comes to determining how many story points to assign to a user story, there are three factors that help our teams accurately assess the work: amount of work, risk, and complexity.
1. Amount of work: Work volume and intensity required
Amount of work required to put efforts in completing different user stories. The relative estimation process includes answering questions like:
•	How many tasks are involved?
•	What preparation and follow-up activities should we expect?
•	How much effort will each task and prep activity require? Etc.
The greater the effort required across these stages, the more points a story is likely to have. Here, we can make a comparison based on how many hours the proposed tasks take—for example:
Under 3 hours for designing a birthday-themed game character: 0.5 story point
A day’s worth of work to design a new app feature: 2 story points
A common mistake while calculating story points is treating them only as a direct measure of time. While time estimates tell us in absolute terms how long a user story will take to complete, they don’t offer a suitable relative measure of how challenging a user story is compared to other. In Manuchar we estimate story points with relative values to avoid any emotions getting attached to absolute values.

2. Risk: Uncertainty and potential obstacles
This criterion involves considering process risks, dependencies on internal tasks or external factors, and the unknowns in the development process. Each story point value adds to the risk score. So, high-risk stories will warrant more story points as they require an additional buffer period to cushion the unforeseen challenges that pop up. We may use the points to manage and mitigate risks more effectively.
3. Complexity: Technical difficulty and intricacies
Complexity is not just about how hard the task is but also how intricate and involved the solution needs to be. This includes the use of new or unfamiliar technologies, the need to rely on innovative or untested solutions, and the level of intellectual challenge. More complex stories usually require more thought, planning, and problem-solving, which is reflected in higher story points.
Now when we have a clear understanding on criteria to estimate story points, a reference story serves as an aid for a team to estimate the effort required for the work of a user story that is actually to be processed. The reference story is a user story whose requirements, complexity and implementation are comprehensible to all team members. In this way, it is used for relative estimation.

How are reference stories used in Scrum:
The team first considers the effort of the story that serves as a reference and then evaluates it with the corresponding story points. New requirements in the form of user stories are now evaluated in relation or reference with the effort of this reference story.

How to estimate story points practically:
Poker planning is a popular Agile technique used for estimating the size or complexity of user stories. It facilitates collaborative decision-making within a team on estimating story points. We have ‘Estimate’ poker integrated to Azure DevOps to estimate story points on the tool itself.
1. Card Distribution: Each team logs into the poker and will receives a set of cards with values typically based on linear or Fibonacci sequence (1, 2, 3, 5, 8, 13....). We prefer to use a Fibonacci sequence for assigning story points, where each point represents the sum of the two numbers before it. Compared to the linear point system, this sequence better reflects the inherent uncertainty in larger stories—the bigger the story, the more uncertainty, hence the larger the jump in points. Numbers 1–8 are mostly used for precise tasks, while 13, 21, 34, 55, and beyond can be used for more broad-scope work items. Very high estimates of story points indicate that the user story can be split into multiple stories.
Example Story Point Scale
•	0.5: Even smaller task than a 1.
•	1: Smallest unit of work, a simple task.
•	2: Slightly larger than a 1, but still relatively small.
•	3: Larger than a 2, but not complex.
•	5: Moderately complex task.
•	8: Larger and more complex task.
•	13: Complex task with significant uncertainty.
•	21: Very large, complex task with high uncertainty. Need to split and refine further.

Or visually we can scale it like:
![image.png](/.attachments/image-569f931c-51dd-4ce6-8f82-0b0f6739a043.png)
2. Reference story estimation: Team members independently estimate the size of a user story relative to the "1, 2, 3, 5 or 8" story point. This user story then becomes our reference user story.
3. Story Presentation: A user story is presented to the team by PO/FA from the backlog and discuss it briefly.
4. Individual Estimation: Each team member silently formulate an estimate referring to the base user story.
5. Revealing Estimates: All team members simultaneously reveal their cards.
6. Discussion and Consensus: If there's a significant spread in estimates, the team quickly discusses the reasons for the differences and re-estimates.
7. Agreement: The process continues until a consensus is reached on a story point value.
8. Refinement: As the team gains experience, they can refine their estimates and adjust the scale if needed.
Story points are a flexible, team-specific way to estimate effort in Scrum. They help teams focus on relative effort rather than absolute time, fostering a better understanding of workload and capacity. By continuously refining their estimation process, teams can improve their ability to predict and manage work, ultimately enhancing productivity and delivery.
Benefits of Using Story Points in Agile
The process of estimating story points involves discussion and consensus among team members, promoting collaboration and a shared understanding of work items. Here are some other notable benefits:
Well-rounded planning: Story points take into account more factors than time estimates, ensuring a balanced workload and realistic commitments to the product owner
Strategic prioritization: Addressing the product backlog requires smart work over hard work. With story points in the picture, teams can prioritize working on items with higher points while accommodating changes and unforeseen challenges with greater flexibility
Continuous improvement: Teams that use historical data on story points to analyze their estimation accuracy and process efficiency are better equipped to improve their processes over time.
Important Considerations
1. Story points are relative, not absolute. They don't predict exact development time.
2. Team velocity is used to estimate how many story points a team can deliver in a sprint.
3. Regular estimation and refinement are crucial for accurate forecasting.
4. Focus on collaboration and consensus building during estimation sessions.
