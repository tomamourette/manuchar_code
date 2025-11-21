Agile project delivery management is an iterative approach of delivering software development projects that focuses on continuous releases and incorporating customer feedback preferably with every iteration. It is guided by several principles, often referred to as "Golden Rules," that helps us deliver value to customers efficiently and effectively. While the specific phrasing may vary for others based on improve software/data development processes, focusing on adaptability, customer collaboration, and delivering high-quality products; here are some interpretations of the principles for Manuchar Service Delivery: 

1. Customer satisfaction through early and continuous delivery of valuable software: 

- Focus on delivering working software frequently, ensuring that it meets the customer's needs. 

- Involve customers early in the process and gather feedback regularly to ensure alignment with their expectations. 

 

2. Welcome changing requirements, even Late in development: 

- Embrace change as a natural part of the development process. 

- Adapt to changing requirements quickly and efficiently to deliver maximum value to the customer. 

 

3. Deliver working software frequently, from a couple of weeks to a couple of months with a reference to the shorter timescale: 

- Break down work into smaller, manageable increments, delivering value iteratively. 

- Aim for short development cycles (sprints) to get rapid feedback and maintain a sustainable pace of work. 

 

4. Collaboration between business people and developers throughout the project: 

- Foster open communication and collaboration between stakeholders, including customers, business representatives, and development teams. 

- Ensure that everyone understands the project's goals and priorities, enabling shared ownership and alignment. 

 

5. Build projects around motivated individuals. Give them an environment and support they need, and trust them to get the job done: 

- Empower teams by providing them with the autonomy, resources, and support they need to succeed. 

- Trust individuals to make decisions and take ownership of their work, fostering a culture of accountability and innovation. 

 

6. The most efficient and effective method of conveying information to and within a development team is face-to-face conversation: 

- Prioritize face-to-face communication whenever possible, as it minimizes misunderstandings and enables rapid feedback. 

- Use video conferencing, meetings, and other collaborative tools to facilitate communication. 

 
7. Working software is the primary measure of progress: 

- Focus on delivering tangible outcomes rather than just completing tasks. 

- Measure progress based on the functionality and value delivered to customers, rather than solely on adherence to schedules or plans. 

 

8. Agile processes promote sustainable development. The sponsors, developers, and users should be able to maintain a constant pace indefinitely: 

- Maintain a sustainable pace of work by balancing productivity with the well-being of team members. 

- Fail in proper capacity planning can lead to burnout and reduced productivity over time. 

 

9. Continuous attention to technical excellence and good design enhances agility: 

- Prioritize quality and technical excellence in all aspects of development, including code, architecture, and design. 

- Regularly refactor code and address technical debt to maintain flexibility and adaptability as requirements evolve. 

 

10. Simplicity—the art of maximizing the amount of work not done—is essential: 

- Emphasize simplicity in design, architecture, and processes to minimize complexity and maximize efficiency. 

- Focus on delivering the most valuable features while avoiding unnecessary features or complexity that can slow down development. 

 

**Agile Methodologies/Frameworks** 

1. Scrum (currently being used at Manuchar): An iterative and incremental framework characterized by fixed-length iterations called sprints. It follows a structured approach with predefined roles (Scrum Master, Product Owner, Development Team) and events/ceremonies (Sprint Planning, Daily Standup, Sprint Review, Sprint Retrospective). Steps to scrum with DevOps: 

![1.png](/.attachments/1-be6c8a01-34d8-4a6e-8de7-3ce9f4d35c43.png)


It all starts with the backlog, or body of work that needs to be done. And its four ceremonies are as follow, we will share the baselines later in this guide: 
![2.png](/.attachments/2-7278aa46-ecf3-4128-8725-d72c34c1c657.png)

2. Kanban (Aimed to go to at Manuchar): A visual workflow management method that uses a Kanban board to visualize and manage work as it moves through various stages. 

3. Extreme Programming (XP): Focuses on technical practices like continuous integration, test-driven development, and pair programming to enhance product quality. 

4. Lean: Emphasizes eliminating waste, optimizing processes, and delivering value more efficiently. 

 

**Agile scrum ceremonies** 

Establishing a baseline for Agile Scrum ceremonies involves defining the essential components and expectations for each ceremony to ensure consistency, effectiveness, and alignment with Agile principles. Here's a baseline for Agile Scrum ceremonies that we expect all the Service Delivery team to conduct in their respective teams: 
![3.png](/.attachments/3-5aa0cef4-d643-4e19-a24e-7413d5259441.png)

1. Sprint Planning: 

Purpose: Define the goals and scope of the upcoming sprint and select the user stories or tasks to be worked on. We use the combination of backlog, sprint boards and estimate poker from Azure boards for planning our sprints and keep the work items in sync at the same time. 

Agenda:  

- Review and clarify the sprint goal and objectives. 

- Prioritize the product backlog items. 

- Break down selected items into actionable tasks. 

- Estimate effort for each task. 

- Define the sprint backlog and commit to delivering the selected items. 

2. Daily Standup (Daily Scrum): 

Purpose: Provide a brief status update, synchronize activities, and identify any obstacles or impediments. Use of sprint boards for daily is standard so we can move along the progress of the work items. 

Agenda: 

- Each team member answers three questions: What did I accomplish yesterday? What will I do today? Are there any impediments blocking my progress? 

- Keep the meeting time-boxed to 15 minutes or less. 

- Use the meeting to identify potential collaboration opportunities and address any impediments. 

3. Sprint Review: 

Purpose: Review and demonstrate the completed work from the sprint to stakeholders and gather feedback. 

Agenda: 

- Demonstrate the completed user stories or features. 

- Solicit feedback from stakeholders. 

- Review and potentially adjust the product backlog based on feedback. 

- Reflect on the sprint's accomplishments and areas for improvement. 

4. Sprint Retrospective: 

Purpose: Reflect on the previous sprint, identify what went well and what could be improved, and define actionable improvements for the next sprint. We recommend the use of retrospectives from teams’ boards to have better clarity on previous sprint. 

Agenda: 

- Discuss what worked well and what didn't during the sprint. 

- Identify root causes of issues and areas for improvement. 

- Define actionable improvement items. 

- Assign owners and deadlines for implementing improvements. 

- Reflect on the effectiveness of the retrospective process itself and make adjustments as needed. 

- Ensure tasks are closed and have an actual performed time amount 

These are the core ceremonies in Agile Scrum. Depending on the SD team's needs and context, additional ceremonies or adjustments to the baseline may be done in a sprint cycle. It's essential to ensure that each ceremony serves its intended purpose, promotes collaboration, and contributes to the team's overall effectiveness and success. 

![image.png](/.attachments/image-a94db887-1880-40e4-9086-8cbf9dcf35f2.png)
 

**End of sprint:** 

To end a sprint we need to look at the burndown chart and take care of the pending/on-going work items from that sprint. Here is the [End of sprint activities](https://learn.microsoft.com/en-us/azure/devops/boards/sprints/end-sprint-activities?view=azure-devops) that can help you determine what can be done with those work items. We recommend to conduct end of sprint activities along with retrospective. 

 

**Project handling:** 

In Manuchar, we practice scrum with 10 workdays of sprint. Each iteration starts on Monday until next Friday. We will have 25/26 sprints in a year that needs to be selected from the iteration list latest by the last sprint of November. Below are the steps that can be followed to select for the teams: 

- Navigate to 'Project Settings' in Manuchar Service Delivery project. 

- Select your project from the dropdown. 

- Go to 'Team configuration' under Boards. 

- Click on 'Select iteration' from the dropdown. 

- Save and close. 

We expect scrum ceremonies to be conducted within teams for progress of the projects. Based on project behavior, we can have self owned projects and cross functional projects. The sprint duration, ceremonies and capacity planning include the standard way while workflow management differs. 

- Own projects: Each team has their own boards to deliver different self owned projects. We expect workflow management, capacity plannings and sprint ceremonies through teams’ sprint boards only. This simplicity makes them suitable for projects being delivered by the members of the same team or users with same competency. 

- Cross functional projects: However, with larger projects or complex projects, managing workflow management where different teams are involved can be challenging. Therefore, to accommodate cross functional projects we have the ‘Service Delivery’ boards. It is our centralized board and this will help us to prioritize projects, monitor all the teams' matrix centrally, easy to visualize all projects' progress, accommodating cross functional project, teams can see the status of the dependent work items, a place to dump all the PMO approved projects, FA can see and refine EIPICs in advance to avoid ad-hoc work during the sprint etc..  

In case of cross functional projects, EPICs and Features should be created under ‘Service Delivery’ board instead of the individual’s boards. Further user stories and tasks of a cross functional project can be created in teams’ boards with proper linking with the work items to avoid losing on traceability. While creating user stories and tasks one should always keep a track on iterations. Once user stories and tasks are created in team’s boards then they should be treated similar to own project work items until delivery. 

**Work items handling:** 

Creating and completing user stories and tasks in Azure Boards involves a structured process to plan, track, and deliver work. We highly believe in traceability of related work items to understand the nature of project, estimate future projects’ timelines and serve similar project with great pace and accuracy in future. Hence we encourage to link work items and don’t create any unparented work items. To comply with traceability we have 2 queries running every Monday to deliver a list of unparented work items to the IT Staff leads. We can quickly map work items to features, which creates parent-child links in the background. Also to avoid creating unparented tasks we create them directly in sprint boards at the time of refinement under a user story. Below is the natural hierarchy for work item types we expect: 

![4.png](/.attachments/4-fafdc60d-fef2-475a-9a9d-d9c6d2508c8e.png)

We define it in a way that not just the creator/PO or developer but any user can have a basic understanding/idea of the work item. Here is how we create an effective work item:
Mandatory fields:
•	Title
•	Assigned To (initially creator can be assignee)
•	Area and iteration path
•	Description
•	Acceptance criteria
•	Story points (for user stories during refinement)
•	Related work
•	Project
Fields to be filled in when value is available:
•	Priority
•	Ticket
•	Change reference

![US.png](/.attachments/US-4e58ae93-8f1c-49c4-8976-16915fbee150.png)

General guidelines: 

- Define Process: Before we start using Azure Boards, make sure our team has a clear understanding of the process. Decide on the Agile framework we're following (Scrum, Kanban, etc.) and define our workflow stages. We need this to be documented in wiki section under each project. 

- Use of Product Backlog: In Azure Boards, we capture all our epics, features and user stories in product backlog. Each item in the backlog should represent a user need or a feature request. 

- Prioritize the Backlog: Prioritize the items in the product backlog based on their importance and value to the project. We can use techniques like MoSCoW (Must have, Should have, Could have, Won't have) or a numeric priority system, it truly depends on the type of the projects. 

- Plan Sprints : Always define a sprint with a unique name. Select a set of user stories from the product backlog to include in the sprint, considering the team's capacity. And if working on support ticket; create a user story and tasks for the sprint. 

- Start the Sprint : Once the sprint begins, move the selected user stories and associated tasks into the "In Progress" or equivalent state on the board. 

- Standups : Hold 10-15 minutes standup meetings with the team to discuss progress, impediments, and plan the day's work. 

- Update Work Items: As work progresses, team members should regularly update the status of their work items on the Azure Boards board. This includes changing the state of tasks and user stories, updating remaining effort, adding comments as needed etc.. Work items can have different statuses like blocked(an external impediment where a dependency exists outside of the team), on-hold(internal impediment), To-do, ready for dev, in-progress, testing, done, removed. 

- Complete Work Items: When a task or user story is completed and meets the acceptance criteria, mark it as "Done" or move it to the equivalent state for completed items. 

- Review and Retrospective : At the end of the sprint, hold a sprint review meeting to demonstrate completed work to stakeholders. Followed by a sprint retrospective to discuss what went well and what could be improved. 

- Repeat the Process: Continue iterating through the backlog, planning and executing sprints, and continuously improving our process based on feedback and data. 

- Monitor and Report: Use Azure Boards' query, reporting and analytics features to track progress, identify bottlenecks, and make data-driven decisions for improvement. 

 

User Story Handling: 

Defining a user story in Azure Boards involves creating a clear and concise description of a specific user need or feature. Here's how we define a user story:

- Title: Start with a clear and descriptive title that summarizes the essence of the user story. 

- Assignee: There must be an assignee when the user story is included to the sprint. 

- State: State to be defined as per the progress of the user stories. 

To Do 

Ready for Dev 

In progress 

Blocked 

OnHold 

Testing 

Done 

Removed 

- Area and Iteration: Area and iteration helps us tracing a user story without any trouble. They are also counted on generating matrix and reports. 

- Action or Goal: Describe what the user wants to accomplish or the problem they want to solve in ‘Description’. 

- Story Points: Assign a relative effort estimation, such as story points, to the user story to help with planning and prioritization.

- Estimation: An estimated hour to complete the user story.

- Acceptance Criteria (Optional): Define clear and measurable acceptance criteria that must be met for the user story to be considered complete. Acceptance criteria specify the conditions that must be satisfied for the story to be accepted by the product owner or stakeholders. 

- Attachments and Details (Optional): We can include additional information, attachments or wireframes to provide more context or clarity to the user story. 

- Dependencies (Optional): If the user story has dependencies on other work items, we can link them in Azure Boards to track relationships. 

Once we define a user story in this format, it becomes a valuable communication tool between the development team, product owner, and stakeholders. It conveys the "who," "what," and "why" of a specific piece of work and serves as a foundation for development and sprint planning in Azure Boards. Ideally, a user story should be completed within a single sprint. This means it should be taken from the "To Do" column at the beginning of the sprint and moved to the "Done" column by the end of the sprint. Sometimes, user stories may spill over into the next sprint if they are not completed within the sprint duration. These are often referred to as "carryover" stories and it's essential to minimize carryover as it can impact sprint predictability and planning. 

 

Task Handling: 

Defining a task in Azure Boards involves breaking down a user story or a piece of work into smaller, actionable steps that can be executed by team members. Tasks should be specific, manageable, and contribute to the completion of a user story. With that said a particular tasks should not exceed 8 hours(one workday) and ideally be completed within the sprint they were created. Limiting individual tasks to a duration of around 8 hours (or one workday) is a common practice in Agile and Scrum methodologies. Hence, we are also adapting this approach. This practice is guided by several principles and benefits: 

- Granularity and Visibility 

- Improved Estimation Accuracy 

- Adaptability and Flexibility 

- Encourages Collaboration 

- Facilitates Daily Standups 

- Enhances Focus and Productivity 

- Easier Tracking and Burndown Chart Management(we should use) 

- The key is to keep tasks small enough to maintain a steady flow of value delivery and to provide effective sprint planning, execution, and review. 

 



Task Creation: 

- Title: Start with a clear and concise title that describes the task. The title should be specific and action-oriented. 

- Description: Provide a brief description or additional context for the task. This can help team members understand the task's purpose and scope. 

- Assignee: Assign the task to a team member who will be responsible for defining and completing it. This ensures accountability. 

- State: Set the initial state of the task. Common states in include "To Do", "In Progress", "Done", "on hold"(internal impediment, for instance priority changed, delayed etc.) and "blocked"(an external impediment where a dependency exists outside of the team). Tasks typically start in the "To Do" state. 

- Parent User Story: Link the task to the user story or feature it belongs to or create tasks in sprint boards directly under relevant user story. This establishes the connection between the task and the higher-level work item. 

- Acceptance Criteria: Reference the acceptance criteria defined in the user story. Ensure that the task aligns with the criteria that define when the user story is complete. 

- Dependencies: If the task has dependencies on other tasks or work items, you can specify them to track relationships. 

- Attachments and Details (Optional): Include additional information, attachments, or references to design documents, if necessary, to provide clarity to the team member working on the task. 

- Breakdown (Optional): For complex tasks, you may further break them down into sub-tasks to make them more manageable and ensure the tasks completes within the sprint. Each sub-task should follow the same principles as the main task. 

- Review and Validation: Once the task is complete, ensure that it meets the acceptance criteria defined in the user story. 

- Original estimation: The amount of estimated work required to complete a task. Typically, this field doesn't change after it's assigned. 

- Completed hours: We need to provide the total number of hours we spent in completing a task by indicating hours in this field. Filling the time taken in this field is mandatory to change the status of your task to 'Done'. 

- Blocked task: When you change the status of any task to 'Blocked' then it is mandatory to put a date in 'Notify date' field so that you can receive a notification/reminder on that date to follow-up/work on that blocked task. 

-By defining tasks in this structured manner, you enable efficient Agile project delivery management, better tracking of work progress, and improved collaboration within your team. Azure Boards provides a visual representation of tasks on boards, making it easy to monitor and manage the work throughout the development cycle. 

In case any issue/failure happen to take longer than 3 working days to resolve then we need to make sure that we track the issue and the solution in your project wiki page for future reference. 

Remember that Agile is about adaptability and continuous improvement. Please be flexible in this approach and adjust the process as necessary to meet the needs of the team and project. If agile ceremonies are not being followed, then it is recommended to regularly communicate and collaborate with the team to ensure everyone is aligned.
 

**References:** 

Steps to adapt Agile project delivery management: 

Implementing Agile project delivery management involves several practical steps to ensure that teams can effectively plan, execute, and deliver projects while adhering to Agile principles. It involves several key steps to foster a culture of collaboration, adaptability, and continuous improvement. Here's a structured approach to Agile project delivery management in Manuchar: 

- Establish clear goals and objectives: Define the project's vision, goals, and objectives clearly to ensure alignment among team members. This helps everyone understand the purpose of the project and the value it aims to deliver to customers. 

- Define roles and responsibilities: Clarify the roles and responsibilities of each team member within the agile framework. Ensure that everyone understands their role and how they contribute to the project's success. 

- Educate the team: Ensure that all team members understand the project requirement and the agile principles they represent. 

- Form agile teams: Assemble cross-functional teams with the necessary skills and expertise to deliver the cross functional project. Assign roles such as Scrum Master, Product Owner, and Development Team members as needed. 

- Create a collaborative environment: Foster open communication and collaboration among team members. Encourage transparency, trust, and respect within the team to facilitate effective collaboration and problem-solving. 

- Adopt agile framework, practices and tools: In Manuchar scrum suits the project's requirements. Implement agile practices such as stand-up meetings, sprint planning, sprint reviews, and retrospectives to facilitate agile project management. Use agile tools such as task boards, retrospective, and burndown charts to visualize work and track progress. 

- Create a product backlog: Collaborate with stakeholders to create and prioritize a product backlog. Break down features into smaller, actionable items (user stories and tasks) that can be completed within a single sprint. 

- Plan iteratively: Conduct Sprint Planning meetings to select user stories from the product backlog and define tasks for the upcoming sprint. Estimate effort and set realistic goals for the sprint based on team capacity and velocity. 

- Execute sprints: Work collaboratively as a team to deliver the committed user stories during the sprint. Hold Standup meetings to share progress, discuss obstacles, and plan the day's work. 

- Deliver value incrementally: Aim to deliver working software increments at the end of each sprint or iteration. Gather feedback from stakeholders and end-users to validate assumptions and ensure alignment with expectations.  

- Prioritize customer satisfaction: Keep the customer's needs and priorities at the forefront of decision-making. Involve customers in the development process, gather feedback regularly, and prioritize features based on customer value. Prioritize the delivery of working software and tangible outcomes over adherence to plans or processes. 

- Embrace change: Emphasize flexibility and adaptability within the team. Encourage team members to welcome changes in requirements and priorities, and empower them to respond to changes quickly and effectively. 

- Monitor progress: Use Agile metrics such as burndown charts, velocity, and cumulative flow diagrams to track progress and identify potential issues. Conduct regular reviews of completed work and adjust plans accordingly. 

- Promote continuous improvement: Foster a culture of continuous improvement within the team. Encourage experimentation, learning, and reflection, and regularly review and adjust processes to optimize performance. Hold sprint retrospectives at the end of each sprint to reflect on what went well, what didn't, and identify areas for improvement. Implement changes based on retrospective findings to enhance team performance and delivery effectiveness. 

- Celebrate successes and learn from failures: Recognize achievements and milestones reached during the project. Encourage a culture of learning and experimentation, where failures are viewed as opportunities for growth and improvement. 

- Lead by example: Demonstrate leadership and commitment to agile principles as a manager or team leader. Lead by example by practicing agile values, encouraging collaboration and transparency, and supporting team members in their agile journey. 

 

**Benefits of agile delivery management** 

Agile project delivery management offers numerous benefits for teams, organizations, and stakeholders involved in the development process. Some of the key benefits include: 

1. Increased flexibility and adaptability: 

- Agile methodologies, such as Scrum and Kanban, embrace change and allow teams to respond quickly to shifting priorities, requirements, and market conditions. 

- Teams can adapt their plans and processes iteratively, maximizing responsiveness to customer feedback and evolving needs. 

 

2. Improved stakeholder engagement and satisfaction: 

- Agile encourages continuous collaboration and feedback between development teams and stakeholders. 

- Stakeholders have greater visibility into the project's progress, can provide input throughout the development cycle, and see tangible results early and frequently, leading to higher satisfaction with the final product. 

 

3. Faster time-to-market: 

- Agile emphasizes delivering working increments of software in short iterations (sprints), enabling faster delivery of value to customers. 

- By breaking down work into smaller, manageable chunks and focusing on high-priority features, Agile teams can reduce time-to-market and gain a competitive edge. 

 

4. Enhanced product quality: 

- Agile promotes a focus on delivering high-quality software through practices such as continuous testing, automated testing, and frequent integration. 

- Iterative development and regular feedback loops enable teams to identify and address issues early, resulting in a more robust and reliable product. 

 

5. Greater transparency and visibility: 

- Agile promotes a focus on delivering high-quality software through practices such as continuous testing, automated testing, and frequent integration. 

- Stakeholders have real-time visibility into project status, enabling informed decision-making and proactive problem-solving. 

 

6. Improved team collaboration and morale: 

- Agile fosters a collaborative and empowered team culture, where members work together towards common goals and share ownership of project success. 

- Regular communication, shared responsibility, and a focus on continuous improvement contribute to higher team morale and job satisfaction. 

 

7. Reduced project risks: 

- Agile's iterative approach allows teams to identify and mitigate risks early in the development process. 

- By delivering value incrementally and frequently, Agile reduces the risk of project failure or significant deviations from stakeholder expectations. 

 

8. Enhanced business agility: 

- Agile enables organizations to adapt quickly to changing market conditions, customer needs, and technological advancements. 

- By embracing Agile principles and practices, businesses can stay competitive, innovate faster, and seize new opportunities more effectively. 

Overall, Agile project delivery management offers a range of benefits that promote faster delivery, higher quality, increased stakeholder satisfaction, and improved adaptability in today's dynamic and competitive business environment. 

 

Brief Agile Project Management history can be referred [here](https://www.eylean.com/blog/2020/01/brief-project-management-history/). 